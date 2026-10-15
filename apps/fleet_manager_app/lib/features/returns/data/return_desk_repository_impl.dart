import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/return_case.dart';
import '../domain/return_desk_repository.dart';

typedef _RiderCard = ({String name, String? mobile});

class ReturnDeskRepositoryImpl implements ReturnDeskRepository {
  ReturnDeskRepositoryImpl(this._desk, this._media, this._api);

  final ReturnDeskApi _desk;
  final MediaApi _media;
  final ApiClient _api;
  final Map<String, _RiderCard> _riders = {};

  static const int _bulkLookupAfter = 5;
  static const int _pageSize = 100;

  @override
  Future<Result<ReturnCasePage>> cases({String? cursor, ReturnState? state}) async {
    final Result<RideReturnPage> page = await _desk.list(
      cursor: cursor,
      status: switch (state) {
        ReturnState.requested => RideReturnStatus.requested,
        ReturnState.returned => RideReturnStatus.returned,
        ReturnState.cancelled => RideReturnStatus.cancelled,
        null => null,
      },
    );
    if (page case Err<RideReturnPage>(:final failure)) return Result.err(failure);
    final RideReturnPage value = (page as Ok<RideReturnPage>).value;
    await _lookUp({for (final RideReturnDto dto in value.items) dto.riderId});
    return Result.ok(
      ReturnCasePage(
        items: [for (final RideReturnDto dto in value.items) _case(dto, _riders[dto.riderId])],
        nextCursor: value.nextCursor,
      ),
    );
  }

  @override
  Future<Result<ReturnCase>> detail(String id) async {
    final Result<StaffRideReturnDto> detail = await _desk.detail(id);
    if (detail case Err<StaffRideReturnDto>(:final failure)) return Result.err(failure);
    final StaffRideReturnDto value = (detail as Ok<StaffRideReturnDto>).value;
    final String riderId = value.rideReturn.riderId;
    final _RiderCard? rider = (await _rider(riderId)).valueOrNull ?? _riders[riderId];
    return Result.ok(_case(value.rideReturn, rider, vehicle: value.vehicle, inspection: value.inspection));
  }

  @override
  Future<Result<void>> receive(String id, {required String hubId, DateTime? receivedAt, String? backdateReason}) =>
      _desk.receive(id, hubId: hubId, receivedAt: receivedAt, backdateReason: backdateReason);

  @override
  Future<Result<InspectionSheet>> inspection(String inspectionId) async {
    final (requirements, photos) = await (
      _media.requirements(PhotoEntity.inspection),
      _media.photos(entity: PhotoEntity.inspection, entityId: inspectionId),
    ).wait;
    if (requirements case Err<List<PhotoRequirement>>(:final failure)) return Result.err(failure);
    if (photos case Err<List<RemotePhoto>>(:final failure)) return Result.err(failure);
    return Result.ok(
      InspectionSheet(
        slots: [
          for (final PhotoRequirement requirement in (requirements as Ok<List<PhotoRequirement>>).value)
            InspectionSlot(
              photoType: requirement.photoType,
              label: requirement.title,
              required: requirement.isRequired,
            ),
        ],
        photos: [
          for (final RemotePhoto photo in (photos as Ok<List<RemotePhoto>>).value)
            if (photo.isComplete) InspectionPhoto(id: photo.id, photoType: photo.photoType),
        ],
      ),
    );
  }

  @override
  Future<Result<InspectionPhoto>> uploadPhoto(
    String inspectionId, {
    required String photoType,
    required File photo,
  }) async => (await _media.upload(
    entity: PhotoEntity.inspection,
    entityId: inspectionId,
    photoType: photoType,
    file: photo,
    mimeType: _mimeOf(photo),
  )).map((uploaded) => InspectionPhoto(id: uploaded.id, photoType: uploaded.photoType));

  @override
  Future<Result<void>> completeInspection(String inspectionId, {required bool safeForReuse, String? unsafeReason}) =>
      _desk.completeInspection(inspectionId, safeForReuse: safeForReuse, unsafeReason: unsafeReason);

  @override
  Future<Result<List<PenaltyPrice>>> prices() async => (await _desk.prices()).map(
    (prices) => [
      for (final PenaltyPriceDto price in prices)
        PenaltyPrice(
          id: price.id,
          code: price.code,
          description: price.description,
          amount: price.amount,
          kind: price.category == PenaltyCategory.missingItem ? PenaltyKind.missingItem : PenaltyKind.damage,
        ),
    ],
  );

  @override
  Future<Result<void>> saveCharges(String id, List<PenaltyLine> lines) => _desk.savePenalties(id, [
    for (final PenaltyLine line in lines)
      PenaltyLineInput(priceId: line.priceId, details: line.details, evidencePhotoIds: line.evidencePhotoIds),
  ]);

  @override
  Future<Result<void>> submitCharges(String id) => _desk.submitPenalties(id);

  @override
  Future<Result<void>> approveCharges(String id) => _desk.approvePenalties(id);

  @override
  Future<Result<void>> overrideRiderApproval(String id, String reason) => _desk.overrideRiderApproval(id, reason);

  Future<void> _lookUp(Set<String> riderIds) async {
    final Set<String> missing = {
      for (final String id in riderIds)
        if (id.isNotEmpty && !_riders.containsKey(id)) id,
    };
    if (missing.isEmpty) return;
    if (missing.length > _bulkLookupAfter) {
      final Result<List<Map<String, dynamic>>> all = await _api.get<List<Map<String, dynamic>>>(
        '/riders',
        query: {'pageSize': _pageSize},
        parse: _rows,
      );
      for (final Map<String, dynamic> row in all.valueOrNull ?? const <Map<String, dynamic>>[]) {
        final String id = row['id']?.toString() ?? '';
        if (id.isNotEmpty) _riders[id] = _card(row);
      }
    }
    await Future.wait([
      for (final String id in missing)
        if (!_riders.containsKey(id)) _rider(id),
    ]);
  }

  Future<Result<_RiderCard>> _rider(String id) async {
    if (id.isEmpty) return Result.err(const NotFoundFailure());
    final Result<_RiderCard> result = await _api.get<_RiderCard>(
      '/riders/$id',
      parse: (data) => _card(Map<String, dynamic>.from(data as Map)),
    );
    if (result case Ok<_RiderCard>(:final value)) _riders[id] = value;
    return result;
  }

  static _RiderCard _card(Map<String, dynamic> row) {
    final String mobile = row['mobile']?.toString() ?? '';
    return (name: row['name']?.toString() ?? '—', mobile: mobile.isEmpty ? null : mobile);
  }

  static List<Map<String, dynamic>> _rows(dynamic data) => [
    for (final Object? row in data is Map ? (data['items'] as List<dynamic>? ?? const []) : data as List<dynamic>)
      if (row is Map) Map<String, dynamic>.from(row),
  ];

  static ReturnCase _case(
    RideReturnDto dto,
    _RiderCard? rider, {
    ReturnVehicleDto? vehicle,
    ReturnInspectionDto? inspection,
  }) {
    final PenaltyCaseDto? penalty = dto.penaltyCase;
    return ReturnCase(
      id: dto.id,
      state: switch (dto.status) {
        RideReturnStatus.returned => ReturnState.returned,
        RideReturnStatus.cancelled => ReturnState.cancelled,
        RideReturnStatus.requested || RideReturnStatus.unknown => ReturnState.requested,
      },
      riderName: rider?.name ?? '—',
      riderMobile: rider?.mobile,
      reasonCode: dto.reasonCode,
      notes: dto.reasonText,
      plannedDate: dto.requestedDate,
      createdAt: dto.createdAt,
      plannedHubId: dto.plannedHubId,
      receivedHubId: dto.receivedHubId,
      receivedAt: dto.receivedAt,
      vehicleNumber: vehicle?.number,
      vehicleModel: vehicle?.model,
      inspectionId: inspection?.id,
      inspectionDone: inspection?.isCompleted ?? penalty != null,
      safeForReuse: inspection?.safeForReuse,
      penalty: penalty == null ? null : _penalty(penalty),
    );
  }

  static PenaltyState _penalty(PenaltyCaseDto penalty) => PenaltyState(
    stage: switch (penalty.status) {
      PenaltyCaseStatus.riderApprovalPending => PenaltyStage.awaitingRider,
      PenaltyCaseStatus.managerApprovalPending => PenaltyStage.awaitingManager,
      PenaltyCaseStatus.riderDisputed => PenaltyStage.disputed,
      PenaltyCaseStatus.posted => PenaltyStage.posted,
      PenaltyCaseStatus.draft || PenaltyCaseStatus.unknown => PenaltyStage.draft,
    },
    total: penalty.totalAmount,
    lines: [
      for (final PenaltyItemDto item in penalty.items)
        PenaltyLine(
          priceId: item.priceId,
          details: item.details,
          evidencePhotoIds: item.evidencePhotoIds,
          description: item.description,
          kind: switch (item.category) {
            PenaltyCategory.damage => PenaltyKind.damage,
            PenaltyCategory.missingItem => PenaltyKind.missingItem,
            PenaltyCategory.unknown => null,
          },
          amount: item.amount,
        ),
    ],
    riderApproved: penalty.riderApproved,
    adminOverridden: penalty.adminOverridden,
    managerApproved: penalty.managerApproved,
    disputeReason: penalty.riderDisputeReason,
    overrideReason: penalty.adminOverrideReason,
    submittedAt: penalty.submittedAt,
    postedAt: penalty.postedAt,
  );

  static String _mimeOf(File file) {
    final String name = file.path.toLowerCase();
    if (name.endsWith('.png')) return 'image/png';
    if (name.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
