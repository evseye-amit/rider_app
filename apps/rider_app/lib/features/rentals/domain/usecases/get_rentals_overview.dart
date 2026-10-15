import 'package:evseye_core/evseye_core.dart';

import '../entities/rental.dart';
import '../rentals_repository.dart';

class GetRentalsOverview extends UseCase<RentalsOverview, NoParams> {
  const GetRentalsOverview(this._repository);

  final RentalsRepository _repository;

  @override
  Future<Result<RentalsOverview>> call(NoParams params) => _repository.getRentals();
}

class GetBill extends UseCase<BillDetail, String> {
  const GetBill(this._repository);

  final RentalsRepository _repository;

  @override
  Future<Result<BillDetail>> call(String params) => _repository.bill(params);
}

class GetLedger extends UseCase<List<LedgerLine>, NoParams> {
  const GetLedger(this._repository);

  final RentalsRepository _repository;

  @override
  Future<Result<List<LedgerLine>>> call(NoParams params) => _repository.ledger();
}

class GetPaymentReceipts extends UseCase<List<PaymentReceipt>, NoParams> {
  const GetPaymentReceipts(this._repository);

  final RentalsRepository _repository;

  @override
  Future<Result<List<PaymentReceipt>>> call(NoParams params) => _repository.receipts();
}
