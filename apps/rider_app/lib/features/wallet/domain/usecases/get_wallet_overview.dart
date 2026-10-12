import 'package:evseye_core/evseye_core.dart';

import '../entities/wallet_overview.dart';
import '../wallet_repository.dart';

class GetWalletOverview extends UseCase<WalletOverview, NoParams> {
  const GetWalletOverview(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<WalletOverview>> call(NoParams params) => _repository.getOverview();
}
