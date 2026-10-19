import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/damage_charge.dart';
import '../providers/damage_charges_providers.dart';
import '../widgets/damage_charge_widgets.dart';

class DamageChargesPage extends ConsumerStatefulWidget {
  const DamageChargesPage({super.key});

  @override
  ConsumerState<DamageChargesPage> createState() => _DamageChargesPageState();
}

class _DamageChargesPageState extends ConsumerState<DamageChargesPage> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final bool includePaid = _filter == 1;
    final AsyncValue<List<DamageCharge>> charges = ref.watch(damageChargesProvider(includePaid));
    final List<DamageCharge>? items = charges.value;

    return AppScaffold(
      title: context.l10n.damageChargesTitle,
      body: RefreshIndicator(
        onRefresh: () => ref.refreshQuietly(damageChargesProvider(includePaid)),
        color: AppColors.primary,
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            FilterChipBar(
              items: [context.l10n.damageChargesUnpaid, context.l10n.damageChargesAll],
              selectedIndex: _filter,
              onChanged: (index) => setState(() => _filter = index),
              padding: EdgeInsets.zero,
            ),
            const Gap.lg(),
            if (items == null && charges.hasError)
              EmptyState(
                title: context.l10n.damageChargesCouldNotLoad,
                message: charges.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(damageChargesProvider(includePaid)),
              )
            else if (items == null)
              for (int i = 0; i < 3; i++) ...[const ShimmerBox(height: 92, borderRadius: Corners.brLg), const Gap.md()]
            else if (items.isEmpty)
              EmptyState(
                title: includePaid ? context.l10n.damageChargesNoneTitle : context.l10n.damageChargesNothingToPay,
                message: includePaid
                    ? context.l10n.damageChargesNoneMessage
                    : context.l10n.damageChargesNothingToPayMessage,
                icon: includePaid ? Icons.receipt_long_rounded : Icons.check_circle_rounded,
                tone: includePaid ? AppColors.primary : AppColors.success,
              )
            else
              for (final DamageCharge charge in items) ...[
                DamageChargeTile(
                  charge: charge,
                  onOpen: () => context.push('${Routes.damageChargeDetail}?id=${charge.id}'),
                ),
                const Gap.md(),
              ],
          ],
        ),
      ),
    );
  }
}
