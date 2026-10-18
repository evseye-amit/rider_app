import 'package:evseye_core/evseye_core.dart';

import '../../app/router/app_routes.dart';

enum RiderStage {
  signedOut,
  onboarding,
  waiting,
  planAcceptance,
  payment,
  pdi,
  training,
  active;

  String get route => switch (this) {
    signedOut => Routes.login,
    onboarding => Routes.onboarding,
    waiting => Routes.deploymentWaiting,
    planAcceptance => Routes.deploymentPlan,
    payment => Routes.deploymentPayment,
    pdi => Routes.deploymentPdi,
    training => Routes.deploymentTraining,
    active => Routes.home,
  };

  static RiderStage fromScreen(RiderScreen screen) => switch (screen) {
    RiderScreen.onboarding => onboarding,
    RiderScreen.waiting => waiting,
    RiderScreen.planAcceptance => planAcceptance,
    RiderScreen.payment => payment,
    RiderScreen.pdi => pdi,
    RiderScreen.training => training,
    RiderScreen.home => active,
  };
}
