import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../deployment_dependencies.dart';
import '../../domain/usecases/accept_plan.dart';
import '../providers/deployment_provider.dart';
import '../widgets/plan_widgets.dart';

class PlanAcceptancePage extends ConsumerStatefulWidget {
  const PlanAcceptancePage({super.key});

  @override
  ConsumerState<PlanAcceptancePage> createState() => _PlanAcceptancePageState();
}

class _PlanAcceptancePageState extends ConsumerState<PlanAcceptancePage> {
  String? _agreedOfferId;
  bool _accepting = false;

  Future<void> _accept(CommercialOffer offer) async {
    setState(() => _accepting = true);
    final Result<CommercialAgreement> result = await ref.read(acceptPlanProvider)(
      AcceptPlanParams(offerId: offer.id, termsVersion: offer.terms.version),
    );
    if (!mounted) return;
    setState(() => _accepting = false);
    switch (result) {
      case Ok<CommercialAgreement>():
        AppSnack.success(context, context.l10n.deploymentPlanAcceptedSnack);
      case Err<CommercialAgreement>(:final failure):
        AppSnack.error(context, failure.message);
    }
    await ref.read(deploymentProvider.notifier).refresh(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(deploymentPollingProvider);
    final AsyncValue<RiderDeployment> deployment = ref.watch(deploymentProvider);
    final CommercialOffer? offer = deployment.value?.commercial?.offer;

    if (offer == null) {
      return AppScaffold(
        title: context.l10n.deploymentPlanTitle,
        showBack: false,
        body: deployment.hasError
            ? EmptyState(
                title: context.l10n.deploymentPlanCouldNotLoad,
                message: deployment.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.read(deploymentProvider.notifier).refresh(),
              )
            : const PageBody(
                children: [
                  ShimmerBox(height: 90, borderRadius: Corners.brLg),
                  Gap.lg(),
                  ShimmerBox(height: 320, borderRadius: Corners.brXl),
                ],
              ),
      );
    }

    final bool live = offer.isPresented;
    final bool agreed = _agreedOfferId == offer.id;
    final DateTime? validUntil = offer.validUntil;
    final CommercialBreakdown breakdown = offer.breakdown;
    final String vehicle = [breakdown.modelName, breakdown.variantName].whereType<String>().join(' ').trim();

    return AppScaffold(
      title: context.l10n.deploymentPlanTitle,
      showBack: false,
      footer: PrimaryButton(
        label: context.l10n.planAccept,
        icon: Icons.check_circle_rounded,
        loading: _accepting,
        onPressed: live && agreed && !_accepting ? () => _accept(offer) : null,
      ),
      body: PageBody(
        children: [
          AccentCard(
            accent: AppColors.primary,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.price_change_rounded, size: 19, color: AppColors.primary),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Text(
                    context.l10n.deploymentPlanIntro,
                    style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: rentalPeriodName(context.l10n, breakdown),
            leading: const IconTile(icon: Icons.electric_scooter_rounded, solid: true, size: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (vehicle.isNotEmpty)
                  KeyValueRow(label: context.l10n.commonScooter, value: vehicle, icon: Icons.two_wheeler_rounded),
                PlanSummary(breakdown: breakdown),
                if (validUntil != null) ...[
                  const Gap.sm(),
                  KeyValueRow(
                    label: context.l10n.planValidUntil,
                    value: Fmt.dateTime(validUntil),
                    icon: Icons.schedule_rounded,
                  ),
                ],
              ],
            ),
          ),
          const Gap.lg(),
          if (live)
            AppCheckTile(
              value: agreed,
              onChanged: (value) => setState(() => _agreedOfferId = value ? offer.id : null),
              title: context.l10n.planConsent,
            )
          else
            AccentCard(
              accent: AppColors.danger,
              child: Text(
                context.l10n.planOfferNotLive,
                style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
              ),
            ),
          const Gap.xl(),
        ],
      ),
    );
  }
}
