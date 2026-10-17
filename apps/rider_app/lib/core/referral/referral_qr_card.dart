import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReferralQrCode extends StatelessWidget {
  const ReferralQrCode({required this.data, this.size = 196, super.key});

  final String data;
  final double size;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      size: size,
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
      semanticsLabel: context.l10n.referQrSemantics,
      eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.textPrimary),
      dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AppColors.textPrimary),
    );
  }
}

class ReferralQrCard extends StatelessWidget {
  const ReferralQrCard({required this.code, required this.data, this.title, this.caption, super.key});

  final String code;
  final String data;
  final String? title;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final String? title = this.title;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Corners.brXl,
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
            child: Row(
              children: [
                const Icon(Icons.card_giftcard_rounded, size: 20, color: AppColors.textOnPrimary),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Text(
                    FlavorConfig.riderAppName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(color: AppColors.textOnPrimary),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.lg, Insets.xl, Insets.xl),
            child: Column(
              children: [
                if (title != null) ...[
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleMedium.copyWith(fontSize: 16),
                  ),
                  const Gap.lg(),
                ],
                ReferralQrCode(data: data),
                const Gap.lg(),
                Text(code, style: AppText.titleLarge.copyWith(fontSize: 20, letterSpacing: 2)),
                const Gap.xs(),
                Text(
                  caption ?? context.l10n.referScanToJoin,
                  textAlign: TextAlign.center,
                  style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
