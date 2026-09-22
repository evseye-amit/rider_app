import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  TokenStore({SharedPreferences? preferences}) : _prefs = preferences;

  static const String _accessKey = 'evseye.accessToken';
  static const String _refreshKey = 'evseye.refreshToken';
  static const String _mobileKey = 'evseye.mobile';

  SharedPreferences? _prefs;

  String? _access;
  String? _refresh;
  String? _mobile;

  String? get accessToken => _access;
  String? get refreshToken => _refresh;
  String? get mobile => _mobile;
  bool get hasSession => _refresh != null && _refresh!.isNotEmpty;

  Future<void> load() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      _access = _prefs!.getString(_accessKey);
      _refresh = _prefs!.getString(_refreshKey);
      _mobile = _prefs!.getString(_mobileKey);
    } on Object {
      _prefs = null;
    }
  }

  Future<void> save({required String accessToken, required String refreshToken}) async {
    _access = accessToken;
    _refresh = refreshToken;
    await _write((p) async {
      await p.setString(_accessKey, accessToken);
      await p.setString(_refreshKey, refreshToken);
    });
  }

  Future<void> saveMobile(String mobile) async {
    _mobile = mobile;
    await _write((p) => p.setString(_mobileKey, mobile));
  }

  Future<void> saveAccess(String accessToken) async {
    _access = accessToken;
    await _write((p) => p.setString(_accessKey, accessToken));
  }

  Future<void> clear() async {
    _access = null;
    _refresh = null;
    _mobile = null;
    await _write((p) async {
      await p.remove(_accessKey);
      await p.remove(_refreshKey);
      await p.remove(_mobileKey);
    });
  }

  Future<void> _write(Future<void> Function(SharedPreferences prefs) op) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await op(_prefs!);
    } on Object {
      _prefs = null;
    }
  }
}
