import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_install_referrer/play_install_referrer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'referral_link.dart';

class PendingReferral extends Equatable {
  const PendingReferral({required this.link, required this.source});

  final ReferralLink link;
  final ReferralSource source;

  @override
  List<Object?> get props => [link, source];
}

class PendingReferralNotifier extends Notifier<PendingReferral?> {
  static const String _pendingKey = 'referral.pending';
  static const String _installCheckedKey = 'referral.install_referrer_checked';
  static const String _scheme = 'evseye-rider';

  @override
  PendingReferral? build() {
    final SharedPreferences preferences = ref.watch(sharedPreferencesProvider);
    final StreamSubscription<Uri> links = AppLinks().uriLinkStream.listen(_onLink, onError: (Object _) {});
    ref.onDispose(links.cancel);
    unawaited(_readInstallReferrer(preferences));
    return _restore(preferences);
  }

  void clear() {
    unawaited(ref.read(sharedPreferencesProvider).remove(_pendingKey));
    state = null;
  }

  void _onLink(Uri uri) {
    final bool referral = uri.scheme == _scheme ? uri.host == 'referral' : uri.path.endsWith('/rider/referral');
    if (!referral) return;
    final ReferralLink? link = ReferralLink.fromParameters(uri.queryParameters);
    if (link != null) _save(PendingReferral(link: link, source: ReferralSource.deepLink));
  }

  Future<void> _readInstallReferrer(SharedPreferences preferences) async {
    if (!Platform.isAndroid || (preferences.getBool(_installCheckedKey) ?? false)) return;
    final String? referrer;
    try {
      referrer = (await PlayInstallReferrer.installReferrer).installReferrer;
    } on PlatformException {
      return;
    } on MissingPluginException {
      return;
    }
    await preferences.setBool(_installCheckedKey, true);
    final ReferralLink? link = ReferralLink.parse(referrer);
    if (link != null && ref.mounted && state == null) {
      _save(PendingReferral(link: link, source: ReferralSource.shareLink));
    }
  }

  void _save(PendingReferral pending) {
    unawaited(
      ref
          .read(sharedPreferencesProvider)
          .setString(_pendingKey, jsonEncode({...pending.link.toJson(), 'source': pending.source.wire})),
    );
    state = pending;
  }

  static PendingReferral? _restore(SharedPreferences preferences) {
    final String? raw = preferences.getString(_pendingKey);
    if (raw == null) return null;
    final Object? json;
    try {
      json = jsonDecode(raw);
    } on FormatException {
      return null;
    }
    final ReferralLink? link = ReferralLink.fromJson(json);
    if (link == null || json is! Map) return null;
    final Object? wire = json['source'];
    final ReferralSource source = ReferralSource.values.firstWhere(
      (value) => value.wire == wire,
      orElse: () => ReferralSource.deepLink,
    );
    return PendingReferral(link: link, source: source);
  }
}

final pendingReferralProvider = NotifierProvider<PendingReferralNotifier, PendingReferral?>(
  PendingReferralNotifier.new,
);
