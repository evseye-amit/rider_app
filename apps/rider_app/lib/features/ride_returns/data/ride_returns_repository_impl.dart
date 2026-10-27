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

  static RideReturn _return(RideReturnDto dto) {
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
      checkInId: submission?.id,
      checkInConfirmed: submission?.isConfirmed ?? false,
      checksComplete: submission?.mechanicChecksComplete ?? false,
    );
  }
}
