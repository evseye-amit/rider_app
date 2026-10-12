import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/wallet_overview.dart';
import '../wallet_repository.dart';

class WalletPage extends Equatable {
  const WalletPage({this.page = 1, this.pageSize = 20});

  final int page;
  final int pageSize;

  @override
  List<Object?> get props => [page, pageSize];
}

class GetWalletTransactions extends UseCase<List<WalletEntry>, WalletPage> {
  const GetWalletTransactions(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<List<WalletEntry>>> call(WalletPage params) =>
      _repository.getTransactions(page: params.page, pageSize: params.pageSize);
}
