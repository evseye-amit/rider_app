import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/exchange_request.dart';
import '../domain/entities/rental_agreement.dart';
import '../domain/exchange_repository.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  const ExchangeRepositoryImpl(this._api, this._agreements);

  final VehicleExchangeApi _api;
  final RentalAgreementsApi _agreements;

  @override
  Future<Result<List<ExchangeRequest>>> list() async =>
      (await _api.list()).map((items) => [for (final VehicleExchange item in items) _request(item)]);

  @override
  Future<Result<ExchangeRequest>> details(String id) async => (await _api.details(id)).map(_request);

  @override
  Future<Result<RentalAgreement?>> activeAgreement() async => (await _agreements.list()).map(
    (items) => switch (items.where((item) => item.isActive).firstOrNull) {
      final RentalAgreementDto active => RentalAgreement(
        id: active.id,
        number: active.agreementNumber,
        rent: active.recurringAmount,
        period: RentPeriod.parse(active.rentalPeriodType),
        scooterName: _scooterName(active.vehicleModel, active.vehicleVariant),
      ),
      null => null,
    },
  );

  @override
  Future<Result<ExchangeRequest>> request({
    required String agreementId,
    required String reasonCode,
    String? reason,
  }) async => (await _api.request(agreementId: agreementId, reasonCode: reasonCode, reason: reason)).map(_request);

  @override
  Future<Result<void>> acceptOffer({required String id, required String offerId, required String offerHash}) =>
      _api.accept(id: id, offerId: offerId, offerHash: offerHash);

  @override
  Future<Result<void>> rejectOffer({required String id, required String offerId, required String reason}) =>
      _api.rejectOffer(id: id, offerId: offerId, reason: reason);

  @override
  Future<Result<void>> cancel(String id) => _api.cancel(id);

  @override
  Future<Result<List<AgreementRevision>>> agreementHistory(String agreementId) async =>
      (await _api.agreementVersions(agreementId)).map(
        (versions) => [
          for (final AgreementVersion version in versions.reversed)
            AgreementRevision(
              number: version.versionNumber,
              rent: version.recurringAmount,
              effectiveFrom: version.effectiveFrom,
              state: switch (version.status) {
                'ACTIVE' => RevisionState.current,
                'PENDING' => RevisionState.pending,
                _ => RevisionState.previous,
              },
              scooterName: _scooterName(version.vehicleModel, version.vehicleVariant),
            ),
        ],
      );

  static ExchangeRequest _request(VehicleExchange exchange) => ExchangeRequest(
    id: exchange.id,
    agreementId: exchange.agreementId,
    status: _status(exchange.status),
    reasonCode: exchange.reasonCode,
    createdAt: exchange.createdAt,
    reason: exchange.reason,
    oldScooterReturned: exchange.oldVehicleReturned,
    completedAt: exchange.completedAt,
    canCancel: exchange.canCancel,
    offers: [for (final VehicleExchangeOffer offer in exchange.offers) _offer(offer)],
  );

  static ExchangeStatus _status(VehicleExchangeStatus status) => switch (status) {
    VehicleExchangeStatus.requested => ExchangeStatus.requested,
    VehicleExchangeStatus.approved => ExchangeStatus.approved,
    VehicleExchangeStatus.returnPending => ExchangeStatus.returnPending,
    VehicleExchangeStatus.replacementSelected => ExchangeStatus.replacementSelected,
    VehicleExchangeStatus.offerPresented => ExchangeStatus.offerPresented,
    VehicleExchangeStatus.accepted || VehicleExchangeStatus.depositPending => ExchangeStatus.depositPending,
    VehicleExchangeStatus.handoverPending => ExchangeStatus.handoverPending,
    VehicleExchangeStatus.completed => ExchangeStatus.completed,
    VehicleExchangeStatus.rejected => ExchangeStatus.rejected,
    VehicleExchangeStatus.cancelled => ExchangeStatus.cancelled,
    VehicleExchangeStatus.expired => ExchangeStatus.expired,
  };

  static ExchangeOffer _offer(VehicleExchangeOffer offer) => ExchangeOffer(
    id: offer.id,
    hash: offer.offerHash,
    termsTitle: offer.termsTitle,
    termsBody: offer.termsSnapshot,
    termsVersion: offer.termsVersion,
    expiresAt: offer.expiresAt,
    isPresented: offer.isPresented,
    isAccepted: offer.status == VehicleExchangeOfferStatus.accepted,
    quote: _quote(offer.quote),
  );

  static ExchangeQuote _quote(ExchangeQuoteDto quote) => ExchangeQuote(
    newRent: quote.recurringAmount,
    rentAdjustment: quote.rentAdjustment,
    depositMoved: quote.depositTransfer,
    depositToPay: quote.depositAdditional,
    depositExcess: quote.depositExcess,
    refundsExcess: quote.refundsExcess,
    fee: quote.exchangeFee,
    feeWaived: quote.feeWaived,
    period: RentPeriod.parse(quote.rentalPeriod),
    scooterName: _scooterName(quote.vehicleModel, quote.vehicleVariant),
    hubName: quote.hubName,
    newRentFrom: quote.billingStartAt,
  );

  static String? _scooterName(String? model, String? variant) {
    final String name = [?model, ?variant].join(' ').trim();
    return name.isEmpty ? null : name;
  }
}
