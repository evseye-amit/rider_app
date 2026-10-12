import 'package:evseye_core/evseye_core.dart';

import '../auth_repository.dart';

class RequestOtp extends UseCase<OtpChallenge, String> {
  const RequestOtp(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<OtpChallenge>> call(String params) => _repository.requestOtp(params);
}
