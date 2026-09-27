import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/rider_session_provider.dart';

class OnboardingDraftNotifier extends Notifier<Map<String, Object?>> {
  @override
  Map<String, Object?> build() {
    ref.listen(riderSessionProvider.select((s) => s.isSignedIn), (_, signedIn) {
      if (!signedIn) clear();
    });
    return const {};
  }

  void save(Map<String, Object?> values) {
    state = Map<String, Object?>.unmodifiable(values);
  }

  void clear() {
    state = const {};
  }
}

final onboardingDraftProvider = NotifierProvider<OnboardingDraftNotifier, Map<String, Object?>>(
  OnboardingDraftNotifier.new,
);
