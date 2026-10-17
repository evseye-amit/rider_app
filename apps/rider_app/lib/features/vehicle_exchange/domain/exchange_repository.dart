import 'package:evseye_core/evseye_core.dart';

import 'entities/exchange_request.dart';
import 'entities/rental_agreement.dart';

abstract interface class ExchangeRepository {
  Future<Result<List<ExchangeRequest>>> list();

  Future<Result<ExchangeRequest>> details(String id);

  Future<Result<RentalAgreement?>> activeAgreement();

  Future<Result<ExchangeRequest>> request({
    required String agreementId,
    required String reasonCode,
    required DateTime plannedDate,
    String? hubId,
    String? reason,
  });

  Future<Result<void>> acceptOffer({required String id, required String offerId, required String offerHash});

  Future<Result<void>> rejectOffer({required String id, required String offerId, required String reason});

  Future<Result<void>> cancel(String id);

  Future<Result<List<AgreementRevision>>> agreementHistory(String agreementId);
}
