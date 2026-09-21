import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../domain/entities/support_overview.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/usecases/get_support_overview.dart';
import '../cubit/support_cubit.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupportCubit(GetSupportOverview(sl()))..load(),
      child: const _SupportView(),
    );
  }
}

class _SupportView extends StatelessWidget {
  const _SupportView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportCubit, SupportState>(
      builder: (context, state) {
        if (state.status == SupportStatus.failure) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            body: SafeArea(
              child: EmptyState(
                title: 'Could not load support',
                message: state.message,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: 'Try again',
                onAction: () => context.read<SupportCubit>().refresh(),
              ),
            ),
          );
        }

        final SupportOverview? overview = state.overview;

        return HeroScaffold(
          bottomPadding: 120,
          onRefresh: () => context.read<SupportCubit>().refresh(),
          band: _SupportBand(overview: overview),
          children: overview == null
              ? const [_SupportSkeleton()]
              : _content(context, overview),
        );
      },
    );
  }

  List<Widget> _content(BuildContext context, SupportOverview overview) {
    return [
      ModuleCard(
        title: 'Need help with something?',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us what happened and attach a photo if it helps. '
              'Your team lead sees it straight away.',
              style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
            ),
            const Gap.lg(),
            PrimaryButton(
              label: 'Raise a ticket',
              icon: Icons.add_rounded,
              onPressed: () => _raiseTicket(context),
            ),
          ],
        ),
      ),
      const Gap.lg(),

      ModuleCard(
        title: 'Your tickets',
        child: overview.tickets.isEmpty
            ? const EmptyState(
                compact: true,
                title: 'No tickets yet',
                message:
                    'Raise one above if something needs attention.',
                icon: Icons.confirmation_num_outlined,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overview.openTickets.isEmpty
                        ? 'Nothing open right now'
                        : '${overview.openTickets.length} open',
                    style: AppText.bodySmall.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Gap.lg(),
                  for (final ticket in overview.tickets) ...[
                    _TicketRow(
                      ticket: ticket,
                      categoryLabel:
                          overview.categoryFor(ticket.categoryKey)?.label ??
                          'General',
                    ),
                    if (ticket != overview.tickets.last)
                      Divider(
                        color: AppColors.stroke.withValues(alpha: 0.5),
                        height: 1,
                      ),
                  ],
                ],
              ),
      ),
    ];
  }

  Future<void> _raiseTicket(BuildContext context) async {
    await context.push(Routes.raiseTicket);
    if (context.mounted) context.read<SupportCubit>().refresh();
  }
}

class _SupportBand extends StatelessWidget {
  const _SupportBand({required this.overview});

  final SupportOverview? overview;

  @override
  Widget build(BuildContext context) {
    final SupportOverview? o = overview;
    final int open = o?.openTickets.length ?? 0;
    final int resolved = (o?.tickets.length ?? 0) - open;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const IconTile(
              icon: Icons.support_agent_rounded,
              tone: AppColors.primary,
              solid: true,
              size: 44,
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Support',
                    style: AppText.bodySmall.copyWith(
                      fontSize: 12,
                      color: AppColors.onInkSecondary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    o?.hubName ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleLarge.copyWith(
                      fontSize: 20,
                      color: AppColors.onInk,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap.xxl(),
        Text(
          'Open tickets',
          style: AppText.label.copyWith(color: AppColors.onInkSecondary),
        ),
        const Gap.sm(),
        Text(
          '$open',
          style: AppText.numericLarge.copyWith(
            fontSize: 38,
            color: AppColors.onInk,
          ),
        ),
        const Gap.xl(),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: Insets.md,
            horizontal: Insets.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkStat(
                  label: 'Open',
                  value: '$open',
                  icon: Icons.pending_actions_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Resolved',
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
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
        child: Row(
          children: [
            const PhotoThumb(
              photo: BrandPhoto.service,
              size: 44,
              radius: 12,
            ),
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
                        label: open ? 'Open' : 'Resolved',
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
                ],
              ),
            ),
          ],
        ),
    );
  }
}
