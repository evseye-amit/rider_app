import 'package:evseye_core/evseye_core.dart';

import '../entities/rental_agreement.dart';
import '../exchange_repository.dart';

class GetActiveAgreement extends UseCase<RentalAgreement?, NoParams> {
  const GetActiveAgreement(this._repository);

  final ExchangeRepository _repository;

  @override
  Future<Result<RentalAgreement?>> call(NoParams params) => _repository.activeAgreement();
}
