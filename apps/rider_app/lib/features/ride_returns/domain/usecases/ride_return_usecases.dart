import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/ride_return.dart';
import '../ride_returns_repository.dart';

class ReturnRequestParams extends Equatable {
  const ReturnRequestParams({
    required this.date,
    required this.idempotencyKey,
    this.reasonCode,
    this.hubId,
    this.notes,
  });

  final DateTime date;
  final String idempotencyKey;
  final String? reasonCode;
  final String? hubId;
  final String? notes;

  @override
  List<Object?> get props => [date, idempotencyKey, reasonCode, hubId, notes];
}

class ApproveChargesParams extends Equatable {
  const ApproveChargesParams({required this.id, required this.requestId, required this.code});

  final String id;
  final String requestId;
  final String code;

  @override
  List<Object?> get props => [id, requestId, code];
}

class DisputeChargesParams extends Equatable {
  const DisputeChargesParams({required this.id, required this.reason});

  final String id;
  final String reason;

  @override
  List<Object?> get props => [id, reason];
}

class GetRideReturns extends UseCase<ReturnPage, String?> {
  const GetRideReturns(this._repository);

  final RideReturnsRepository _repository;

  @override
  Future<Result<ReturnPage>> call(String? params) => _repository.returns(cursor: params);
}

class GetRideReturn extends UseCase<RideReturn, String> {
  const GetRideReturn(this._repository);

  final RideReturnsRepository _repository;

  @override
  Future<Result<RideReturn>> call(String params) => _repository.detail(params);
}

class RequestRideReturn extends UseCase<RideReturn, ReturnRequestParams> {
  const RequestRideReturn(this._repository);

  final RideReturnsRepository _repository;

  @override
  Future<Result<RideReturn>> call(ReturnRequestParams params) => _repository.request(
    date: params.date,
    idempotencyKey: params.idempotencyKey,
    reasonCode: params.reasonCode,
    hubId: params.hubId,
    notes: params.notes,
  );
}

class CancelRideReturn extends UseCase<void, String> {
  const CancelRideReturn(this._repository);

  final RideReturnsRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.cancel(params);
}

class RequestChargesApprovalCode extends UseCase<ApprovalCode, String> {
  const RequestChargesApprovalCode(this._repository);

  final RideReturnsRepository _repository;

  @override
  Future<Result<ApprovalCode>> call(String params) => _repository.requestApprovalCode(params);
}

class ApproveReturnCharges extends UseCase<void, ApproveChargesParams> {
  const ApproveReturnCharges(this._repository);

  final RideReturnsRepository _repository;

  @override
  Future<Result<void>> call(ApproveChargesParams params) =>
      _repository.approveCharges(params.id, requestId: params.requestId, code: params.code);
}

class DisputeReturnCharges extends UseCase<void, DisputeChargesParams> {
  const DisputeReturnCharges(this._repository);

  final RideReturnsRepository _repository;

  @override
  Future<Result<void>> call(DisputeChargesParams params) => _repository.disputeCharges(params.id, params.reason);
}
