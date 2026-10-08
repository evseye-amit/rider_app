import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/exchange_case.dart';
import '../../domain/usecases/exchange_steps.dart';
import '../../exchange_dependencies.dart';
import '../providers/exchange_case_providers.dart';

class ChooseScooterPage extends ConsumerStatefulWidget {
  const ChooseScooterPage({required this.exchangeId, super.key});

  final String exchangeId;

  @override
  ConsumerState<ChooseScooterPage> createState() => _ChooseScooterPageState();
}

class _ChooseScooterPageState extends ConsumerState<ChooseScooterPage> {
  ScooterOption? _picked;
  bool _saving = false;

  Future<void> _reserve(ExchangeCase exchange, ScooterOption scooter) async {
    setState(() => _saving = true);
    final Result<void> result = await ref.read(chooseReplacementScooterProvider)(
      ChooseScooterParams(exchange: exchange, scooter: scooter),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case Ok<void>():
        ref.invalidate(availableScootersProvider);
        AppSnack.success(context, context.l10n.exchangeDeskScooterReserved);
        context.pop(true);
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ExchangeCase> detail = ref.watch(exchangeCaseProvider(widget.exchangeId));
    final AsyncValue<List<ScooterOption>> scooters = ref.watch(availableScootersProvider);
    final ExchangeCase? exchange = detail.value;
    final List<ScooterOption>? options = scooters.value
        ?.where((scooter) => scooter.id != exchange?.oldScooter?.id)
        .toList(growable: false);
    final ScooterOption? picked = _picked;

    return AppScaffold(
      title: context.l10n.exchangeDeskChooseScooter,
      subtitle: exchange?.riderName,
      footer: exchange == null || picked == null
          ? null
          : PrimaryButton(
              label: context.l10n.exchangeDeskReserveScooter,
              icon: Icons.lock_rounded,
              loading: _saving,
              onPressed: _saving ? null : () => _reserve(exchange, picked),
            ),
      body: _body(context, detail, scooters, exchange, options, picked),
    );
  }

  Widget _body(
    BuildContext context,
    AsyncValue<ExchangeCase> detail,
    AsyncValue<List<ScooterOption>> scooters,
    ExchangeCase? exchange,
    List<ScooterOption>? options,
    ScooterOption? picked,
  ) {
    if (exchange == null || options == null) {
      if (detail.hasError || scooters.hasError) {
        return EmptyState(
          title: context.l10n.exchangeCouldNotLoad,
          message: detail.hasError ? detail.failureMessage : scooters.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () {
            ref.invalidate(exchangeCaseProvider(widget.exchangeId));
            ref.invalidate(availableScootersProvider);
          },
        );
      }
      return const PageBody(
        children: [
          ShimmerBox(height: 72, borderRadius: Corners.brMd),
          Gap.md(),
          ShimmerBox(height: 72, borderRadius: Corners.brMd),
        ],
      );
    }
    if (options.isEmpty) {
      return EmptyState(
        title: context.l10n.exchangeDeskNoScooters,
        icon: Icons.electric_scooter_rounded,
        actionLabel: context.l10n.commonRefresh,
        onAction: () => ref.invalidate(availableScootersProvider),
      );
    }
    return RefreshIndicator(
      onRefresh: () => ref.refreshQuietly(availableScootersProvider),
      child: PageBody(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          for (final ScooterOption scooter in options) ...[
            AppRadioTile(
              selected: picked?.id == scooter.id,
              onTap: () => setState(() => _picked = scooter),
              title: scooter.number,
              subtitle: scooter.model,
              leading: const Icon(Icons.electric_scooter_rounded, color: AppColors.primary, size: 22),
            ),
            const Gap.sm(),
          ],
        ],
      ),
    );
  }
}
