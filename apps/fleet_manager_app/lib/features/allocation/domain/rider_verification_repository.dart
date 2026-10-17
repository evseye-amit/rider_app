import 'package:evseye_core/evseye_core.dart';

import 'entities/rider_verification.dart';

abstract interface class RiderVerificationRepository {
  Future<Result<VerificationRider>> rider(String riderId);

  Future<Result<List<RiderDocument>>> documents(VerificationRider rider);

  Future<Result<void>> reviewDocument(String documentId, {required bool approve, String? reason});

  Future<Result<List<RiderReference>>> references(String riderId);

  Future<Result<void>> reviewReference(String referenceId, {required bool approve, String? reason});
}
