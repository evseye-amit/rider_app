import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/wallet_auto_pay.dart';
import '../wallet_repository.dart';

class GetWalletAutoPay extends UseCase<WalletAutoPay, NoParams> {
  const GetWalletAutoPay(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<WalletAutoPay>> call(NoParams params) => _repository.getAutoPay();
}

class WalletAutoPayChange extends Equatable {
  const WalletAutoPayChange.enable({required String this.mandateId, required int this.revision}) : enabled = true;

  const WalletAutoPayChange.disable() : enabled = false, mandateId = null, revision = null;

  final bool enabled;
  final String? mandateId;
  final int? revision;

  @override
  List<Object?> get props => [enabled, mandateId, revision];
}

class SetWalletAutoPay extends UseCase<WalletAutoPay, WalletAutoPayChange> {
  const SetWalletAutoPay(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<WalletAutoPay>> call(WalletAutoPayChange params) =>
      _repository.setAutoPay(enabled: params.enabled, mandateId: params.mandateId, revision: params.revision);
}
