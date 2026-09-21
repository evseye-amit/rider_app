import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  TokenStore({SharedPreferences? preferences}) : _prefs = preferences;

  static const String _accessKey = 'evseye.accessToken';
  static const String _refreshKey = 'evseye.refreshToken';

  SharedPreferences? _prefs;

  String? _access;
  String? _refresh;

  String? get accessToken => _access;
  String? get refreshToken => _refresh;
  bool get hasSession => _refresh != null && _refresh!.isNotEmpty;

  Future<void> load() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      _access = _prefs!.getString(_accessKey);
      _refresh = _prefs!.getString(_refreshKey);
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

  Future<void> saveAccess(String accessToken) async {
    _access = accessToken;
    await _write((p) => p.setString(_accessKey, accessToken));
  }

  Future<void> clear() async {
    _access = null;
    _refresh = null;
    await _write((p) async {
      await p.remove(_accessKey);
      await p.remove(_refreshKey);
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
