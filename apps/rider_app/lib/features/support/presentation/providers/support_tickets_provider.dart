import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/support_ticket.dart';
import '../../support_dependencies.dart';

class SupportTicketsNotifier extends AsyncNotifier<TicketPage> {
  bool _loadingMore = false;

  @override
  Future<TicketPage> build() async => (await ref.read(getSupportTicketsProvider)(null)).getOrThrow();

  Future<void> reload() async {
    final AsyncValue<TicketPage> next = await AsyncValue.guard(
      () async => (await ref.read(getSupportTicketsProvider)(null)).getOrThrow(),
    );
    if (ref.mounted) state = next;
  }

  Future<bool> loadMore() async {
    final TicketPage? current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return true;
    _loadingMore = true;
    final Result<TicketPage> next = await ref.read(getSupportTicketsProvider)(current.nextCursor);
    _loadingMore = false;
    if (!ref.mounted) return false;
    if (next case Ok<TicketPage>(:final value)) {
      final Set<String> seen = {for (final SupportTicket ticket in current.tickets) ticket.id};
      state = AsyncData(
        TicketPage(
          tickets: [
            ...current.tickets,
            for (final SupportTicket ticket in value.tickets)
              if (!seen.contains(ticket.id)) ticket,
          ],
          nextCursor: value.nextCursor,
        ),
      );
    }
    return next.isOk;
  }
}

final supportTicketsProvider = AsyncNotifierProvider.autoDispose<SupportTicketsNotifier, TicketPage>(
  SupportTicketsNotifier.new,
);

final supportTicketProvider = FutureProvider.autoDispose.family<TicketThread, String>(
  (ref, id) async => (await ref.watch(getSupportTicketProvider)(id)).getOrThrow(),
);
