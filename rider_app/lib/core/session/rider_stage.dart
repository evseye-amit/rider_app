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
    devicePairing || active => Routes.home,
  };

  static RiderStage fromScreen(RiderScreen screen) => switch (screen) {
    RiderScreen.onboarding => onboarding,
    RiderScreen.waiting => waiting,
    RiderScreen.payment => payment,
    RiderScreen.pdi => pdi,
    RiderScreen.training => training,
    RiderScreen.devicePairing => devicePairing,
    RiderScreen.home => active,
  };
}
