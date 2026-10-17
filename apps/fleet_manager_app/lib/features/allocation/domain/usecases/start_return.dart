import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class StartReturnParams extends Equatable {
  const StartReturnParams({required this.riderId, required this.idempotencyKey, this.hubId});

  final String riderId;
  final String idempotencyKey;
  final String? hubId;

  @override
  List<Object?> get props => [riderId, idempotencyKey, hubId];
}

class StartReturn extends UseCase<String, StartReturnParams> {
  const StartReturn(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<String>> call(StartReturnParams params) =>
      _repository.startReturn(riderId: params.riderId, idempotencyKey: params.idempotencyKey, hubId: params.hubId);
}
