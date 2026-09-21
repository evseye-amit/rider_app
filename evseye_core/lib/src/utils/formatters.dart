import 'package:intl/intl.dart';

abstract final class Fmt {
  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );
  static final NumberFormat _inrPaise = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );
  static final NumberFormat _compact = NumberFormat.compactCurrency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 1,
  );

  static String money(num value, {bool paise = false}) =>
      paise ? _inrPaise.format(value) : _inr.format(value);

  static String moneyCompact(num value) => _compact.format(value);

  static String number(num value) => NumberFormat.decimalPattern('en_IN').format(value);

  static String date(DateTime d) => DateFormat('dd MMM yyyy').format(d);

  static String dateTime(DateTime d) => DateFormat('dd MMM, h:mm a').format(d);

  static String time(DateTime d) => DateFormat('h:mm a').format(d);

  static String weekday(DateTime d) => DateFormat('EEE').format(d);

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
