import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/incentive_scheme.dart';

class IncentivesBand extends StatelessWidget {
  const IncentivesBand({
    required this.earnedThisWeek,
    required this.activeCount,
    required this.achievedCount,
    super.key,
  });

  final num earnedThisWeek;
  final int activeCount;
  final int achievedCount;

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
          subtitle: 'Bonuses you can still clear this week',
          title: 'Incentives',
        ),
        const Gap.xxl(),
        Text(
          'Earned this week',
          style: AppText.label.copyWith(color: AppColors.onInkSecondary),
        ),
        const Gap.sm(),
        Text(
          Fmt.money(earnedThisWeek),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
                  label: 'Active schemes',
                  value: '$activeCount',
                  icon: Icons.emoji_events_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Cleared',
                  value: '$achievedCount',
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

enum IncentiveProgressStyle { bar, ring }

class IncentiveSchemeCard extends StatelessWidget {
  const IncentiveSchemeCard({
    required this.scheme,
    this.progressStyle = IncentiveProgressStyle.bar,
    this.dimmed = false,
    this.elevated = false,
    super.key,
  });

  final IncentiveScheme scheme;
  final IncentiveProgressStyle progressStyle;
  final bool dimmed;

  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final Color tone = NodeTokens.color(
      scheme.tone,
      fallback: AppColors.primary,
    );

    final Widget card = GlassCard(
      shadows: elevated ? Shadows.floating : Shadows.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(
                icon: NodeTokens.icon(scheme.icon),
                tone: tone,
                solid: true,
                size: 40,
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            scheme.title,
                            style: AppText.titleMedium.copyWith(fontSize: 15),
                          ),
                        ),
                        if (dimmed)
                          const StatusChip(
                            label: 'Achieved',
                            tone: StatusTone.success,
                            icon: Icons.check_circle_rounded,
                            dense: true,
                          )
                        else
                          Text(
                            '+${Fmt.money(scheme.rewardAmount)}',
                            style: AppText.numericSmall.copyWith(
                              fontSize: 15,
                              color: tone,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scheme.description,
                      style: AppText.bodySmall.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.lg),
          if (progressStyle == IncentiveProgressStyle.ring)
            Row(
              children: [
                RingGauge(
                  value: scheme.progress,
                  size: 64,
                  strokeWidth: 6,
                  color: tone,
                  centerText:
                      '${scheme.current.toInt()}/${scheme.target.toInt()}',
                ),
                const SizedBox(width: Insets.lg),
                Expanded(
                  child: Text(
                    dimmed
                        ? 'Completed — reward credited to your wallet.'
                        : '${scheme.target - scheme.current} more ${scheme.unit} to go',
                    style: AppText.bodySmall.copyWith(fontSize: 12),
                  ),
                ),
              ],
            )
          else
            LabeledProgress(
              value: scheme.progress,
              color: tone,
              label:
                  '${scheme.current.toInt()} of ${scheme.target.toInt()} ${scheme.unit}',
              trailingLabel: dimmed ? 'Done' : Fmt.percent(scheme.progress),
            ),
          const SizedBox(height: Insets.md),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 13,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: Insets.xs + 2),
              Flexible(
                child: Text(
                  dimmed
                      ? 'Expired ${Fmt.date(scheme.expiresAt)}'
                      : 'Ends ${Fmt.relative(scheme.expiresAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(fontSize: 11.5),
                ),
              ),
              const SizedBox(width: Insets.sm),
              const Spacer(),
              GestureDetector(
                onTap: () => _showTerms(context),
                child: Text(
                  'Terms',
                  style: AppText.bodySmall.copyWith(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBright,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return dimmed ? Opacity(opacity: 0.55, child: card) : card;
  }

  void _showTerms(BuildContext context) {
    AppSheet.show(
      context,
      title: scheme.title,
      subtitle: 'Terms & conditions',
      child: Padding(
        padding: const EdgeInsets.only(bottom: Insets.lg),
        child: Text(
          scheme.terms,
          style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.55),
        ),
      ),
    );
  }
}
