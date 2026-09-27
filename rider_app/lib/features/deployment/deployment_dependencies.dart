import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/deployment_repository_impl.dart';
import 'domain/deployment_repository.dart';
import 'domain/usecases/accept_pdi.dart';
import 'domain/usecases/complete_training.dart';
import 'domain/usecases/get_current_deployment.dart';
import 'domain/usecases/get_deployment_payment.dart';
import 'domain/usecases/get_training.dart';
import 'domain/usecases/mark_training_viewed.dart';
import 'domain/usecases/submit_deployment_payment.dart';

final deploymentRepositoryProvider = Provider<DeploymentRepository>(
  (ref) => DeploymentRepositoryImpl(ref.watch(deploymentApiProvider)),
);

final getCurrentDeploymentProvider = Provider<GetCurrentDeployment>(
  (ref) => GetCurrentDeployment(ref.watch(deploymentRepositoryProvider)),
);

final getDeploymentPaymentProvider = Provider<GetDeploymentPayment>(
  (ref) => GetDeploymentPayment(ref.watch(deploymentRepositoryProvider)),
);

final submitDeploymentPaymentProvider = Provider<SubmitDeploymentPayment>(
  (ref) => SubmitDeploymentPayment(ref.watch(deploymentRepositoryProvider)),
);

final acceptPdiProvider = Provider<AcceptPdi>((ref) => AcceptPdi(ref.watch(deploymentRepositoryProvider)));

final getTrainingProvider = Provider<GetTraining>((ref) => GetTraining(ref.watch(deploymentRepositoryProvider)));

final markTrainingViewedProvider = Provider<MarkTrainingViewed>(
  (ref) => MarkTrainingViewed(ref.watch(deploymentRepositoryProvider)),
);

final completeTrainingProvider = Provider<CompleteTraining>(
  (ref) => CompleteTraining(ref.watch(deploymentRepositoryProvider)),
);
