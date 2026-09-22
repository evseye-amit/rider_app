import '../utils/result.dart';
import 'api_client.dart';

enum RiderScreen {
  onboarding,
  waiting,
  payment,
  pdi,
  training,
  devicePairing,
  home;

  static RiderScreen parse(String? wire) => switch (wire?.toUpperCase()) {
        'ONBOARDING' => RiderScreen.onboarding,
        'PAYMENT' => RiderScreen.payment,
        'PDI' => RiderScreen.pdi,
        'TRAINING' => RiderScreen.training,
        'DEVICE_PAIRING' => RiderScreen.devicePairing,
        'HOME' => RiderScreen.home,
        _ => RiderScreen.waiting,
      };
}

enum DeploymentStatus {
  riderWaiting('RIDER_WAITING'),
  fleetRequested('FLEET_REQUESTED'),
  paymentPending('PAYMENT_PENDING'),
  paymentPaid('PAYMENT_PAID'),
  pdiPendingRider('PDI_PENDING_RIDER'),
  trainingPending('TRAINING_PENDING'),
  devicePairingPending('DEVICE_PAIRING_PENDING'),
  deployed('DEPLOYED'),
  unknown('');

  const DeploymentStatus(this.wire);

  final String wire;

  static DeploymentStatus parse(String? wire) =>
      DeploymentStatus.values.firstWhere((s) => s.wire == wire?.toUpperCase(), orElse: () => unknown);

  int get step => index;

  bool get isDeployed => this == deployed;

  bool get waitsOnRider => switch (this) {
        paymentPending || pdiPendingRider || trainingPending || devicePairingPending => true,
        _ => false,
      };

  String get label => switch (this) {
        riderWaiting => 'Waiting for vehicle request',
        fleetRequested => 'Vehicle requested',
        paymentPending => 'Payment pending',
        paymentPaid => 'Payment received',
        pdiPendingRider => 'Inspection with rider',
        trainingPending => 'Training in progress',
        devicePairingPending => 'Pairing the IoT device',
        deployed => 'Deployed',
        unknown => 'Unknown',
      };
}

class PdiChecklistItem {
  const PdiChecklistItem({required this.code, required this.label, required this.mandatory});

  factory PdiChecklistItem.fromJson(Map<String, dynamic> json) => PdiChecklistItem(
        code: json['code']?.toString() ?? '',
        label: json['label']?.toString() ?? json['code']?.toString() ?? '',
        mandatory: json['mandatory'] != false,
      );

  final String code;
  final String label;
  final bool mandatory;

  Map<String, dynamic> toJson() => {'code': code, 'label': label, 'mandatory': mandatory};
}

class PdiItemResponse {
  const PdiItemResponse({required this.code, required this.accepted, this.remarksText, this.voiceMediaId});

  final String code;
  final bool accepted;
  final String? remarksText;
  final String? voiceMediaId;

  Map<String, dynamic> toJson() => {
        'code': code,
        'accepted': accepted,
        if (remarksText != null && remarksText!.isNotEmpty) 'remarksText': remarksText,
        if (voiceMediaId != null && voiceMediaId!.isNotEmpty) 'voiceMediaId': voiceMediaId,
      };
}

class DeploymentWorkflow {
  const DeploymentWorkflow({
    required this.id,
    required this.allocationId,
    required this.status,
    required this.pdiChecklist,
    required this.trainingViewedContentCodes,
    this.workPartnerName,
    this.paymentPaidAt,
    this.riderPdiAcceptedAt,
    this.trainingCompletedAt,
    this.pairedAt,
    this.pairingBypassedAt,
    this.pairingBypassReason,
    this.createdAt,
    this.updatedAt,
  });

  factory DeploymentWorkflow.fromJson(Map<String, dynamic> json) => DeploymentWorkflow(
        id: json['id']?.toString() ?? '',
        allocationId: json['allocationId']?.toString() ?? '',
        status: DeploymentStatus.parse(json['status']?.toString()),
        pdiChecklist: (json['pdiChecklist'] as List<dynamic>? ?? const [])
            .whereType<Map>()
            .map((e) => PdiChecklistItem.fromJson(Map<String, dynamic>.from(e)))
            .toList(growable: false),
        trainingViewedContentCodes: (json['trainingViewedContentCodes'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(growable: false),
        workPartnerName: json['workPartnerName']?.toString(),
        paymentPaidAt: _date(json['paymentPaidAt']),
        riderPdiAcceptedAt: _date(json['riderPdiAcceptedAt']),
        trainingCompletedAt: _date(json['trainingCompletedAt']),
        pairedAt: _date(json['pairedAt']),
        pairingBypassedAt: _date(json['pairingBypassedAt']),
        pairingBypassReason: json['pairingBypassReason']?.toString(),
        createdAt: _date(json['createdAt']),
        updatedAt: _date(json['updatedAt']),
      );

  final String id;
  final String allocationId;
  final DeploymentStatus status;

  final List<PdiChecklistItem> pdiChecklist;
  final List<String> trainingViewedContentCodes;
  final String? workPartnerName;
  final DateTime? paymentPaidAt;
  final DateTime? riderPdiAcceptedAt;
  final DateTime? trainingCompletedAt;
  final DateTime? pairedAt;
  final DateTime? pairingBypassedAt;
  final String? pairingBypassReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

class DeploymentFleet {
  const DeploymentFleet({
    required this.id,
    required this.fleetCode,
    required this.vehicleNumber,
    required this.chassisNumber,
    required this.status,
    this.modelName,
    this.colour,
    this.currentHubId,
    this.iotDeviceId,
    this.iotDeviceNumber,
    this.iotLastHeartbeatAt,
    this.odometerKm,
    this.vinNumber,
    this.motorNumber,
    this.controllerNumber,
    this.batteryType,
    this.batterySerial,
    this.homeHubName,
    this.currentHubName,
  });

  factory DeploymentFleet.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? device =
        json['iotDevice'] is Map ? Map<String, dynamic>.from(json['iotDevice'] as Map) : null;
    return DeploymentFleet(
      id: json['id']?.toString() ?? '',
      fleetCode: json['fleetCode']?.toString() ?? '',
      vehicleNumber: json['vehicleNumber']?.toString() ?? '',
      chassisNumber: json['chassisNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      modelName: json['modelName']?.toString(),
      colour: json['colour']?.toString(),
      currentHubId: json['currentHubId']?.toString(),
      iotDeviceId: json['iotDeviceId']?.toString(),
      iotDeviceNumber: device?['deviceNumber']?.toString(),
      iotLastHeartbeatAt: _date(device?['lastHeartbeatAt']),
      odometerKm: _num(json['odometerKm']),
      vinNumber: json['vinNumber']?.toString(),
      motorNumber: json['motorNumber']?.toString(),
      controllerNumber: _first(json['controllerHistory'])?['controller']?['controllerNumber']?.toString(),
      batteryType: _first(json['batteryHistory'])?['battery']?['batteryType']?.toString(),
      batterySerial: _first(json['batteryHistory'])?['battery']?['serialNumber']?.toString(),
      homeHubName: (json['homeHub'] as Map?)?['name']?.toString(),
      currentHubName: (json['currentHub'] as Map?)?['name']?.toString(),
    );
  }

  static Map<String, dynamic>? _first(Object? raw) {
    if (raw is! List || raw.isEmpty) return null;
    final Object? row = raw.first;
    return row is Map ? Map<String, dynamic>.from(row) : null;
  }

  final String id;
  final String fleetCode;
  final String vehicleNumber;
  final String chassisNumber;
  final String status;
  final String? modelName;
  final String? colour;
  final String? currentHubId;
  final String? iotDeviceId;
  final String? iotDeviceNumber;
  final DateTime? iotLastHeartbeatAt;
  final num? odometerKm;
  final String? vinNumber;
  final String? motorNumber;
  final String? controllerNumber;
  final String? batteryType;
  final String? batterySerial;
  final String? homeHubName;
  final String? currentHubName;
}

class DeploymentRider {
  const DeploymentRider({
    required this.id,
    required this.name,
    required this.mobile,
    required this.status,
    this.riderCode,
    this.city,
    this.joiningDate,
    this.teamLeadName,
  });

  factory DeploymentRider.fromJson(Map<String, dynamic> json) => DeploymentRider(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        mobile: json['mobile']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        riderCode: json['riderCode']?.toString(),
        city: json['city']?.toString(),
        joiningDate: _date(json['joiningDate']),
        teamLeadName: _teamLead(json['teamLeaders']),
      );

  static String? _teamLead(Object? raw) {
    if (raw is! List || raw.isEmpty) return null;
    final Object? row = raw.first;
    if (row is! Map) return null;
    final Map? lead = row['teamLeader'] as Map?;
    final Map? user = lead?['user'] as Map?;
    final String? name = user?['name']?.toString();
    return name == null || name.isEmpty ? null : name;
  }

  final String id;
  final String name;
  final String mobile;
  final String status;
  final String? riderCode;
  final String? city;
  final DateTime? joiningDate;
  final String? teamLeadName;
}

class DeploymentAllocation {
  const DeploymentAllocation({
    required this.id,
    required this.fleetId,
    required this.riderId,
    required this.status,
    this.allocatedAt,
    this.createdAt,
    this.updatedAt,
    this.rider,
    this.fleet,
    this.workflow,
  });

  factory DeploymentAllocation.fromJson(Map<String, dynamic> json) => DeploymentAllocation(
        id: json['id']?.toString() ?? '',
        fleetId: json['fleetId']?.toString() ?? '',
        riderId: json['riderId']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        allocatedAt: _date(json['allocatedAt']),
        createdAt: _date(json['createdAt']),
        updatedAt: _date(json['updatedAt']),
        rider: json['rider'] is Map ? DeploymentRider.fromJson(Map<String, dynamic>.from(json['rider'] as Map)) : null,
        fleet: json['fleet'] is Map ? DeploymentFleet.fromJson(Map<String, dynamic>.from(json['fleet'] as Map)) : null,
        workflow: json['mobileDeployment'] is Map
            ? DeploymentWorkflow.fromJson(Map<String, dynamic>.from(json['mobileDeployment'] as Map))
            : null,
      );

  final String id;
  final String fleetId;
  final String riderId;

  final String status;
  final DateTime? allocatedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DeploymentRider? rider;
  final DeploymentFleet? fleet;
  final DeploymentWorkflow? workflow;

  DeploymentStatus get deploymentStatus => workflow?.status ?? DeploymentStatus.unknown;
}

class PaymentLineItem {
  const PaymentLineItem({required this.label, required this.amount});

  factory PaymentLineItem.fromJson(Map<String, dynamic> json) => PaymentLineItem(
        label: json['label']?.toString() ?? '',
        amount: _num(json['amount']) ?? 0,
      );

  final String label;
  final num amount;

  Map<String, dynamic> toJson() => {'label': label, 'amount': amount.toStringAsFixed(2)};
}

class DeploymentPayment {
  const DeploymentPayment({
    required this.id,
    required this.status,
    required this.currency,
    required this.amount,
    required this.items,
    this.provider,
    this.providerReference,
    this.submittedAt,
    this.paidAt,
    this.createdAt,
    this.fleetCode,
    this.vehicleNumber,
  });

  factory DeploymentPayment.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> breakdown =
        json['breakdown'] is Map ? Map<String, dynamic>.from(json['breakdown'] as Map) : const {};
    final Map<String, dynamic>? fleet =
        json['fleet'] is Map ? Map<String, dynamic>.from(json['fleet'] as Map) : null;
    return DeploymentPayment(
      id: json['id']?.toString() ?? '',
      status: (json['status']?.toString() ?? 'PENDING').toUpperCase(),
      currency: json['currency']?.toString() ?? 'INR',
      amount: _num(json['amount']) ?? 0,
      items: (breakdown['items'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((e) => PaymentLineItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(growable: false),
      provider: json['provider']?.toString(),
      providerReference: json['providerReference']?.toString(),
      submittedAt: _date(json['submittedAt']),
      paidAt: _date(json['paidAt']),
      createdAt: _date(json['createdAt']),
      fleetCode: fleet?['fleetCode']?.toString(),
      vehicleNumber: fleet?['vehicleNumber']?.toString(),
    );
  }

  final String id;

  final String status;
  final String currency;
  final num amount;
  final List<PaymentLineItem> items;
  final String? provider;
  final String? providerReference;
  final DateTime? submittedAt;
  final DateTime? paidAt;
  final DateTime? createdAt;
  final String? fleetCode;
  final String? vehicleNumber;

  bool get isPending => status == 'PENDING';
  bool get isSubmitted => status == 'SUBMITTED';
  bool get isPaid => status == 'PAID';
  bool get isOpen => isPending || isSubmitted;
}

class RiderDeployment {
  const RiderDeployment({required this.screen, this.allocation, this.workflow, this.payment});

  factory RiderDeployment.fromJson(Map<String, dynamic> json) => RiderDeployment(
        screen: json.isEmpty
            ? RiderScreen.onboarding
            : RiderScreen.parse(json['screen']?.toString()),
        allocation: json['allocation'] is Map
            ? DeploymentAllocation.fromJson(Map<String, dynamic>.from(json['allocation'] as Map))
            : null,
        workflow: json['workflow'] is Map
            ? DeploymentWorkflow.fromJson(Map<String, dynamic>.from(json['workflow'] as Map))
            : null,
        payment: json['payment'] is Map
            ? DeploymentPayment.fromJson(Map<String, dynamic>.from(json['payment'] as Map))
            : null,
      );

  final RiderScreen screen;
  final DeploymentAllocation? allocation;
  final DeploymentWorkflow? workflow;
  final DeploymentPayment? payment;

  DeploymentStatus get status => workflow?.status ?? DeploymentStatus.unknown;

  String? get riderId => allocation?.riderId;
}

class RiderWallet {
  const RiderWallet({
    required this.currency,
    required this.amountDue,
    required this.payments,
    this.currentPayment,
  });

  factory RiderWallet.fromJson(Map<String, dynamic> json) => RiderWallet(
        currency: json['currency']?.toString() ?? 'INR',
        amountDue: _num(json['amountDue']) ?? 0,
        currentPayment: json['currentPayment'] is Map
            ? DeploymentPayment.fromJson(Map<String, dynamic>.from(json['currentPayment'] as Map))
            : null,
        payments: (json['payments'] as List<dynamic>? ?? const [])
            .whereType<Map>()
            .map((e) => DeploymentPayment.fromJson(Map<String, dynamic>.from(e)))
            .toList(growable: false),
      );

  final String currency;
  final num amountDue;
  final DeploymentPayment? currentPayment;
  final List<DeploymentPayment> payments;

  num get totalPaid => payments.where((p) => p.isPaid).fold<num>(0, (sum, p) => sum + p.amount);
}

class TrainingItem {
  const TrainingItem({
    required this.code,
    required this.title,
    required this.isMandatory,
    required this.displayOrder,
    required this.viewed,
    this.description,
    this.downloadUrl,
  });

  factory TrainingItem.fromJson(Map<String, dynamic> json) => TrainingItem(
        code: json['code']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString(),
        isMandatory: json['isMandatory'] != false,
        displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
        viewed: json['viewed'] == true,
        downloadUrl: json['downloadUrl']?.toString(),
      );

  final String code;
  final String title;
  final String? description;
  final bool isMandatory;
  final int displayOrder;
  final bool viewed;
  final String? downloadUrl;
}

class PendingRider {
  const PendingRider({
    required this.id,
    required this.name,
    required this.mobile,
    this.riderCode,
    this.joiningDate,
    this.createdAt,
  });

  factory PendingRider.fromJson(Map<String, dynamic> json) => PendingRider(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        mobile: json['mobile']?.toString() ?? '',
        riderCode: json['riderCode']?.toString(),
        joiningDate: _date(json['joiningDate']),
        createdAt: _date(json['createdAt']),
      );

  final String id;
  final String name;
  final String mobile;
  final String? riderCode;
  final DateTime? joiningDate;
  final DateTime? createdAt;
}

class EligibleFleet {
  const EligibleFleet({
    required this.id,
    required this.fleetCode,
    required this.vehicleNumber,
    required this.chassisNumber,
    this.hubId,
    this.hubCode,
    this.hubName,
    this.iotDeviceNumber,
    this.iotLastHeartbeatAt,
  });

  factory EligibleFleet.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? hub =
        json['currentHub'] is Map ? Map<String, dynamic>.from(json['currentHub'] as Map) : null;
    final Map<String, dynamic>? device =
        json['iotDevice'] is Map ? Map<String, dynamic>.from(json['iotDevice'] as Map) : null;
    return EligibleFleet(
      id: json['id']?.toString() ?? '',
      fleetCode: json['fleetCode']?.toString() ?? '',
      vehicleNumber: json['vehicleNumber']?.toString() ?? '',
      chassisNumber: json['chassisNumber']?.toString() ?? '',
      hubId: hub?['id']?.toString(),
      hubCode: hub?['code']?.toString(),
      hubName: hub?['name']?.toString(),
      iotDeviceNumber: device?['deviceNumber']?.toString(),
      iotLastHeartbeatAt: _date(device?['lastHeartbeatAt']),
    );
  }

  final String id;
  final String fleetCode;
  final String vehicleNumber;
  final String chassisNumber;
  final String? hubId;
  final String? hubCode;
  final String? hubName;
  final String? iotDeviceNumber;
  final DateTime? iotLastHeartbeatAt;

  bool get hasDevice => iotDeviceNumber != null && iotDeviceNumber!.isNotEmpty;

  bool get heartbeatFresh =>
      iotLastHeartbeatAt != null && DateTime.now().difference(iotLastHeartbeatAt!) <= const Duration(minutes: 15);
}

class IotHealth {
  const IotHealth({
    required this.deploymentStatus,
    required this.deviceNumber,
    required this.heartbeatFresh,
    required this.isOnline,
    required this.simStatus,
    required this.workingCondition,
    this.imei,
    this.model,
    this.provider,
    this.heartbeatAt,
    this.heartbeatAgeSeconds,
    this.simLastFour,
  });

  factory IotHealth.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> device = Map<String, dynamic>.from(json['device'] as Map? ?? const {});
    final Map<String, dynamic> heartbeat = Map<String, dynamic>.from(json['heartbeat'] as Map? ?? const {});
    final Map<String, dynamic> sim = Map<String, dynamic>.from(json['sim'] as Map? ?? const {});
    return IotHealth(
      deploymentStatus: DeploymentStatus.parse(json['deploymentStatus']?.toString()),
      deviceNumber: device['deviceNumber']?.toString() ?? '',
      imei: device['imei']?.toString(),
      model: device['model']?.toString(),
      provider: device['provider']?.toString(),
      heartbeatAt: _date(heartbeat['receivedAt']),
      heartbeatAgeSeconds: (heartbeat['ageSeconds'] as num?)?.toInt(),
      heartbeatFresh: heartbeat['isFresh'] == true,
      isOnline: heartbeat['isOnline'] == true,
      simStatus: sim['status']?.toString() ?? 'UNKNOWN',
      simLastFour: sim['numberLastFour']?.toString(),
      workingCondition: json['workingCondition']?.toString() ?? 'ATTENTION_REQUIRED',
    );
  }

  final DeploymentStatus deploymentStatus;
  final String deviceNumber;
  final String? imei;
  final String? model;
  final String? provider;
  final DateTime? heartbeatAt;
  final int? heartbeatAgeSeconds;
  final bool heartbeatFresh;
  final bool isOnline;

  final String simStatus;
  final String? simLastFour;

  final String workingCondition;

  bool get isHealthy => workingCondition == 'HEALTHY';
}

class AllocationEvidence {
  const AllocationEvidence({
    required this.inspectionId,
    required this.inspectionStatus,
    required this.requiredPhotoTypes,
    required this.completedPhotoTypes,
    required this.missingPhotoTypes,
  });

  factory AllocationEvidence.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> inspection =
        Map<String, dynamic>.from(json['inspection'] as Map? ?? const {});
    final List<Map<String, dynamic>> requirements = (json['requirements'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: false);
    final List<Map<String, dynamic>> photos = (json['photos'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: false);
    return AllocationEvidence(
      inspectionId: inspection['id']?.toString() ?? '',
      inspectionStatus: inspection['status']?.toString() ?? '',
      requiredPhotoTypes: requirements
          .where((r) => r['isRequired'] != false)
          .map((r) => r['photoType']?.toString() ?? '')
          .toList(growable: false),
      completedPhotoTypes: photos
          .where((p) => p['status'] == 'COMPLETE')
          .map((p) => p['photoType']?.toString() ?? '')
          .toList(growable: false),
      missingPhotoTypes: (json['missingPhotoTypes'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(growable: false),
    );
  }

  final String inspectionId;
  final String inspectionStatus;
  final List<String> requiredPhotoTypes;
  final List<String> completedPhotoTypes;
  final List<String> missingPhotoTypes;

  bool get isComplete => missingPhotoTypes.isEmpty;
}

class DeploymentApi {
  const DeploymentApi(this._client);

  final ApiClient _client;

  static const String _base = '/mobile-deployments';

  Future<Result<RiderDeployment>> riderCurrent() => _client.get<RiderDeployment>(
        '$_base/rider/current',
        parse: (data) => RiderDeployment.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<RiderWallet>> riderWallet() => _client.get<RiderWallet>(
        '$_base/rider/wallet',
        parse: (data) => RiderWallet.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<DeploymentPayment>> payment(String allocationId) => _client.get<DeploymentPayment>(
        '$_base/$allocationId/payment',
        parse: (data) => DeploymentPayment.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<DeploymentPayment>> submitPayment(
    String allocationId, {
    required String provider,
    required String providerReference,
  }) =>
      _client.post<DeploymentPayment>(
        '$_base/$allocationId/payment/submit',
        body: {'provider': provider, 'providerReference': providerReference},
        parse: (data) => DeploymentPayment.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<DeploymentWorkflow>> acceptPdi(String allocationId, List<PdiItemResponse> items) =>
      _client.post<DeploymentWorkflow>(
        '$_base/$allocationId/accept-pdi',
        body: {'items': items.map((i) => i.toJson()).toList(growable: false)},
        parse: (data) => DeploymentWorkflow.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<List<TrainingItem>>> training(String allocationId) => _client.get<List<TrainingItem>>(
        '$_base/$allocationId/training',
        parse: (data) => (data as List<dynamic>)
            .whereType<Map>()
            .map((e) => TrainingItem.fromJson(Map<String, dynamic>.from(e)))
            .toList(growable: false),
      );

  Future<Result<DeploymentWorkflow>> markTrainingViewed(String allocationId, String contentCode) =>
      _client.post<DeploymentWorkflow>(
        '$_base/$allocationId/training/viewed',
        body: {'contentCode': contentCode},
        parse: (data) => DeploymentWorkflow.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<DeploymentWorkflow>> completeTraining(String allocationId) => _client.post<DeploymentWorkflow>(
        '$_base/$allocationId/training/complete',
        parse: (data) => DeploymentWorkflow.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<DeploymentWorkflow>> pair(String allocationId, String deviceNumber) =>
      _client.post<DeploymentWorkflow>(
        '$_base/$allocationId/pair',
        body: {'deviceNumber': deviceNumber},
        parse: (data) => DeploymentWorkflow.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<List<PendingRider>>> pendingRiders() => _client.get<List<PendingRider>>(
        '$_base/fleet-manager/pending-riders',
        parse: (data) => (data as List<dynamic>)
            .whereType<Map>()
            .map((e) => PendingRider.fromJson(Map<String, dynamic>.from(e)))
            .toList(growable: false),
      );

  Future<Result<List<EligibleFleet>>> eligibleFleets() => _client.get<List<EligibleFleet>>(
        '$_base/fleet-manager/eligible-fleets',
        parse: (data) => (data as List<dynamic>)
            .whereType<Map>()
            .map((e) => EligibleFleet.fromJson(Map<String, dynamic>.from(e)))
            .toList(growable: false),
      );

  Future<Result<DeploymentAllocation>> allocate({required String riderId, required String fleetId}) =>
      _client.post<DeploymentAllocation>(
        '$_base/fleet-manager/allocate',
        body: {'riderId': riderId, 'fleetId': fleetId},
        parse: (data) => DeploymentAllocation.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<List<DeploymentAllocation>>> requests() => _client.get<List<DeploymentAllocation>>(
        '$_base/fleet-manager/requests',
        parse: (data) => (data as List<dynamic>)
            .whereType<Map>()
            .map((e) => DeploymentAllocation.fromJson(Map<String, dynamic>.from(e)))
            .toList(growable: false),
      );

  Future<Result<DeploymentWorkflow>> requestFleet(String allocationId) => _client.post<DeploymentWorkflow>(
        '$_base/$allocationId/request-fleet',
        parse: (data) => DeploymentWorkflow.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<DeploymentPayment>> askPayment(
    String allocationId, {
    required List<PaymentLineItem> items,
    String currency = 'INR',
  }) =>
      _client.post<DeploymentPayment>(
        '$_base/$allocationId/ask-payment',
        body: {'currency': currency, 'items': items.map((i) => i.toJson()).toList(growable: false)},
        parse: (data) => DeploymentPayment.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<DeploymentWorkflow>> verifyPayment(String allocationId) => _client.post<DeploymentWorkflow>(
        '$_base/$allocationId/payment/verify',
        parse: (data) => DeploymentWorkflow.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<AllocationEvidence>> evidence(String allocationId) => _client.get<AllocationEvidence>(
        '$_base/$allocationId/allocation-evidence',
        parse: (data) => AllocationEvidence.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<DeploymentWorkflow>> submitPdi(
    String allocationId, {
    required String workPartnerName,
    required List<PdiChecklistItem> checklist,
  }) =>
      _client.post<DeploymentWorkflow>(
        '$_base/$allocationId/pdi',
        body: {
          'workPartnerName': workPartnerName,
          'checklist': checklist.map((i) => i.toJson()).toList(growable: false),
        },
        parse: (data) => DeploymentWorkflow.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<IotHealth>> iotHealth(String allocationId) => _client.get<IotHealth>(
        '$_base/$allocationId/iot-health',
        parse: (data) => IotHealth.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<DeploymentWorkflow>> bypassPairing(String allocationId, String remarks) =>
      _client.post<DeploymentWorkflow>(
        '$_base/$allocationId/pair/bypass',
        body: {'remarks': remarks},
        parse: (data) => DeploymentWorkflow.fromJson(Map<String, dynamic>.from(data as Map)),
      );
}

DateTime? _date(Object? raw) => raw == null ? null : DateTime.tryParse(raw.toString())?.toLocal();

num? _num(Object? raw) => switch (raw) {
      null => null,
      final num n => n,
      _ => num.tryParse(raw.toString()),
    };
