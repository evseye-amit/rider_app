import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rider_app/app/router/app_routes.dart';
import 'package:rider_app/core/session/rider_stage.dart';

void main() {
  group('riderStageFrom', () {
    test('no rider row means the form is still open', () {
      expect(riderStageFrom(RiderScreen.onboarding), RiderStage.onboarding);
    });

    test('each deployment screen the API names has a stage', () {
      expect(riderStageFrom(RiderScreen.waiting), RiderStage.waiting);
      expect(riderStageFrom(RiderScreen.payment), RiderStage.payment);
      expect(riderStageFrom(RiderScreen.pdi), RiderStage.pdi);
      expect(riderStageFrom(RiderScreen.training), RiderStage.training);
      expect(riderStageFrom(RiderScreen.devicePairing), RiderStage.devicePairing);
    });

    test('deployed means home', () {
      expect(riderStageFrom(RiderScreen.home), RiderStage.active);
    });
  });

  group('RiderScreen.parse', () {
    test('reads the API wire values, whatever the case', () {
      expect(RiderScreen.parse('ONBOARDING'), RiderScreen.onboarding);
      expect(RiderScreen.parse('payment'), RiderScreen.payment);
      expect(RiderScreen.parse('DEVICE_PAIRING'), RiderScreen.devicePairing);
      expect(RiderScreen.parse('HOME'), RiderScreen.home);
    });

    test('anything unknown is a wait, never a crash or a home screen', () {
      expect(RiderScreen.parse(null), RiderScreen.waiting);
      expect(RiderScreen.parse(''), RiderScreen.waiting);
      expect(RiderScreen.parse('SOMETHING_NEW'), RiderScreen.waiting);
    });
  });

  group('RiderStage.route', () {
    test('every stage lands on exactly one screen', () {
      expect(RiderStage.signedOut.route, Routes.login);
      expect(RiderStage.onboarding.route, Routes.onboarding);
      expect(RiderStage.waiting.route, Routes.deploymentWaiting);
      expect(RiderStage.payment.route, Routes.deploymentPayment);
      expect(RiderStage.pdi.route, Routes.deploymentPdi);
      expect(RiderStage.training.route, Routes.deploymentTraining);
      expect(RiderStage.devicePairing.route, Routes.deploymentPairing);
      expect(RiderStage.active.route, Routes.home);
    });

    test('the deployment stages are the ones between the form and the tabs', () {
      for (final stage in RiderStage.values) {
        final bool between = stage != RiderStage.signedOut && stage != RiderStage.onboarding && stage != RiderStage.active;
        expect(stage.isDeploying, between, reason: '$stage');
      }
    });
  });

  group('DeploymentStatus', () {
    test('parses the workflow wire values and orders them', () {
      expect(DeploymentStatus.parse('RIDER_WAITING'), DeploymentStatus.riderWaiting);
      expect(DeploymentStatus.parse('DEPLOYED'), DeploymentStatus.deployed);
      expect(DeploymentStatus.parse('nope'), DeploymentStatus.unknown);
      expect(DeploymentStatus.paymentPending.step, lessThan(DeploymentStatus.pdiPendingRider.step));
    });

    test('knows whose move it is', () {
      expect(DeploymentStatus.paymentPending.waitsOnRider, isTrue);
      expect(DeploymentStatus.trainingPending.waitsOnRider, isTrue);
      expect(DeploymentStatus.fleetRequested.waitsOnRider, isFalse);
      expect(DeploymentStatus.paymentPaid.waitsOnRider, isFalse);
    });
  });
}
