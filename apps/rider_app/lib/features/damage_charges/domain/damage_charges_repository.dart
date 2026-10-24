import 'package:evseye_core/evseye_core.dart';

import 'entities/damage_charge.dart';

abstract interface class DamageChargesRepository {
  Future<Result<DamageChargesSummary>> getSummary();

  Future<Result<List<DamageCharge>>> getCharges();

  Future<Result<DamageCharge>> getCharge(String id);

  Future<Result<String>> getPhotoUrl({required String submissionId, required String photoId});
}
