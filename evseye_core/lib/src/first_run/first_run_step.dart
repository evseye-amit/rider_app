import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/locale_provider.dart';
import 'terms_consent.dart';

enum FirstRunStep { terms, language }

final pendingFirstRunStepProvider = Provider<FirstRunStep?>((ref) {
  if (!ref.watch(termsConsentProvider)) return FirstRunStep.terms;
  if (!ref.watch(localeProvider.select((p) => p.hasBeenPrompted))) return FirstRunStep.language;
  return null;
});
