import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/support_overview.dart';
import '../../domain/usecases/get_support_overview.dart';
import '../../domain/usecases/raise_ticket.dart';

enum RaiseTicketStatus { loading, ready, submitting, submitted, failure }

class RaiseTicketState extends Equatable {
  const RaiseTicketState({
    this.status = RaiseTicketStatus.loading,
    this.categories = const [],
    this.message,
    this.createdTicketId,
  });

  final RaiseTicketStatus status;
  final List<SupportCategory> categories;
  final String? message;
  final String? createdTicketId;

  RaiseTicketState copyWith({
    RaiseTicketStatus? status,
    List<SupportCategory>? categories,
    String? message,
    String? createdTicketId,
  }) => RaiseTicketState(
    status: status ?? this.status,
    categories: categories ?? this.categories,
    message: message,
    createdTicketId: createdTicketId ?? this.createdTicketId,
  );

  @override
  List<Object?> get props => [status, categories, message, createdTicketId];
}

class RaiseTicketCubit extends Cubit<RaiseTicketState> {
  RaiseTicketCubit(this._getOverview, this._raiseTicket)
    : super(const RaiseTicketState());

  final GetSupportOverview _getOverview;
  final RaiseTicket _raiseTicket;

  Future<void> load() async {
    final Result<SupportOverview> result = await _getOverview(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RaiseTicketStatus.failure,
          message: failure.message,
        ),
      ),
      (overview) => emit(
        state.copyWith(
          status: RaiseTicketStatus.ready,
          categories: overview.categories,
        ),
      ),
    );
  }

  Future<void> submit({
    required String categoryKey,
    required String subject,
    required String description,
    required bool vehicleAffected,
    required int photoCount,
  }) async {
    emit(state.copyWith(status: RaiseTicketStatus.submitting));
    final result = await _raiseTicket(
      RaiseTicketParams(
        categoryKey: categoryKey,
        subject: subject,
        description: description,
        vehicleAffected: vehicleAffected,
        photoCount: photoCount,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RaiseTicketStatus.failure,
          message: failure.message,
        ),
      ),
      (ticket) => emit(
        state.copyWith(
          status: RaiseTicketStatus.submitted,
          createdTicketId: ticket.id,
        ),
      ),
    );
  }
}
