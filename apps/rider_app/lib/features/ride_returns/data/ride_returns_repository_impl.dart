import 'package:evseye_core/evseye_core.dart';

import '../../../core/location/geo_point.dart';
import '../domain/entities/ride_return.dart';
import '../domain/ride_returns_repository.dart';

class RideReturnsRepositoryImpl implements RideReturnsRepository {
  const RideReturnsRepositoryImpl(this._returns, this._agreements, this._hubs);

  final RideReturnsApi _returns;
  final RentalAgreementsApi _agreements;
  final RiderHubsApi _hubs;

  static const Set<String> _returnable = {'ACTIVE', 'SUSPENDED', 'TERMINATION_PENDING'};

  @override
  Future<Result<ReturnPage>> returns({String? cursor}) async => (await _returns.list(cursor: cursor)).map(
    (page) =>
        ReturnPage(returns: [for (final RideReturnDto dto in page.items) _return(dto)], nextCursor: page.nextCursor),
  );

  @override
  Future<Result<RideReturn>> detail(String id) async => (await _returns.detail(id)).map(_return);

  @override
  Future<Result<List<ReturnablePlan>>> returnablePlans() async {
    final (agreements, returns) = await (_agreements.list(), _returns.list()).wait;
    if (agreements case Err<List<RentalAgreementDto>>(:final failure)) return Result.err(failure);
    final Set<String> taken = {
      for (final RideReturnDto dto in returns.valueOrNull?.items ?? const <RideReturnDto>[])
        if (dto.status == RideReturnStatus.requested) dto.agreementId,
    };
    return Result.ok([
      for (final RentalAgreementDto agreement in (agreements as Ok<List<RentalAgreementDto>>).value)
        if (_returnable.contains(agreement.status) && !taken.contains(agreement.id))
          ReturnablePlan(
            agreementId: agreement.id,
            number: agreement.agreementNumber,
            scooterName: _scooterName(agreement),
          ),
    ]);
  }

  @override
  Future<Result<List<ReturnHub>>> hubs(GeoPoint origin) async =>
      (await _hubs.nearby(latitude: origin.latitude, longitude: origin.longitude)).map(
        (hubs) => [
          for (final NearbyHubDto hub in hubs)
            ReturnHub(
              id: hub.id,
              name: hub.name,
              address: hub.address,
              distanceMeters: hub.roadMeters ?? hub.straightLineMeters,
              etaMinutes: hub.etaMinutes,
            ),
        ],
      );

  @override
  Future<Result<RideReturn>> request({
    required String agreementId,
    required String reasonCode,
    required String hubId,
    required DateTime date,
    required String idempotencyKey,
    String? notes,
  }) async => (await _returns.request(
    agreementId: agreementId,
    reasonCode: reasonCode,
    plannedHubId: hubId,
    plannedReturnDate: date,
    idempotencyKey: idempotencyKey,
    notes: notes,
  )).map(_return);

  @override
  Future<Result<void>> cancel(String id) => _returns.cancel(id);

  @override
  Future<Result<ApprovalCode>> requestApprovalCode(String id) async => (await _returns.requestPenaltyOtp(
    id,
  )).map((challenge) => ApprovalCode(requestId: challenge.otpRequestId, expiresAt: challenge.expiresAt));

  @override
  Future<Result<void>> approveCharges(String id, {required String requestId, required String code}) async {
    final Result<void> result = await _returns.verifyPenaltyOtp(id, otpRequestId: requestId, code: code);
    if (result case Err<void>(failure: UnauthorizedFailure(:final message))) {
      final String text = message.toLowerCase();
      final String reason = text.contains('expired')
          ? ActiveLocale.strings.returnsCodeExpired
          : text.contains('no longer current')
          ? ActiveLocale.strings.returnsErrorStateChanged
          : ActiveLocale.strings.returnsCodeInvalid;
      return Result.err(ValidationFailure(reason));
    }
    return result;
  }

  @override
  Future<Result<void>> disputeCharges(String id, String reason) => _returns.dispute(id, reason);

  static String? _scooterName(RentalAgreementDto agreement) {
    final String name = [?agreement.vehicleModel, ?agreement.vehicleVariant].join(' ').trim();
    return name.isEmpty ? null : name;
  }

  static RideReturn _return(RideReturnDto dto) {
    final PenaltyCaseDto? penalty = dto.penaltyCase;
    return RideReturn(
      id: dto.id,
      status: switch (dto.status) {
        RideReturnStatus.returned => ReturnStatus.returned,
        RideReturnStatus.cancelled => ReturnStatus.cancelled,
        RideReturnStatus.requested || RideReturnStatus.unknown => ReturnStatus.requested,
      },
      reasonCode: dto.reasonCode,
      plannedDate: dto.requestedDate,
      createdAt: dto.createdAt,
      notes: dto.reasonText,
      receivedAt: dto.receivedAt,
      cancelledAt: dto.cancelledAt,
      charges: penalty == null ? null : _charges(penalty),
    );
  }

  static ReturnCharges _charges(PenaltyCaseDto penalty) {
    final ChargesStage stage = switch (penalty.status) {
      PenaltyCaseStatus.riderApprovalPending => ChargesStage.awaitingYou,
      PenaltyCaseStatus.managerApprovalPending => ChargesStage.awaitingManager,
      PenaltyCaseStatus.riderDisputed => ChargesStage.disputed,
      PenaltyCaseStatus.posted => ChargesStage.settled,
      PenaltyCaseStatus.draft || PenaltyCaseStatus.unknown => ChargesStage.reviewing,
    };
    return ReturnCharges(
      stage: stage,
      total: penalty.totalAmount,
      items: stage == ChargesStage.reviewing
          ? const []
          : [
              for (final PenaltyItemDto item in penalty.items)
                ReturnCharge(
                  description: item.description ?? item.priceCode ?? '—',
                  details: item.details,
                  kind: switch (item.category) {
                    PenaltyCategory.damage => ChargeKind.damage,
                    PenaltyCategory.missingItem => ChargeKind.missingItem,
                    PenaltyCategory.unknown => ChargeKind.other,
                  },
                  evidenceCount: item.evidencePhotoIds.length,
                  amount: item.amount,
                ),
            ],
      approvedByYou: penalty.riderApproved,
      approvedByAdmin: penalty.adminOverridden,
      submittedAt: penalty.submittedAt,
      approvedAt: penalty.riderApprovedAt,
      disputeReason: penalty.riderDisputeReason,
      disputedAt: penalty.riderDisputedAt,
      postedAt: penalty.postedAt,
    );
  }
}
