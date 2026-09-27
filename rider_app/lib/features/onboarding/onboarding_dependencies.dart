import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/onboarding_repository_impl.dart';
import 'domain/onboarding_repository.dart';
import 'domain/usecases/get_onboarding.dart';
import 'domain/usecases/save_onboarding_step.dart';
import 'domain/usecases/upload_onboarding_document.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepositoryImpl(ref.watch(riderAppApiProvider), ref.watch(mediaApiProvider)),
);

final getOnboardingProvider = Provider<GetOnboarding>((ref) => GetOnboarding(ref.watch(onboardingRepositoryProvider)));

final saveOnboardingStepProvider = Provider<SaveOnboardingStep>(
  (ref) => SaveOnboardingStep(ref.watch(onboardingRepositoryProvider)),
);

final uploadOnboardingDocumentProvider = Provider<UploadOnboardingDocument>(
  (ref) => UploadOnboardingDocument(ref.watch(onboardingRepositoryProvider)),
);
