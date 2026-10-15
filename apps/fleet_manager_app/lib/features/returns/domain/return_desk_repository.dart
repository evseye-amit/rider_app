import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import 'entities/return_case.dart';

abstract interface class ReturnDeskRepository {
  Future<Result<ReturnCasePage>> cases({String? cursor, ReturnState? state});

  Future<Result<ReturnCase>> detail(String id);

  Future<Result<void>> receive(String id, {required String hubId, DateTime? receivedAt, String? backdateReason});

  Future<Result<InspectionSheet>> inspection(String inspectionId);

  Future<Result<InspectionPhoto>> uploadPhoto(String inspectionId, {required String photoType, required File photo});

  Future<Result<void>> completeInspection(String inspectionId, {required bool safeForReuse, String? unsafeReason});

  Future<Result<List<PenaltyPrice>>> prices();

  Future<Result<void>> saveCharges(String id, List<PenaltyLine> lines);

  Future<Result<void>> submitCharges(String id);

  Future<Result<void>> approveCharges(String id);

  Future<Result<void>> overrideRiderApproval(String id, String reason);
}
