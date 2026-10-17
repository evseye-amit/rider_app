import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/legal_api.dart';
import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../utils/result.dart';
import '../widgets/buttons.dart';
import '../widgets/feedback.dart';
import '../widgets/inputs.dart';
import 'company.dart';
import 'first_run_scaffold.dart';

class CompanyResolvePage extends ConsumerStatefulWidget {
  const CompanyResolvePage({required this.audience, required this.onResolved, super.key});

  final LegalAudience audience;

  final VoidCallback onResolved;

  @override
  ConsumerState<CompanyResolvePage> createState() => _CompanyResolvePageState();
}

class _CompanyResolvePageState extends ConsumerState<CompanyResolvePage> {
  final TextEditingController _code = TextEditingController();
  bool _resolving = false;
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _resolve() async {
    if (_resolving) return;
    final String code = _code.text.trim();
    if (code.isEmpty) {
      setState(() => _error = context.l10n.companyCodeRequired);
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _resolving = true;
      _error = null;
    });
    final Result<ResolvedCompany> result = await ref.read(companyProvider.notifier).resolve(code, widget.audience);
    if (!mounted) return;
    switch (result) {
      case Ok<ResolvedCompany>(:final value):
        final String? name = value.name;
        if (name != null && name.isNotEmpty) AppSnack.success(context, context.l10n.companyWelcome(name));
        widget.onResolved();
      case Err<ResolvedCompany>(:final failure):
        setState(() {
          _resolving = false;
          _error = failure.message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FirstRunScaffold(
      icon: Icons.apartment_rounded,
      title: context.l10n.companyTitle,
      subtitle: context.l10n.companySubtitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: context.l10n.companyCodeLabel,
              hint: context.l10n.companyCodeHint,
              controller: _code,
              prefixIcon: Icons.business_rounded,
              autofocus: true,
              maxLength: 80,
              errorText: _error,
              enabled: !_resolving,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9-]')), _LowerCase()],
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) => _resolve(),
            ),
            const SizedBox(height: Insets.lg),
            Container(
              padding: const EdgeInsets.all(Insets.md),
              decoration: BoxDecoration(
                color: AppColors.primaryWash,
                borderRadius: Corners.brLg,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: Insets.sm),
                  Expanded(
                    child: Text(
                      context.l10n.companyHelp,
                      style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      footer: PrimaryButton(
        label: context.l10n.authContinue,
        trailingIcon: Icons.arrow_forward_rounded,
        loading: _resolving,
        onPressed: _resolving ? null : _resolve,
      ),
    );
  }
}

class _LowerCase extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) =>
      newValue.copyWith(text: newValue.text.toLowerCase());
}
