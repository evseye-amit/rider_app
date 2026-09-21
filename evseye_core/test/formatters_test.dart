import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Fmt.relative', () {
    test('reads the past', () {
      final DateTime now = DateTime.now();
      expect(Fmt.relative(now.subtract(const Duration(seconds: 20))), 'just now');
      expect(Fmt.relative(now.subtract(const Duration(minutes: 8))), '8 min ago');
      expect(Fmt.relative(now.subtract(const Duration(hours: 5))), '5 hr ago');
      expect(Fmt.relative(now.subtract(const Duration(days: 1, hours: 1))), 'yesterday');
      expect(Fmt.relative(now.subtract(const Duration(days: 3))), '3 days ago');
    });

    test('reads the future', () {
      final DateTime now = DateTime.now();
      expect(Fmt.relative(now.add(const Duration(minutes: 40, seconds: 30))), 'in 40 min');
      expect(Fmt.relative(now.add(const Duration(hours: 6, minutes: 1))), 'in 6 hr');
      expect(Fmt.relative(now.add(const Duration(days: 1, hours: 1))), 'tomorrow');
      expect(Fmt.relative(now.add(const Duration(days: 3, minutes: 1))), 'in 3 days');
    });

    test('falls back to a date beyond a week either way', () {
      final DateTime now = DateTime.now();
      final DateTime far = now.add(const Duration(days: 30));
      expect(Fmt.relative(far), Fmt.date(far));
    });
  });
}
