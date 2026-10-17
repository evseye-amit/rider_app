import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/core_providers.dart';
import '../utils/result.dart';

class ConsentNotifier extends Notifier<bool> {
  static const String _acceptedKey = 'app.consent.accepted';
  static const String _documentKey = 'app.consent.documentId';
  static const String _hashKey = 'app.consent.contentHash';
  static const String _recordedKey = 'app.consent.recordedFor';

  SharedPreferences get _preferences => ref.read(sharedPreferencesProvider);

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_acceptedKey) ?? false;

  Future<void> accept({required String documentId, required String contentHash}) async {
    state = true;
    await _preferences.setBool(_acceptedKey, true);
    await _preferences.setString(_documentKey, documentId);
    await _preferences.setString(_hashKey, contentHash);
    await _preferences.remove(_recordedKey);
  }

  Future<void> recordAcceptance(String userId) async {
    final String? documentId = _preferences.getString(_documentKey);
    final String? contentHash = _preferences.getString(_hashKey);
    if (documentId == null || contentHash == null || userId.isEmpty) return;
    final String marker = '$userId:$documentId';
    if (_preferences.getString(_recordedKey) == marker) return;
    final Result<void> result = await ref
        .read(legalApiProvider)
        .accept(documentId: documentId, contentHash: contentHash);
    if (result is Ok<void>) await _preferences.setString(_recordedKey, marker);
  }
}

final consentProvider = NotifierProvider<ConsentNotifier, bool>(ConsentNotifier.new);
