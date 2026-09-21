import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/incentive_scheme.dart';
import '../../domain/usecases/get_incentives_overview.dart';

enum IncentivesStatus { initial, loading, ready, failure }

class IncentivesState extends Equatable {
  const IncentivesState({
    this.status = IncentivesStatus.initial,
    this.overview,
    this.message,
  });

  final IncentivesStatus status;
  final IncentivesOverview? overview;
  final String? message;

  bool get isLoading =>
      status == IncentivesStatus.loading || status == IncentivesStatus.initial;

  IncentivesState copyWith({
    IncentivesStatus? status,
    IncentivesOverview? overview,
    String? message,
  }) => IncentivesState(
    status: status ?? this.status,
    overview: overview ?? this.overview,
    message: message,
  );

  @override
  List<Object?> get props => [status, overview, message];
}

class IncentivesCubit extends Cubit<IncentivesState> {
  IncentivesCubit(this._getIncentives) : super(const IncentivesState());

  final GetIncentivesOverview _getIncentives;

  Future<void> load() async {
    emit(state.copyWith(status: IncentivesStatus.loading));
    final Result<IncentivesOverview> result = await _getIncentives(
      const NoParams(),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: IncentivesStatus.failure,
          message: failure.message,
        ),
      ),
      (overview) => emit(
        state.copyWith(status: IncentivesStatus.ready, overview: overview),
      ),
    );
  }

  Future<void> refresh() => load();
}
