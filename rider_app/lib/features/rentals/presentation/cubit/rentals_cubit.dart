import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/rental.dart';
import '../../domain/usecases/get_rentals_overview.dart';

enum RentalsStatus { initial, loading, ready, failure }

class RentalsState extends Equatable {
  const RentalsState({
    this.status = RentalsStatus.initial,
    this.overview,
    this.message,
  });

  final RentalsStatus status;
  final RentalsOverview? overview;
  final String? message;

  bool get isLoading =>
      status == RentalsStatus.loading || status == RentalsStatus.initial;

  RentalsState copyWith({
    RentalsStatus? status,
    RentalsOverview? overview,
    String? message,
  }) => RentalsState(
    status: status ?? this.status,
    overview: overview ?? this.overview,
    message: message,
  );

  @override
  List<Object?> get props => [status, overview, message];
}

class RentalsCubit extends Cubit<RentalsState> {
  RentalsCubit(this._getRentals) : super(const RentalsState());

  final GetRentalsOverview _getRentals;

  Future<void> load() async {
    emit(state.copyWith(status: RentalsStatus.loading));
    final Result<RentalsOverview> result = await _getRentals(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: RentalsStatus.failure, message: failure.message),
      ),
      (overview) =>
          emit(state.copyWith(status: RentalsStatus.ready, overview: overview)),
    );
  }

  Future<void> refresh() => load();
}
