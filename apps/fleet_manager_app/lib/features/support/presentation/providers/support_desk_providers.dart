import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/desk_ticket.dart';
import '../../domain/usecases/support_desk_usecases.dart';
import '../../support_desk_dependencies.dart';

class DeskTicketsNotifier extends AsyncNotifier<DeskPage> {
  DeskTicketsNotifier(this._status);

  final TicketStatus? _status;
  bool _loadingMore = false;

  @override
  Future<DeskPage> build() => _first();

  Future<DeskPage> _first() async => (await ref.read(getDeskTicketsProvider)(DeskQuery(status: _status))).getOrThrow();

  Future<void> reload() async {
    final AsyncValue<DeskPage> next = await AsyncValue.guard(_first);
    if (ref.mounted) state = next;
  }

  Future<bool> loadMore() async {
    final DeskPage? current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return true;
    _loadingMore = true;
    final Result<DeskPage> next = await ref.read(getDeskTicketsProvider)(
      DeskQuery(cursor: current.nextCursor, status: _status),
    );
    _loadingMore = false;
    if (!ref.mounted) return false;
    if (next case Ok<DeskPage>(:final value)) {
      final Set<String> seen = {for (final DeskTicket ticket in current.tickets) ticket.id};
      state = AsyncData(
        DeskPage(
          tickets: [
            ...current.tickets,
            for (final DeskTicket ticket in value.tickets)
              if (!seen.contains(ticket.id)) ticket,
          ],
          nextCursor: value.nextCursor,
        ),
      );
    }
    return next.isOk;
  }
}

final deskTicketsProvider = AsyncNotifierProvider.autoDispose.family<DeskTicketsNotifier, DeskPage, TicketStatus?>(
  DeskTicketsNotifier.new,
);

final deskTicketProvider = FutureProvider.autoDispose.family<DeskThread, String>(
  (ref, id) async => (await ref.watch(getDeskTicketProvider)(id)).getOrThrow(),
);
