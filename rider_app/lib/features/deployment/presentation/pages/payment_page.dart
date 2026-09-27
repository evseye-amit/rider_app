import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/deployment_payment_provider.dart';
import '../providers/deployment_provider.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  final TextEditingController _reference = TextEditingController();
  int _providerIndex = 0;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _reference.dispose();
    super.dispose();
  }

  List<String> _providers(AppL10n l10n) => [
    'UPI',
    l10n.deploymentBankTransfer,
    l10n.deploymentCashHub,
    l10n.deploymentCard,
  ];

  Future<void> _submit(String allocationId) async {
    final String reference = _reference.text.trim();
    if (reference.length < 4) {
      setState(() => _error = context.l10n.deploymentEnterTransactionReferencePaidWith);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });

    final Result<DeploymentPayment> result = await ref
        .read(deploymentPaymentProvider(allocationId).notifier)
        .submit(provider: _providers(context.l10n)[_providerIndex], reference: reference);
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case Ok<DeploymentPayment>():
        AppSnack.success(context, context.l10n.deploymentReferenceSubmittedWaitingVerification);
        unawaited(ref.read(deploymentProvider.notifier).refresh(silent: true));
      case Err<DeploymentPayment>(:final failure):
        setState(() => _error = failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(deploymentPollingProvider);
    final AsyncValue<RiderDeployment> deployment = ref.watch(deploymentProvider);
    final RiderDeployment? current = deployment.value;
    final String? allocationId = current?.allocation?.id;

    if (deployment.hasError || allocationId == null) {
      return AppScaffold(
        title: context.l10n.commonPayment,
        showBack: false,
        body: deployment.isLoading && !deployment.hasValue
            ? const PageBody(children: [ShimmerBox(height: 180, borderRadius: Corners.brXl)])
            : EmptyState(
                title: context.l10n.deploymentNoPaymentShow,
                message: deployment.failureMessage ?? context.l10n.deploymentFleetManagerHasNotAsked,
                icon: Icons.receipt_long_rounded,
                actionLabel: context.l10n.commonRefresh,
                onAction: () => ref.read(deploymentProvider.notifier).refresh(),
              ),
      );
    }

    final DeploymentPayment? payment = ref.watch(deploymentPaymentProvider(allocationId)).value;
    final DeploymentFleet? fleet = current?.allocation?.fleet;
    final bool submitted = payment?.isSubmitted == true;
    final List<String> providers = _providers(context.l10n);

    return AppScaffold(
      title: submitted ? context.l10n.deploymentPaymentSubmitted : context.l10n.deploymentPayScooter,
      subtitle: fleet == null
          ? null
          : '${fleet.vehicleNumber}${fleet.modelName == null ? '' : ' · ${fleet.modelName}'}',
      showBack: false,
      body: RefreshIndicator(
        onRefresh: () => ref.read(deploymentProvider.notifier).refresh(),
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (payment == null)
              const ShimmerBox(height: 180, borderRadius: Corners.brXl)
            else ...[
              _Bill(payment: payment),
              const Gap.lg(),
              if (submitted)
                _Submitted(payment: payment)
              else ...[
                ModuleCard(
                  title: context.l10n.deploymentHowDidPay,
                  leading: const IconTile(icon: Icons.payments_rounded, solid: true, size: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilterChipBar(
                        items: providers,
                        selectedIndex: _providerIndex,
                        onChanged: (i) => setState(() => _providerIndex = i),
                        padding: EdgeInsets.zero,
                      ),
                      const Gap.lg(),
                      AppTextField(
                        label: context.l10n.deploymentTransactionReference,
                        hint: _providerIndex == 0
                            ? context.l10n.deploymentUpiTransactionIdEG
                            : context.l10n.deploymentReferenceReceiptNumber,
                        helper: context.l10n.deploymentFleetManagerChecksAgainstWhat,
                        controller: _reference,
                        errorText: _error,
                        prefixIcon: Icons.tag_rounded,
                        onChanged: (_) => setState(() => _error = null),
                      ),
                    ],
                  ),
                ),
                const Gap.xl(),
                PrimaryButton(
                  label: 'I have paid ${Fmt.money(payment.amount)}',
                  icon: Icons.check_circle_rounded,
                  loading: _submitting,
                  onPressed: _submitting ? null : () => _submit(allocationId),
                ),
              ],
            ],
            const Gap.xl(),
          ],
        ),
      ),
    );
  }
}

class _Bill extends StatelessWidget {
  const _Bill({required this.payment});

  final DeploymentPayment payment;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: context.l10n.deploymentAmountDue,
      leading: const IconTile(icon: Icons.receipt_long_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Fmt.money(payment.amount), style: AppText.numericLarge.copyWith(color: AppColors.primary)),
          const Gap.md(),
          for (final PaymentLineItem item in payment.items)
            KeyValueRow(label: item.label, value: Fmt.money(item.amount)),
          const Divider(),
          KeyValueRow(
            label: context.l10n.commonTotal,
            value: Fmt.money(payment.amount),
            valueStyle: AppText.titleSmall,
          ),
          if (payment.createdAt != null) ...[
            const Gap.sm(),
            Text(
              'Requested ${Fmt.relative(payment.createdAt!)}',
              style: AppText.bodySmall.copyWith(color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _Submitted extends StatelessWidget {
  const _Submitted({required this.payment});

  final DeploymentPayment payment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ArtBlock(
          art: BrandArt.success,
          artSize: 140,
          title: context.l10n.deploymentReferenceSubmitted,
          message:
              'Your fleet manager is checking ${payment.provider ?? 'the payment'} reference '
              '${payment.providerReference ?? ''}. This screen moves on the moment it is verified.',
        ),
        const Gap.lg(),
        ModuleCard(
          child: Column(
            children: [
              KeyValueRow(
                label: context.l10n.deploymentPaidVia,
                value: payment.provider ?? '—',
                icon: Icons.payments_rounded,
              ),
              KeyValueRow(
                label: context.l10n.deploymentReference,
                value: payment.providerReference ?? '—',
                icon: Icons.tag_rounded,
              ),
              if (payment.submittedAt != null)
                KeyValueRow(
                  label: context.l10n.deploymentSubmitted,
                  value: Fmt.dateTime(payment.submittedAt!),
                  icon: Icons.schedule_rounded,
                ),
              KeyValueRow(
                label: context.l10n.commonStatus,
                value: context.l10n.deploymentAwaitingVerification,
                icon: Icons.hourglass_top_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
