import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/wallet_summary.dart';
import '../../domain/usecases/get_wallet.dart';

enum WalletStatus { initial, loading, ready, failure }

class WalletState extends Equatable {
  const WalletState({
    this.status = WalletStatus.initial,
    this.summary,
    this.message,
  });

  final WalletStatus status;
  final WalletSummary? summary;
  final String? message;

  bool get isLoading =>
      status == WalletStatus.loading || status == WalletStatus.initial;

  WalletState copyWith({
    WalletStatus? status,
    WalletSummary? summary,
    String? message,
  }) => WalletState(
    status: status ?? this.status,
    summary: summary ?? this.summary,
    message: message,
  );

  @override
  List<Object?> get props => [status, summary, message];
}

class WalletCubit extends Cubit<WalletState> {
  WalletCubit(this._getWallet) : super(const WalletState());

  final GetWallet _getWallet;

  Future<void> load() async {
    emit(state.copyWith(status: WalletStatus.loading));
    final Result<WalletSummary> result = await _getWallet(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: WalletStatus.failure, message: failure.message),
      ),
      (summary) =>
          emit(state.copyWith(status: WalletStatus.ready, summary: summary)),
    );
  }

  Future<void> refresh() => load();
}
