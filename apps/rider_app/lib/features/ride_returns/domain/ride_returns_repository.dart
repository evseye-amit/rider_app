import 'package:evseye_core/evseye_core.dart';

import '../../../core/location/geo_point.dart';
import 'entities/ride_return.dart';

abstract interface class RideReturnsRepository {
  Future<Result<ReturnPage>> returns({String? cursor});

  Future<Result<RideReturn>> detail(String id);

  Future<Result<List<ReturnablePlan>>> returnablePlans();

  Future<Result<List<ReturnHub>>> hubs(GeoPoint origin);

  Future<Result<RideReturn>> request({
    required String agreementId,
    required String reasonCode,
    required String hubId,
    required DateTime date,
    required String idempotencyKey,
    String? notes,
  });

  Future<Result<void>> cancel(String id);

  Future<Result<ApprovalCode>> requestApprovalCode(String id);

  Future<Result<void>> approveCharges(String id, {required String requestId, required String code});

  Future<Result<void>> disputeCharges(String id, String reason);
}
