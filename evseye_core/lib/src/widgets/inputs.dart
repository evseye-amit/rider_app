import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'pressable.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    this.label,
    this.hint,
    this.helper,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffix,
    this.prefixText,
    this.required = false,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.onTap,
    this.style,
    this.suffixText,
    this.blockClipboard = false,
    super.key,
  });

  final String? label;
  final String? hint;
  final String? helper;
  final String? errorText;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? prefixText;
  final bool required;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final VoidCallback? onTap;
  final TextStyle? style;
  final String? suffixText;
  final bool blockClipboard;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController(text: widget.initialValue);
  late final bool _ownsController = widget.controller == null;
  final FocusNode _focus = FocusNode();
  bool _focused = false;
  late bool _obscured = widget.obscureText;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final Color border = hasError
        ? AppColors.danger
        : _focused
            ? AppColors.primary
            : AppColors.stroke;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          _FieldLabel(label: widget.label!, required: widget.required),
          const SizedBox(height: Insets.sm),
        ],
        AnimatedContainer(
          duration: Motion.fast,
          decoration: BoxDecoration(
            color: widget.enabled ? AppColors.surface : AppColors.surfaceMuted,
            borderRadius: Corners.brMd,
            border: Border.all(color: border, width: _focused || hasError ? 1.4 : 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: Insets.lg, right: Insets.sm),
                  child: Icon(
                    widget.prefixIcon,
                    size: 19,
                    color: _focused ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              if (widget.prefixText != null)
                Padding(
                  padding: const EdgeInsets.only(left: Insets.lg),
                  child: Row(
                    children: [
                      Text(widget.prefixText!, style: AppText.bodyLarge),
                      const SizedBox(width: Insets.md),
                      Container(width: 1, height: 22, color: AppColors.stroke),
                    ],
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  autofocus: widget.autofocus,
                  onTap: widget.onTap,
                  obscureText: _obscured,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  textCapitalization: widget.textCapitalization,
                  maxLines: widget.obscureText ? 1 : widget.maxLines,
                  maxLength: widget.maxLength,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  enableInteractiveSelection: !widget.blockClipboard,
                  contextMenuBuilder:
                      widget.blockClipboard ? (_, __) => const SizedBox.shrink() : null,
                  cursorColor: AppColors.cyan,
                  style: widget.style ??
                      AppText.bodyLarge.copyWith(
                        color: widget.enabled ? AppColors.textPrimary : AppColors.textMuted,
                      ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: AppText.bodyLarge.copyWith(color: AppColors.textMuted),
                    counterText: '',
                    filled: false,
                    isDense: true,
                    suffixText: widget.suffixText,
                    suffixStyle: AppText.bodyLarge.copyWith(color: AppColors.textMuted),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(
                      widget.prefixIcon != null || widget.prefixText != null ? 0 : Insets.lg,
                      Insets.lg,
                      Insets.md,
                      Insets.lg,
                    ),
                  ),
                ),
              ),
              if (widget.obscureText)
                Pressable(
                  onTap: () => setState(() => _obscured = !_obscured),
                  child: Padding(
                    padding: const EdgeInsets.only(right: Insets.lg, left: Insets.sm),
                    child: Icon(
                      _obscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      size: 19,
                      color: AppColors.textMuted,
                    ),
                  ),
                )
              else if (widget.suffix != null)
                Padding(
                  padding: const EdgeInsets.only(right: Insets.md, left: Insets.sm),
                  child: widget.suffix,
                ),
            ],
          ),
        ),
        if (hasError)
          _HelperLine(text: widget.errorText!, color: AppColors.danger, icon: Icons.error_rounded)
        else if (widget.helper != null)
          _HelperLine(text: widget.helper!, color: AppColors.textMuted),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, this.required = false});

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: AppText.label.copyWith(color: AppColors.textSecondary),
        children: required
            ? const [TextSpan(text: ' *', style: TextStyle(color: AppColors.danger))]
            : null,
      ),
    );
  }
}

class _HelperLine extends StatelessWidget {
  const _HelperLine({required this.text, required this.color, this.icon});

  final String text;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Insets.sm, left: Insets.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: Insets.xs + 2),
          ],
          Expanded(
            child: Text(text, style: AppText.bodySmall.copyWith(color: color, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class AppPickerField extends StatelessWidget {
  const AppPickerField({
    required this.label,
    this.value,
    this.hint,
    this.onTap,
    this.icon = Icons.expand_more_rounded,
    this.prefixIcon,
    this.errorText,
    this.helper,
    this.required = false,
    this.enabled = true,
    super.key,
  });

  final String label;
  final String? value;
  final String? hint;
  final VoidCallback? onTap;
  final IconData icon;
  final IconData? prefixIcon;
  final String? errorText;
  final String? helper;
  final bool required;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;
    final bool hasValue = value != null && value!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, required: required),
        const SizedBox(height: Insets.sm),
        Pressable(
          enabled: enabled,
          onTap: onTap,
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
            decoration: BoxDecoration(
              color: enabled ? AppColors.surface : AppColors.surfaceMuted,
              borderRadius: Corners.brMd,
              border: Border.all(color: hasError ? AppColors.danger : AppColors.stroke),
            ),
            child: Row(
              children: [
                if (prefixIcon != null) ...[
                  Icon(prefixIcon, size: 19, color: AppColors.textMuted),
                  const SizedBox(width: Insets.md),
                ],
                Expanded(
                  child: Text(
                    hasValue ? value! : (hint ?? 'Select'),
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyLarge.copyWith(
                      color: hasValue ? AppColors.textPrimary : AppColors.textMuted,
                    ),
                  ),
                ),
                Icon(icon, size: 20, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
        if (hasError)
          _HelperLine(text: errorText!, color: AppColors.danger, icon: Icons.error_rounded)
        else if (helper != null)
          _HelperLine(text: helper!, color: AppColors.textMuted),
      ],
    );
  }
}

class OtpInput extends StatelessWidget {
  const OtpInput({
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.hasError = false,
    this.autofocus = true,
    super.key,
  });

  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final bool hasError;
  final bool autofocus;

  static const double _gap = Insets.sm;
  static const double _maxCell = 54;

  PinTheme _cell(
    double size, {
    Color? fill,
    Color border = AppColors.stroke,
    double width = 1,
  }) =>
      PinTheme(
        width: size,
        height: size * 1.12,
        textStyle: AppText.numeric.copyWith(
          fontSize: size * 0.46,
          color: AppColors.textPrimary,
        ),
        decoration: BoxDecoration(
          color: fill ?? AppColors.surface,
          borderRadius: Corners.brMd,
          border: Border.all(color: border, width: width),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double available = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final double cell =
            ((available - _gap * (length - 1)) / length).clamp(34.0, _maxCell);

        return Pinput(
          length: length,
          autofocus: autofocus,
          closeKeyboardWhenCompleted: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofillHints: const [AutofillHints.oneTimeCode],
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          mainAxisAlignment: MainAxisAlignment.center,
          defaultPinTheme: _cell(
            cell,
            border: hasError ? AppColors.danger : AppColors.stroke,
          ),
          focusedPinTheme: _cell(
            cell,
            border: hasError ? AppColors.danger : AppColors.primary,
            width: 1.4,
          ),
          submittedPinTheme: _cell(
            cell,
            fill: AppColors.primaryWash,
            border: hasError ? AppColors.danger : AppColors.strokeStrong,
            width: 1.4,
          ),
          errorPinTheme: _cell(
            cell,
            fill: AppColors.dangerWash,
            border: AppColors.danger,
            width: 1.4,
          ),
          forceErrorState: hasError,
          separatorBuilder: (_) => const SizedBox(width: _gap),
          onChanged: onChanged,
          onCompleted: onCompleted,
          cursor: Container(
            width: 2,
            height: cell * 0.46,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        );
      },
    );
  }
}

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    this.hint = 'Search',
    this.onChanged,
    this.controller,
    this.trailing,
    super.key,
  });

  final String hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: Corners.pill,
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 19, color: AppColors.textMuted),
          const SizedBox(width: Insets.md),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: AppColors.cyan,
              style: AppText.bodyMedium.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppText.bodyMedium.copyWith(color: AppColors.textMuted),
                filled: false,
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class AppCheckTile extends StatelessWidget {
  const AppCheckTile({
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.rich,
    this.errorText,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final String? subtitle;
  final Widget? rich;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Pressable(
          onTap: () => onChanged(!value),
          scale: 0.99,
          child: Container(
            padding: const EdgeInsets.all(Insets.md + 2),
            decoration: BoxDecoration(
              color: value ? AppColors.primaryWash : AppColors.surface,
              borderRadius: Corners.brMd,
              border: Border.all(
                color: errorText != null
                    ? AppColors.danger
                    : value
                        ? AppColors.primary.withValues(alpha: 0.45)
                        : AppColors.stroke,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: Motion.fast,
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: value ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: value ? AppColors.primary : AppColors.strokeStrong,
                      width: 1.5,
                    ),
                  ),
                  child: value
                      ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: rich ??
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppText.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          )),
                          if (subtitle != null) ...[
                            const SizedBox(height: Insets.xs),
                            Text(subtitle!, style: AppText.bodySmall),
                          ],
                        ],
                      ),
                ),
              ],
            ),
          ),
        ),
        if (errorText != null)
          _HelperLine(text: errorText!, color: AppColors.danger, icon: Icons.error_rounded),
      ],
    );
  }
}

class AppRadioTile extends StatelessWidget {
  const AppRadioTile({
    required this.selected,
    required this.onTap,
    required this.title,
    this.subtitle,
    this.trailing,
    this.leading,
    this.badge,
    super.key,
  });

  final bool selected;
  final VoidCallback onTap;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryWash : AppColors.surface,
          borderRadius: Corners.brLg,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.stroke,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: Insets.md)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text(title, style: AppText.titleMedium)),
                      if (badge != null) ...[
                        const SizedBox(width: Insets.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.mintWash,
                            borderRadius: Corners.pill,
                          ),
                          child: Text(
                            badge!,
                            style: AppText.overline.copyWith(
                              color: AppColors.mint,
                              fontSize: 9.5,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: Insets.xs + 2),
                    Text(subtitle!, style: AppText.bodySmall),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: Insets.md), trailing!],
            const SizedBox(width: Insets.md),
            AnimatedContainer(
              duration: Motion.fast,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.strokeStrong,
                  width: selected ? 6.5 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
