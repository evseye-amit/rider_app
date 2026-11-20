import 'dart:async';
import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/payments/online_payments.dart';
import '../../../../core/payments/payment_feedback.dart';
import '../../../../core/payments/payment_flow_provider.dart';
import '../../domain/usecases/payment_receipt_usecases.dart';
import '../providers/deployment_auto_pay_provider.dart';
import '../providers/deployment_payment_provider.dart';
import '../providers/deployment_provider.dart';

const int _maxScreenshots = 20;
const double _thumbSize = 76;

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  final TextEditingController _email = TextEditingController();
  bool _autoPay = false;
  bool _autoPayRefused = false;
  bool _adding = false;
  String? _emailError;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<File?> _pickScreenshot() async {
    final File? file = await PhotoSourceSheet.pick(context);
    if (file == null || !mounted) return null;
    if (await file.length() > MediaApi.maxReceiptBytes) {
      if (mounted) AppSnack.error(context, context.l10n.deploymentReceiptTooLarge);
      return null;
    }
    return file;
  }

  Future<void> _payOnline(String allocationId, String? vehicle, {DeploymentAutoPayTerms? autoPay}) async {
    final AppL10n l10n = context.l10n;
    final String email = _email.text.trim();
    if (autoPay != null && !_emailPattern.hasMatch(email)) {
      setState(() => _emailError = l10n.paymentsAutoPayEmailInvalid);
      return;
    }
    final OnlinePaymentOutcome? outcome = await ref
        .read(paymentFlowProvider(PaymentSlots.deployment(allocationId)).notifier)
        .pay(
          PaymentOrderRequest.deployment(
            allocationId,
            autoPay: switch (autoPay) {
              (:final num limit, :final int validityDays) => DeploymentAutoPayConsent(
                email: email,
                maxAmount: limit,
                validityDays: validityDays,
              ),
              null => null,
            },
          ),
          description: ['Scooter payment', ?vehicle].join(' '),
        );
    if (outcome == null || !mounted) return;
    if (outcome case OnlinePaymentAutoPayRefused(:final String code)) {
      setState(() {
        if (code == 'AUTOPAY_TERMS_CHANGED') {
          _autoPay = false;
        } else {
          _autoPayRefused = true;
        }
      });
    }
    showPaymentOutcome(context, outcome, unavailable: l10n.deploymentOnlineUnavailable);
    if (outcome is OnlinePaymentPaid) unawaited(ref.read(deploymentProvider.notifier).refresh(silent: true));
    unawaited(ref.read(deploymentPaymentProvider(allocationId).notifier).reload());
  }

  Future<void> _addAfterSubmit(String allocationId) async {
    final File? file = await _pickScreenshot();
    if (file == null || !mounted) return;
    setState(() => _adding = true);
    final DeploymentPaymentNotifier notifier = ref.read(deploymentPaymentProvider(allocationId).notifier);
    final Result<String> uploaded = await notifier.uploadReceipt(file);
    if (!mounted) return;
    setState(() => _adding = false);
    switch (uploaded) {
      case Ok<String>():
        AppSnack.success(context, context.l10n.deploymentReceiptAdded);
        await notifier.reload();
      case Err<String>(:final failure):
        AppSnack.error(context, failure.message);
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
    final String slot = PaymentSlots.deployment(allocationId);
    final PaymentFlowState flow = ref.watch(paymentFlowProvider(slot));
    final DeploymentFleet? fleet = current?.allocation?.fleet;
    final bool submitted = payment?.isSubmitted == true;
    final bool canPay = payment != null && !submitted && !payment.isPaid && !payment.needsSupport;
    final DeploymentAutoPayTerms? autoPayTerms = switch ((payment, ref.watch(deploymentAutoPayTermsProvider))) {
      (final DeploymentPayment due, final DeploymentAutoPayTerms terms)
          when canPay && !_autoPayRefused && due.amount >= 1 && due.amount <= terms.limit =>
        terms,
      _ => null,
    };
    final DeploymentAutoPayTerms? withAutoPay = _autoPay ? autoPayTerms : null;

    return AppScaffold(
      title: submitted ? context.l10n.deploymentPaymentSubmitted : context.l10n.deploymentPayScooter,
      subtitle: fleet == null
          ? null
          : '${fleet.vehicleNumber}${fleet.modelName == null ? '' : ' · ${fleet.modelName}'}',
      showBack: false,
      centerTitle: submitted,
      footer: switch (payment) {
        final DeploymentPayment due when canPay => PrimaryButton(
          label: withAutoPay != null
              ? context.l10n.deploymentPayWithAutoPay(Fmt.money(due.amount))
              : context.l10n.deploymentPayOnline(Fmt.money(due.amount)),
          icon: withAutoPay != null ? Icons.autorenew_rounded : Icons.lock_rounded,
          loading: flow.busy,
          onPressed: flow.busy || flow.blocksPayment
              ? null
              : () => _payOnline(allocationId, fleet?.vehicleNumber, autoPay: withAutoPay),
        ),
        _ => null,
      },
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(deploymentProvider.notifier).refresh();
          await ref.read(deploymentPaymentProvider(allocationId).notifier).reload();
        },
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (payment == null)
              const ShimmerBox(height: 180, borderRadius: Corners.brXl)
            else if (submitted)
              _Submitted(
                payment: payment,
                adding: _adding,
                onAdd: payment.receipts.length < _maxScreenshots ? () => _addAfterSubmit(allocationId) : null,
              )
            else ...[
              _Bill(payment: payment),
              const Gap.lg(),
              if (payment.isPaid)
                AccentCard(
                  accent: AppColors.success,
                  child: Text(
                    context.l10n.onlinePaymentDone,
                    style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                  ),
                )
              else if (payment.needsSupport)
                AccentCard(
                  accent: AppColors.warning,
                  child: Text(
                    context.l10n.deploymentPaymentSupport,
                    style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                  ),
                )
              else ...[
                if (payment.isRejected) ...[_Rejected(payment: payment), const Gap.lg()],
                PaymentNoticeCard(slot: slot, spacing: Insets.lg),
                if (autoPayTerms != null)
                  _AutoPayOffer(
                    amount: payment.amount,
                    terms: autoPayTerms,
                    enabled: _autoPay,
                    email: _email,
                    emailError: _emailError,
                    locked: flow.busy,
                    onToggle: (value) {
                      if (flow.busy) return;
                      setState(() {
                        _autoPay = value;
                        _emailError = null;
                      });
                    },
                    onEmailChanged: () => setState(() => _emailError = null),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.deploymentAmountDue,
            style: AppText.bodySmall.copyWith(fontSize: 13, color: AppColors.textSecondary),
          ),
          const Gap.xs(),
          Text(Fmt.money(payment.amount), style: AppText.numericLarge.copyWith(color: AppColors.primary)),
          if (payment.items.isNotEmpty) ...[
            const Gap.sm(),
            for (final PaymentLineItem item in payment.items)
              KeyValueRow(label: item.label, value: Fmt.money(item.amount), dense: true),
          ],
        ],
      ),
    );
  }
}

class _AutoPayOffer extends StatelessWidget {
  const _AutoPayOffer({
    required this.amount,
    required this.terms,
    required this.enabled,
    required this.email,
    required this.emailError,
    required this.locked,
    required this.onToggle,
    required this.onEmailChanged,
  });

  final num amount;
  final DeploymentAutoPayTerms terms;
  final bool enabled;
  final TextEditingController email;
  final String? emailError;
  final bool locked;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEmailChanged;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    return ModuleCard(
      title: l10n.deploymentAutoPayTitle,
      leading: const IconTile(icon: Icons.autorenew_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.deploymentAutoPayTerms(Fmt.money(amount), Fmt.money(terms.limit), terms.validityDays),
            style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
          ),
          const Gap.sm(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textMuted),
              const SizedBox(width: Insets.sm),
              Expanded(
                child: Text(
                  l10n.deploymentAutoPayUpiOnly,
                  style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45, color: AppColors.textMuted),
                ),
              ),
            ],
          ),
          const Gap.md(),
          AppCheckTile(value: enabled, onChanged: onToggle, title: l10n.deploymentAutoPayToggle),
          if (enabled) ...[
            const Gap.lg(),
            AppTextField(
              label: l10n.paymentsAutoPayEmail,
              hint: 'name@example.com',
              helper: l10n.paymentsAutoPayEmailHelp,
              controller: email,
              errorText: emailError,
              enabled: !locked,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.mail_outline_rounded,
              onChanged: (_) => onEmailChanged(),
            ),
          ],
        ],
      ),
    );
  }
}

class _Rejected extends StatelessWidget {
  const _Rejected({required this.payment});

  final DeploymentPayment payment;

  @override
  Widget build(BuildContext context) {
    final String? reference = payment.providerReference;
    return AccentCard(
      accent: AppColors.danger,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.deploymentPaymentRejectedTitle,
            style: AppText.titleSmall.copyWith(color: AppColors.danger),
          ),
          const Gap.xs(),
          Text(
            context.l10n.deploymentPaymentRejectedBody(payment.rejectionReason ?? '—'),
            style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
          ),
          if (reference != null) ...[
            const Gap.xs(),
            Text(
              '${context.l10n.deploymentReference}: $reference',
              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _Submitted extends StatelessWidget {
  const _Submitted({required this.payment, required this.adding, required this.onAdd});

  final DeploymentPayment payment;
  final bool adding;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final DateTime? submittedAt = payment.submittedAt;
    final VoidCallback? onAdd = this.onAdd;
    final bool showReceipts = payment.receipts.isNotEmpty || onAdd != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Gap.lg(),
        ArtBlock(
          art: BrandArt.success,
          artSize: 112,
          title: l10n.deploymentAwaitingVerification,
          message: l10n.deploymentAwaitingVerificationHint,
        ),
        const Gap.xl(),
        ModuleCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KeyValueRow(label: l10n.commonTotal, value: Fmt.money(payment.amount)),
              KeyValueRow(label: l10n.deploymentPaidVia, value: payment.provider ?? '—'),
              KeyValueRow(label: l10n.deploymentReference, value: payment.providerReference ?? '—'),
              if (submittedAt != null) KeyValueRow(label: l10n.deploymentSubmitted, value: Fmt.dateTime(submittedAt)),
              if (showReceipts) ...[
                const Gap.sm(),
                Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
                const Gap.md(),
                GroupLabel(payment.receipts.isEmpty ? l10n.deploymentReceiptTitle : l10n.deploymentReceiptsSent),
                const Gap.sm(),
                Wrap(
                  spacing: Insets.sm,
                  runSpacing: Insets.sm,
                  children: [
                    for (final DeploymentPaymentReceipt receipt in payment.receipts)
                      _ReceiptThumb(paymentId: payment.id, photoId: receipt.id),
                    if (onAdd != null) _AddThumb(onTap: adding ? null : onAdd, busy: adding),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ReceiptThumb extends ConsumerWidget {
  const _ReceiptThumb({required this.paymentId, required this.photoId});

  final String paymentId;
  final String photoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<String> url = ref.watch(
      paymentReceiptUrlProvider(ReceiptRef(paymentId: paymentId, photoId: photoId)),
    );
    final String? link = url.value;
    final Widget content = link == null
        ? (url.hasError ? const _ThumbIcon(icon: Icons.image_not_supported_rounded) : const _ThumbSpinner())
        : Image.network(
            link,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) => progress == null ? child : const _ThumbSpinner(),
            errorBuilder: (_, _, _) => const _ThumbIcon(icon: Icons.image_not_supported_rounded),
          );
    return Pressable(
      onTap: link == null ? null : () => PhotoViewer.show(context, link),
      scale: 0.97,
      child: ClipRRect(
        borderRadius: Corners.brMd,
        child: SizedBox.square(dimension: _thumbSize, child: content),
      ),
    );
  }
}

class _AddThumb extends StatelessWidget {
  const _AddThumb({required this.onTap, this.busy = false});

  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.96,
      child: Container(
        width: _thumbSize,
        height: _thumbSize,
        padding: const EdgeInsets.all(Insets.xs),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: Corners.brMd,
          border: Border.all(color: AppColors.stroke),
        ),
        child: busy
            ? const _ThumbSpinner()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate_rounded, size: 22, color: AppColors.primary),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.deploymentReceiptAdd,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 10.5, height: 1.2, color: AppColors.primary),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ThumbIcon extends StatelessWidget {
  const _ThumbIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(child: Icon(icon, size: 22, color: AppColors.textMuted)),
    );
  }
}

class _ThumbSpinner extends StatelessWidget {
  const _ThumbSpinner();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: SizedBox.square(
          dimension: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
        ),
      ),
    );
  }
}
