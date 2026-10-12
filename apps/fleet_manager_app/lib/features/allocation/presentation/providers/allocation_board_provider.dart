import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../allocation_dependencies.dart';
import '../../domain/entities/allocation_board.dart';

final allocationBoardProvider = FutureProvider.autoDispose<AllocationBoard>(
  (ref) async => (await ref.watch(getAllocationBoardProvider)(const NoParams())).getOrThrow(),
);
