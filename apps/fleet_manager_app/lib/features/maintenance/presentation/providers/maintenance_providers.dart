import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/maintenance_vehicle.dart';
import '../../domain/usecases/maintenance_usecases.dart';
import '../../maintenance_dependencies.dart';

typedef MaintenanceFilter = ({String? hubId, String search});

class MaintenanceListNotifier extends AsyncNotifier<MaintenanceVehicleList> {
  MaintenanceListNotifier(this._filter);

  final MaintenanceFilter _filter;
  bool _loadingMore = false;

  @override
  Future<MaintenanceVehicleList> build() async => (await _page(1)).getOrThrow();

  Future<Result<MaintenanceVehicleList>> _page(int page) => ref.read(getMaintenanceVehiclesProvider)(
    MaintenanceQuery(hubId: _filter.hubId, search: _filter.search, page: page),
  );

  Future<void> reload() async {
    final AsyncValue<MaintenanceVehicleList> next = await AsyncValue.guard(() async => (await _page(1)).getOrThrow());
    if (ref.mounted) state = next;
  }

  Future<bool> loadMore() async {
    final MaintenanceVehicleList? current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return true;
    _loadingMore = true;
    final Result<MaintenanceVehicleList> next = await _page(current.page + 1);
    _loadingMore = false;
    if (!ref.mounted) return false;
    if (next case Ok<MaintenanceVehicleList>(:final value)) {
      final Set<String> seen = {for (final MaintenanceVehicle vehicle in current.items) vehicle.id};
      state = AsyncData(
        MaintenanceVehicleList(
          items: [
            ...current.items,
            for (final MaintenanceVehicle vehicle in value.items)
              if (!seen.contains(vehicle.id)) vehicle,
          ],
          page: value.page,
          totalPages: value.totalPages,
          total: value.total,
          underMaintenance: value.underMaintenance,
        ),
      );
    }
    return next.isOk;
  }
}

final maintenanceListProvider = AsyncNotifierProvider.autoDispose
    .family<MaintenanceListNotifier, MaintenanceVehicleList, MaintenanceFilter>(MaintenanceListNotifier.new);

final maintenanceVehicleProvider = FutureProvider.autoDispose.family<MaintenanceVehicleDetail, String>(
  (ref, fleetId) async => (await ref.watch(getMaintenanceVehicleProvider)(fleetId)).getOrThrow(),
);

final evidencePhotoUrlProvider = FutureProvider.autoDispose.family<String, String>(
  (ref, photoId) async => (await ref.watch(getEvidencePhotoUrlProvider)(photoId)).getOrThrow(),
);
