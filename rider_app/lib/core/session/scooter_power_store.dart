import 'package:shared_preferences/shared_preferences.dart';

class ScooterPowerStore {
  ScooterPowerStore._();

  static final ScooterPowerStore instance = ScooterPowerStore._();

  static const String _pairedKey = 'evseye.scooter.paired';
  static const String _powerKey = 'evseye.scooter.powerOn';

  SharedPreferences? _prefs;

  bool _paired = false;
  bool _powerOn = false;
  bool _loaded = false;

  bool get paired => _paired;
  bool get powerOn => _powerOn;
  bool get loaded => _loaded;

  Future<void> load() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      _paired = _prefs!.getBool(_pairedKey) ?? false;
      _powerOn = _prefs!.getBool(_powerKey) ?? false;
    } on Object {
      _prefs = null;
    }
    _loaded = true;
  }

  Future<void> setPaired(bool value) async {
    _paired = value;
    await _write((p) => p.setBool(_pairedKey, value));
  }

  Future<void> setPowerOn(bool value) async {
    _powerOn = value;
    await _write((p) => p.setBool(_powerKey, value));
  }

  Future<void> reset() async {
    _paired = false;
    _powerOn = false;
    await _write((p) async {
      await p.remove(_pairedKey);
      await p.remove(_powerKey);
    });
  }

  Future<void> _write(Future<void> Function(SharedPreferences prefs) action) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await action(_prefs!);
    } on Object {
      _prefs = null;
    }
  }
}
