import 'package:evseye_core/evseye_core.dart';

import 'entities/ride_return.dart';

abstract interface class RideReturnsRepository {
  Future<Result<ReturnPage>> returns({String? cursor});

  Future<Result<RideReturn>> detail(String id);

  Future<Result<RideReturn>> request({
    required DateTime date,
    required String idempotencyKey,
    String? reasonCode,
    String? hubId,
    String? notes,
  });

  Future<Result<void>> cancel(String id);

  Future<Result<ApprovalCode>> requestApprovalCode(String id);

  Future<Result<void>> approveCharges(String id, {required String requestId, required String code});

  Future<Result<void>> disputeCharges(String id, String reason);
}
