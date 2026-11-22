import 'package:evseye_core/evseye_core.dart';

import '../entities/auto_pay.dart';
import '../payments_repository.dart';

class SetUpAutoPayParams {
  const SetUpAutoPayParams({required this.email, required this.idempotencyKey});

  final String email;

  final String idempotencyKey;
}

class GetAutoPay extends UseCase<AutoPay?, NoParams> {
  const GetAutoPay(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<AutoPay?>> call(NoParams params) => _repository.getAutoPay();
}

class SetUpAutoPay extends UseCase<AutoPayMandate, SetUpAutoPayParams> {
  const SetUpAutoPay(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<AutoPayMandate>> call(SetUpAutoPayParams params) =>
      _repository.setUpAutoPay(email: params.email, idempotencyKey: params.idempotencyKey);
}

class VerifyAutoPay extends UseCase<AutoPayMandate, String> {
  const VerifyAutoPay(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<AutoPayMandate>> call(String params) => _repository.verifyAutoPay(params);
}
