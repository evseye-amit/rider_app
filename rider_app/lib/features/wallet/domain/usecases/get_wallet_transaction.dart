import 'package:evseye_core/evseye_core.dart';

import '../entities/wallet_overview.dart';
import '../wallet_repository.dart';

class GetWalletTransaction extends UseCase<WalletEntry, String> {
  const GetWalletTransaction(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<WalletEntry>> call(String params) => _repository.getTransaction(params);
}
