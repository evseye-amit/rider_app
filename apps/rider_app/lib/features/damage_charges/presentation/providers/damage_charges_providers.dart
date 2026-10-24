import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../damage_charges_dependencies.dart';
import '../../domain/entities/damage_charge.dart';
import '../../domain/usecases/damage_charge_usecases.dart';

final damageChargesSummaryProvider = FutureProvider.autoDispose<DamageChargesSummary>(
  (ref) async => (await ref.watch(getDamageChargesSummaryProvider)(const NoParams())).getOrThrow(),
);

final damageChargesProvider = FutureProvider.autoDispose<List<DamageCharge>>(
  (ref) async => (await ref.watch(getDamageChargesProvider)(const NoParams())).getOrThrow(),
);

final damageChargeProvider = FutureProvider.autoDispose.family<DamageCharge, String>(
  (ref, id) async => (await ref.watch(getDamageChargeProvider)(id)).getOrThrow(),
);

final damagePhotoUrlProvider = FutureProvider.autoDispose.family<String, DamagePhotoParams>(
  (ref, params) async => (await ref.watch(getDamagePhotoUrlProvider)(params)).getOrThrow(),
);
