import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/home_summary.dart';

class ShiftStatusStrip extends StatelessWidget {
  const ShiftStatusStrip({
    required this.present,
    required this.vehicleOn,
    required this.onlineMinutes,
    required this.tripsToday,
    required this.distanceKm,
    super.key,
  });

  final bool present;
  final bool vehicleOn;
  final int onlineMinutes;
  final int tripsToday;
  final double distanceKm;

  @override
  Widget build(BuildContext context) {
    final Color tone = present ? AppColors.success : AppColors.danger;

    return GlassCard(
      padding: const EdgeInsets.all(Insets.lg),
      borderColor: tone.withValues(alpha: 0.28),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.washFor(tone),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  present ? Icons.how_to_reg_rounded : Icons.person_off_rounded,
                  size: 20,
                  color: tone,
                ),
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      present ? 'Marked present' : 'Not marked present',
                      style: AppText.titleMedium.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      present
                          ? 'Shift running · ${Fmt.duration(Duration(minutes: onlineMinutes))} online'
                          : 'Mark attendance to start the scooter',
                      style: AppText.bodySmall.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: vehicleOn ? 'Vehicle on' : 'Vehicle off',
                tone: vehicleOn ? StatusTone.brand : StatusTone.neutral,
                dense: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IncentiveCard extends StatelessWidget {
  const IncentiveCard({required this.summary, this.onTap, super.key});

  final HomeSummary summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final int remaining = summary.tripsToIncentive;
    final bool achieved = remaining == 0;

    return GlassCard(
      onTap: onTap,
      tint: AppColors.washFor(AppColors.warning),
      borderColor: AppColors.warning.withValues(alpha: 0.26),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: Corners.brSm,
                ),
                child: const Icon(Icons.emoji_events_rounded, size: 19, color: AppColors.warning),
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achieved
                          ? 'Bonus unlocked'
                          : '$remaining more ${remaining == 1 ? 'trip' : 'trips'} to your bonus',
                      style: AppText.titleMedium.copyWith(fontSize: 14.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      achieved
                          ? '${Fmt.money(summary.incentiveTarget)} added to today\'s earnings'
                          : 'Finish ${summary.incentiveTripsTarget} trips today to earn ${Fmt.money(summary.incentiveTarget)}',
                      style: AppText.bodySmall.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: Insets.lg),
          LabeledProgress(
            value: summary.incentiveProgress,
            color: AppColors.warning,
            label: '${summary.incentiveTrips} of ${summary.incentiveTripsTarget} trips',
            trailingLabel: Fmt.money(summary.incentiveEarned),
          ),
        ],
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    required this.vehicleNumber,
    required this.model,
    required this.batteryPercent,
    required this.rangeKm,
    required this.iotOnline,
    this.onTap,
    super.key,
  });

  final String vehicleNumber;
  final String model;
  final int batteryPercent;
  final int rangeKm;
  final bool iotOnline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(Insets.lg),
      child: Row(
        children: [
          RingGauge(
            value: batteryPercent / 100,
            size: 78,
            strokeWidth: 7,
            icon: Icons.bolt_rounded,
            label: 'charge',
          ),
          const SizedBox(width: Insets.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        vehicleNumber,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.titleLarge.copyWith(fontSize: 17, letterSpacing: 0.4),
                      ),
                    ),
                    const SizedBox(width: Insets.sm),
                    StatusChip(
                      label: iotOnline ? 'Online' : 'Offline',
                      tone: iotOnline ? StatusTone.success : StatusTone.danger,
                      dense: true,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(model, style: AppText.bodySmall.copyWith(fontSize: 12)),
                const SizedBox(height: Insets.md),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      MetricPill(icon: Icons.near_me_rounded, value: '$rangeKm', label: 'km left'),
                      const SizedBox(width: Insets.sm),
                      const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuickActionRow extends StatelessWidget {
  const QuickActionRow({required this.actions, required this.onTap, super.key});

  final List<QuickAction> actions;
  final void Function(QuickAction action) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final action in actions) ...[
          Expanded(
            child: Pressable(
              onTap: () => onTap(action),
              scale: 0.94,
              child: Column(
                children: [
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.washFor(
                        NodeTokens.color(action.tone, fallback: AppColors.primary),
                      ),
                      borderRadius: Corners.brMd,
                      border: Border.all(
                        color: NodeTokens.color(action.tone, fallback: AppColors.primary)
                            .withValues(alpha: 0.26),
                      ),
                    ),
                    child: Icon(
                      NodeTokens.icon(action.icon),
                      size: 22,
                      color: NodeTokens.color(action.tone, fallback: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: Insets.sm),
                  Text(
                    action.label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(
                      fontSize: 10.5,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (action != actions.last) const SizedBox(width: Insets.md),
        ],
      ],
    );
  }
}

class WeeklyEarningsChart extends StatelessWidget {
  const WeeklyEarningsChart({
    required this.values,
    required this.labels,
    this.todayIndex,
    super.key,
  });

  final List<num> values;
  final List<String> labels;
  final int? todayIndex;

  @override
  Widget build(BuildContext context) {
    final num peak = values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b);
    final num total = values.fold<num>(0, (a, b) => a + b);
    final int today = todayIndex ?? (DateTime.now().weekday - 1);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('This week', style: AppText.label),
                    const SizedBox(height: Insets.xs),
                    Text(Fmt.money(total), style: AppText.numeric.copyWith(fontSize: 24)),
                  ],
                ),
              ),
              const StatusChip(label: 'Mon – Sun', tone: StatusTone.neutral, dense: true, showDot: false),
            ],
          ),
          const SizedBox(height: Insets.xl),
          SizedBox(
            height: 112,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values.length, (i) {
                final double factor = peak == 0 ? 0 : (values[i] / peak).toDouble();
                final bool isToday = i == today;
                final bool empty = values[i] == 0;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i == values.length - 1 ? 0 : 7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isToday && !empty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              Fmt.moneyCompact(values[i]),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              softWrap: false,
                              style: AppText.bodySmall.copyWith(
                                fontSize: 9.5,
                                height: 1.1,
                                fontWeight: FontWeight.w800,
                                color: AppColors.cyan,
                              ),
                            ),
                          ),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: factor),
                          duration: Duration(milliseconds: 420 + i * 60),
                          curve: Motion.enter,
                          builder: (context, v, _) => Container(
                            height: (isToday ? 60 : 66) * v + 4,
                            decoration: BoxDecoration(
                              color: empty
                                  ? AppColors.surfaceSunken
                                  : isToday
                                      ? AppColors.primary
                                      : AppColors.primary.withValues(alpha: 0.35),
                              borderRadius: Corners.brXs,
                            ),
                          ),
                        ),
                        const SizedBox(height: Insets.sm),
                        Text(
                          i < labels.length ? labels[i] : '',
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          softWrap: false,
                          style: AppText.bodySmall.copyWith(
                            fontSize: 10,
                            height: 1.1,
                            fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                            color: isToday ? AppColors.textPrimary : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
