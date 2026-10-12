import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/exchange_case.dart';
import '../exchange_desk_repository.dart';

class RejectExchangeParams extends Equatable {
  const RejectExchangeParams({required this.id, required this.reason});

  final String id;
  final String reason;

  @override
  List<Object?> get props => [id, reason];
}

class ChooseScooterParams extends Equatable {
  const ChooseScooterParams({required this.exchange, required this.scooter});

  final ExchangeCase exchange;
  final ScooterOption scooter;

  @override
  List<Object?> get props => [exchange, scooter];
}

class ApproveExchange extends UseCase<void, String> {
  const ApproveExchange(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.approve(params);
}

class RejectExchange extends UseCase<void, RejectExchangeParams> {
  const RejectExchange(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<void>> call(RejectExchangeParams params) => _repository.reject(params.id, reason: params.reason);
}

class StartExchangeReturn extends UseCase<void, String> {
  const StartExchangeReturn(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.startReturn(params);
}

class ConfirmExchangeReturn extends UseCase<void, String> {
  const ConfirmExchangeReturn(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.confirmReturn(params);
}

class ChooseReplacementScooter extends UseCase<void, ChooseScooterParams> {
  const ChooseReplacementScooter(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<void>> call(ChooseScooterParams params) => _repository.chooseScooter(params.exchange, params.scooter);
}

class SendExchangeOffer extends UseCase<void, String> {
  const SendExchangeOffer(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.sendOffer(params);
}

class SettleExchangeDeposits extends UseCase<num, String> {
  const SettleExchangeDeposits(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<num>> call(String params) => _repository.settleDeposits(params);
}

class StartExchangeHandover extends UseCase<void, String> {
  const StartExchangeHandover(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.startHandover(params);
}

class CompleteExchange extends UseCase<void, String> {
  const CompleteExchange(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.complete(params);
}

class CancelExchangeCase extends UseCase<void, String> {
  const CancelExchangeCase(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.cancel(params);
}
