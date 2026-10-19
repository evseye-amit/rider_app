import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/damage_charges_repository_impl.dart';
import 'domain/damage_charges_repository.dart';
import 'domain/usecases/damage_charge_usecases.dart';

final damageChargesRepositoryProvider = Provider<DamageChargesRepository>(
  (ref) => DamageChargesRepositoryImpl(
    ref.watch(submissionPenaltyApiProvider),
    ref.watch(riderBillingApiProvider),
    ref.watch(vehicleSubmissionApiProvider),
  ),
);

final getDamageChargesProvider = Provider<GetDamageCharges>(
  (ref) => GetDamageCharges(ref.watch(damageChargesRepositoryProvider)),
);

final getDamageChargeProvider = Provider<GetDamageCharge>(
  (ref) => GetDamageCharge(ref.watch(damageChargesRepositoryProvider)),
);

final getDamagePhotoUrlProvider = Provider<GetDamagePhotoUrl>(
  (ref) => GetDamagePhotoUrl(ref.watch(damageChargesRepositoryProvider)),
);

final payDamageChargeProvider = Provider<PayDamageCharge>(
  (ref) => PayDamageCharge(ref.watch(damageChargesRepositoryProvider)),
);
