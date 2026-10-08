import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'pressable.dart';
import 'status_chip.dart';

class ESignature extends Equatable {
  const ESignature({required this.name, required this.signedAt});

  final String name;
  final DateTime signedAt;

  @override
  List<Object?> get props => [name, signedAt];
}

const TextStyle _signatureFont = TextStyle(
  fontFamily: 'Snell Roundhand',
  fontFamilyFallback: ['cursive', 'Bradley Hand', 'Savoye LET'],
  fontSize: 30,
  height: 1.15,
);

class ESignCard extends StatelessWidget {
  const ESignCard({
    required this.name,
    required this.onSign,
    this.signature,
    this.errorText,
    this.enabled = true,
    super.key,
  });

  final String name;
  final VoidCallback onSign;
  final ESignature? signature;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ESignature? signed = signature;
    final bool isSigned = signed != null;
    final String signer = signed?.name ?? name;
    final Color border = errorText != null
        ? AppColors.danger
        : isSigned
        ? AppColors.primary
        : AppColors.stroke;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Pressable(
          enabled: enabled,
          onTap: isSigned ? null : onSign,
          scale: 0.99,
          child: AnimatedContainer(
            duration: Motion.fast,
            padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md + 2),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: Corners.brLg,
              border: Border.all(color: border, width: isSigned ? 1.6 : 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.draw_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: Insets.sm - 2),
                    Expanded(
                      child: Text(
                        context.l10n.esignTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.titleSmall.copyWith(fontSize: 13),
                      ),
                    ),
                    if (isSigned)
                      _SignedBadge(label: context.l10n.esignSigned)
                    else
                      StatusChip(label: context.l10n.esignTapToSign, tone: StatusTone.brand, dense: true),
                  ],
                ),
                SizedBox(
                  height: 52,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        signer.isEmpty ? context.l10n.esignYourName : signer,
                        maxLines: 1,
                        style: _signatureFont.copyWith(color: isSigned ? AppColors.primaryInk : AppColors.textMuted),
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: AppColors.strokeStrong),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: Insets.sm, left: Insets.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_rounded, size: 13, color: AppColors.danger),
                const SizedBox(width: Insets.xs + 2),
                Expanded(
                  child: Text(errorText!, style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SignedBadge extends StatelessWidget {
  const _SignedBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.sm + 2, vertical: Insets.xs),
      decoration: BoxDecoration(
        borderRadius: Corners.pill,
        border: Border.all(color: AppColors.success),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded, size: 13, color: AppColors.success),
          const SizedBox(width: Insets.xs),
          Text(
            label,
            style: AppText.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.success),
          ),
        ],
      ),
    );
  }
}
