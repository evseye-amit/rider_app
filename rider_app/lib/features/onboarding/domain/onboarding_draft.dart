class OnboardingDraft {
  OnboardingDraft._();

  static final OnboardingDraft instance = OnboardingDraft._();

  Map<String, Object?> values = const {};

  int? jumpToStepIndex;

  void save(Map<String, Object?> next) => values = Map<String, Object?>.from(next);

  void clear() {
    values = const {};
    jumpToStepIndex = null;
  }
}
