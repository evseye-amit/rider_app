import 'package:equatable/equatable.dart';

class RaiseJobInput extends Equatable {
  const RaiseJobInput({
    required this.vehicleNumber,
    required this.model,
    required this.jobType,
    required this.priority,
    required this.issue,
    required this.odometerKm,
    this.vendor,
    this.photoCount = 0,
  });

  final String vehicleNumber;
  final String model;
  final String jobType;

  final String priority;
  final String issue;
  final int odometerKm;
  final String? vendor;
  final int photoCount;

  @override
  List<Object?> get props =>
      [vehicleNumber, model, jobType, priority, issue, odometerKm, vendor, photoCount];
}
