import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/earnings_overview.dart';
import '../../domain/usecases/get_earnings_overview.dart';

enum EarningsStatus { initial, loading, ready, failure }

class EarningsState extends Equatable {
  const EarningsState({
    this.status = EarningsStatus.initial,
    this.overview,
    this.message,
    this.period = EarningsPeriod.daily,
    this.selectedBarIndex,
  });

  final EarningsStatus status;
  final EarningsOverview? overview;
  final String? message;
  final EarningsPeriod period;
  final int? selectedBarIndex;

  bool get isLoading =>
      status == EarningsStatus.loading || status == EarningsStatus.initial;

  List<EarningsBar> get bars => overview?.barsFor(period) ?? const [];

  EarningsBar? get selectedBar {
    final int? i = selectedBarIndex;
    if (i == null || i < 0 || i >= bars.length) {
      return bars.isEmpty ? null : bars.last;
    }
    return bars[i];
  }

  EarningsState copyWith({
    EarningsStatus? status,
    EarningsOverview? overview,
    String? message,
    EarningsPeriod? period,
    int? selectedBarIndex,
    bool clearSelection = false,
  }) => EarningsState(
    status: status ?? this.status,
    overview: overview ?? this.overview,
    message: message,
    period: period ?? this.period,
    selectedBarIndex: clearSelection
        ? null
        : (selectedBarIndex ?? this.selectedBarIndex),
  );

  @override
  List<Object?> get props => [
    status,
    overview,
    message,
    period,
    selectedBarIndex,
  ];
}

class EarningsCubit extends Cubit<EarningsState> {
  EarningsCubit(this._getEarnings) : super(const EarningsState());

  final GetEarningsOverview _getEarnings;

  Future<void> load() async {
    emit(state.copyWith(status: EarningsStatus.loading));
    final Result<EarningsOverview> result = await _getEarnings(
      const NoParams(),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EarningsStatus.failure,
          message: failure.message,
        ),
      ),
      (overview) => emit(
        EarningsState(
          status: EarningsStatus.ready,
          overview: overview,
          period: state.period,
          selectedBarIndex: overview.barsFor(state.period).length - 1,
        ),
      ),
    );
  }

  Future<void> refresh() => load();

  void selectPeriod(EarningsPeriod period) {
    final int lastIndex = (state.overview?.barsFor(period).length ?? 1) - 1;
    emit(
      state.copyWith(period: period, selectedBarIndex: lastIndex.clamp(0, 999)),
    );
  }

  void selectBar(int index) => emit(state.copyWith(selectedBarIndex: index));
}
