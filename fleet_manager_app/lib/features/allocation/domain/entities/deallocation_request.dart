import 'package:equatable/equatable.dart';

class DeallocationRequest extends Equatable {
  const DeallocationRequest({
    required this.id,
    required this.riderName,
    required this.riderCode,
    required this.mobile,
    required this.vehicleNumber,
    required this.model,
    required this.reason,
    required this.raisedOn,
    required this.teamLead,
    required this.priority,
    this.allocationStatus = 'DEALLOCATION_INITIATED',
    this.postReturnInspectionId,
  });

  final String id;
  final String riderName;
  final String riderCode;
  final String mobile;
  final String vehicleNumber;
  final String model;
  final String reason;
  final DateTime raisedOn;
  final String teamLead;

  final String priority;

  final String allocationStatus;

  final String? postReturnInspectionId;

  bool get isInitiated => allocationStatus == 'DEALLOCATION_INITIATED';

  @override
  List<Object?> get props => [
        id,
        riderName,
        riderCode,
        mobile,
        vehicleNumber,
        model,
        reason,
        raisedOn,
        teamLead,
        priority,
        allocationStatus,
        postReturnInspectionId,
      ];
}
