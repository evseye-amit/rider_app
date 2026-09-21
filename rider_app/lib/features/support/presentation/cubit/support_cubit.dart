import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/support_overview.dart';
import '../../domain/usecases/get_support_overview.dart';

enum SupportStatus { initial, loading, ready, failure }

class SupportState extends Equatable {
  const SupportState({
    this.status = SupportStatus.initial,
    this.overview,
    this.message,
  });

  final SupportStatus status;
  final SupportOverview? overview;
  final String? message;

  bool get isLoading =>
      status == SupportStatus.loading || status == SupportStatus.initial;

  SupportState copyWith({
    SupportStatus? status,
    SupportOverview? overview,
    String? message,
  }) => SupportState(
    status: status ?? this.status,
    overview: overview ?? this.overview,
    message: message,
  );

  @override
  List<Object?> get props => [status, overview, message];
}

class SupportCubit extends Cubit<SupportState> {
  SupportCubit(this._getOverview) : super(const SupportState());

  final GetSupportOverview _getOverview;

  Future<void> load() async {
    emit(state.copyWith(status: SupportStatus.loading));
    final Result<SupportOverview> result = await _getOverview(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: SupportStatus.failure, message: failure.message),
      ),
      (overview) =>
          emit(state.copyWith(status: SupportStatus.ready, overview: overview)),
    );
  }

  Future<void> refresh() => load();
}
