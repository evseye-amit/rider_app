import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

abstract interface class OnboardingRepository {
  Future<Result<RiderOnboardingConfig>> fetch();

  Future<Result<RiderOnboardingConfig>> saveStep(String stepId, Map<String, Object?> values);

  Future<Result<RemotePhoto>> uploadDocument({
    required String fieldCode,
    required File file,
  });
}
