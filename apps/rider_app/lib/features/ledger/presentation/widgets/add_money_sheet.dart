import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/entities/ledger_top_up.dart';

String topUpMoney(int paise) => Fmt.money(paise / 100, paise: paise % 100 != 0);

class AddMoneySheet extends StatefulWidget {
  const AddMoneySheet({this.pendingAutoRecharge, super.key});

  final num? pendingAutoRecharge;

  static Future<int?> show(BuildContext context, {num? pendingAutoRecharge}) => AppSheet.show<int>(
    context,
    title: context.l10n.ledgerAddMoney,
    subtitle: context.l10n.ledgerAddMoneyLimits(
      topUpMoney(LedgerTopUpLimits.minPaise),
      topUpMoney(LedgerTopUpLimits.maxPaise),
    ),
    child: AddMoneySheet(pendingAutoRecharge: pendingAutoRecharge),
  );

  @override
  State<AddMoneySheet> createState() => _AddMoneySheetState();
}

class _AddMoneySheetState extends State<AddMoneySheet> {
  final TextEditingController _amount = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _pick(int rupees) {
    _amount.value = TextEditingValue(
      text: '$rupees',
      selection: TextSelection.collapsed(offset: '$rupees'.length),
    );
    setState(() => _error = null);
  }

  void _continue() {
    final int? paise = LedgerTopUpLimits.parsePaise(_amount.text);
    if (paise == null || !LedgerTopUpLimits.allows(paise)) {
      setState(
        () => _error = context.l10n.ledgerAddMoneyInvalidAmount(
          topUpMoney(LedgerTopUpLimits.minPaise),
          topUpMoney(LedgerTopUpLimits.maxPaise),
        ),
      );
      return;
    }
    Navigator.of(context).pop(paise);
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final int? paise = LedgerTopUpLimits.parsePaise(_amount.text);
    final bool valid = paise != null && LedgerTopUpLimits.allows(paise);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: l10n.ledgerAddMoneyAmount,
            controller: _amount,
            errorText: _error,
            prefixText: '₹ ',
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,5}(\.\d{0,2})?'))],
            onChanged: (_) => setState(() => _error = null),
            onSubmitted: (_) => _continue(),
          ),
          const Gap.md(),
          FilterChipBar(
            items: [for (final int rupees in LedgerTopUpLimits.presetRupees) Fmt.money(rupees)],
            selectedIndex: LedgerTopUpLimits.presetRupees.indexWhere((rupees) => rupees * 100 == paise),
            padding: EdgeInsets.zero,
            onChanged: (index) => _pick(LedgerTopUpLimits.presetRupees[index]),
          ),
          const Gap.lg(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textMuted),
              const SizedBox(width: Insets.sm),
              Expanded(
                child: Text(
                  l10n.ledgerAddMoneyNonRefundable,
                  style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                ),
              ),
            ],
          ),
          if (widget.pendingAutoRecharge case final num pending) ...[
            const Gap.md(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.autorenew_rounded, size: 16, color: AppColors.warning),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Text(
                    l10n.ledgerAutoPayManualNote(Fmt.money(pending)),
                    style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                  ),
                ),
              ],
            ),
          ],
          const Gap.lg(),
          PrimaryButton(
            label: valid ? l10n.ledgerAddMoneyPay(topUpMoney(paise)) : l10n.ledgerAddMoney,
            icon: Icons.lock_rounded,
            onPressed: _continue,
          ),
          const Gap.md(),
        ],
      ),
    );
  }
}
