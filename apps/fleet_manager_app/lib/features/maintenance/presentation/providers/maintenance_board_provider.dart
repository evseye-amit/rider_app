import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/maintenance_board.dart';
import '../../maintenance_dependencies.dart';

final maintenanceBoardProvider = FutureProvider.autoDispose<MaintenanceBoard>(
  (ref) async => (await ref.watch(getMaintenanceBoardProvider)(const NoParams())).getOrThrow(),
);
