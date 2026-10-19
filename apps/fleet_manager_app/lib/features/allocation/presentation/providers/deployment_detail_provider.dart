import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../allocation_dependencies.dart';
import '../../domain/usecases/evidence_photo_usecases.dart';
import '../../domain/usecases/payment_review_usecases.dart';
import '../../domain/usecases/rental_plan_usecases.dart';
import '../../domain/usecases/submit_pdi.dart';
import '../../domain/usecases/team_lead_usecases.dart';
import '../../domain/usecases/verify_payment.dart';

class DeploymentDetail extends Equatable {
  const DeploymentDetail({required this.request, this.evidence, this.commercial, this.teamLead, this.busy = false});

  final DeploymentAllocation request;
  final AllocationEvidence? evidence;
  final AllocationCommercial? commercial;
  final AllocationTeamLead? teamLead;
  final bool busy;

  bool get canChangeTeamLead => const {'INITIATED', 'INSPECTION_PENDING', 'OTP_PENDING'}.contains(request.status);

  DeploymentStatus get status => request.deploymentStatus;

  bool get waitsOnRider => status.waitsOnRider || (commercial?.awaitingRider ?? false);

  DeploymentDetail copyWith({
    DeploymentAllocation? request,
    AllocationEvidence? evidence,
    AllocationCommercial? commercial,
    AllocationTeamLead? teamLead,
    bool? busy,
  }) => DeploymentDetail(
    request: request ?? this.request,
    evidence: evidence ?? this.evidence,
    commercial: commercial ?? this.commercial,
    teamLead: teamLead ?? this.teamLead,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [
    request.id,
    status,
    request.updatedAt,
    evidence,
    commercial,
    teamLead?.teamLead?.id,
    teamLead == null,
    busy,
  ];
}

class DeploymentDetailNotifier extends AsyncNotifier<DeploymentDetail> {
  DeploymentDetailNotifier(this._allocationId);

  static const Duration _pollEvery = Duration(seconds: 10);

  final String _allocationId;

  @override
  Future<DeploymentDetail> build() async {
    final Timer timer = Timer.periodic(_pollEvery, (_) {
      if (state.value?.waitsOnRider ?? false) unawaited(refresh(silent: true));
    });
    ref.onDispose(timer.cancel);

    final DeploymentDetail detail = DeploymentDetail(
      request: (await ref.read(getDeploymentRequestProvider)(_allocationId)).getOrThrow(),
    );
    unawaited(_loadSideData(detail));
    return detail;
  }

  Future<void> refresh({bool silent = false}) async {
    if (!silent && !state.hasValue) state = const AsyncLoading();
    final Result<DeploymentAllocation> result = await ref.read(getDeploymentRequestProvider)(_allocationId);
    if (!ref.mounted) return;
    switch (result) {
      case Ok<DeploymentAllocation>(:final value):
        final DeploymentDetail? current = state.value;
        final DeploymentDetail next = current == null
            ? DeploymentDetail(request: value)
            : current.copyWith(request: value);
        state = AsyncData(next);
        await _loadSideData(next);
      case Err<DeploymentAllocation>(:final failure):
        if (!state.hasValue) state = AsyncError(failure, StackTrace.current);
    }
  }

  Future<Result<void>> requestFleet() => _perform(() => ref.read(requestFleetProvider)(_allocationId));

  Future<Result<void>> askPayment() => _perform(() => ref.read(askPaymentProvider)(_allocationId));

  Future<Result<void>> selectPlan(RentalPlanOption plan) => _perform(
    () => ref.read(selectRentalPlanProvider)(SelectRentalPlanParams(allocationId: _allocationId, plan: plan)),
  );

  Future<Result<void>> verifyPayment({int? expectedVersion}) => _perform(
    () => ref.read(verifyPaymentProvider)(
      VerifyPaymentParams(allocationId: _allocationId, expectedVersion: expectedVersion),
    ),
  );

  Future<Result<void>> rejectPayment({required String reason, required int expectedVersion}) => _perform(
    () => ref.read(rejectPaymentProvider)(
      RejectPaymentParams(allocationId: _allocationId, reason: reason, expectedVersion: expectedVersion),
    ),
  );

  Future<Result<void>> assignTeamLead(TeamLeadOption lead) => _perform(
    () => ref.read(assignTeamLeadProvider)(AssignTeamLeadParams(allocationId: _allocationId, teamLeaderId: lead.id)),
  );

  Future<Result<void>> submitPdi({required WorkPartnerOption workPartner, required List<PdiChecklistItem> checklist}) =>
      _perform(
        () => ref.read(submitPdiProvider)(
          SubmitPdiParams(allocationId: _allocationId, workPartner: workPartner, checklist: checklist),
        ),
      );

  Future<Result<void>> uploadEvidencePhoto(String photoType, File file) async {
    final String inspectionId = state.value?.evidence?.inspectionId ?? '';
    if (inspectionId.isEmpty) return const Result.err(NotFoundFailure());
    final Result<RemotePhoto> result = await ref.read(uploadEvidencePhotoProvider)(
      EvidencePhotoParams(inspectionId: inspectionId, photoType: photoType, file: file),
    );
    if (!ref.mounted) return const Result.err(ServerFailure());
    if (result case Err<RemotePhoto>(:final failure)) return Result.err(failure);
    final DeploymentDetail? current = state.value;
    if (current != null) await _loadSideData(current);
    return const Result.ok(null);
  }

  Future<void> _loadSideData(DeploymentDetail detail) async {
    final Future<Result<AllocationTeamLead>> teamLead = ref.read(getAllocationTeamLeadProvider)(_allocationId);
    Result<AllocationEvidence>? evidence;
    Result<AllocationCommercial>? commercial;
    if (detail.status.beforeInspection) {
      (evidence, commercial) = await (
        ref.read(getAllocationEvidenceProvider)(_allocationId),
        ref.read(getAllocationCommercialProvider)(_allocationId),
      ).wait;
    }
    final Result<AllocationTeamLead> lead = await teamLead;
    if (!ref.mounted) return;
    final DeploymentDetail? current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        evidence: evidence?.valueOrNull,
        commercial: commercial?.valueOrNull,
        teamLead: lead.valueOrNull,
      ),
    );
  }

  Future<Result<void>> _perform(Future<Result<Object?>> Function() action) async {
    final DeploymentDetail? current = state.value;
    if (current == null) return const Result.err(NotFoundFailure());
    if (current.busy) return const Result.err(RateLimitFailure());

    state = AsyncData(current.copyWith(busy: true));
    final Result<Object?> result = await action();
    if (!ref.mounted) return const Result.err(ServerFailure());
    state = AsyncData(state.value!.copyWith(busy: false));

    switch (result) {
      case Err<Object?>(:final failure):
        return Result.err(failure);
      case Ok<Object?>():
        await refresh(silent: true);
        return const Result.ok(null);
    }
  }
}

final deploymentDetailProvider = AsyncNotifierProvider.autoDispose
    .family<DeploymentDetailNotifier, DeploymentDetail, String>(DeploymentDetailNotifier.new);
