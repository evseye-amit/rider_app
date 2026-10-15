import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/fleet_session_provider.dart';
import '../../domain/entities/desk_ticket.dart';
import '../providers/support_desk_providers.dart';
import '../widgets/desk_widgets.dart';

class SupportDeskPage extends ConsumerStatefulWidget {
  const SupportDeskPage({super.key});

  @override
  ConsumerState<SupportDeskPage> createState() => _SupportDeskPageState();
}

class _SupportDeskPageState extends ConsumerState<SupportDeskPage> {
  static const List<TicketStatus?> _filters = [TicketStatus.open, TicketStatus.inProgress, TicketStatus.resolved, null];

  int _tab = 0;

  TicketStatus? get _status => _filters[_tab];

  Future<void> _open(DeskTicket ticket) async {
    await context.push(Uri(path: Routes.supportTicket, queryParameters: {'id': ticket.id}).toString());
    if (!mounted) return;
    for (final TicketStatus? status in _filters) {
      ref.invalidate(deskTicketsProvider(status));
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<DeskPage> tickets = ref.watch(deskTicketsProvider(_status));
    final Map<String, String> hubs = {
      for (final hub in ref.watch(fleetSessionProvider.select((session) => session.hubs))) hub.id: hub.name,
    };

    return AppScaffold(
      title: context.l10n.supportDeskTitle,
      subtitle: context.l10n.supportDeskSubtitle,
      body: Column(
        children: [
          const Gap.sm(),
          FilterChipBar(
            items: [
              context.l10n.commonOpen,
              context.l10n.supportInProgress,
              context.l10n.supportResolved,
              context.l10n.supportAll,
            ],
            selectedIndex: _tab,
            onChanged: (index) => setState(() => _tab = index),
          ),
          const Gap.md(),
          Expanded(child: _body(tickets, hubs)),
        ],
      ),
    );
  }

  Widget _body(AsyncValue<DeskPage> tickets, Map<String, String> hubs) {
    final DeskPage? page = tickets.value;
    if (page == null) {
      return tickets.hasError
          ? EmptyState(
              title: context.l10n.supportCouldNotLoadSupport,
              message: tickets.failureMessage,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: context.l10n.commonTryAgain,
              onAction: () => ref.invalidate(deskTicketsProvider(_status)),
            )
          : const PageBody(
              children: [
                ShimmerBox(height: 120, borderRadius: Corners.brXl),
                Gap.md(),
                ShimmerBox(height: 120, borderRadius: Corners.brXl),
                Gap.md(),
                ShimmerBox(height: 120, borderRadius: Corners.brXl),
              ],
            );
    }

    final DeskTicketsNotifier notifier = ref.read(deskTicketsProvider(_status).notifier);

    if (page.tickets.isEmpty) {
      return RefreshIndicator(
        onRefresh: notifier.reload,
        color: AppColors.primary,
        child: PageBody(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Insets.xl),
              child: EmptyState(
                title: context.l10n.supportDeskEmpty,
                message: context.l10n.supportDeskEmptyBody,
                icon: Icons.support_agent_rounded,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: notifier.reload,
      color: AppColors.primary,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(Insets.gutter, 0, Insets.gutter, Insets.x4l),
        itemCount: page.tickets.length + (page.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Gap.md(),
        itemBuilder: (context, index) {
          if (index == page.tickets.length) return LoadMoreTile(onLoad: notifier.loadMore);
          final DeskTicket ticket = page.tickets[index];
          return DeskTicketTile(ticket: ticket, hubName: hubs[ticket.hubId], onOpen: () => _open(ticket));
        },
      ),
    );
  }
}
