import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_controller.dart';

enum DeploymentLoad { initial, loading, ready, failure }

class DeploymentState extends Equatable {
  const DeploymentState({this.status = DeploymentLoad.initial, this.deployment, this.message});

  final DeploymentLoad status;
  final RiderDeployment? deployment;
  final String? message;

  bool get isLoading => status == DeploymentLoad.loading || status == DeploymentLoad.initial;

  DeploymentState copyWith({DeploymentLoad? status, RiderDeployment? deployment, String? message}) => DeploymentState(
        status: status ?? this.status,
        deployment: deployment ?? this.deployment,
        message: message,
      );

  @override
  List<Object?> get props => [
        status,
        deployment?.screen,
        deployment?.status,
        deployment?.allocation?.id,
        deployment?.allocation?.updatedAt,
        deployment?.payment?.status,
        deployment?.payment?.submittedAt,
        message,
      ];
}

class DeploymentCubit extends Cubit<DeploymentState> {
  DeploymentCubit(this._session, {this.pollEvery = const Duration(seconds: 10)})
      : super(DeploymentState(deployment: _session.deployment, status: _session.deployment == null ? DeploymentLoad.initial : DeploymentLoad.ready));

  final SessionController _session;
  final Duration pollEvery;
  Timer? _timer;

  Future<void> load({bool silent = false}) async {
    if (!silent) emit(state.copyWith(status: DeploymentLoad.loading));
    final Result<RiderDeployment> result = await _session.refreshState();
    if (isClosed) return;
    switch (result) {
      case Ok<RiderDeployment>(:final value):
        emit(state.copyWith(status: DeploymentLoad.ready, deployment: value));
      case Err<RiderDeployment>(:final failure):

        if (state.deployment == null) {
          emit(state.copyWith(status: DeploymentLoad.failure, message: failure.message));
        } else if (!silent) {
          emit(state.copyWith(status: DeploymentLoad.ready, message: failure.message));
        }
    }
  }

  void startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(pollEvery, (_) => load(silent: true));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
