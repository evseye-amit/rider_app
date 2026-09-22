import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an empty payload opens onboarding', () {
    expect(RiderDeployment.fromJson(const {}).screen, RiderScreen.onboarding);
  });

  test('a payload with a screen is honoured', () {
    expect(RiderDeployment.fromJson(const {'screen': 'HOME'}).screen, RiderScreen.home);
    expect(RiderDeployment.fromJson(const {'screen': 'PAYMENT'}).screen, RiderScreen.payment);
  });

  test('a non-empty payload with an unknown screen still waits', () {
    expect(RiderDeployment.fromJson(const {'screen': 'SOMETHING_NEW'}).screen, RiderScreen.waiting);
  });
}
