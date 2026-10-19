import 'dart:async';
import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/payment_receipt_usecases.dart';
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
  final TextEditingController _reference = TextEditingController();
  final List<File> _screenshots = [];
  final Map<String, String> _uploaded = {};
  int _providerIndex = 0;
  bool _submitting = false;
  bool _adding = false;
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

  Future<File?> _pickScreenshot() async {
    final File? file = await PhotoSourceSheet.pick(context);
    if (file == null || !mounted) return null;
    if (await file.length() > MediaApi.maxReceiptBytes) {
      if (mounted) AppSnack.error(context, context.l10n.deploymentReceiptTooLarge);
      return null;
    }
    return file;
  }

  Future<void> _addScreenshot() async {
    final File? file = await _pickScreenshot();
    if (file != null && mounted) setState(() => _screenshots.add(file));
  }

  void _removeScreenshot(File file) => setState(() {
    _screenshots.remove(file);
    _uploaded.remove(file.path);
  });

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

    final DeploymentPaymentNotifier notifier = ref.read(deploymentPaymentProvider(allocationId).notifier);
    for (final File file in [..._screenshots]) {
      if (_uploaded.containsKey(file.path)) continue;
      final Result<String> uploaded = await notifier.uploadReceipt(file);
      if (!mounted) return;
      if (uploaded case Err<String>(:final failure)) {
        setState(() {
          _submitting = false;
          _error = failure.message;
        });
        return;
      }
      _uploaded[file.path] = uploaded.getOrThrow();
    }

    final Result<DeploymentPayment> result = await notifier.submit(
      provider: _providers(context.l10n)[_providerIndex],
      reference: reference,
      receiptPhotoIds: [for (final File file in _screenshots) ?_uploaded[file.path]],
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case Ok<DeploymentPayment>():
        setState(() {
          _screenshots.clear();
          _uploaded.clear();
          _reference.clear();
        });
        AppSnack.success(context, context.l10n.deploymentReferenceSubmittedWaitingVerification);
        unawaited(ref.read(deploymentProvider.notifier).refresh(silent: true));
      case Err<DeploymentPayment>(:final failure):
        setState(() => _error = failure.message);
    }
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
        onRefresh: () async {
          await ref.read(deploymentProvider.notifier).refresh();
          await ref.read(deploymentPaymentProvider(allocationId).notifier).reload();
        },
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (payment == null)
              const ShimmerBox(height: 180, borderRadius: Corners.brXl)
            else ...[
              _Bill(payment: payment),
              const Gap.lg(),
              if (submitted)
                _Submitted(
                  payment: payment,
                  adding: _adding,
                  onAdd: payment.receipts.length < _maxScreenshots ? () => _addAfterSubmit(allocationId) : null,
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
                      const Gap.lg(),
                      GroupLabel(context.l10n.deploymentReceiptTitle),
                      const Gap.xs(),
                      Text(
                        context.l10n.deploymentReceiptHint,
                        style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45),
                      ),
                      const Gap.md(),
                      Wrap(
                        spacing: Insets.sm,
                        runSpacing: Insets.sm,
                        children: [
                          for (final DeploymentPaymentReceipt receipt in payment.receipts)
                            _ReceiptThumb(paymentId: payment.id, photoId: receipt.id),
                          for (final File file in _screenshots)
                            _LocalThumb(file: file, onRemove: _submitting ? null : () => _removeScreenshot(file)),
                          if (payment.receipts.length + _screenshots.length < _maxScreenshots)
                            _AddThumb(onTap: _submitting ? null : _addScreenshot),
                        ],
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
    final VoidCallback? onAdd = this.onAdd;
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
        const Gap.lg(),
        ModuleCard(
          title: payment.receipts.isEmpty ? context.l10n.deploymentReceiptTitle : context.l10n.deploymentReceiptsSent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (payment.receipts.isEmpty) ...[
                Text(context.l10n.deploymentReceiptHint, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45)),
                const Gap.md(),
              ],
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

class _LocalThumb extends StatelessWidget {
  const _LocalThumb({required this.file, required this.onRemove});

  final File file;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? onRemove = this.onRemove;
    return SizedBox.square(
      dimension: _thumbSize,
      child: Stack(
        children: [
          Positioned.fill(
            child: Pressable(
              onTap: () => PhotoViewer.showImage(context, FileImage(file)),
              scale: 0.97,
              child: ClipRRect(
                borderRadius: Corners.brMd,
                child: Image.file(file, fit: BoxFit.cover, cacheWidth: 228),
              ),
            ),
          ),
          if (onRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: Pressable(
                onTap: onRemove,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                ),
              ),
            ),
        ],
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
