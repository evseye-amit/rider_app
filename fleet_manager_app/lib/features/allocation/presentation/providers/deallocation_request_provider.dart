import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../allocation_dependencies.dart';
import '../../domain/entities/deallocation_request.dart';

final deallocationRequestProvider = FutureProvider.autoDispose.family<DeallocationRequest, String>(
  (ref, requestId) async => (await ref.watch(getDeallocationRequestProvider)(requestId)).getOrThrow(),
);

final deallocationFlowConfigProvider = FutureProvider.autoDispose<UiFlowConfig>(
  (ref) => ref.watch(uiConfigServiceProvider).loadFlow('deallocation_flow'),
);
