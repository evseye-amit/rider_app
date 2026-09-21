import 'dart:io';

class OnboardingDraft {
  OnboardingDraft._();

  static final OnboardingDraft instance = OnboardingDraft._();

  Map<String, Object?> values = const {};

  final Map<String, File> pendingUploads = {};

  int? jumpToStepIndex;

  void save(Map<String, Object?> next) => values = Map<String, Object?>.from(next);

  void attach(String key, File file) => pendingUploads[key] = file;

  void detach(String key) => pendingUploads.remove(key);

  void clear() {
    values = const {};
    pendingUploads.clear();
    jumpToStepIndex = null;
  }
}
