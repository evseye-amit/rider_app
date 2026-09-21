import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/ask_payment.dart';
import '../../domain/usecases/bypass_pairing.dart';
import '../../domain/usecases/get_allocation_evidence.dart';
import '../../domain/usecases/get_deployment_request.dart';
import '../../domain/usecases/get_iot_health.dart';
import '../../domain/usecases/request_fleet.dart';
import '../../domain/usecases/submit_pdi.dart';
import '../../domain/usecases/verify_payment.dart';

enum DeploymentDetailStatus { initial, loading, ready, failure }

class DeploymentDetailState extends Equatable {
  const DeploymentDetailState({
    this.status = DeploymentDetailStatus.initial,
    this.request,
    this.evidence,
    this.iotHealth,
    this.busy = false,
    this.message,
  });

  final DeploymentDetailStatus status;
  final DeploymentAllocation? request;

  final AllocationEvidence? evidence;

  final IotHealth? iotHealth;

  final bool busy;
  final String? message;

  bool get isLoading => status == DeploymentDetailStatus.loading || status == DeploymentDetailStatus.initial;
  DeploymentStatus get deployment => request?.deploymentStatus ?? DeploymentStatus.unknown;

  DeploymentDetailState copyWith({
    DeploymentDetailStatus? status,
    DeploymentAllocation? request,
    AllocationEvidence? evidence,
    IotHealth? iotHealth,
    bool? busy,
    String? message,
  }) =>
      DeploymentDetailState(
        status: status ?? this.status,
        request: request ?? this.request,
        evidence: evidence ?? this.evidence,
        iotHealth: iotHealth ?? this.iotHealth,
        busy: busy ?? this.busy,
        message: message,
      );

  @override
  List<Object?> get props => [status, request?.id, deployment, request?.updatedAt, evidence, iotHealth, busy, message];
}

class DeploymentDetailCubit extends Cubit<DeploymentDetailState> {
  DeploymentDetailCubit({
    required this.allocationId,
    required GetDeploymentRequest getRequest,
    required GetAllocationEvidence getEvidence,
    required GetIotHealth getIotHealth,
    required RequestFleet requestFleet,
    required AskPayment askPayment,
    required VerifyPayment verifyPayment,
    required SubmitPdi submitPdi,
    required BypassPairing bypassPairing,
    this.pollEvery = const Duration(seconds: 10),
  })  : _getRequest = getRequest,
        _getEvidence = getEvidence,
        _getIotHealth = getIotHealth,
        _requestFleet = requestFleet,
        _askPayment = askPayment,
        _verifyPayment = verifyPayment,
        _submitPdi = submitPdi,
        _bypassPairing = bypassPairing,
        super(const DeploymentDetailState());

  final String allocationId;
  final Duration pollEvery;
  final GetDeploymentRequest _getRequest;
  final GetAllocationEvidence _getEvidence;
  final GetIotHealth _getIotHealth;
  final RequestFleet _requestFleet;
  final AskPayment _askPayment;
  final VerifyPayment _verifyPayment;
  final SubmitPdi _submitPdi;
  final BypassPairing _bypassPairing;
  Timer? _timer;

  Future<void> load({bool silent = false}) async {
    if (!silent) emit(state.copyWith(status: DeploymentDetailStatus.loading));
    final Result<DeploymentAllocation> result = await _getRequest(allocationId);
    if (isClosed) return;
    switch (result) {
      case Err<DeploymentAllocation>(:final failure):
        if (state.request == null) {
          emit(state.copyWith(status: DeploymentDetailStatus.failure, message: failure.message));
        }
      case Ok<DeploymentAllocation>(:final value):
        emit(state.copyWith(status: DeploymentDetailStatus.ready, request: value));
        await _loadSideData(value.deploymentStatus);
    }
  }

  Future<void> _loadSideData(DeploymentStatus status) async {
    if (status == DeploymentStatus.paymentPaid) {
      final Result<AllocationEvidence> evidence = await _getEvidence(allocationId);
      if (isClosed) return;
      if (evidence case Ok<AllocationEvidence>(:final value)) emit(state.copyWith(evidence: value));
    }
    if (status == DeploymentStatus.devicePairingPending) {
      final Result<IotHealth> health = await _getIotHealth(allocationId);
      if (isClosed) return;
      if (health case Ok<IotHealth>(:final value)) emit(state.copyWith(iotHealth: value));
    }
  }

  void startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(pollEvery, (_) {
      if (state.deployment.waitsOnRider) load(silent: true);
    });
  }

  Future<bool> requestFleet() => _act(() => _requestFleet(allocationId));

  Future<bool> askPayment(List<PaymentLineItem> items) =>
      _act(() => _askPayment(AskPaymentParams(allocationId: allocationId, items: items)));

  Future<bool> verifyPayment() => _act(() => _verifyPayment(allocationId));

  Future<bool> submitPdi({required String workPartnerName, required List<PdiChecklistItem> checklist}) => _act(
        () => _submitPdi(SubmitPdiParams(allocationId: allocationId, workPartnerName: workPartnerName, checklist: checklist)),
      );

  Future<bool> bypassPairing(String remarks) =>
      _act(() => _bypassPairing(BypassPairingParams(allocationId: allocationId, remarks: remarks)));

  Future<void> refreshIotHealth() async {
    final Result<IotHealth> health = await _getIotHealth(allocationId);
    if (isClosed) return;
    health.fold(
      (failure) => emit(state.copyWith(message: failure.message)),
      (value) => emit(state.copyWith(iotHealth: value)),
    );
  }

  Future<bool> _act(Future<Result<Object?>> Function() call) async {
    if (state.busy) return false;
    emit(state.copyWith(busy: true));
    final Result<Object?> result = await call();
    if (isClosed) return false;
    switch (result) {
      case Err<Object?>(:final failure):
        emit(state.copyWith(busy: false, message: failure.message));
        return false;
      case Ok<Object?>():
        emit(state.copyWith(busy: false));
        await load(silent: true);
        return true;
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
