import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import '../domain/allocation_repository.dart';
import '../domain/entities/active_allocation.dart';
import '../domain/entities/allocation_board.dart';
import '../domain/entities/payment_review.dart';

class AllocationRepositoryImpl implements AllocationRepository {
  const AllocationRepositoryImpl(this._api, this._deployments, this._media, this._submissions, this._commercial);

  final ApiClient _api;
  final DeploymentApi _deployments;
  final MediaApi _media;
  final VehicleSubmissionApi _submissions;
  final CommercialApi _commercial;

  static const int _maxPageSize = 100;

  @override
  Future<Result<AllocationBoard>> getBoard() async {
    final List<Result<dynamic>> results = await Future.wait<Result<dynamic>>([
      _deployments.pendingRiders(),
      _deployments.requests(),
      _api.get<List<Map<String, dynamic>>>('/allocations', query: {'pageSize': _maxPageSize}, parse: _rows),
    ]);
    for (final r in results) {
      if (r case Err<dynamic>(:final failure)) return Result.err(failure);
    }
    final List<Map<String, dynamic>> allocations = (results[2] as Ok<List<Map<String, dynamic>>>).value;
    return Result.ok(
      AllocationBoard(
        pending: (results[0] as Ok<List<PendingRider>>).value,
        inProgress: (results[1] as Ok<List<DeploymentAllocation>>).value
          ..sort((a, b) => (b.updatedAt ?? DateTime(0)).compareTo(a.updatedAt ?? DateTime(0))),
        active: allocations.where((r) => r['status'] == 'ACTIVE').map(_activeFrom).toList(growable: false),
      ),
    );
  }

  @override
  Future<Result<PendingRider>> getPendingRider(String riderId) async {
    final Result<List<PendingRider>> result = await _deployments.pendingRiders();
    return result.fold(Result<PendingRider>.err, (riders) {
      for (final r in riders) {
        if (r.id == riderId) return Result.ok(r);
      }
      return Result.err(NotFoundFailure(ActiveLocale.strings.allocationRiderNoLongerWaitingVehicle));
    });
  }

  @override
  Future<Result<List<EligibleFleet>>> getEligibleFleets() => _deployments.eligibleFleets();

  @override
  Future<Result<DeploymentAllocation>> allocate({required String riderId, required String fleetId}) =>
      _deployments.allocate(riderId: riderId, fleetId: fleetId);

  @override
  Future<Result<List<TeamLeadOption>>> getTeamLeads({String? search}) => _deployments.teamLeads(search: search);

  @override
  Future<Result<AllocationTeamLead>> getTeamLead(String allocationId) => _deployments.allocationTeamLead(allocationId);

  @override
  Future<Result<AllocationTeamLead>> assignTeamLead(String allocationId, String teamLeaderId) =>
      _deployments.assignTeamLead(allocationId, teamLeaderId);

  @override
  Future<Result<DeploymentAllocation>> getRequest(String allocationId) async {
    final Result<List<DeploymentAllocation>> queue = await _deployments.requests();
    if (queue case Ok<List<DeploymentAllocation>>(:final value)) {
      for (final a in value) {
        if (a.id == allocationId) return Result.ok(a);
      }
    }
    return _api.get<DeploymentAllocation>(
      '/allocations/$allocationId',
      parse: (data) => DeploymentAllocation.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  @override
  Future<Result<DeploymentWorkflow>> requestFleet(String allocationId) => _deployments.requestFleet(allocationId);

  @override
  Future<Result<DeploymentPayment>> askPayment(String allocationId) => _deployments.askPayment(allocationId);

  @override
  Future<Result<RentalPlanList>> getPlans(String allocationId, {String? batteryPlanId}) =>
      _commercial.plans(allocationId, batteryPlanId: batteryPlanId);

  @override
  Future<Result<AllocationCommercial>> selectPlan(String allocationId, RentalPlanOption plan) =>
      _commercial.selectPlan(allocationId, plan, idempotencyKey: newIdempotencyKey());

  @override
  Future<Result<AllocationCommercial>> getCommercial(String allocationId) =>
      _commercial.allocationCommercial(allocationId);

  @override
  Future<Result<DeploymentWorkflow>> verifyPayment(String allocationId, {int? expectedVersion}) =>
      _deployments.verifyPayment(allocationId, expectedVersion: expectedVersion);

  @override
  Future<Result<PaymentReview>> paymentReview(String allocationId) async {
    final Result<DeploymentPayment> payment = await _deployments.askPayment(allocationId);
    if (payment case Err<DeploymentPayment>(:final failure)) return Result.err(failure);
    final DeploymentPayment value = payment.getOrThrow();
    final Result<List<DeploymentPaymentReceipt>> receipts = await _deployments.paymentReceipts(value.id);
    return receipts.map((list) => PaymentReview(payment: value, receipts: list));
  }

  @override
  Future<Result<DeploymentPayment>> rejectPayment(
    String allocationId, {
    required String reason,
    required int expectedVersion,
  }) => _deployments.rejectPayment(allocationId, reason: reason, expectedVersion: expectedVersion);

  @override
  Future<Result<String>> paymentReceiptUrl(String paymentId, String photoId) =>
      _deployments.receiptUrl(paymentId, photoId);

  @override
  Future<Result<AllocationEvidence>> getEvidence(String allocationId) => _deployments.evidence(allocationId);

  @override
  Future<Result<RemotePhoto>> uploadEvidencePhoto(
    String inspectionId, {
    required String photoType,
    required File file,
  }) => _media.upload(
    entity: PhotoEntity.inspection,
    entityId: inspectionId,
    photoType: photoType,
    file: file,
    mimeType: _mimeOf(file),
  );

  @override
  Future<Result<String>> photoUrl(String photoId) => _media.downloadUrl(photoId);

  @override
  Future<Result<List<WorkPartnerOption>>> getWorkPartners() => _deployments.workPartners();

  @override
  Future<Result<DeploymentWorkflow>> submitPdi(
    String allocationId, {
    required WorkPartnerOption workPartner,
    required List<PdiChecklistItem> checklist,
  }) => _deployments.submitPdi(
    allocationId,
    workPartnerName: workPartner.name,
    workPartnerId: workPartner.id,
    checklist: checklist,
  );

  @override
  Future<Result<String>> startReturn({required String riderId, required String idempotencyKey, String? hubId}) async {
    final Result<String> created = await _submissions.createStaffReturn(
      riderId: riderId,
      plannedDate: DateTime.now(),
      idempotencyKey: idempotencyKey,
      hubId: hubId,
    );
    return switch (created) {
      Ok<String>(:final value) => _submissions.start(source: SubmissionSource.returns, requestId: value, hubId: hubId),
      Err<String>(:final failure) => Result.err(failure),
    };
  }

  static List<Map<String, dynamic>> _rows(dynamic data) {
    final List<dynamic> raw = data is Map ? (data['items'] as List<dynamic>? ?? const []) : data as List<dynamic>;
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList(growable: false);
  }

  static Map<String, dynamic> _sub(Map<String, dynamic> row, String key) =>
      Map<String, dynamic>.from(row[key] as Map? ?? const {});

  static ActiveAllocation _activeFrom(Map<String, dynamic> row) {
    final Map<String, dynamic> rider = _sub(row, 'rider');
    final Map<String, dynamic> fleet = _sub(row, 'fleet');
    return ActiveAllocation(
      id: row['id']?.toString() ?? '',
      riderId: row['riderId']?.toString() ?? rider['id']?.toString() ?? '',
      hubId: fleet['currentHubId']?.toString(),
      riderName: rider['name']?.toString() ?? '—',
      riderCode: rider['riderCode']?.toString() ?? '',
      mobile: rider['mobile']?.toString() ?? '',
      vehicleNumber: fleet['vehicleNumber']?.toString() ?? '—',
      model: fleet['modelName']?.toString() ?? '',
      allocatedOn:
          DateTime.tryParse(row['allocatedAt']?.toString() ?? '') ??
          DateTime.tryParse(row['createdAt']?.toString() ?? '') ??
          DateTime.now(),

      teamLead: '',
      plan: '',
      batteryPercent: null,
      status: fleet['status'] == 'IN_USE' ? 'riding' : 'idle',
    );
  }

  static String _mimeOf(File file) {
    final String name = file.path.toLowerCase();
    if (name.endsWith('.png')) return 'image/png';
    if (name.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
