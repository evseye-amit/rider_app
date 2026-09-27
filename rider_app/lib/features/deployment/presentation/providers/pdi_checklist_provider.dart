import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../deployment_dependencies.dart';
import '../../domain/usecases/accept_pdi.dart';
import 'deployment_provider.dart';

enum PdiSubmission { idle, submitting, submitted }

class PdiChecklistState extends Equatable {
  const PdiChecklistState({
    required this.items,
    this.verdicts = const {},
    this.notes = const {},
    this.submission = PdiSubmission.idle,
  });

  final List<PdiChecklistItem> items;
  final Map<String, CheckState> verdicts;
  final Map<String, String> notes;
  final PdiSubmission submission;

  int get total => items.length;

  int get checked => verdicts.values.where((v) => v != CheckState.pending).length;

  int get flagged => verdicts.values.where((v) => v == CheckState.fail).length;

  bool get allChecked => total > 0 && checked == total;

  bool get anyFailed => flagged > 0;

  bool get isSubmitting => submission == PdiSubmission.submitting;

  CheckState verdictOf(String code) => verdicts[code] ?? CheckState.pending;

  List<PdiItemResponse> get responses => [
    for (final PdiChecklistItem item in items)
      PdiItemResponse(
        code: item.code,
        accepted: verdictOf(item.code) == CheckState.pass,
        remarksText: notes[item.code],
      ),
  ];

  PdiChecklistState copyWith({
    Map<String, CheckState>? verdicts,
    Map<String, String>? notes,
    PdiSubmission? submission,
  }) => PdiChecklistState(
    items: items,
    verdicts: verdicts ?? this.verdicts,
    notes: notes ?? this.notes,
    submission: submission ?? this.submission,
  );

  @override
  List<Object?> get props => [items, verdicts, notes, submission];
}

class PdiChecklistNotifier extends Notifier<PdiChecklistState> {
  PdiChecklistNotifier(this._allocationId);

  final String _allocationId;

  @override
  PdiChecklistState build() =>
      PdiChecklistState(items: ref.read(deploymentProvider).value?.workflow?.pdiChecklist ?? const []);

  void setVerdict(String code, CheckState verdict) {
    state = state.copyWith(verdicts: {...state.verdicts, code: verdict});
  }

  void setNote(String code, String note) {
    state = state.copyWith(notes: {...state.notes, code: note});
  }

  Future<Result<DeploymentWorkflow>> submit() async {
    state = state.copyWith(submission: PdiSubmission.submitting);
    final Result<DeploymentWorkflow> result = await ref.read(acceptPdiProvider)(
      AcceptPdiParams(allocationId: _allocationId, items: state.responses),
    );
    if (ref.mounted) {
      state = state.copyWith(submission: result.isOk ? PdiSubmission.submitted : PdiSubmission.idle);
    }
    return result;
  }
}

final pdiChecklistProvider = NotifierProvider.autoDispose.family<PdiChecklistNotifier, PdiChecklistState, String>(
  PdiChecklistNotifier.new,
);
