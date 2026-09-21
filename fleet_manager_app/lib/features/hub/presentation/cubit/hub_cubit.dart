import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/hub_profile.dart';
import '../../domain/entities/hub_summary.dart';
import '../../domain/usecases/get_hub_profile.dart';
import '../../domain/usecases/get_hub_summary.dart';

enum HubStatus { initial, loading, ready, failure }

class HubState extends Equatable {
  const HubState({
    this.status = HubStatus.initial,
    this.summary,
    this.profile,
    this.message,
  });

  final HubStatus status;

  final HubSummary? summary;

  final HubProfile? profile;

  final String? message;

  bool get isLoading => status == HubStatus.loading || status == HubStatus.initial;

  HubState copyWith({
    HubStatus? status,
    HubSummary? summary,
    HubProfile? profile,
    String? message,
  }) =>
      HubState(
        status: status ?? this.status,
        summary: summary ?? this.summary,
        profile: profile ?? this.profile,
        message: message,
      );

  @override
  List<Object?> get props => [status, summary, profile, message];
}

class HubCubit extends Cubit<HubState> {
  HubCubit(this._getSummary, this._getProfile) : super(const HubState());

  final GetHubSummary _getSummary;
  final GetHubProfile _getProfile;

  String _hubCode = '';

  Future<void> load(String hubCode) async {
    _hubCode = hubCode;
    emit(state.copyWith(status: HubStatus.loading));

    final List<Object> results =
        await Future.wait([_getSummary(hubCode), _getProfile(hubCode)]);
    final Result<HubSummary> summary = results[0] as Result<HubSummary>;
    final Result<HubProfile> profile = results[1] as Result<HubProfile>;

    if (summary.isErr || profile.isErr) {
      emit(
        state.copyWith(
          status: HubStatus.failure,
          message: summary.failureOrNull?.message ??
              profile.failureOrNull?.message ??
              'Something went wrong.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: HubStatus.ready,
        summary: summary.valueOrNull,
        profile: profile.valueOrNull,
      ),
    );
  }

  Future<void> refresh() => load(_hubCode);
}
