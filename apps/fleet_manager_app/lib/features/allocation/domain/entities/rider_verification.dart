import 'package:equatable/equatable.dart';

enum ReviewStatus {
  pending('PENDING'),
  approved('APPROVED'),
  rejected('REJECTED');

  const ReviewStatus(this.wire);

  final String wire;

  static ReviewStatus parse(Object? raw) =>
      ReviewStatus.values.firstWhere((status) => status.wire == raw?.toString(), orElse: () => ReviewStatus.pending);
}

class VerificationRider extends Equatable {
  const VerificationRider({required this.id, required this.name, required this.mobile, this.riderCode, this.userId});

  final String id;
  final String name;
  final String mobile;
  final String? riderCode;
  final String? userId;

  @override
  List<Object?> get props => [id, name, mobile, riderCode, userId];
}

class RiderDocument extends Equatable {
  const RiderDocument({
    required this.id,
    required this.title,
    required this.fieldLabel,
    required this.status,
    this.rejectionReason,
    this.photoId,
    this.mimeType,
    this.uploadedAt,
  });

  final String id;
  final String title;
  final String fieldLabel;
  final ReviewStatus status;
  final String? rejectionReason;
  final String? photoId;
  final String? mimeType;
  final DateTime? uploadedAt;

  bool get isPdf => mimeType == 'application/pdf';

  @override
  List<Object?> get props => [id, title, fieldLabel, status, rejectionReason, photoId, mimeType, uploadedAt];
}

class RiderReference extends Equatable {
  const RiderReference({
    required this.id,
    required this.name,
    required this.mobile,
    required this.relation,
    required this.status,
    this.rejectionReason,
    this.reviewedBy,
  });

  final String id;
  final String name;
  final String mobile;
  final String relation;
  final ReviewStatus status;
  final String? rejectionReason;
  final String? reviewedBy;

  @override
  List<Object?> get props => [id, name, mobile, relation, status, rejectionReason, reviewedBy];
}
