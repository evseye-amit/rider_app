import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/accept_pdi.dart';

enum PdiStatus { ready, submitting, submitted, failure }

class PdiState extends Equatable {
  const PdiState({
    required this.items,
    this.status = PdiStatus.ready,
    this.verdicts = const {},
    this.notes = const {},
    this.message,
  });

  final List<PdiChecklistItem> items;
  final PdiStatus status;
  final Map<String, CheckState> verdicts;
  final Map<String, String> notes;
  final String? message;

  int get total => items.length;
  int get checked => verdicts.values.where((v) => v != CheckState.pending).length;
  bool get allChecked => total > 0 && checked == total;
  bool get anyFailed => verdicts.values.any((v) => v == CheckState.fail);
  bool get isSubmitting => status == PdiStatus.submitting;

  CheckState verdictOf(String code) => verdicts[code] ?? CheckState.pending;

  List<PdiItemResponse> get responses => [
        for (final item in items)
          PdiItemResponse(
            code: item.code,
            accepted: verdictOf(item.code) == CheckState.pass,
            remarksText: notes[item.code],
          ),
      ];

  PdiState copyWith({
    PdiStatus? status,
    Map<String, CheckState>? verdicts,
    Map<String, String>? notes,
    String? message,
  }) =>
      PdiState(
        items: items,
        status: status ?? this.status,
        verdicts: verdicts ?? this.verdicts,
        notes: notes ?? this.notes,
        message: message,
      );

  @override
  List<Object?> get props => [items, status, verdicts, notes, message];
}

class PdiCubit extends Cubit<PdiState> {
  PdiCubit({required List<PdiChecklistItem> items, required AcceptPdi acceptPdi, required String allocationId})
      : _acceptPdi = acceptPdi,
        _allocationId = allocationId,
        super(PdiState(items: items));

  final AcceptPdi _acceptPdi;
  final String _allocationId;

  void setVerdict(String code, CheckState verdict) {
    emit(state.copyWith(verdicts: {...state.verdicts, code: verdict}));
  }

  void setNote(String code, String note) {
    emit(state.copyWith(notes: {...state.notes, code: note}));
  }

  Future<bool> submit() async {
    if (!state.allChecked || state.isSubmitting) return false;
    emit(state.copyWith(status: PdiStatus.submitting));
    final Result<DeploymentWorkflow> result =
        await _acceptPdi(AcceptPdiParams(allocationId: _allocationId, items: state.responses));
    return result.fold(
      (failure) {
        emit(state.copyWith(status: PdiStatus.failure, message: failure.message));
        return false;
      },
      (_) {
        emit(state.copyWith(status: PdiStatus.submitted));
        return true;
      },
    );
  }
}
