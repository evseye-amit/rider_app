import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class VerifyDeallocationOtpParams {
  const VerifyDeallocationOtpParams({required this.allocationId, required this.otpRequestId, required this.code});

  final String allocationId;
  final String otpRequestId;
  final String code;
}

class VerifyDeallocationOtp extends UseCase<void, VerifyDeallocationOtpParams> {
  const VerifyDeallocationOtp(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<void>> call(VerifyDeallocationOtpParams params) => _repository.verifyDeallocationOtp(params.allocationId, otpRequestId: params.otpRequestId, code: params.code);
}
