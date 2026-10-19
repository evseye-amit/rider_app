import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

class IssueDraft extends Equatable {
  const IssueDraft({
    required this.key,
    required this.category,
    required this.description,
    required this.status,
    required this.photoIds,
    this.issueId,
    this.requiredParts,
    this.penaltyFindingId,
  });

  factory IssueDraft.fromDto(MaintenanceIssueDto dto) => IssueDraft(
    key: dto.id,
    issueId: dto.id,
    category: dto.category,
    description: dto.description,
    status: dto.status,
    photoIds: dto.evidencePhotoIds,
    requiredParts: dto.requiredParts,
    penaltyFindingId: dto.penaltyFindingId,
  );

  final String key;
  final String? issueId;
  final MaintenanceIssueCategory category;
  final String description;
  final MaintenanceIssueStatus status;
  final List<String> photoIds;
  final String? requiredParts;
  final String? penaltyFindingId;

  bool get isSaved => issueId != null;

  bool get waitsForParts => !status.isResolved && requiredParts != null;

  MaintenanceIssueInput toInput() => MaintenanceIssueInput(
    issueId: issueId,
    category: category,
    description: description,
    status: status,
    evidencePhotoIds: photoIds,
    requiredParts: requiredParts,
    penaltyFindingId: penaltyFindingId,
  );

  @override
  List<Object?> get props => [key, issueId, category, description, status, photoIds, requiredParts, penaltyFindingId];
}
