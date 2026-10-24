import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/exchange_case.dart';
import '../../domain/usecases/exchange_steps.dart';
import '../../exchange_dependencies.dart';
import '../providers/exchange_case_providers.dart';
import '../widgets/exchange_case_widgets.dart';

class ChooseScooterPage extends ConsumerStatefulWidget {
  const ChooseScooterPage({required this.exchangeId, super.key});

  final String exchangeId;

  @override
  ConsumerState<ChooseScooterPage> createState() => _ChooseScooterPageState();
}

class _ChooseScooterPageState extends ConsumerState<ChooseScooterPage> {
  String? _pickedId;
  int _hubFilter = 0;
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
    final List<ScooterOption>? options = scooters.value;

    if (exchange == null || options == null) {
      return AppScaffold(
        title: context.l10n.exchangeDeskChooseScooter,
        body: detail.hasError || scooters.hasError
            ? EmptyState(
                title: context.l10n.exchangeCouldNotLoad,
                message: detail.hasError ? detail.failureMessage : scooters.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () {
                  ref.invalidate(exchangeCaseProvider(widget.exchangeId));
                  ref.invalidate(availableScootersProvider);
                },
              )
            : const PageBody(
                children: [
                  ShimmerBox(height: 72, borderRadius: Corners.brLg),
                  Gap.md(),
                  ShimmerBox(height: 72, borderRadius: Corners.brLg),
                ],
              ),
      );
    }

    final List<ScooterOption> candidates = [...options.where((scooter) => scooter.id != exchange.oldScooter?.id)];
    final List<String> hubs = [
      context.l10n.allocationAllHubs,
      ...{for (final ScooterOption scooter in candidates) scooter.hubName ?? '—'}.toList()..sort(),
    ];
    final int hubFilter = _hubFilter.clamp(0, hubs.length - 1);
    final List<ScooterOption> filtered = [
      ...candidates.where((scooter) => hubFilter == 0 || (scooter.hubName ?? '—') == hubs[hubFilter]),
    ];
    final ScooterOption? picked = candidates.where((scooter) => scooter.id == _pickedId).firstOrNull;

    return HeroScaffold(
      bottomPadding: 130,
      onRefresh: () => ref.refreshQuietly(availableScootersProvider),
      band: _Band(riderName: exchange.riderName),
      bottomNavigationBar: ExchangeFooter(
        child: PrimaryButton(
          label: picked == null ? context.l10n.maintenanceSelectVehicle : context.l10n.exchangeDeskReserveScooter,
          icon: Icons.lock_rounded,
          loading: _saving,
          onPressed: picked == null || _saving ? null : () => _reserve(exchange, picked),
        ),
      ),
      children: [
        ExchangeFloatingCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilterChipBar(
                items: hubs,
                selectedIndex: hubFilter,
                onChanged: (i) => setState(() => _hubFilter = i),
                padding: EdgeInsets.zero,
              ),
              const Gap.md(),
              Text(
                context.l10n.exchangeDeskScootersReady(candidates.length),
                style: AppText.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        const Gap.lg(),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.lg),
            child: ArtBlock(
              art: BrandArt.empty,
              artSize: 112,
              title: context.l10n.exchangeDeskNoScooters,
              message: context.l10n.allocationVehicleHasAvailableOnboardedAllocation,
            ),
          )
        else
          Column(
            children: [
              for (final ScooterOption scooter in filtered) ...[
                _ScooterCard(
                  scooter: scooter,
                  selected: scooter.id == _pickedId,
                  onTap: () => setState(() => _pickedId = scooter.id),
                ),
                if (scooter != filtered.last) const Gap.md(),
              ],
            ],
          ),
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.riderName});

  final String riderName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
        const Gap.lg(),
        PhotoPanel(
          photo: BrandPhoto.evScooter,
          height: 132,
          title: context.l10n.exchangeDeskChooseScooter,
          subtitle: context.l10n.exchangeDeskForRider(riderName),
        ),
      ],
    );
  }
}

class _ScooterCard extends StatelessWidget {
  const _ScooterCard({required this.scooter, required this.selected, required this.onTap});

  final ScooterOption scooter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final List<String> details = [?scooter.code, ?scooter.hubName];
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: selected ? AppColors.washFor(AppColors.primary) : AppColors.surface,
          borderRadius: Corners.brLg,
          border: Border.all(color: selected ? AppColors.primary : AppColors.stroke, width: selected ? 1.6 : 1),
          boxShadow: selected ? Shadows.lift(AppColors.primary, opacity: 0.16, blur: 18) : null,
        ),
        child: Row(
          children: [
            const PhotoThumb(photo: BrandPhoto.evScooter, size: 44),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scooter.number, style: AppText.titleMedium.copyWith(fontSize: 15.5, letterSpacing: 0.3)),
                  if (details.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(details.join(' · '), style: AppText.bodySmall.copyWith(fontSize: 12)),
                  ],
                ],
              ),
            ),
            AnimatedContainer(
              duration: Motion.fast,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(color: selected ? AppColors.primary : AppColors.stroke, width: 1.6),
              ),
              child: selected ? const Icon(Icons.check_rounded, size: 15, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
