import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/ledger_overview.dart';
import '../ledger_repository.dart';

class LedgerPage extends Equatable {
  const LedgerPage({this.page = 1, this.pageSize = 20});

  final int page;
  final int pageSize;

  @override
  List<Object?> get props => [page, pageSize];
}

class GetLedgerTransactions extends UseCase<List<LedgerEntry>, LedgerPage> {
  const GetLedgerTransactions(this._repository);

  final LedgerRepository _repository;

  @override
  Future<Result<List<LedgerEntry>>> call(LedgerPage params) =>
      _repository.getTransactions(page: params.page, pageSize: params.pageSize);
}
