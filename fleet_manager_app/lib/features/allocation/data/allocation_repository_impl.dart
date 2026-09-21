import 'package:evseye_core/evseye_core.dart';

import '../domain/allocation_repository.dart';
import '../domain/entities/active_allocation.dart';
import '../domain/entities/allocation_board.dart';
import '../domain/entities/deallocation_request.dart';

class AllocationRepositoryImpl implements AllocationRepository {
  const AllocationRepositoryImpl(this._api, this._deployments);

  final ApiClient _api;
  final DeploymentApi _deployments;

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
        returns: allocations
            .where((r) => r['status'] == 'DEALLOCATION_INITIATED')
            .map(_returnFrom)
            .toList(growable: false),
      ),
    );
  }

  @override
  Future<Result<PendingRider>> getPendingRider(String riderId) async {
    final Result<List<PendingRider>> result = await _deployments.pendingRiders();
    return result.fold(
      Result<PendingRider>.err,
      (riders) {
        for (final r in riders) {
          if (r.id == riderId) return Result.ok(r);
        }
        return const Result.err(NotFoundFailure('This rider is no longer waiting for a vehicle.'));
      },
    );
  }

  @override
  Future<Result<List<EligibleFleet>>> getEligibleFleets() => _deployments.eligibleFleets();

  @override
  Future<Result<DeploymentAllocation>> allocate({required String riderId, required String fleetId}) =>
      _deployments.allocate(riderId: riderId, fleetId: fleetId);

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
  Future<Result<DeploymentPayment>> askPayment(String allocationId, List<PaymentLineItem> items) =>
      _deployments.askPayment(allocationId, items: items);

  @override
  Future<Result<DeploymentWorkflow>> verifyPayment(String allocationId) => _deployments.verifyPayment(allocationId);

  @override
  Future<Result<AllocationEvidence>> getEvidence(String allocationId) => _deployments.evidence(allocationId);

  @override
  Future<Result<DeploymentWorkflow>> submitPdi(
    String allocationId, {
    required String workPartnerName,
    required List<PdiChecklistItem> checklist,
  }) =>
      _deployments.submitPdi(allocationId, workPartnerName: workPartnerName, checklist: checklist);

  @override
  Future<Result<IotHealth>> getIotHealth(String allocationId) => _deployments.iotHealth(allocationId);

  @override
  Future<Result<DeploymentWorkflow>> bypassPairing(String allocationId, String remarks) =>
      _deployments.bypassPairing(allocationId, remarks);

  @override
  Future<Result<DeallocationRequest>> getDeallocationRequest(String allocationId) => _api.get<DeallocationRequest>(
        '/allocations/$allocationId',
        parse: (data) => _returnFrom(Map<String, dynamic>.from(data as Map)),
      );

  @override
  Future<Result<DeallocationStart>> initiateDeallocation(String allocationId) => _api.post<DeallocationStart>(
        '/allocations/$allocationId/deallocation/initiate',
        parse: (data) {
          final Map<String, dynamic> m = Map<String, dynamic>.from(data as Map);
          return DeallocationStart(
            allocationId: m['allocationId']?.toString() ?? allocationId,
            inspectionId: m['inspectionId']?.toString() ?? '',
          );
        },
      );

  @override
  Future<Result<OtpChallenge>> requestDeallocationOtp(
    String allocationId, {
    required String phone,
    required String party,
  }) =>
      _api.post<OtpChallenge>(
        '/allocations/$allocationId/deallocation/otp/request',
        body: {'phone': _e164(phone), 'party': party},
        parse: (data) => OtpChallenge.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  @override
  Future<Result<void>> verifyDeallocationOtp(
    String allocationId, {
    required String otpRequestId,
    required String code,
  }) =>
      _api.post<void>(
        '/allocations/$allocationId/deallocation/otp/verify',
        body: {'otpRequestId': otpRequestId, 'code': code},
        parse: (_) {},
      );

  @override
  Future<Result<void>> completeInspection(String inspectionId) =>
      _api.post<void>('/inspections/$inspectionId/complete', parse: (_) {});

  @override
  Future<Result<void>> completeDeallocation(String allocationId) =>
      _api.post<void>('/allocations/$allocationId/deallocation/complete', parse: (_) {});

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
      riderName: rider['name']?.toString() ?? '—',
      riderCode: rider['riderCode']?.toString() ?? '',
      mobile: rider['mobile']?.toString() ?? '',
      vehicleNumber: fleet['vehicleNumber']?.toString() ?? '—',
      model: fleet['modelName']?.toString() ?? '',
      allocatedOn: DateTime.tryParse(row['allocatedAt']?.toString() ?? '') ??
          DateTime.tryParse(row['createdAt']?.toString() ?? '') ??
          DateTime.now(),

      teamLead: '',
      plan: '',
      batteryPercent: null,
      status: fleet['status'] == 'IN_USE' ? 'riding' : 'idle',
    );
  }

  static DeallocationRequest _returnFrom(Map<String, dynamic> row) {
    final Map<String, dynamic> rider = _sub(row, 'rider');
    final Map<String, dynamic> fleet = _sub(row, 'fleet');
    return DeallocationRequest(
      id: row['id']?.toString() ?? '',
      riderName: rider['name']?.toString() ?? '—',
      riderCode: rider['riderCode']?.toString() ?? '',
      mobile: rider['mobile']?.toString() ?? '',
      vehicleNumber: fleet['vehicleNumber']?.toString() ?? '—',
      model: fleet['modelName']?.toString() ?? '',
      reason: row['status'] == 'ACTIVE' ? 'Active allocation' : 'Return initiated',
      raisedOn: DateTime.tryParse(row['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      teamLead: '',
      priority: 'normal',
      allocationStatus: row['status']?.toString() ?? 'DEALLOCATION_INITIATED',

      postReturnInspectionId: (row['inspections'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .where((i) => i['type'] == 'POST_DEALLOCATION')
          .map((i) => i['id']?.toString())
          .firstOrNull,
    );
  }

  static String _e164(String raw) {
    final String digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) return '+91$digits';
    if (digits.length == 12 && digits.startsWith('91')) return '+$digits';
    return raw.startsWith('+') ? raw : '+$digits';
  }
}
