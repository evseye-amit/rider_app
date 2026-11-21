import 'package:evseye_core/evseye_core.dart';

import '../entities/auto_pay.dart';
import '../payments_repository.dart';

class SetUpAutoPayParams {
  const SetUpAutoPayParams({required this.email, required this.idempotencyKey});

  final String email;

  final String idempotencyKey;
}

class TurnOnAutoPayParams {
  const TurnOnAutoPayParams({required this.mandateId, required this.revision, required this.consentRevision});

  final String mandateId;

  final int revision;

  final int consentRevision;
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

class TurnOnAutoPay extends UseCase<AutoPay, TurnOnAutoPayParams> {
  const TurnOnAutoPay(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<AutoPay>> call(TurnOnAutoPayParams params) => _repository.turnOnAutoPay(
    mandateId: params.mandateId,
    revision: params.revision,
    consentRevision: params.consentRevision,
  );
}
