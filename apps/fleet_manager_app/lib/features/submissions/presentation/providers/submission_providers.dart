import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/submission_usecases.dart';
import '../../submission_dependencies.dart';

typedef SubmissionQueueKey = ({SubmissionSource source, SubmissionPhase phase});

class SubmissionQueueNotifier extends AsyncNotifier<SubmissionQueuePage> {
  SubmissionQueueNotifier(this._key);

  final SubmissionQueueKey _key;
  bool _loadingMore = false;

  @override
  Future<SubmissionQueuePage> build() => _page(1);

  Future<SubmissionQueuePage> _page(int page) async => (await ref.read(getSubmissionQueueProvider)(
    SubmissionQueueQuery(source: _key.source, phase: _key.phase, page: page),
  )).getOrThrow();

  Future<void> reload() async {
    final AsyncValue<SubmissionQueuePage> next = await AsyncValue.guard(() => _page(1));
    if (ref.mounted) state = next;
  }

  Future<bool> loadMore() async {
    final SubmissionQueuePage? current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return true;
    _loadingMore = true;
    final Result<SubmissionQueuePage> next = await ref.read(getSubmissionQueueProvider)(
      SubmissionQueueQuery(source: _key.source, phase: _key.phase, page: current.page + 1),
    );
    _loadingMore = false;
    if (!ref.mounted) return false;
    if (next case Ok<SubmissionQueuePage>(:final value)) {
      final Set<String> seen = {for (final SubmissionRequestDto item in current.items) item.id};
      state = AsyncData(
        SubmissionQueuePage(
          items: [
            ...current.items,
            for (final SubmissionRequestDto item in value.items)
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

final submissionQueueProvider = AsyncNotifierProvider.autoDispose
    .family<SubmissionQueueNotifier, SubmissionQueuePage, SubmissionQueueKey>(SubmissionQueueNotifier.new);

final submissionProvider = FutureProvider.autoDispose.family<VehicleSubmissionDto, String>(
  (ref, id) async => (await ref.watch(getSubmissionProvider)(id)).getOrThrow(),
);

final penaltyPricesProvider = FutureProvider.autoDispose<List<PenaltyPriceDto>>(
  (ref) async => (await ref.watch(getPenaltyPricesProvider)(const NoParams())).getOrThrow(),
);
