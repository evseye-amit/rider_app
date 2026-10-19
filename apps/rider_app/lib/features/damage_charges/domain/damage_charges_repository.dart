import 'package:evseye_core/evseye_core.dart';

import 'entities/damage_charge.dart';

abstract interface class DamageChargesRepository {
  Future<Result<List<DamageCharge>>> getCharges({required bool includePaid});

  Future<Result<DamageCharge>> getCharge(String id);

  Future<Result<String>> getPhotoUrl({required String submissionId, required String photoId});

  Future<Result<DamagePaymentResult>> pay(String id, {required String idempotencyKey});
}
