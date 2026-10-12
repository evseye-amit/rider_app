import 'package:evseye_core/evseye_core.dart';

import '../auth_repository.dart';

class VerifyOtpParams {
  const VerifyOtpParams({required this.otpRequestId, required this.code});

  final String otpRequestId;
  final String code;
}

class VerifyOtp extends UseCase<AuthUser, VerifyOtpParams> {
  const VerifyOtp(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AuthUser>> call(VerifyOtpParams params) =>
      _repository.verifyOtp(otpRequestId: params.otpRequestId, code: params.code);
}
