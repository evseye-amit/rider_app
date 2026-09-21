import 'package:evseye_core/evseye_core.dart';

import '../entities/wallet_summary.dart';
import '../wallet_repository.dart';

class GetWallet extends UseCase<WalletSummary, NoParams> {
  const GetWallet(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<WalletSummary>> call(NoParams params) =>
      _repository.getWallet();
}
