import '../l10n/l10n.dart';

enum ReturnReason {
  noLongerNeeded('NO_LONGER_NEEDED'),
  relocating('RELOCATING'),
  changingJob('CHANGING_JOB'),
  vehicleIssues('VEHICLE_ISSUES'),
  tooExpensive('TOO_EXPENSIVE'),
  other('OTHER');

  const ReturnReason(this.wire);

  final String wire;

  static ReturnReason? parse(String code) => ReturnReason.values.where((reason) => reason.wire == code).firstOrNull;
}

String returnReasonLabel(AppL10n l10n, String code) => switch (ReturnReason.parse(code)) {
  ReturnReason.noLongerNeeded => l10n.returnsReasonNoLongerNeeded,
  ReturnReason.relocating => l10n.returnsReasonRelocating,
  ReturnReason.changingJob => l10n.returnsReasonChangingJob,
  ReturnReason.vehicleIssues => l10n.returnsReasonVehicleIssues,
  ReturnReason.tooExpensive => l10n.returnsReasonTooExpensive,
  ReturnReason.other => l10n.commonOther,
  null => _humanize(code),
};

String _humanize(String code) {
  final String spaced = code.replaceAll('_', ' ').trim().toLowerCase();
  if (spaced.isEmpty) return '—';
  return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
