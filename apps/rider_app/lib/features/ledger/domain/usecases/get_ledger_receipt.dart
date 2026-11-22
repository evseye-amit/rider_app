import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../ledger_repository.dart';

class ReceiptParams extends Equatable {
  const ReceiptParams({required this.kind, required this.id});

  final WalletReceiptKind kind;
  final String id;

  @override
  List<Object?> get props => [kind, id];
}

class GetLedgerReceipt extends UseCase<WalletReceipt, ReceiptParams> {
  const GetLedgerReceipt(this._repository);

  final LedgerRepository _repository;

  @override
  Future<Result<WalletReceipt>> call(ReceiptParams params) => _repository.getReceipt(params.kind, params.id);
}
