import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/earnings_overview.dart';

/// The earnings band: a back control, the period total as the headline
/// number, and the period selector that drives the chart below.
class EarningsBand extends StatelessWidget {
  const EarningsBand({
    required this.breakdown,
    required this.periods,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  final EarningsBreakdown breakdown;
  final List<String> periods;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeroBandBar(
          leading: Builder(
            builder: (context) => InkCircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          subtitle: 'See how your fare, incentives and rent add up',
          title: 'Earnings',
        ),
        const Gap.xxl(),
        Text(
          'Net earnings',
          style: AppText.label.copyWith(color: AppColors.onInkSecondary),
        ),
        const Gap.sm(),
        Text(
          Fmt.money(breakdown.net),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.numericLarge.copyWith(
            fontSize: 38,
            color: AppColors.onInk,
          ),
        ),
        if (breakdown.deductions > 0) ...[
          const SizedBox(height: 4),
          Text(
            'After ${Fmt.money(breakdown.deductions)} in deductions',
            style: AppText.bodySmall.copyWith(
              fontSize: 12,
              color: AppColors.onInkSecondary,
            ),
          ),
        ],
        const Gap.xl(),
        SegmentedTabs(
          items: periods,
          selectedIndex: selectedIndex,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// A tappable bar chart. Selecting a bar is how the detail panel above it
/// gets its numbers — there is no separate "view details" action.
class EarningsBarChart extends StatelessWidget {
  const EarningsBarChart({
    required this.bars,
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });

  final List<EarningsBar> bars;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    if (bars.isEmpty) {
      return const EmptyState(
        title: 'No earnings yet',
        message: 'Complete a few trips to see them here.',
        icon: Icons.bar_chart_rounded,
        compact: true,
      );
    }

    final num peak = bars
        .map((b) => b.amount)
        .fold<num>(0, (a, b) => a > b ? a : b);

    return SizedBox(
      height: 148,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(bars.length, (i) {
          final EarningsBar bar = bars[i];
          final bool selected = i == selectedIndex;
          final double factor = peak <= 0 ? 0 : (bar.amount / peak).toDouble();
          final bool empty = bar.amount <= 0;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == bars.length - 1 ? 0 : 6),
              child: Pressable(
                onTap: empty ? null : () => onSelect(i),
                scale: 0.94,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: factor),
                      duration: Duration(milliseconds: 360 + i * 50),
                      curve: Motion.enter,
                      builder: (context, v, _) => Container(
                        height: 100 * v + 4,
                        decoration: BoxDecoration(
                          color: empty
                              ? AppColors.surfaceSunken
                              : selected
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.35),
                          borderRadius: Corners.brXs,
                          boxShadow: selected
                              ? Shadows.lift(
                                  AppColors.primary,
                                  opacity: 0.22,
                                  blur: 10,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: Insets.sm),
                    Text(
                      bar.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppText.bodySmall.copyWith(
                        fontSize: 10,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: selected
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// The numbers behind whichever bar is currently selected.
class EarningsBarDetail extends StatelessWidget {
  const EarningsBarDetail({required this.bar, super.key});

  final EarningsBar? bar;

  @override
  Widget build(BuildContext context) {
    final EarningsBar? b = bar;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(b == null ? '—' : Fmt.date(b.date), style: AppText.label),
              const SizedBox(height: Insets.xs),
              Text(
                Fmt.money(b?.amount ?? 0),
                style: AppText.numeric.copyWith(fontSize: 26),
              ),
            ],
          ),
        ),
        StatusChip(
          label: '${b?.trips ?? 0} trips',
          tone: StatusTone.brand,
          icon: Icons.route_rounded,
        ),
      ],
    );
  }
}

/// Base fare, distance pay, surge, incentives, minus deductions, net. Placed
/// inside a [ModuleCard] by the page, so this is just the content.
class EarningsBreakdownCard extends StatelessWidget {
  const EarningsBreakdownCard({required this.breakdown, super.key});

  final EarningsBreakdown breakdown;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KeyValueRow(label: 'Base fare', value: Fmt.money(breakdown.baseFare)),
        KeyValueRow(
          label: 'Distance pay',
          value: Fmt.money(breakdown.distancePay),
        ),
        KeyValueRow(
          label: 'Surge',
          value: breakdown.surge > 0
              ? '+${Fmt.money(breakdown.surge)}'
              : Fmt.money(breakdown.surge),
          valueColor: breakdown.surge > 0 ? AppColors.warning : null,
        ),
        KeyValueRow(
          label: 'Incentives',
          value: '+${Fmt.money(breakdown.incentives)}',
          valueColor: AppColors.mint,
        ),
        KeyValueRow(
          label: 'Deductions',
          value: '−${Fmt.money(breakdown.deductions)}',
          valueColor: AppColors.danger,
        ),
        const SizedBox(height: Insets.sm),
        Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
        const SizedBox(height: Insets.sm),
        KeyValueRow(
          label: 'Net earnings',
          value: Fmt.money(breakdown.net),
          valueStyle: AppText.numeric.copyWith(
            fontSize: 18,
            color: AppColors.mint,
          ),
        ),
      ],
    );
  }
}

/// Day-by-day rows under the breakdown. Placed inside a [ModuleCard] by the
/// page, so this is just the content.
class DailyEarningsList extends StatelessWidget {
  const DailyEarningsList({required this.entries, super.key});

  final List<EarningsBar> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const EmptyState(
        title: 'No days to show yet',
        icon: Icons.calendar_today_rounded,
        compact: true,
      );
    }

    return Column(
      children: [
        for (final day in entries) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryWash,
                    borderRadius: Corners.brSm,
                  ),
                  child: Text(
                    '${day.date.day}',
                    style: AppText.titleSmall.copyWith(
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.label,
                        style: AppText.titleSmall.copyWith(fontSize: 13.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        day.trips == 0 ? 'No trips' : '${day.trips} trips',
                        style: AppText.bodySmall.copyWith(fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
                Text(
                  Fmt.money(day.amount),
                  style: AppText.numericSmall.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          if (day != entries.last)
            Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
        ],
      ],
    );
  }
}
