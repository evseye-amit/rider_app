import 'package:evseye_core/evseye_core.dart';

import '../entities/wallet_overview.dart';
import '../wallet_repository.dart';

class GetWithdrawalStatus extends UseCase<WithdrawalStatus, NoParams> {
  const GetWithdrawalStatus(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<WithdrawalStatus>> call(NoParams params) => _repository.getWithdrawalStatus();
}
