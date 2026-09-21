import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import 'active_allocation.dart';
import 'deallocation_request.dart';

class AllocationBoard extends Equatable {
  const AllocationBoard({
    required this.pending,
    required this.inProgress,
    required this.active,
    required this.returns,
  });

  final List<PendingRider> pending;
  final List<DeploymentAllocation> inProgress;
  final List<ActiveAllocation> active;
  final List<DeallocationRequest> returns;

  int get needingAction => inProgress.where((a) => !a.deploymentStatus.waitsOnRider).length;

  @override
  List<Object?> get props => [pending, inProgress, active, returns];
}
