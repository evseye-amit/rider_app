import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/return_case.dart';
import '../../domain/usecases/return_desk_usecases.dart';
import '../../return_desk_dependencies.dart';

class ReturnCasesNotifier extends AsyncNotifier<ReturnCasePage> {
  ReturnCasesNotifier(this._state);

  final ReturnState? _state;
  bool _loadingMore = false;

  @override
  Future<ReturnCasePage> build() => _first();

  Future<ReturnCasePage> _first() async =>
      (await ref.read(getReturnCasesProvider)(ReturnCaseQuery(state: _state))).getOrThrow();

  Future<void> reload() async {
    final AsyncValue<ReturnCasePage> next = await AsyncValue.guard(_first);
    if (ref.mounted) state = next;
  }

  Future<bool> loadMore() async {
    final ReturnCasePage? current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return true;
    _loadingMore = true;
    final Result<ReturnCasePage> next = await ref.read(getReturnCasesProvider)(
      ReturnCaseQuery(cursor: current.nextCursor, state: _state),
    );
    _loadingMore = false;
    if (!ref.mounted) return false;
    if (next case Ok<ReturnCasePage>(:final value)) {
      final Set<String> seen = {for (final ReturnCase item in current.items) item.id};
      state = AsyncData(
        ReturnCasePage(
          items: [
            ...current.items,
            for (final ReturnCase item in value.items)
              if (!seen.contains(item.id)) item,
          ],
          nextCursor: value.nextCursor,
        ),
      );
    }
    return next.isOk;
  }
}

final returnCasesProvider = AsyncNotifierProvider.autoDispose.family<ReturnCasesNotifier, ReturnCasePage, ReturnState?>(
  ReturnCasesNotifier.new,
);

final returnCaseProvider = FutureProvider.autoDispose.family<ReturnCase, String>(
  (ref, id) async => (await ref.watch(getReturnCaseProvider)(id)).getOrThrow(),
);

final inspectionSheetProvider = FutureProvider.autoDispose.family<InspectionSheet, String>(
  (ref, inspectionId) async => (await ref.watch(getInspectionSheetProvider)(inspectionId)).getOrThrow(),
);

final penaltyPricesProvider = FutureProvider.autoDispose<List<PenaltyPrice>>(
  (ref) async => (await ref.watch(getPenaltyPricesProvider)(const NoParams())).getOrThrow(),
);
