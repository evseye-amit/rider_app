import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auto_pay.dart';
import '../../payments_dependencies.dart';

class AutoRechargesNotifier extends AsyncNotifier<AutoRechargePage> {
  bool _loadingMore = false;

  @override
  Future<AutoRechargePage> build() async => (await ref.read(getAutoRechargesProvider)(1)).getOrThrow();

  Future<void> reload() async {
    final AsyncValue<AutoRechargePage> next = await AsyncValue.guard(
      () async => (await ref.read(getAutoRechargesProvider)(1)).getOrThrow(),
    );
    if (ref.mounted) state = next;
  }

  Future<bool> loadMore() async {
    final AutoRechargePage? current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return true;
    _loadingMore = true;
    final Result<AutoRechargePage> next = await ref.read(getAutoRechargesProvider)(current.page + 1);
    _loadingMore = false;
    if (!ref.mounted) return false;
    if (next case Ok<AutoRechargePage>(:final value)) {
      final Set<String> seen = {for (final AutoRecharge item in current.items) item.id};
      state = AsyncData(
        AutoRechargePage(
          items: [
            ...current.items,
            for (final AutoRecharge item in value.items)
              if (!seen.contains(item.id)) item,
          ],
          page: value.page,
          hasMore: value.hasMore,
        ),
      );
    }
    return next.isOk;
  }
}

final autoRechargesProvider = AsyncNotifierProvider.autoDispose<AutoRechargesNotifier, AutoRechargePage>(
  AutoRechargesNotifier.new,
);
