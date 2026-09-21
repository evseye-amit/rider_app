import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/foundation.dart';

import '../../features/auth/domain/usecases/request_otp.dart';
import '../../features/auth/domain/usecases/restore_session.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/hub/domain/entities/hub_profile.dart';
import '../../features/hub/domain/usecases/list_hubs.dart';

class SessionController extends ChangeNotifier {
  SessionController({
    required UiConfigService config,
    required RequestOtp requestOtpUseCase,
    required VerifyOtp verifyOtpUseCase,
    required RestoreSession restoreSession,
    required SignOut signOutUseCase,
    required ListHubs listHubs,
  })  : _config = config,
        _requestOtp = requestOtpUseCase,
        _verifyOtp = verifyOtpUseCase,
        _restoreSession = restoreSession,
        _signOut = signOutUseCase,
        _listHubs = listHubs;

  final UiConfigService _config;
  final RequestOtp _requestOtp;
  final VerifyOtp _verifyOtp;
  final RestoreSession _restoreSession;
  final SignOut _signOut;
  final ListHubs _listHubs;

  FeatureFlags _flags = FeatureFlags.empty;
  FeatureFlags get flags => _flags;

  bool _signedIn = false;
  bool get isSignedIn => _signedIn;

  String _mobile = '';
  String get mobile => _mobile;

  AuthUser? _user;
  AuthUser? get user => _user;

  List<HubProfile> _hubs = const [];

  List<HubProfile> get hubs => _hubs;

  final Set<int> _hubSelection = {0};

  int get hubIndex => activeHubIndexes.isEmpty ? 0 : activeHubIndexes.first;

  List<int> get activeHubIndexes {
    final List<int> valid = _hubSelection.where((i) => i >= 0 && i < _hubs.length).toList()..sort();
    return valid.isEmpty && _hubs.isNotEmpty ? [0] : valid;
  }

  List<HubProfile> get activeHubs => [for (final i in activeHubIndexes) _hubs[i]];

  List<String> get activeHubCodes => [for (final h in activeHubs) h.code];

  bool get isMultiHub => activeHubIndexes.length > 1;

  bool isHubSelected(int index) => activeHubIndexes.contains(index);

  void selectHub(int index) {
    if (index < 0 || index >= hubs.length) return;
    if (_hubSelection.length == 1 && _hubSelection.contains(index)) return;
    _hubSelection
      ..clear()
      ..add(index);
    notifyListeners();
  }

  void setHubSelection(Iterable<int> indexes) {
    final Set<int> next = indexes.where((i) => i >= 0 && i < _hubs.length).toSet();
    if (next.isEmpty) return;
    if (next.length == _hubSelection.length && next.every(_hubSelection.contains)) return;
    _hubSelection
      ..clear()
      ..addAll(next);
    notifyListeners();
  }

  HubProfile? get hub => activeHubs.isEmpty ? null : activeHubs.first;

  bool _present = false;

  bool get present => _present;

  void setAttendance(bool present) {
    if (_present == present) return;
    _present = present;
    notifyListeners();
  }

  String get managerName => 'Manager';

  String get hubId => hub?.id ?? '';
  String get hubName => hub?.name ?? '—';
  String get hubCode => hub?.code ?? '—';

  Future<void> bootstrap() async {
    _flags = await _config.loadFeatureFlags();
    final Result<AuthUser> me = await _restoreSession(const NoParams());
    if (me case Ok<AuthUser>(:final value)) {
      _user = value;
      _signedIn = true;
      await _loadConfig();
      await _loadHubs();
    }
    notifyListeners();
  }

  Future<Result<OtpChallenge>> requestOtp(String mobile) {
    _mobile = mobile;
    return _requestOtp(mobile);
  }

  Future<Result<AuthUser>> verifyOtp({
    required String otpRequestId,
    required String code,
  }) async {
    final Result<AuthUser> result = await _verifyOtp(
      VerifyOtpParams(otpRequestId: otpRequestId, code: code),
    );
    if (result case Ok<AuthUser>(:final value)) {
      _user = value;
      _signedIn = true;
      await _loadConfig();
      await _loadHubs();
      notifyListeners();
    }
    return result;
  }

  Future<void> _loadConfig() async {
    _flags = await _config.loadFeatureFlags();
  }

  Future<void> _loadHubs() async {
    final Result<List<HubProfile>> result = await _listHubs(const NoParams());
    if (result case Ok<List<HubProfile>>(:final value)) {
      _hubs = value;
      _hubSelection.removeWhere((i) => i >= _hubs.length);
      if (_hubSelection.isEmpty) _hubSelection.add(0);
    }
  }

  Future<void> signOut() async {
    await _signOut();
    _signedIn = false;
    _hubSelection
      ..clear()
      ..add(0);
    _mobile = '';
    _user = null;
    _hubs = const [];
    notifyListeners();
  }

  DynamicUiScope scope({
    required DynamicFormController form,
    required UiActionHandler onAction,
    Map<String, Object?> data = const {},
  }) =>
      DynamicUiScope(
        flags: _flags,
        form: form,
        onAction: onAction,

        data: {
          'manager': {'name': managerName, 'mobile': _mobile},
          'hub': {'id': hubId, 'name': hubName, 'code': hubCode},
          ...data,
        },
      );
}
