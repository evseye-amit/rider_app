import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/session/session_controller.dart';
import '../../domain/usecases/get_deployment_payment.dart';
import '../../domain/usecases/submit_deployment_payment.dart';
import '../cubit/deployment_cubit.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeploymentCubit(sl<SessionController>())
        ..load(silent: sl<SessionController>().deployment != null)
        ..startPolling(),
      child: const _PaymentView(),
    );
  }
}

class _PaymentView extends StatefulWidget {
  const _PaymentView();

  @override
  State<_PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<_PaymentView> {
  static const List<String> _providers = ['UPI', 'Bank transfer', 'Cash at hub', 'Card'];

  final TextEditingController _reference = TextEditingController();
  String _provider = _providers.first;
  bool _submitting = false;
  String? _error;
  DeploymentPayment? _payment;
  String? _loadedFor;

  @override
  void dispose() {
    _reference.dispose();
    super.dispose();
  }

  Future<void> _loadPayment(String allocationId) async {
    if (_loadedFor == allocationId) return;
    _loadedFor = allocationId;
    final Result<DeploymentPayment> result = await GetDeploymentPayment(sl())(allocationId);
    if (!mounted) return;
    if (result case Ok<DeploymentPayment>(:final value)) setState(() => _payment = value);
  }

  Future<void> _submit(String allocationId) async {
    final String ref = _reference.text.trim();
    if (ref.length < 4) {
      setState(() => _error = 'Enter the transaction reference you paid with');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    final Result<DeploymentPayment> result = await SubmitDeploymentPayment(sl())(
      SubmitPaymentParams(allocationId: allocationId, provider: _provider, reference: ref),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (result) {
      case Ok<DeploymentPayment>(:final value):
        setState(() => _payment = value);
        AppSnack.success(context, 'Reference submitted — waiting for verification');
        context.read<DeploymentCubit>().load(silent: true);
      case Err<DeploymentPayment>(:final failure):
        setState(() => _error = failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeploymentCubit, DeploymentState>(
      builder: (context, state) {
        final RiderDeployment? d = state.deployment;
        final String? allocationId = d?.allocation?.id;
        final DeploymentPayment? payment = d?.payment ?? _payment;

        if (allocationId != null && payment == null) _loadPayment(allocationId);

        if (state.status == DeploymentLoad.failure || allocationId == null) {
          return AppScaffold(
            title: 'Payment',
            showBack: false,
            body: state.isLoading
                ? const PageBody(children: [ShimmerBox(height: 180, borderRadius: Corners.brXl)])
                : EmptyState(
                    title: 'No payment to show',
                    message: state.message ?? 'Your fleet manager has not asked for a payment yet.',
                    icon: Icons.receipt_long_rounded,
                    actionLabel: 'Refresh',
                    onAction: context.read<DeploymentCubit>().load,
                  ),
          );
        }

        final DeploymentFleet? fleet = d?.allocation?.fleet;
        final bool submitted = payment?.isSubmitted == true;

        return AppScaffold(
          title: submitted ? 'Payment submitted' : 'Pay for your scooter',
          subtitle: fleet == null ? null : '${fleet.vehicleNumber}${fleet.modelName == null ? '' : ' · ${fleet.modelName}'}',
          showBack: false,
          body: RefreshIndicator(
            onRefresh: context.read<DeploymentCubit>().load,
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
                      title: 'How did you pay?',
                      leading: const IconTile(icon: Icons.payments_rounded, solid: true, size: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FilterChipBar(
                            items: _providers,
                            selectedIndex: _providers.indexOf(_provider),
                            onChanged: (i) => setState(() => _provider = _providers[i]),
                            padding: EdgeInsets.zero,
                          ),
                          const Gap.lg(),
                          AppTextField(
                            label: 'Transaction reference',
                            hint: _provider == 'UPI' ? 'UPI transaction ID, e.g. 4284 7192 3456' : 'Reference or receipt number',
                            helper: 'Your fleet manager checks this against what they received.',
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
      },
    );
  }
}

class _Bill extends StatelessWidget {
  const _Bill({required this.payment});

  final DeploymentPayment payment;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: 'Amount due',
      leading: const IconTile(icon: Icons.receipt_long_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Fmt.money(payment.amount), style: AppText.numericLarge.copyWith(color: AppColors.primary)),
          const Gap.md(),
          for (final item in payment.items) KeyValueRow(label: item.label, value: Fmt.money(item.amount)),
          const Divider(),
          KeyValueRow(label: 'Total', value: Fmt.money(payment.amount), valueStyle: AppText.titleSmall),
          if (payment.createdAt != null) ...[
            const Gap.sm(),
            Text('Requested ${Fmt.relative(payment.createdAt!)}', style: AppText.bodySmall.copyWith(color: AppColors.textMuted)),
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
          title: 'Reference submitted',
          message: 'Your fleet manager is checking ${payment.provider ?? 'the payment'} reference '
              '${payment.providerReference ?? ''}. This screen moves on the moment it is verified.',
        ),
        const Gap.lg(),
        ModuleCard(
          child: Column(
            children: [
              KeyValueRow(label: 'Paid via', value: payment.provider ?? '—', icon: Icons.payments_rounded),
              KeyValueRow(label: 'Reference', value: payment.providerReference ?? '—', icon: Icons.tag_rounded),
              if (payment.submittedAt != null)
                KeyValueRow(label: 'Submitted', value: Fmt.dateTime(payment.submittedAt!), icon: Icons.schedule_rounded),
              const KeyValueRow(label: 'Status', value: 'Awaiting verification', icon: Icons.hourglass_top_rounded),
            ],
          ),
        ),
      ],
    );
  }
}
