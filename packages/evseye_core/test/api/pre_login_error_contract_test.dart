import 'package:flutter_test/flutter_test.dart';
import 'package:evseye_core/src/api/pre_login_error_codes.g.dart';

void main() {
  test('generated pre-login catalog contains every API error code', () {
    expect(preLoginErrorCodes, containsAll(<String>[
      'WORKSPACE_NOT_FOUND',
      'WORKSPACE_UNAVAILABLE',
      'WORKSPACE_HOST_MISMATCH',
      'WORKSPACE_INACTIVE',
      'WORKSPACE_PENDING_APPROVAL',
      'WORKSPACE_SUSPENDED',
      'UNSUPPORTED_APP_ROLE',
    ]));
  });
}
