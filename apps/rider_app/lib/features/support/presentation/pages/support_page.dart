import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/support_ticket.dart';
import '../providers/support_tickets_provider.dart';
import '../widgets/ticket_status.dart';

class SupportPage extends ConsumerStatefulWidget {
  const SupportPage({super.key});

  @override
  ConsumerState<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends ConsumerState<SupportPage> {
  bool _loadingMore = false;

  Future<void> _raiseTicket() async {
    final String? ticketId = await context.push<String>(Routes.raiseTicket);
    if (!mounted) return;
    await ref.read(supportTicketsProvider.notifier).reload();
    if (ticketId != null && mounted) await _openTicket(ticketId);
  }

  Future<void> _openTicket(String id) async {
    await context.push(Uri(path: Routes.supportTicket, queryParameters: {'id': id}).toString());
    if (mounted) await ref.read(supportTicketsProvider.notifier).reload();
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    final bool loaded = await ref.read(supportTicketsProvider.notifier).loadMore();
    if (!mounted) return;
    setState(() => _loadingMore = false);
    if (!loaded) AppSnack.error(context, context.l10n.commonSomethingWentWrongPleaseTry);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<TicketPage> tickets = ref.watch(supportTicketsProvider);

    if (tickets.hasError && !tickets.hasValue) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.supportCouldNotLoadSupport,
            message: tickets.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(supportTicketsProvider),
          ),
        ),
      );
    }

    final TicketPage? page = tickets.value;

    return HeroScaffold(
      onRefresh: () => ref.read(supportTicketsProvider.notifier).reload(),
      band: _SupportBand(tickets: page?.tickets),
      children: page == null ? const [_SupportSkeleton()] : _content(page),
    );
  }

  List<Widget> _content(TicketPage page) {
    final int open = page.tickets.where((ticket) => ticket.isActive).length;
    return [
      ModuleCard(
        title: context.l10n.supportNeedHelpWithSomething,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.supportTellUsWhatHappenedAttach + context.l10n.supportTeamLeadSeesStraightAway,
              style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
            ),
            const Gap.lg(),
            PrimaryButton(label: context.l10n.supportRaiseTicket, icon: Icons.add_rounded, onPressed: _raiseTicket),
          ],
        ),
      ),
      const Gap.lg(),
      ModuleCard(
        title: context.l10n.supportTickets,
        child: page.tickets.isEmpty
            ? EmptyState(
                compact: true,
                title: context.l10n.supportNoTicketsYet,
                message: context.l10n.supportRaiseOneAboveIfSomething,
                icon: Icons.confirmation_num_outlined,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    open == 0 ? context.l10n.supportNothingOpenRightNow : context.l10n.supportOpenCount(open),
                    style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const Gap.md(),
                  for (final SupportTicket ticket in page.tickets) ...[
                    _TicketRow(ticket: ticket, onTap: () => _openTicket(ticket.id)),
                    if (ticket != page.tickets.last) Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
                  ],
                  if (page.hasMore) ...[
                    const Gap.md(),
                    _loadingMore
                        ? const Center(
                            child: SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                            ),
                          )
                        : GhostButton(label: context.l10n.commonLoadMore, onPressed: _loadMore),
                  ],
                ],
              ),
      ),
    ];
  }
}

class _SupportBand extends StatelessWidget {
  const _SupportBand({required this.tickets});

  final List<SupportTicket>? tickets;

  int _count(TicketStatus status) => tickets?.where((ticket) => ticket.status == status).length ?? 0;

  @override
  Widget build(BuildContext context) {
    final int open = _count(TicketStatus.open);
    final int inProgress = _count(TicketStatus.inProgress);
    final int resolved = _count(TicketStatus.resolved);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
            const SizedBox(width: Insets.md),
            const IconTile(icon: Icons.support_agent_rounded, tone: AppColors.primary, solid: true, size: 44),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.commonSupport,
                    style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.onInkSecondary),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    context.l10n.supportTickets,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleLarge.copyWith(fontSize: 20, color: AppColors.onInk),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap.xxl(),
        Text(context.l10n.supportOpenTickets, style: AppText.label.copyWith(color: AppColors.onInkSecondary)),
        const Gap.sm(),
        Text('${open + inProgress}', style: AppText.numericLarge.copyWith(fontSize: 38, color: AppColors.onInk)),
        const Gap.xl(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: Insets.md, horizontal: Insets.sm),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkStat(label: context.l10n.commonOpen, value: '$open', icon: Icons.pending_actions_rounded),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.supportInProgress,
                  value: '$inProgress',
                  icon: Icons.support_agent_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.supportResolved,
                  value: '$resolved',
                  icon: Icons.check_circle_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SupportSkeleton extends StatelessWidget {
  const _SupportSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 132, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 260, borderRadius: Corners.brXl),
      ],
    );
  }
}

class _TicketRow extends StatelessWidget {
  const _TicketRow({required this.ticket, required this.onTap});

  final SupportTicket ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TicketStatusStyle style = TicketStatusStyle.of(context, ticket.status);

    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
        child: Row(
          children: [
            IconTile(icon: style.icon, tone: style.tone.color, size: 40),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.subject,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(fontSize: 13.5),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      StatusChip(label: style.label, tone: style.tone, dense: true),
                      const SizedBox(width: Insets.sm),
                      Flexible(
                        child: Text(
                          context.l10n.supportUpdated(Fmt.relative(ticket.lastActivityAt)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySmall.copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
