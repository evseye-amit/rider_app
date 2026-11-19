abstract final class WalletTopUpLimits {
  static const int minPaise = 50000;
  static const int maxPaise = 500000;
  static const List<int> presetRupees = [500, 1000, 2000, 5000];

  static final RegExp _amount = RegExp(r'^(\d{1,7})(?:\.(\d{0,2}))?$');

  static int? parsePaise(String input) {
    final RegExpMatch? match = _amount.firstMatch(input.trim());
    if (match == null) return null;
    final int rupees = int.parse(match.group(1)!);
    final int paise = int.parse((match.group(2) ?? '').padRight(2, '0'));
    return rupees * 100 + paise;
  }

  static bool allows(int paise) => paise >= minPaise && paise <= maxPaise;

  static String wire(int paise) => '${paise ~/ 100}.${(paise % 100).toString().padLeft(2, '0')}';
}
