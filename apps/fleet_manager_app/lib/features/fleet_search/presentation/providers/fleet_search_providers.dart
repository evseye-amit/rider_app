import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/fleet_search_usecases.dart';
import '../../fleet_search_dependencies.dart';

class ScooterSearchNotifier extends AsyncNotifier<GlobalFleetPage> {
  ScooterSearchNotifier(this._query);

  final String _query;
  bool _loadingMore = false;

  @override
  Future<GlobalFleetPage> build() async => (await _page(1)).getOrThrow();

  Future<Result<GlobalFleetPage>> _page(int page) =>
      ref.read(searchScootersProvider)(ScooterSearchQuery(text: _query, page: page));

  Future<bool> loadMore() async {
    final GlobalFleetPage? current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return true;
    _loadingMore = true;
    final Result<GlobalFleetPage> next = await _page(current.page + 1);
    _loadingMore = false;
    if (!ref.mounted) return false;
    if (next case Ok<GlobalFleetPage>(:final value)) {
      final Set<String> seen = {for (final GlobalFleetDto fleet in current.items) fleet.id};
      state = AsyncData(
        GlobalFleetPage(
          items: [
            ...current.items,
            for (final GlobalFleetDto fleet in value.items)
              if (!seen.contains(fleet.id)) fleet,
          ],
          page: value.page,
          hasMore: value.hasMore,
        ),
      );
    }
    return next.isOk;
  }
}

final scooterSearchProvider = AsyncNotifierProvider.autoDispose.family<ScooterSearchNotifier, GlobalFleetPage, String>(
  ScooterSearchNotifier.new,
);

final scooterProvider = FutureProvider.autoDispose.family<GlobalFleetDetailDto, String>(
  (ref, fleetId) async => (await ref.watch(getScooterProvider)(fleetId)).getOrThrow(),
);

final scooterRidersProvider = FutureProvider.autoDispose.family<List<GlobalFleetRiderDto>, String>(
  (ref, fleetId) async => (await ref.watch(getScooterRidersProvider)(fleetId)).getOrThrow(),
);
