import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/wallet_overview.dart';
import '../wallet_repository.dart';

class StatementQuery extends Equatable {
  const StatementQuery({required this.month, this.page = 1, this.pageSize = 50});

  final DateTime month;
  final int page;
  final int pageSize;

  @override
  List<Object?> get props => [month, page, pageSize];
}

class GetWalletStatement extends UseCase<WalletStatementView, StatementQuery> {
  const GetWalletStatement(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<WalletStatementView>> call(StatementQuery params) =>
      _repository.getStatement(month: params.month, page: params.page, pageSize: params.pageSize);
}

class GetSecurityDeposit extends UseCase<WalletDeposit, String> {
  const GetSecurityDeposit(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<WalletDeposit>> call(String params) => _repository.getDeposit(params);
}
