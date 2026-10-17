import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/ride_return.dart';
import '../domain/ride_returns_repository.dart';

class RideReturnsRepositoryImpl implements RideReturnsRepository {
  const RideReturnsRepositoryImpl(this._returns);

  final RideReturnsApi _returns;

  @override
  Future<Result<ReturnPage>> returns({String? cursor}) async => (await _returns.list(cursor: cursor)).map(
    (page) =>
        ReturnPage(returns: [for (final RideReturnDto dto in page.items) _return(dto)], nextCursor: page.nextCursor),
  );

  @override
  Future<Result<RideReturn>> detail(String id) async => (await _returns.detail(id)).map(_return);

  @override
  Future<Result<RideReturn>> request({
    required DateTime date,
    required String idempotencyKey,
    String? reasonCode,
    String? hubId,
    String? notes,
  }) async => (await _returns.request(
    plannedReturnDate: date,
    idempotencyKey: idempotencyKey,
    reasonCode: reasonCode,
    plannedHubId: hubId,
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

  static RideReturn _return(RideReturnDto dto) {
    final PenaltyCaseDto? penalty = dto.penaltyCase;
    final SubmissionSummaryDto? submission = dto.submission;
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
      usesCheckIn: dto.submissionRequired,
      checkInId: submission?.id,
      checkInConfirmed: submission?.isConfirmed ?? false,
      checksComplete: submission?.mechanicChecksComplete ?? false,
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
