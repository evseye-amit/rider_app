import 'package:evseye_core/evseye_core.dart';

import '../../app/router/app_routes.dart';

enum RiderStage {
  signedOut,
  onboarding,
  waiting,
  payment,
  pdi,
  training,
  devicePairing,
  active;

  String get route => switch (this) {
        signedOut => Routes.login,
        onboarding => Routes.onboarding,
        waiting => Routes.deploymentWaiting,
        payment => Routes.deploymentPayment,
        pdi => Routes.deploymentPdi,
        training => Routes.deploymentTraining,
        devicePairing => Routes.home,
        active => Routes.home,
      };

  bool get isDeploying => switch (this) {
        waiting || payment || pdi || training => true,
        _ => false,
      };
}

RiderStage riderStageFrom(RiderScreen screen) => switch (screen) {
      RiderScreen.onboarding => RiderStage.onboarding,
      RiderScreen.waiting => RiderStage.waiting,
      RiderScreen.payment => RiderStage.payment,
      RiderScreen.pdi => RiderStage.pdi,
      RiderScreen.training => RiderStage.training,
      RiderScreen.devicePairing => RiderStage.devicePairing,
      RiderScreen.home => RiderStage.active,
    };
