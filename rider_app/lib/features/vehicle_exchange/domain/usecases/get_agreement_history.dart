import 'package:evseye_core/evseye_core.dart';

import '../entities/rental_agreement.dart';
import '../exchange_repository.dart';

class GetAgreementHistory extends UseCase<List<AgreementRevision>, String> {
  const GetAgreementHistory(this._repository);

  final ExchangeRepository _repository;

  @override
  Future<Result<List<AgreementRevision>>> call(String params) => _repository.agreementHistory(params);
}
