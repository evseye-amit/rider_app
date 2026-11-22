import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/ledger_overview.dart';
import '../ledger_repository.dart';

class StatementQuery extends Equatable {
  const StatementQuery({required this.month, this.page = 1, this.pageSize = 50});

  final DateTime month;
  final int page;
  final int pageSize;

  @override
  List<Object?> get props => [month, page, pageSize];
}

class GetLedgerStatement extends UseCase<LedgerStatementView, StatementQuery> {
  const GetLedgerStatement(this._repository);

  final LedgerRepository _repository;

  @override
  Future<Result<LedgerStatementView>> call(StatementQuery params) =>
      _repository.getStatement(month: params.month, page: params.page, pageSize: params.pageSize);
}

class GetSecurityDeposit extends UseCase<LedgerDeposit, String> {
  const GetSecurityDeposit(this._repository);

  final LedgerRepository _repository;

  @override
  Future<Result<LedgerDeposit>> call(String params) => _repository.getDeposit(params);
}
