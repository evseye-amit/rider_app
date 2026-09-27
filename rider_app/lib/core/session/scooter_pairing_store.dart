import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScooterPairingStore {
  const ScooterPairingStore(this._preferences);

  static const String _pairedKey = 'evseye.scooter.paired';

  final SharedPreferences _preferences;

  bool get paired => _preferences.getBool(_pairedKey) ?? false;

  Future<void> setPaired(bool value) => _preferences.setBool(_pairedKey, value);

  Future<void> reset() => _preferences.remove(_pairedKey);
}

final scooterPairingStoreProvider = Provider<ScooterPairingStore>(
  (ref) => ScooterPairingStore(ref.watch(sharedPreferencesProvider)),
);
