import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../allocation_dependencies.dart';
import '../../domain/usecases/ask_payment.dart';
import '../../domain/usecases/bypass_pairing.dart';
import '../../domain/usecases/submit_pdi.dart';

class DeploymentDetail extends Equatable {
  const DeploymentDetail({required this.request, this.evidence, this.iotHealth, this.busy = false});

  final DeploymentAllocation request;
  final AllocationEvidence? evidence;
  final IotHealth? iotHealth;
  final bool busy;

  DeploymentStatus get status => request.deploymentStatus;

  DeploymentDetail copyWith({
    DeploymentAllocation? request,
    AllocationEvidence? evidence,
    IotHealth? iotHealth,
    bool? busy,
  }) => DeploymentDetail(
    request: request ?? this.request,
    evidence: evidence ?? this.evidence,
    iotHealth: iotHealth ?? this.iotHealth,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [request.id, status, request.updatedAt, evidence, iotHealth, busy];
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

  Future<Result<void>> bypassPairing(String remarks) => _perform(
    () => ref.read(bypassPairingProvider)(BypassPairingParams(allocationId: _allocationId, remarks: remarks)),
  );

  Future<Result<IotHealth>> refreshIotHealth() async {
    final Result<IotHealth> result = await ref.read(getIotHealthProvider)(_allocationId);
    if (!ref.mounted) return result;
    final DeploymentDetail? current = state.value;
    if (current != null && result is Ok<IotHealth>) {
      state = AsyncData(current.copyWith(iotHealth: result.value));
    }
    return result;
  }

  Future<void> _loadSideData(DeploymentDetail detail) async {
    final DeploymentDetail enriched = switch (detail.status) {
      DeploymentStatus.paymentPaid => detail.copyWith(
        evidence: (await ref.read(getAllocationEvidenceProvider)(_allocationId)).valueOrNull,
      ),
      DeploymentStatus.devicePairingPending => detail.copyWith(
        iotHealth: (await ref.read(getIotHealthProvider)(_allocationId)).valueOrNull,
      ),
      _ => detail,
    };
    if (!ref.mounted || enriched == detail) return;
    final DeploymentDetail? current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(evidence: enriched.evidence, iotHealth: enriched.iotHealth));
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
