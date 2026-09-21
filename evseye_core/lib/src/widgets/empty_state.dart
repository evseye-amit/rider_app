import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    this.message,
    this.icon = Icons.inbox_rounded,
    this.actionLabel,
    this.onAction,
    this.tone = AppColors.primary,
    this.compact = false,
    super.key,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color tone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.x3l,
          vertical: compact ? Insets.xxl : Insets.x4l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 66 : 84,
              height: compact ? 66 : 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.washFor(tone),
                border: Border.all(color: tone.withValues(alpha: 0.16)),
              ),
              child: Icon(icon, size: compact ? 28 : 34, color: tone),
            ),
            SizedBox(height: compact ? Insets.lg : Insets.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppText.titleLarge.copyWith(fontSize: compact ? 16 : 18),
            ),
            if (message != null) ...[
              const SizedBox(height: Insets.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppText.bodyMedium.copyWith(fontSize: 13.5),
              ),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: Insets.xl),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                expand: false,
                size: AppButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = Corners.brSm,
    super.key,
  });

  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final double t = _c.value * 2 - 1;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(t - 1, 0),
              end: Alignment(t + 1, 0),
              colors: const [
                AppColors.surfaceMuted,
                AppColors.surfaceSunken,
                AppColors.surfaceMuted,
              ],
            ),
          ),
        );
      },
    );
  }
}
