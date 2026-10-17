import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../allocation_dependencies.dart';
import '../../domain/usecases/ask_payment.dart';
import '../../domain/usecases/evidence_photo_usecases.dart';
import '../../domain/usecases/submit_pdi.dart';

class DeploymentDetail extends Equatable {
  const DeploymentDetail({required this.request, this.evidence, this.busy = false});

  final DeploymentAllocation request;
  final AllocationEvidence? evidence;
  final bool busy;

  DeploymentStatus get status => request.deploymentStatus;

  DeploymentDetail copyWith({DeploymentAllocation? request, AllocationEvidence? evidence, bool? busy}) =>
      DeploymentDetail(request: request ?? this.request, evidence: evidence ?? this.evidence, busy: busy ?? this.busy);

  @override
  List<Object?> get props => [request.id, status, request.updatedAt, evidence, busy];
}

class DeploymentDetailNotifier extends AsyncNotifier<DeploymentDetail> {
  DeploymentDetailNotifier(this._allocationId);

  static const Duration _pollEvery = Duration(seconds: 10);

  final String _allocationId;

  @override
  Future<DeploymentDetail> build() async {
    final Timer timer = Timer.periodic(_pollEvery, (_) {
      if (state.value?.status.waitsOnRider ?? false) unawaited(refresh(silent: true));
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

  Future<Result<void>> askPayment(List<PaymentLineItem> items) =>
      _perform(() => ref.read(askPaymentProvider)(AskPaymentParams(allocationId: _allocationId, items: items)));

  Future<Result<void>> verifyPayment() => _perform(() => ref.read(verifyPaymentProvider)(_allocationId));

  Future<Result<void>> submitPdi({required String workPartnerName, required List<PdiChecklistItem> checklist}) =>
      _perform(
        () => ref.read(submitPdiProvider)(
          SubmitPdiParams(allocationId: _allocationId, workPartnerName: workPartnerName, checklist: checklist),
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
    final DeploymentDetail enriched = detail.status.beforeInspection
        ? detail.copyWith(evidence: (await ref.read(getAllocationEvidenceProvider)(_allocationId)).valueOrNull)
        : detail;
    if (!ref.mounted || enriched == detail) return;
    final DeploymentDetail? current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(evidence: enriched.evidence));
    }
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
