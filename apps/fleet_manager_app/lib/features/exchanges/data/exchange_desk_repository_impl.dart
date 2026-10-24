import 'dart:async';

import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/exchange_case.dart';
import '../domain/exchange_desk_repository.dart';

typedef _RiderRef = ({String name, String? mobile});

class ExchangeDeskRepositoryImpl implements ExchangeDeskRepository {
  const ExchangeDeskRepositoryImpl(this._exchanges, this._submissions, this._deployments, this._api);

  final ExchangeOperationsApi _exchanges;
  final VehicleSubmissionApi _submissions;
  final DeploymentApi _deployments;
  final ApiClient _api;

  static const int _pageSize = 100;

  @override
  Future<Result<List<ExchangeCase>>> cases() async {
    final (list, riderPage, scooterPage) = await (_exchanges.list(), _riderPage(), _scooterPage()).wait;
    switch (list) {
      case Err<List<VehicleExchange>>(:final failure):
        return Result.err(failure);
      case Ok<List<VehicleExchange>>(:final value):
        final Map<String, _RiderRef> riders = {...?riderPage.valueOrNull};
        final Map<String, ScooterOption> scooters = {...?scooterPage.valueOrNull};
        final List<VehicleExchange> open = [...value.where((exchange) => exchange.status.isOpen)];
        final (moreRiders, moreScooters) = await (
          _byId(
            {for (final VehicleExchange exchange in open) ?exchange.riderId}.difference(riders.keys.toSet()),
            _rider,
          ),
          _byId(
            {
              for (final VehicleExchange exchange in open) ...[?exchange.oldVehicleId, ?exchange.replacementVehicleId],
            }.difference(scooters.keys.toSet()),
            _scooter,
          ),
        ).wait;
        riders.addAll(moreRiders);
        scooters.addAll(moreScooters);
        return Result.ok([for (final VehicleExchange exchange in value) _case(exchange, riders, scooters)]);
    }
  }

  @override
  Future<Result<ExchangeCase>> caseDetail(String id) async {
    final Result<VehicleExchange> detail = await _exchanges.details(id);
    if (detail case Err<VehicleExchange>(:final failure)) return Result.err(failure);
    final VehicleExchange exchange = detail.getOrThrow();
    final (riders, scooters) = await (
      _byId({?exchange.riderId}, _rider),
      _byId({?exchange.oldVehicleId, ?exchange.replacementVehicleId}, _scooter),
    ).wait;
    return Result.ok(_case(exchange, riders, scooters));
  }

  @override
  Future<Result<List<ScooterOption>>> availableScooters() async => (await _deployments.eligibleFleets()).map(
    (fleets) => [
      for (final EligibleFleet fleet in fleets)
        ScooterOption(
          id: fleet.id,
          number: fleet.vehicleNumber.isEmpty ? fleet.fleetCode : fleet.vehicleNumber,
          code: fleet.fleetCode.isEmpty ? null : fleet.fleetCode,
          hubId: fleet.hubId,
          hubName: fleet.hubName,
        ),
    ],
  );

  @override
  Future<Result<CaseQuote>> quote(String id) async => (await _exchanges.preview(id)).map(_quote);

  @override
  Future<Result<void>> approve(String id) => _exchanges.approve(id);

  @override
  Future<Result<void>> reject(String id, {required String reason}) => _exchanges.reject(id, reason: reason);

  @override
  Future<Result<String>> startCheckIn(String id, {String? hubId}) =>
      _submissions.start(source: SubmissionSource.exchange, requestId: id, hubId: hubId);

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

  Future<Result<Map<String, _RiderRef>>> _riderPage() => _api.get<Map<String, _RiderRef>>(
    '/riders',
    query: {'pageSize': _pageSize},
    parse: (data) => {for (final Map<String, dynamic> row in _rows(data)) row['id']?.toString() ?? '': _riderOf(row)},
  );

  Future<Result<Map<String, ScooterOption>>> _scooterPage() => _api.get<Map<String, ScooterOption>>(
    '/fleets',
    query: {'pageSize': _pageSize},
    parse: (data) => {for (final Map<String, dynamic> row in _rows(data)) row['id']?.toString() ?? '': _scooterOf(row)},
  );

  Future<Result<_RiderRef>> _rider(String id) =>
      _api.get<_RiderRef>('/riders/$id', parse: (data) => _riderOf(_map(data)));

  Future<Result<ScooterOption>> _scooter(String id) =>
      _api.get<ScooterOption>('/fleets/$id', parse: (data) => _scooterOf(_map(data)));

  static Future<Map<String, T>> _byId<T>(Set<String> ids, Future<Result<T>> Function(String id) load) async {
    final List<(String, Result<T>)> found = await Future.wait([
      for (final String id in ids) load(id).then((result) => (id, result)),
    ]);
    return {
      for (final (String id, Result<T> result) in found)
        if (result case Ok<T>(:final value)) id: value,
    };
  }

  static Map<String, dynamic> _map(dynamic data) =>
      data is Map ? Map<String, dynamic>.from(data) : const <String, dynamic>{};

  static List<Map<String, dynamic>> _rows(dynamic data) => [
    for (final Object? row in data is Map ? (data['items'] as List<dynamic>? ?? const []) : data as List<dynamic>)
      if (row is Map) Map<String, dynamic>.from(row),
  ];

  static _RiderRef _riderOf(Map<String, dynamic> row) {
    final String mobile = row['mobile']?.toString().trim() ?? '';
    return (name: row['name']?.toString() ?? '—', mobile: mobile.isEmpty ? null : mobile);
  }

  static ScooterOption _scooterOf(Map<String, dynamic> row) {
    final Map<String, dynamic> hub = _map(row['currentHub']);
    final String model = [row['modelName'], row['variantName']].nonNulls.join(' ').trim();
    return ScooterOption(
      id: row['id']?.toString() ?? '',
      number: row['vehicleNumber']?.toString() ?? '—',
      model: model.isEmpty ? null : model,
      code: row['fleetCode']?.toString(),
      hubId: row['currentHubId']?.toString() ?? row['homeHubId']?.toString(),
      hubName: hub['name']?.toString(),
    );
  }

  static ExchangeCase _case(
    VehicleExchange exchange,
    Map<String, _RiderRef> riders,
    Map<String, ScooterOption> scooters,
  ) {
    final _RiderRef? rider = riders[exchange.riderId];
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
      checkInRequired: exchange.submissionRequired,
      checkInId: exchange.submission?.id,
      plannedHubId: exchange.plannedHubId,
      plannedDate: exchange.plannedReturnDate,
      reservedUntil: exchange.reservationExpiresAt,
      rentalPeriodType: exchange.rentalPeriodType,
      durationValue: exchange.durationValue,
      durationUnit: exchange.durationUnit,
      batteryPlanId: exchange.batteryPlanId,
      pendingOffer: pending == null ? null : _offer(pending),
      acceptedOffer: accepted == null ? null : _offer(accepted),
      completedAt: exchange.completedAt,
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
