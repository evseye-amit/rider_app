import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/entities/wallet_top_up.dart';

String topUpMoney(int paise) => Fmt.money(paise / 100, paise: paise % 100 != 0);

class AddMoneySheet extends StatefulWidget {
  const AddMoneySheet({this.pendingAutoRecharge, super.key});

  final num? pendingAutoRecharge;

  static Future<int?> show(BuildContext context, {num? pendingAutoRecharge}) => AppSheet.show<int>(
    context,
    title: context.l10n.walletAddMoney,
    subtitle: context.l10n.walletAddMoneyLimits(
      topUpMoney(WalletTopUpLimits.minPaise),
      topUpMoney(WalletTopUpLimits.maxPaise),
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
    final int? paise = WalletTopUpLimits.parsePaise(_amount.text);
    if (paise == null || !WalletTopUpLimits.allows(paise)) {
      setState(
        () => _error = context.l10n.walletAddMoneyInvalidAmount(
          topUpMoney(WalletTopUpLimits.minPaise),
          topUpMoney(WalletTopUpLimits.maxPaise),
        ),
      );
      return;
    }
    Navigator.of(context).pop(paise);
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final int? paise = WalletTopUpLimits.parsePaise(_amount.text);
    final bool valid = paise != null && WalletTopUpLimits.allows(paise);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: l10n.walletAddMoneyAmount,
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
            items: [for (final int rupees in WalletTopUpLimits.presetRupees) Fmt.money(rupees)],
            selectedIndex: WalletTopUpLimits.presetRupees.indexWhere((rupees) => rupees * 100 == paise),
            padding: EdgeInsets.zero,
            onChanged: (index) => _pick(WalletTopUpLimits.presetRupees[index]),
          ),
          const Gap.lg(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textMuted),
              const SizedBox(width: Insets.sm),
              Expanded(
                child: Text(
                  l10n.walletAddMoneyNonRefundable,
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
                    l10n.walletAutoPayManualNote(Fmt.money(pending)),
                    style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                  ),
                ),
              ],
            ),
          ],
          const Gap.lg(),
          PrimaryButton(
            label: valid ? l10n.walletAddMoneyPay(topUpMoney(paise)) : l10n.walletAddMoney,
            icon: Icons.lock_rounded,
            onPressed: _continue,
          ),
          const Gap.md(),
        ],
      ),
    );
  }
}
