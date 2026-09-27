import 'package:intl/intl.dart';

abstract final class Fmt {
  static String get _locale {
    final String? active = Intl.defaultLocale;
    if (active == null || active.isEmpty || active.startsWith('en')) return 'en_IN';
    return active;
  }

  static final Map<String, NumberFormat> _money = <String, NumberFormat>{};
  static final Map<String, NumberFormat> _moneyPaise = <String, NumberFormat>{};
  static final Map<String, NumberFormat> _moneyCompact = <String, NumberFormat>{};

  static NumberFormat _cached(Map<String, NumberFormat> cache, NumberFormat Function(String) build) =>
      cache.putIfAbsent(_locale, () => build(_locale));

  static String money(num value, {bool paise = false}) => paise
      ? _cached(_moneyPaise, (l) => NumberFormat.currency(locale: l, symbol: '₹', decimalDigits: 2)).format(value)
      : _cached(_money, (l) => NumberFormat.currency(locale: l, symbol: '₹', decimalDigits: 0)).format(value);

  static String moneyCompact(num value) =>
      _cached(_moneyCompact, (l) => NumberFormat.compactCurrency(locale: l, symbol: '₹', decimalDigits: 1))
          .format(value);

  static String number(num value) => NumberFormat.decimalPattern(_locale).format(value);

  static String date(DateTime d) => DateFormat('dd MMM yyyy', _locale).format(d);

  static String dateTime(DateTime d) => DateFormat('dd MMM, h:mm a', _locale).format(d);

  static String time(DateTime d) => DateFormat('h:mm a', _locale).format(d);

  static String weekday(DateTime d) => DateFormat('EEE', _locale).format(d);

  static String duration(Duration d) {
    final int h = d.inHours;
    final int m = d.inMinutes.remainder(60);
    if (h == 0) return '${m}m';
    return '${h}h ${m}m';
  }

  static String relative(DateTime d) {
    final Duration diff = DateTime.now().difference(d);

    if (diff.isNegative) {
      final Duration ahead = -diff;
      if (ahead.inMinutes < 1) return 'in a moment';
      if (ahead.inMinutes < 60) return 'in ${ahead.inMinutes} min';
      if (ahead.inHours < 24) return 'in ${ahead.inHours} hr';
      if (ahead.inDays == 1) return 'tomorrow';
      if (ahead.inDays < 7) return 'in ${ahead.inDays} days';
      return date(d);
    }
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return date(d);
  }

  static String phone(String raw) {
    final String digits = raw.replaceAll(RegExp(r'\D'), '');
    final String last10 = digits.length > 10 ? digits.substring(digits.length - 10) : digits;
    if (last10.length != 10) return raw;
    return '+91 ${last10.substring(0, 5)} ${last10.substring(5)}';
  }

  static String maskAadhaar(String raw) {
    final String digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 12) return raw;
    return 'XXXX XXXX ${digits.substring(8)}';
  }

  static String maskAccount(String raw) {
    if (raw.length < 4) return raw;
    return '${'X' * (raw.length - 4)}${raw.substring(raw.length - 4)}';
  }

  static String distanceKm(num km) => '${km.toStringAsFixed(1)} km';

  static String percent(num value, {int digits = 0}) =>
      '${(value * 100).toStringAsFixed(digits)}%';

  const Fmt._();
}
