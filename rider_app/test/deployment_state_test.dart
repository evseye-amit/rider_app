import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rider_app/features/deployment/presentation/cubit/deployment_cubit.dart';

void main() {
  RiderDeployment deployment(String paymentStatus) => RiderDeployment.fromJson({
        'screen': 'PAYMENT',
        'allocation': {
          'id': 'alloc-1',
          'mobileDeployment': {'status': 'PAYMENT_PENDING'},
        },
        'payment': {'status': paymentStatus, 'amount': '3500', 'breakdown': {'items': [], 'total': '3500'}},
      });

  test('a submitted payment is a different state from a pending one', () {
    final DeploymentState pending = DeploymentState(status: DeploymentLoad.ready, deployment: deployment('PENDING'));
    final DeploymentState submitted =
        DeploymentState(status: DeploymentLoad.ready, deployment: deployment('SUBMITTED'));

    expect(pending, isNot(equals(submitted)));
    expect(pending, equals(DeploymentState(status: DeploymentLoad.ready, deployment: deployment('PENDING'))));
  });
}
