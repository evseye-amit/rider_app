import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class DeallocationOtpParams {
  const DeallocationOtpParams({required this.allocationId, required this.phone, required this.party});

  final String allocationId;
  final String phone;

  final String party;
}

class RequestDeallocationOtp extends UseCase<OtpChallenge, DeallocationOtpParams> {
  const RequestDeallocationOtp(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<OtpChallenge>> call(DeallocationOtpParams params) => _repository.requestDeallocationOtp(params.allocationId, phone: params.phone, party: params.party);
}
