import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/legal_api.dart';
import '../l10n/locale_provider.dart';
import '../providers/core_providers.dart';
import '../utils/result.dart';

class ConsentNotifier extends Notifier<bool> {
  static const String _acceptedKey = 'app.consent.accepted';
  static const String _documentKey = 'app.consent.documentId';
  static const String _hashKey = 'app.consent.contentHash';
  static const String _localeKey = 'app.consent.locale';
  static const String _recordedKey = 'app.consent.recordedFor';

  SharedPreferences get _preferences => ref.read(sharedPreferencesProvider);

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_acceptedKey) ?? false;

  Future<void> accept({required String documentId, required String contentHash, required String locale}) async {
    state = true;
    await _preferences.setBool(_acceptedKey, true);
    await _preferences.setString(_documentKey, documentId);
    await _preferences.setString(_hashKey, contentHash);
    await _preferences.setString(_localeKey, locale);
    await _preferences.remove(_recordedKey);
  }

  Future<void> verify(LegalAudience audience) async {
    if (!state) return;
    final String locale = _preferences.getString(_localeKey) ?? ref.read(localeProvider).locale.code;
    final Result<LegalDocumentDto> current = await ref
        .read(legalApiProvider)
        .current(audience: audience, kind: LegalKind.consent, locale: locale);
    final LegalDocumentDto? latest = current.valueOrNull;
    if (latest == null) return;
    if (latest.id == _preferences.getString(_documentKey) && latest.contentHash == _preferences.getString(_hashKey)) {
      return;
    }
    state = false;
    await _preferences.setBool(_acceptedKey, false);
  }

  Future<void> recordAcceptance(String userId) async {
    final String? documentId = _preferences.getString(_documentKey);
    final String? contentHash = _preferences.getString(_hashKey);
    if (!state || documentId == null || contentHash == null || userId.isEmpty) return;
    final String marker = '$userId:$documentId';
    if (_preferences.getString(_recordedKey) == marker) return;
    final Result<void> result = await ref
        .read(legalApiProvider)
        .accept(documentId: documentId, contentHash: contentHash);
    if (result is Ok<void>) await _preferences.setString(_recordedKey, marker);
  }
}

final consentProvider = NotifierProvider<ConsentNotifier, bool>(ConsentNotifier.new);
