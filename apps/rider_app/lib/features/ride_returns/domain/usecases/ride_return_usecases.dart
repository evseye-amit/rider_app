import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../../../../core/location/geo_point.dart';
import '../entities/ride_return.dart';
import '../ride_returns_repository.dart';

class ReturnRequestParams extends Equatable {
  const ReturnRequestParams({
    required this.agreementId,
    required this.reasonCode,
    required this.hubId,
    required this.date,
    required this.idempotencyKey,
    this.notes,
  });

  final String agreementId;
  final String reasonCode;
  final String hubId;
  final DateTime date;
  final String idempotencyKey;
  final String? notes;

  @override
  List<Object?> get props => [agreementId, reasonCode, hubId, date, idempotencyKey, notes];
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

class GetReturnablePlans extends UseCase<List<ReturnablePlan>, NoParams> {
  const GetReturnablePlans(this._repository);

  final RideReturnsRepository _repository;

  @override
  Future<Result<List<ReturnablePlan>>> call(NoParams params) => _repository.returnablePlans();
}

class GetReturnHubs extends UseCase<List<ReturnHub>, GeoPoint> {
  const GetReturnHubs(this._repository);

  final RideReturnsRepository _repository;

  @override
  Future<Result<List<ReturnHub>>> call(GeoPoint params) => _repository.hubs(params);
}

class RequestRideReturn extends UseCase<RideReturn, ReturnRequestParams> {
  const RequestRideReturn(this._repository);

  final RideReturnsRepository _repository;

  @override
  Future<Result<RideReturn>> call(ReturnRequestParams params) => _repository.request(
    agreementId: params.agreementId,
    reasonCode: params.reasonCode,
    hubId: params.hubId,
    date: params.date,
    idempotencyKey: params.idempotencyKey,
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
