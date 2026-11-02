import 'package:flutter_test/flutter_test.dart';
import 'package:evseye_core/evseye_core.dart';

void main() {
  test('maps the active Work Partner API contract to WorkPartnerOption', () {
    final List<WorkPartnerOption> partners = workPartnerOptionsFromJson([
      {'id': 'partner-1', 'name': 'Fast Delivery', 'code': 'FAST', 'category': 'FOOD_DELIVERY'},
      {'id': 'partner-2', 'name': 'New Category Partner', 'category': 'FUTURE_CATEGORY'},
      {'id': '', 'name': 'Incomplete'},
      {'id': 'partner-3'},
      'malformed',
    ]);

    expect(partners, hasLength(2));
    expect(partners.first.id, 'partner-1');
    expect(partners.first.code, 'FAST');
    expect(partners.first.category, 'FOOD_DELIVERY');
    expect(partners.last.category, 'FUTURE_CATEGORY');
  });
}
