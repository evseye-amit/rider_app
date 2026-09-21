import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/home_summary.dart';
import '../../domain/usecases/get_home_summary.dart';

enum HomeStatus { initial, loading, ready, failure }

class HomeState extends Equatable {
  const HomeState({this.status = HomeStatus.initial, this.summary, this.message});

  final HomeStatus status;
  final HomeSummary? summary;
  final String? message;

  bool get isLoading => status == HomeStatus.loading || status == HomeStatus.initial;

  HomeState copyWith({HomeStatus? status, HomeSummary? summary, String? message}) => HomeState(
        status: status ?? this.status,
        summary: summary ?? this.summary,
        message: message,
      );

  @override
  List<Object?> get props => [status, summary, message];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getSummary) : super(const HomeState());

  final GetHomeSummary _getSummary;

  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading));
    final Result<HomeSummary> result = await _getSummary(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: HomeStatus.failure, message: failure.message)),
      (summary) => emit(state.copyWith(status: HomeStatus.ready, summary: summary)),
    );
  }

  Future<void> refresh() => load();
}
