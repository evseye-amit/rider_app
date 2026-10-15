import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/location/geo_point.dart';
import '../../domain/entities/ride_return.dart';
import '../../ride_returns_dependencies.dart';

class RideReturnsNotifier extends AsyncNotifier<ReturnPage> {
  bool _loadingMore = false;

  @override
  Future<ReturnPage> build() async => (await ref.read(getRideReturnsProvider)(null)).getOrThrow();

  Future<void> reload() async {
    final AsyncValue<ReturnPage> next = await AsyncValue.guard(
      () async => (await ref.read(getRideReturnsProvider)(null)).getOrThrow(),
    );
    if (ref.mounted) state = next;
  }

  Future<bool> loadMore() async {
    final ReturnPage? current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return true;
    _loadingMore = true;
    final Result<ReturnPage> next = await ref.read(getRideReturnsProvider)(current.nextCursor);
    _loadingMore = false;
    if (!ref.mounted) return false;
    if (next case Ok<ReturnPage>(:final value)) {
      final Set<String> seen = {for (final RideReturn item in current.returns) item.id};
      state = AsyncData(
        ReturnPage(
          returns: [
            ...current.returns,
            for (final RideReturn item in value.returns)
              if (!seen.contains(item.id)) item,
          ],
          nextCursor: value.nextCursor,
        ),
      );
    }
    return next.isOk;
  }
}

final rideReturnsProvider = AsyncNotifierProvider.autoDispose<RideReturnsNotifier, ReturnPage>(RideReturnsNotifier.new);

final rideReturnProvider = FutureProvider.autoDispose.family<RideReturn, String>(
  (ref, id) async => (await ref.watch(getRideReturnProvider)(id)).getOrThrow(),
);

final returnablePlansProvider = FutureProvider.autoDispose<List<ReturnablePlan>>(
  (ref) async => (await ref.watch(getReturnablePlansProvider)(const NoParams())).getOrThrow(),
);

final returnHubsProvider = FutureProvider.autoDispose.family<List<ReturnHub>, GeoPoint>(
  (ref, origin) async => (await ref.watch(getReturnHubsProvider)(origin)).getOrThrow(),
);
