import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/app_update_api.dart';
import '../first_run/company.dart';
import '../providers/core_providers.dart';
import '../utils/result.dart';
import 'app_release.dart';

class AppUpdateState extends Equatable {
  const AppUpdateState({this.required, this.optional, this.checking = false});

  final AppUpdateDecision? required;
  final AppUpdateDecision? optional;
  final bool checking;

  bool get blocked => required != null;

  @override
  List<Object?> get props => [required, optional, checking];
}

class AppUpdateNotifier extends Notifier<AppUpdateState> {
  static const String _cacheKey = 'app_update.required';
  static const String _dismissKey = 'app_update.dismissed';
  static const Duration _fallbackMaxAge = Duration(minutes: 5);
  static const Duration _dismissFor = Duration(hours: 24);

  int _generation = 0;
  Future<void>? _inFlight;
  Stopwatch? _sinceDecision;
  Duration _maxAge = _fallbackMaxAge;
  Timer? _refresh;

  @override
  AppUpdateState build() {
    ref.read(apiClientProvider).onUpdateRequired = _fromServer;
    ref.onDispose(() => _refresh?.cancel());
    return const AppUpdateState();
  }

  SharedPreferences get _preferences => ref.read(sharedPreferencesProvider);

  String? get _companyCode {
    final String? code = ref.read(companyProvider)?.code;
    return code == null || code.isEmpty ? null : code;
  }

  String _scope(AppRelease release) => '${_companyCode ?? ''}|${release.key}';

  Future<void> check() {
    final Future<void>? running = _inFlight;
    if (running != null) return running;
    late final Future<void> next;
    next = _check().whenComplete(() {
      if (identical(_inFlight, next)) _inFlight = null;
    });
    return _inFlight = next;
  }

  Future<void> _check() async {
    final AppRelease? release = ref.read(appReleaseProvider);
    if (release == null) return;
    final bool signedIn = ref.read(tokenStoreProvider).hasSession;
    final String? company = _companyCode;
    if (!signedIn && company == null) return;
    final int generation = _generation;
    final String scope = _scope(release);
    if (state.blocked) state = AppUpdateState(required: state.required, checking: true);
    final AppUpdateApi api = ref.read(appUpdateApiProvider);
    final Result<AppUpdateDecision> result = signedIn
        ? await api.check(release)
        : await api.checkBeforeLogin(release, company!);
    if (!ref.mounted || generation != _generation) return;
    switch (result) {
      case Ok<AppUpdateDecision>(:final value):
        _accept(value, scope);
      case Err<AppUpdateDecision>(:final failure):
        _fail(failure, scope);
    }
  }

  void onResume() {
    final Stopwatch? since = _sinceDecision;
    if (state.blocked || since == null || since.elapsed >= _maxAge) unawaited(check());
  }

  void contextChanged({bool clientChanged = false}) {
    _generation++;
    _inFlight = null;
    _refresh?.cancel();
    unawaited(_preferences.remove(_cacheKey));
    if (clientChanged) {
      _sinceDecision = null;
      state = const AppUpdateState();
    }
    unawaited(check());
  }

  void _fromServer(Map<String, dynamic> json) {
    final AppRelease? release = ref.read(appReleaseProvider);
    final AppUpdateDecision decision = AppUpdateDecision.fromJson(json);
    if (release == null || !decision.isRequired || state.required == decision) return;
    _accept(decision, _scope(release));
  }

  void _accept(AppUpdateDecision decision, String scope) {
    _sinceDecision = Stopwatch()..start();
    _maxAge = decision.cacheMaxAgeSeconds > 0 ? Duration(seconds: decision.cacheMaxAgeSeconds) : _fallbackMaxAge;
    _scheduleRefresh();
    if (decision.isRequired) {
      state = AppUpdateState(required: decision);
      unawaited(
        _preferences.setString(
          _cacheKey,
          jsonEncode({
            'scope': scope,
            'receivedAt': DateTime.now().millisecondsSinceEpoch,
            'decision': decision.toJson(),
          }),
        ),
      );
    } else {
      state = AppUpdateState(optional: decision.isOptional && !_dismissed(decision) ? decision : null);
      unawaited(_preferences.remove(_cacheKey));
    }
  }

  void dismissOptional() {
    final AppUpdateDecision? optional = state.optional;
    final String? key = optional == null ? null : _dismissalKey(optional);
    if (key != null) {
      unawaited(
        _preferences.setString(
          _dismissKey,
          jsonEncode({'key': key, 'until': DateTime.now().add(_dismissFor).millisecondsSinceEpoch}),
        ),
      );
    }
    state = AppUpdateState(required: state.required, checking: state.checking);
  }

  String? _dismissalKey(AppUpdateDecision decision) {
    final AppRelease? release = ref.read(appReleaseProvider);
    if (release == null) return null;
    return [
      decision.clientId ?? _companyCode ?? '',
      release.appCode,
      release.platform,
      release.applicationId,
      release.channel,
      decision.policyRevision ?? 0,
    ].join('|');
  }

  bool _dismissed(AppUpdateDecision decision) {
    final String? raw = _preferences.getString(_dismissKey);
    final String? key = _dismissalKey(decision);
    if (raw == null || key == null) return false;
    try {
      final Object? saved = jsonDecode(raw);
      if (saved is! Map || saved['key'] != key) return false;
      final int until = saved['until'] is int ? saved['until'] as int : 0;
      final int remaining = until - DateTime.now().millisecondsSinceEpoch;
      return remaining > 0 && remaining <= _dismissFor.inMilliseconds;
    } on FormatException {
      return false;
    }
  }

  void _fail(Failure failure, String scope) {
    final bool unreachable = failure is NetworkFailure || (failure is ServerFailure && (failure.status ?? 500) >= 500);
    if (!unreachable) {
      state = const AppUpdateState();
      unawaited(_preferences.remove(_cacheKey));
      return;
    }
    final AppUpdateDecision? current = state.required;
    final Stopwatch? since = _sinceDecision;
    if (current != null && since != null && since.elapsed < _maxAge) {
      state = AppUpdateState(required: current);
      return;
    }
    final AppUpdateDecision? cached = _restore(scope);
    state = AppUpdateState(required: cached, optional: cached == null ? state.optional : null);
  }

  AppUpdateDecision? _restore(String scope) {
    final String? raw = _preferences.getString(_cacheKey);
    if (raw == null) return null;
    try {
      final Object? saved = jsonDecode(raw);
      if (saved is Map && saved['scope'] == scope && saved['decision'] is Map) {
        final AppUpdateDecision decision = AppUpdateDecision.fromJson(
          Map<String, dynamic>.from(saved['decision'] as Map),
        );
        final int receivedAt = saved['receivedAt'] is int ? saved['receivedAt'] as int : 0;
        final Duration age = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - receivedAt);
        final Duration maxAge = Duration(seconds: decision.cacheMaxAgeSeconds);
        if (decision.isRequired && !age.isNegative && age < maxAge) {
          _sinceDecision = Stopwatch()..start();
          _maxAge = maxAge - age;
          return decision;
        }
      }
    } on FormatException {
      return null;
    }
    unawaited(_preferences.remove(_cacheKey));
    return null;
  }

  void _scheduleRefresh() {
    _refresh?.cancel();
    _refresh = Timer(_maxAge, () {
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) unawaited(check());
    });
  }
}

final appUpdateProvider = NotifierProvider<AppUpdateNotifier, AppUpdateState>(AppUpdateNotifier.new);
