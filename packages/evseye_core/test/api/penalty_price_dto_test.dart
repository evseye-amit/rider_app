import 'package:flutter_test/flutter_test.dart';
import 'package:evseye_core/src/api/ride_returns_api.dart';

void main() {
  test('retains spare catalogue provenance and finding constraints', () {
    final PenaltyPriceDto item = PenaltyPriceDto.fromJson({
      'id': 'spare-1',
      'code': 'BRAKE_PAD',
      'name': 'Brake pad',
      'category': 'DAMAGE',
      'description': 'Brake pad',
      'amount': 450,
      'currency': 'INR',
      'isSpare': true,
      'configurationVersion': 4,
      'version': 4,
      'origin': 'MASTER',
      'masterUpdateAvailable': true,
      'masterInactive': false,
      'allowedFindingTypes': ['DAMAGE', 'MISSING_ITEM'],
    });

    expect(item.isSpare, isTrue);
    expect(item.origin, 'MASTER');
    expect(item.configurationVersion, 4);
    expect(item.masterUpdateAvailable, isTrue);
    expect(item.masterInactive, isFalse);
    expect(item.allowedFindingTypes, ['DAMAGE', 'MISSING_ITEM']);
  });
}
