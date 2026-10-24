import 'package:evseye_core/evseye_core.dart';

import '../entities/auto_pay_setup.dart';
import '../payments_repository.dart';

class SetUpAutoPayParams {
  const SetUpAutoPayParams({required this.email, required this.idempotencyKey});

  final String email;

  final String idempotencyKey;
}

class AutoPayActionParams {
  const AutoPayActionParams({required this.mandateId, required this.idempotencyKey});

  final String mandateId;

  final String idempotencyKey;
}

class PauseAutoPayParams {
  const PauseAutoPayParams({required this.mandateId, required this.pause, required this.idempotencyKey});

  final String mandateId;

  final bool pause;

  final String idempotencyKey;
}

class GetAutoPay extends UseCase<AutoPaySetup?, NoParams> {
  const GetAutoPay(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<AutoPaySetup?>> call(NoParams params) => _repository.getAutoPay();
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

class CancelAutoPay extends UseCase<AutoPayMandate, AutoPayActionParams> {
  const CancelAutoPay(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<AutoPayMandate>> call(AutoPayActionParams params) =>
      _repository.cancelAutoPay(params.mandateId, idempotencyKey: params.idempotencyKey);
}

class PauseAutoPay extends UseCase<AutoPayMandate, PauseAutoPayParams> {
  const PauseAutoPay(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<AutoPayMandate>> call(PauseAutoPayParams params) =>
      _repository.pauseAutoPay(params.mandateId, pause: params.pause, idempotencyKey: params.idempotencyKey);
}

class SetAutoDebit extends UseCase<AutoPayMandate, bool> {
  const SetAutoDebit(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<AutoPayMandate>> call(bool params) => _repository.setAutoDebit(enabled: params);
}
