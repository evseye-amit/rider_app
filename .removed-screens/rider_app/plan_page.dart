import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

class _RentalPlan {
  const _RentalPlan({
    required this.key,
    required this.name,
    required this.rent,
    required this.cadence,
    required this.benefits,
    this.badge,
  });

  final String key;
  final String name;
  final int rent;
  final String cadence;
  final List<String> benefits;
  final String? badge;
}

const List<_RentalPlan> _plans = [
  _RentalPlan(
    key: 'daily',
    name: 'Daily Flex',
    rent: 199,
    cadence: 'per day',
    benefits: [
      'Pay only for days you ride',
      'No lock-in, cancel any day',
      'Best for occasional riders',
    ],
  ),
  _RentalPlan(
    key: 'weekly',
    name: 'Weekly Saver',
    rent: 1190,
    cadence: 'per week',
    benefits: [
      'Unlimited kilometres all week',
      'Free scheduled service at the hub',
      '1 free breakdown pickup per week',
    ],
    badge: 'Current plan',
  ),
  _RentalPlan(
    key: 'monthly',
    name: 'Monthly Pro',
    rent: 3990,
    cadence: 'per month',
    benefits: [
      'Everything in Weekly Saver',
      'Priority roadside response (15 min)',
      '2 free breakdown pickups per month',
      'Save ₹770 versus paying weekly',
    ],
    badge: 'Best value',
  ),
];

/// Current rental plan and the alternatives, with a change flow that is
/// honest about when a switch actually takes effect.
///
/// The current plan and its price are the headline of the ink band; every
/// plan — including the current one — is a selectable card below with its
/// full benefit list, so a rider can compare without opening anything.
class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  String _currentKey = 'weekly';
  String? _selectedKey;

  _RentalPlan get _current => _plans.firstWhere((p) => p.key == _currentKey);

  Future<void> _confirmChange(_RentalPlan target) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: 'Switch to ${target.name}?',
      message:
          'Your current cycle keeps running on ${_current.name}. ${target.name} starts from your '
          'next billing cycle at ${Fmt.money(target.rent)} ${target.cadence}.',
      confirmLabel: 'Confirm switch',
      icon: Icons.workspace_premium_rounded,
    );
    if (!confirmed || !mounted) return;
    setState(() {
      _currentKey = target.key;
      _selectedKey = null;
    });
    AppSnack.success(context, '${target.name} will start next billing cycle.');
  }

  @override
  Widget build(BuildContext context) {
    final String selectedKey = _selectedKey ?? _currentKey;
    final _RentalPlan selected = _plans.firstWhere((p) => p.key == selectedKey);
    final bool changed = selectedKey != _currentKey;

    return HeroScaffold(
      bottomPadding: changed ? Insets.x4l + Insets.x4l : Insets.x4l,
      band: _Band(current: _current),
      bottomNavigationBar: changed
          ? Container(
              padding: EdgeInsets.fromLTRB(
                Insets.gutter,
                Insets.md,
                Insets.gutter,
                MediaQuery.paddingOf(context).bottom + Insets.md,
              ),
              decoration: const BoxDecoration(
                color: AppColors.canvas,
                border: Border(top: BorderSide(color: AppColors.stroke)),
              ),
              child: PrimaryButton(
                label: 'Switch to ${selected.name}',
                onPressed: () => _confirmChange(selected),
              ),
            )
          : null,
      children: [
        const PhotoPanel(
          photo: BrandPhoto.fleet,
          height: 140,
          title: 'One plan, every vehicle covered',
          subtitle: 'Your rent covers scheduled service and roadside help across the fleet',
        ),
        const Gap.lg(),

        ModuleCard(
          title: 'Plan benefits',
          leading: const IconTile(
            icon: Icons.workspace_premium_rounded,
            tone: AppColors.primary,
            size: 34,
            solid: true,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final benefit in _current.benefits) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: AppColors.mint,
                    ),
                    const SizedBox(width: Insets.sm),
                    Expanded(
                      child: Text(
                        benefit,
                        style: AppText.bodyMedium.copyWith(
                          fontSize: 13.5,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                if (benefit != _current.benefits.last) const Gap.md(),
              ],
            ],
          ),
        ),
        const Gap.lg(),

        ModuleCard(
          title: 'Other plans',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A change takes effect from your next billing cycle',
                style: AppText.bodySmall.copyWith(fontSize: 12),
              ),
              const Gap.lg(),
              for (final plan in _plans) ...[
                _PlanCard(
                  plan: plan,
                  isCurrent: plan.key == _currentKey,
                  selected: plan.key == selectedKey,
                  onTap: () => setState(() => _selectedKey = plan.key),
                ),
                if (plan != _plans.last) const Gap.md(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// The current plan and its price, reversed out as the band headline.
class _Band extends StatelessWidget {
  const _Band({required this.current});

  final _RentalPlan current;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) => InkCircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
            const SizedBox(width: Insets.md),
            Text(
              'Rental plan',
              style: AppText.titleLarge.copyWith(
                fontSize: 17,
                color: AppColors.onInk,
              ),
            ),
          ],
        ),
        const Gap.xxl(),

        Text(
          'YOUR CURRENT PLAN',
          style: AppText.overline.copyWith(color: AppColors.onInkMuted),
        ),
        const Gap.sm(),
        Text(
          current.name,
          style: AppText.displaySmall.copyWith(
            fontSize: 26,
            color: AppColors.onInk,
          ),
        ),
        const Gap.sm(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: Text(
                Fmt.money(current.rent),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.numericLarge.copyWith(
                  fontSize: 34,
                  color: AppColors.onInk,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              current.cadence,
              style: AppText.bodyMedium.copyWith(
                color: AppColors.onInkSecondary,
              ),
            ),
          ],
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
                  label: 'Includes',
                  value: '${current.benefits.length} perks',
                  icon: Icons.check_circle_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Billing',
                  value: current.cadence,
                  icon: Icons.event_repeat_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Status',
                  value: 'Active',
                  icon: Icons.workspace_premium_rounded,
                  valueColor: AppColors.mint,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A full plan card with its real benefit list, selectable as a radio.
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.isCurrent,
    required this.selected,
    required this.onTap,
  });

  final _RentalPlan plan;
  final bool isCurrent;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color tone = isCurrent ? AppColors.mint : AppColors.primary;

    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryWash : AppColors.surfaceMuted,
          borderRadius: Corners.brLg,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.stroke,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RadioDot(selected: selected),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              plan.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.titleMedium.copyWith(fontSize: 16),
                            ),
                          ),
                          if (isCurrent || plan.badge != null) ...[
                            const SizedBox(width: Insets.sm),
                            StatusChip(
                              label: isCurrent ? 'Current' : plan.badge!,
                              tone: isCurrent
                                  ? StatusTone.success
                                  : StatusTone.brand,
                              dense: true,
                              showDot: false,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            child: Text(
                              Fmt.money(plan.rent),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.numeric.copyWith(
                                fontSize: 20,
                                color: tone,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              plan.cadence,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.bodySmall.copyWith(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Insets.md),
            const Divider(color: AppColors.stroke, height: 1),
            const SizedBox(height: Insets.md),
            for (final benefit in plan.benefits) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded, size: 15, color: tone),
                  const SizedBox(width: Insets.sm),
                  Expanded(
                    child: Text(
                      benefit,
                      style: AppText.bodySmall.copyWith(
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              if (benefit != plan.benefits.last)
                const SizedBox(height: Insets.sm - 2),
            ],
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.strokeStrong,
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
          : null,
    );
  }
}
