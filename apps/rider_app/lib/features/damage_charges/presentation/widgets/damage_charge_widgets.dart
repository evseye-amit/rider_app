import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../damage_charges_dependencies.dart';
import '../../domain/entities/damage_charge.dart';
import '../../domain/usecases/damage_charge_usecases.dart';
import '../providers/damage_charges_providers.dart';

(String, StatusTone) damageChargeStatus(AppL10n l10n, DamageChargeState state) => switch (state) {
  DamageChargeState.unpaid => (l10n.damageChargesUnpaid, StatusTone.warning),
  DamageChargeState.partlyPaid => (l10n.damageChargeStatusPartlyPaid, StatusTone.info),
  DamageChargeState.paid => (l10n.damageChargeStatusPaid, StatusTone.success),
  DamageChargeState.cancelled => (l10n.damageChargeStatusCancelled, StatusTone.neutral),
};

String damageChargeTitle(AppL10n l10n, DamageCharge charge) => switch (charge.lines) {
  [] => l10n.damageChargeTitle,
  [final DamageChargeLine only] => only.name,
  [final DamageChargeLine first, ...final List<DamageChargeLine> rest] => '${first.name} +${rest.length}',
};

class DamageChargeTile extends StatelessWidget {
  const DamageChargeTile({required this.charge, required this.onOpen, super.key});

  final DamageCharge charge;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final (String label, StatusTone tone) = damageChargeStatus(context.l10n, charge.state);
    final DateTime? raisedAt = charge.raisedAt;
    return Pressable(
      onTap: onOpen,
      scale: 0.99,
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.md),
        child: Row(
          children: [
            IconTile(icon: Icons.car_crash_rounded, tone: tone.color, size: 42),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    damageChargeTitle(context.l10n, charge),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(fontSize: 14),
                  ),
                  if (raisedAt != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      context.l10n.damageChargeRaisedOn(Fmt.date(raisedAt)),
                      style: AppText.bodySmall.copyWith(fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: Insets.sm),
                  StatusChip(label: label, tone: tone, dense: true),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            Text(
              Fmt.money(charge.isOpen ? charge.due : charge.total, paise: true),
              style: AppText.titleSmall.copyWith(fontSize: 14),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class DamageChargesNotice extends StatelessWidget {
  const DamageChargesNotice({required this.amount, required this.count, required this.onTap, super.key});

  final num amount;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Corners.brLg,
          border: Border.all(color: AppColors.danger.withValues(alpha: 0.45), width: 1.4),
        ),
        child: Row(
          children: [
            const IconTile(icon: Icons.car_crash_rounded, tone: AppColors.danger, size: 38),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.damageChargesTitle, style: AppText.titleSmall.copyWith(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(context.l10n.damageChargesToPay(count), style: AppText.bodySmall.copyWith(fontSize: 12)),
                ],
              ),
            ),
            Text(
              Fmt.money(amount, paise: true),
              style: AppText.titleSmall.copyWith(fontSize: 15, color: AppColors.danger),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class DamagePhotoThumb extends ConsumerWidget {
  const DamagePhotoThumb({required this.submissionId, required this.photoId, this.size = 64, super.key});

  final String submissionId;
  final String photoId;
  final double size;

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    final Result<String> url = await ref.read(getDamagePhotoUrlProvider)(
      DamagePhotoParams(submissionId: submissionId, photoId: photoId),
    );
    if (!context.mounted) return;
    switch (url) {
      case Ok<String>(:final value) when value.isNotEmpty:
        await PhotoViewer.show(context, value);
      case _:
        AppSnack.error(context, context.l10n.allocationPhotoCannotOpen);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<String> url = ref.watch(
      damagePhotoUrlProvider(DamagePhotoParams(submissionId: submissionId, photoId: photoId)),
    );
    final Widget placeholder = Container(
      width: size,
      height: size,
      color: AppColors.surfaceMuted,
      alignment: Alignment.center,
      child: const Icon(Icons.photo_rounded, color: AppColors.textMuted),
    );
    return Pressable(
      onTap: () => _open(context, ref),
      scale: 0.96,
      child: ClipRRect(
        borderRadius: Corners.brMd,
        child: switch (url.value) {
          final String value when value.isNotEmpty => Image.network(
            value,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => placeholder,
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : ShimmerBox(height: size, width: size, borderRadius: Corners.brMd),
          ),
          _ when url.isLoading => ShimmerBox(height: size, width: size, borderRadius: Corners.brMd),
          _ => placeholder,
        },
      ),
    );
  }
}
