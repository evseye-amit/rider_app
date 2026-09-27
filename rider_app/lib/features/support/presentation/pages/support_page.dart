import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/support_overview.dart';
import '../../domain/entities/support_ticket.dart';
import '../providers/support_overview_provider.dart';

class SupportPage extends ConsumerWidget {
  const SupportPage({super.key});

  Future<void> _raiseTicket(BuildContext context, WidgetRef ref) async {
    await context.push(Routes.raiseTicket);
    if (context.mounted) ref.invalidate(supportOverviewProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<SupportOverview> support = ref.watch(supportOverviewProvider);

    if (support.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.supportCouldNotLoadSupport,
            message: support.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(supportOverviewProvider),
          ),
        ),
      );
    }

    final SupportOverview? overview = support.value;

    return HeroScaffold(
      bottomPadding: 120,
      onRefresh: () => ref.refreshQuietly(supportOverviewProvider),
      band: _SupportBand(overview: overview),
      children: overview == null ? const [_SupportSkeleton()] : _content(context, ref, overview),
    );
  }

  List<Widget> _content(BuildContext context, WidgetRef ref, SupportOverview overview) {
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
            PrimaryButton(
              label: context.l10n.supportRaiseTicket,
              icon: Icons.add_rounded,
              onPressed: () => _raiseTicket(context, ref),
            ),
          ],
        ),
      ),
      const Gap.lg(),
      ModuleCard(
        title: context.l10n.supportTickets,
        child: overview.tickets.isEmpty
            ? EmptyState(
                compact: true,
                title: context.l10n.supportNoTicketsYet,
                message: context.l10n.supportRaiseOneAboveIfSomething,
                icon: Icons.confirmation_num_outlined,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overview.openTickets.isEmpty
                        ? context.l10n.supportNothingOpenRightNow
                        : '${overview.openTickets.length} open',
                    style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const Gap.lg(),
                  for (final SupportTicket ticket in overview.tickets) ...[
                    _TicketRow(
                      ticket: ticket,
                      categoryLabel: overview.categoryFor(ticket.categoryKey)?.label ?? context.l10n.supportGeneral,
                    ),
                    if (ticket != overview.tickets.last)
                      Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
                  ],
                  if (overview.totalRepairCost > 0) ...[
                    const Gap.lg(),
                    Container(
                      padding: const EdgeInsets.all(Insets.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: Corners.brMd,
                        border: Border.all(color: AppColors.stroke),
                      ),
                      child: Column(
                        children: [
                          KeyValueRow(
                            label: context.l10n.supportRepairsAcrossTickets,
                            value: Fmt.money(overview.totalRepairCost),
                            icon: Icons.build_rounded,
                          ),
                          KeyValueRow(
                            label: context.l10n.supportBorneBy,
                            value: Fmt.money(overview.riderBorneCost),
                            icon: Icons.account_balance_wallet_rounded,
                            valueColor: overview.riderBorneCost > 0 ? AppColors.danger : AppColors.success,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
      ),
    ];
  }
}

class _SupportBand extends StatelessWidget {
  const _SupportBand({required this.overview});

  final SupportOverview? overview;

  @override
  Widget build(BuildContext context) {
    final int open = overview?.openTickets.length ?? 0;
    final int resolved = (overview?.tickets.length ?? 0) - open;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
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
                    overview?.hubName ?? '—',
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
        Text('$open', style: AppText.numericLarge.copyWith(fontSize: 38, color: AppColors.onInk)),
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
        ShimmerBox(height: 220, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 128, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 96, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 160, borderRadius: Corners.brXl),
      ],
    );
  }
}

class _TicketRow extends StatelessWidget {
  const _TicketRow({required this.ticket, required this.categoryLabel});

  final SupportTicket ticket;
  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    final bool open = ticket.status == TicketStatus.open;
    final Color costTone = ticket.costBorneByRider ? AppColors.danger : AppColors.success;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
      child: Row(
        children: [
          const PhotoThumb(photo: BrandPhoto.service, size: 44, radius: 12),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        ticket.id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.code.copyWith(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: Insets.sm),
                    StatusChip(
                      label: open ? context.l10n.commonOpen : context.l10n.supportResolved,
                      tone: open ? StatusTone.warning : StatusTone.success,
                      dense: true,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  ticket.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.titleSmall.copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 2),
                Text(
                  '$categoryLabel · updated ${Fmt.relative(ticket.updatedAt)}',
                  style: AppText.bodySmall.copyWith(fontSize: 11),
                ),
                if (ticket.repairCost > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.currency_rupee_rounded, size: 13, color: costTone),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          '${Fmt.money(ticket.repairCost)} to fix · ${ticket.costBorneByRider ? 'you paid' : 'operator paid'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w700, color: costTone),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
