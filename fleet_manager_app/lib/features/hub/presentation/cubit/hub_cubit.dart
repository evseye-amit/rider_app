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

  List<String> _hubCodes = const [];

  Future<void> load(String hubCode) => loadAll([hubCode]);

  Future<void> loadAll(List<String> hubCodes) async {
    if (hubCodes.isEmpty) return;
    _hubCodes = hubCodes;
    if (hubCodes.length > 1) return _loadCombined(hubCodes);
    final String hubCode = hubCodes.first;
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

  Future<void> _loadCombined(List<String> hubCodes) async {
    emit(state.copyWith(status: HubStatus.loading));

    final List<Result<HubSummary>> summaries =
        await Future.wait([for (final code in hubCodes) _getSummary(code)]);
    final Result<HubProfile> profile = await _getProfile(hubCodes.first);

    final Result<HubSummary>? failed =
        summaries.where((r) => r.isErr).cast<Result<HubSummary>?>().firstWhere((_) => true, orElse: () => null);
    if (failed != null || profile.isErr) {
      emit(
        state.copyWith(
          status: HubStatus.failure,
          message: failed?.failureOrNull?.message ??
              profile.failureOrNull?.message ??
              'Something went wrong.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: HubStatus.ready,
        summary: HubSummary.combine([for (final r in summaries) r.valueOrNull!]),
        profile: profile.valueOrNull,
      ),
    );
  }

  Future<void> refresh() => loadAll(_hubCodes);
}
