import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/locale_provider.dart';
import 'company.dart';
import 'consent.dart';

enum FirstRunStep { company, language, consent }

final pendingFirstRunStepProvider = Provider.family<FirstRunStep?, bool>((ref, needsConsent) {
  if (ref.watch(companyProvider) == null) return FirstRunStep.company;
  if (!ref.watch(localeProvider.select((p) => p.hasBeenPrompted))) return FirstRunStep.language;
  if (needsConsent && !ref.watch(consentProvider)) return FirstRunStep.consent;
  return null;
});
