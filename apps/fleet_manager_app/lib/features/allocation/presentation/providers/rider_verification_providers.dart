import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../allocation_dependencies.dart';
import '../../domain/entities/rider_verification.dart';

final verificationRiderProvider = FutureProvider.autoDispose.family<VerificationRider, String>(
  (ref, riderId) async => (await ref.watch(getVerificationRiderProvider)(riderId)).getOrThrow(),
);

final riderDocumentsProvider = FutureProvider.autoDispose.family<List<RiderDocument>, String>((ref, riderId) async {
  final VerificationRider rider = await ref.watch(verificationRiderProvider(riderId).future);
  return (await ref.watch(getRiderDocumentsProvider)(rider)).getOrThrow();
});

final riderReferencesProvider = FutureProvider.autoDispose.family<List<RiderReference>, String>(
  (ref, riderId) async => (await ref.watch(getRiderReferencesProvider)(riderId)).getOrThrow(),
);
