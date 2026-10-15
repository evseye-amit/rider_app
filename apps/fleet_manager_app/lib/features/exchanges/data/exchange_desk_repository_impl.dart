import 'dart:async';

import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/exchange_case.dart';
import '../domain/exchange_desk_repository.dart';

class ExchangeDeskRepositoryImpl implements ExchangeDeskRepository {
  const ExchangeDeskRepositoryImpl(this._exchanges, this._api);

  final ExchangeOperationsApi _exchanges;
  final ApiClient _api;

  static const int _pageSize = 100;

  @override
  Future<Result<List<ExchangeCase>>> cases() async {
    final (list, riders, scooters) = await (_exchanges.list(), _riders(), _scooters()).wait;
    return list.map(
      (items) => [
        for (final VehicleExchange item in items)
          _case(item, riders.valueOrNull ?? const {}, scooters.valueOrNull ?? const {}),
      ],
    );
  }

  @override
  Future<Result<ExchangeCase>> caseDetail(String id) async {
    final (detail, riders, scooters) = await (_exchanges.details(id), _riders(), _scooters()).wait;
    return detail.map((item) => _case(item, riders.valueOrNull ?? const {}, scooters.valueOrNull ?? const {}));
  }

  @override
  Future<Result<List<ScooterOption>>> availableScooters() async =>
      (await _scooters(status: 'AVAILABLE')).map((scooters) => scooters.values.toList(growable: false));

  @override
  Future<Result<CaseQuote>> quote(String id) async => (await _exchanges.preview(id)).map(_quote);

  @override
  Future<Result<void>> approve(String id) => _exchanges.approve(id);

  @override
  Future<Result<void>> reject(String id, {required String reason}) => _exchanges.reject(id, reason: reason);

  @override
  Future<Result<void>> startReturn(String id) => _exchanges.startReturn(id);

  @override
  Future<Result<void>> confirmReturn(String id) => _exchanges.confirmReturn(id);

  @override
  Future<Result<void>> chooseScooter(ExchangeCase exchange, ScooterOption scooter) {
    final String period = exchange.rentalPeriodType ?? 'WEEKLY';
    final bool custom = period == 'CUSTOM';
    return _exchanges.selectReplacement(
      exchange.id,
      vehicleId: scooter.id,
      rentalPeriodType: period,
      hubId: scooter.hubId,
      durationValue: custom ? exchange.durationValue : null,
      durationUnit: custom ? exchange.durationUnit : null,
      batteryPlanId: exchange.batteryPlanId,
    );
  }

  @override
  Future<Result<void>> sendOffer(String id) => _exchanges.sendOffer(id);

  @override
  Future<Result<DepositOutcome>> settleDeposits(String id) async => (await _exchanges.settleDeposits(id)).map(
    (settlement) => settlement.status == VehicleExchangeStatus.depositPending
        ? DepositOutcome(due: settlement.additionalRequired, securityShortfall: settlement.riderSecurityShortfall)
        : const DepositOutcome(due: 0, securityShortfall: 0),
  );

  @override
  Future<Result<void>> acceptOnBehalf(
    String id,
    CaseOffer offer, {
    required String consentReference,
    required String reason,
  }) => _exchanges.acceptOnBehalf(
    id,
    offerId: offer.id,
    offerHash: offer.hash,
    consentReference: consentReference,
    reason: reason,
  );

  @override
  Future<Result<void>> rejectOnBehalf(String id, CaseOffer offer, {required String reason}) =>
      _exchanges.rejectOfferOnBehalf(id, offerId: offer.id, reason: reason);

  @override
  Future<Result<void>> startHandover(String id) => _exchanges.startHandover(id);

  @override
  Future<Result<void>> complete(String id) => _exchanges.complete(id);

  @override
  Future<Result<void>> cancel(String id) => _exchanges.cancel(id);

  Future<Result<Map<String, ({String name, String? mobile})>>> _riders() =>
      _api.get<Map<String, ({String name, String? mobile})>>(
        '/riders',
        query: {'pageSize': _pageSize},
        parse: (data) => {
          for (final Map<String, dynamic> row in _rows(data))
            row['id']?.toString() ?? '': (name: row['name']?.toString() ?? '—', mobile: row['mobile']?.toString()),
        },
      );

  Future<Result<Map<String, ScooterOption>>> _scooters({String? status}) => _api.get<Map<String, ScooterOption>>(
    '/fleets',
    query: {'pageSize': _pageSize, 'status': ?status},
    parse: (data) => {
      for (final Map<String, dynamic> row in _rows(data))
        row['id']?.toString() ?? '': ScooterOption(
          id: row['id']?.toString() ?? '',
          number: row['vehicleNumber']?.toString() ?? '—',
          model: row['modelName']?.toString(),
          hubId: row['currentHubId']?.toString() ?? row['homeHubId']?.toString(),
        ),
    },
  );

  static List<Map<String, dynamic>> _rows(dynamic data) => [
    for (final Object? row in data is Map ? (data['items'] as List<dynamic>? ?? const []) : data as List<dynamic>)
      if (row is Map) Map<String, dynamic>.from(row),
  ];

  static ExchangeCase _case(
    VehicleExchange exchange,
    Map<String, ({String name, String? mobile})> riders,
    Map<String, ScooterOption> scooters,
  ) {
    final ({String name, String? mobile})? rider = riders[exchange.riderId];
    final VehicleExchangeOffer? pending = exchange.pendingOffer;
    final VehicleExchangeOffer? accepted = exchange.acceptedOffer;
    return ExchangeCase(
      id: exchange.id,
      status: _status(exchange.status),
      reasonCode: exchange.reasonCode,
      createdAt: exchange.createdAt,
      riderName: rider?.name ?? '—',
      riderMobile: rider?.mobile,
      reason: exchange.reason,
      agreementNumber: exchange.agreementNumber,
      oldScooter: scooters[exchange.oldVehicleId],
      replacementScooter: scooters[exchange.replacementVehicleId],
      oldAllocationId: exchange.oldAllocationId,
      newAllocationId: exchange.newAllocationId,
      oldScooterReturned: exchange.oldVehicleReturned,
      reservedUntil: exchange.reservationExpiresAt,
      rentalPeriodType: exchange.rentalPeriodType,
      durationValue: exchange.durationValue,
      durationUnit: exchange.durationUnit,
      batteryPlanId: exchange.batteryPlanId,
      pendingOffer: pending == null ? null : _offer(pending),
      acceptedOffer: accepted == null ? null : _offer(accepted),
      canCancel: exchange.canCancel,
    );
  }

  static CaseStatus _status(VehicleExchangeStatus status) => switch (status) {
    VehicleExchangeStatus.requested => CaseStatus.requested,
    VehicleExchangeStatus.approved => CaseStatus.approved,
    VehicleExchangeStatus.returnPending => CaseStatus.returnPending,
    VehicleExchangeStatus.replacementSelected => CaseStatus.replacementSelected,
    VehicleExchangeStatus.offerPresented => CaseStatus.offerPresented,
    VehicleExchangeStatus.accepted || VehicleExchangeStatus.depositPending => CaseStatus.depositPending,
    VehicleExchangeStatus.handoverPending => CaseStatus.handoverPending,
    VehicleExchangeStatus.completed => CaseStatus.completed,
    VehicleExchangeStatus.rejected => CaseStatus.rejected,
    VehicleExchangeStatus.cancelled => CaseStatus.cancelled,
    VehicleExchangeStatus.expired => CaseStatus.expired,
  };

  static CaseOffer _offer(VehicleExchangeOffer offer) => CaseOffer(
    id: offer.id,
    expiresAt: offer.expiresAt,
    quote: _quote(offer.quote),
    hash: offer.offerHash,
    termsTitle: offer.termsTitle,
    termsBody: offer.termsSnapshot,
  );

  static CaseQuote _quote(ExchangeQuoteDto quote) {
    final String scooter = [?quote.vehicleModel, ?quote.vehicleVariant].join(' ').trim();
    return CaseQuote(
      newRent: quote.recurringAmount,
      rentAdjustment: quote.rentAdjustment,
      depositMoved: quote.depositTransfer,
      depositToPay: quote.depositAdditional,
      depositExcess: quote.depositExcess,
      refundsExcess: quote.refundsExcess,
      fee: quote.exchangeFee,
      feeWaived: quote.feeWaived,
      period: quote.rentalPeriod,
      scooterName: scooter.isEmpty ? null : scooter,
      newRentFrom: quote.billingStartAt,
    );
  }
}
