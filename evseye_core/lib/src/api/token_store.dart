import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  TokenStore(SharedPreferences preferences)
    : _preferences = preferences,
      _access = preferences.getString(_accessKey),
      _refresh = preferences.getString(_refreshKey),
      _mobile = preferences.getString(_mobileKey);

  static const String _accessKey = 'evseye.accessToken';
  static const String _refreshKey = 'evseye.refreshToken';
  static const String _mobileKey = 'evseye.mobile';

  final SharedPreferences _preferences;

  String? _access;
  String? _refresh;
  String? _mobile;

  String? get accessToken => _access;
  String? get refreshToken => _refresh;
  String? get mobile => _mobile;
  bool get hasSession => _refresh != null && _refresh!.isNotEmpty;

  Future<void> save({required String accessToken, required String refreshToken}) async {
    _access = accessToken;
    _refresh = refreshToken;
    await _preferences.setString(_accessKey, accessToken);
    await _preferences.setString(_refreshKey, refreshToken);
  }

  Future<void> saveAccess(String accessToken) async {
    _access = accessToken;
    await _preferences.setString(_accessKey, accessToken);
  }

  Future<void> saveMobile(String mobile) async {
    _mobile = mobile;
    await _preferences.setString(_mobileKey, mobile);
  }

  Future<void> clear() async {
    _access = null;
    _refresh = null;
    _mobile = null;
    await _preferences.remove(_accessKey);
    await _preferences.remove(_refreshKey);
    await _preferences.remove(_mobileKey);
  }
}
