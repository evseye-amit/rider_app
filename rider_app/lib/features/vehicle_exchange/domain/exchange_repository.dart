import 'package:evseye_core/evseye_core.dart';

import 'entities/exchange_request.dart';

abstract interface class ExchangeRepository {
  Future<Result<List<ExchangeRequest>>> list();

  Future<Result<ExchangeRequest>> details(String id);

  Future<Result<ExchangeRequest>> request({required String agreementId, required String reasonCode, String? reason});

  Future<Result<ExchangeRequest>> acceptOffer({required String id, required String offerId, required String offerHash});

  Future<Result<ExchangeRequest>> rejectOffer({required String id, required String offerId, required String reason});

  Future<Result<ExchangeRequest>> cancel(String id);
}
