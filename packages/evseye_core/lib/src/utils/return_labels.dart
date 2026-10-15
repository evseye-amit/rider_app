import '../l10n/l10n.dart';

enum ReturnReason {
  noLongerNeeded('NO_LONGER_NEEDED'),
  relocating('RELOCATING'),
  changingJob('CHANGING_JOB'),
  takingBreak('TAKING_A_BREAK'),
  lowEarnings('LOW_EARNINGS'),
  tooExpensive('TOO_EXPENSIVE'),
  vehicleIssues('VEHICLE_ISSUES'),
  batteryIssues('BATTERY_ISSUES'),
  serviceIssues('SERVICE_ISSUES'),
  ownVehicle('OWN_VEHICLE'),
  healthOrFamily('HEALTH_OR_FAMILY'),
  other('OTHER');

  const ReturnReason(this.wire);

  final String wire;

  static ReturnReason? parse(String code) => ReturnReason.values.where((reason) => reason.wire == code).firstOrNull;
}

String returnReasonLabel(AppL10n l10n, String code) => switch (ReturnReason.parse(code)) {
  ReturnReason.noLongerNeeded => l10n.returnsReasonNoLongerNeeded,
  ReturnReason.relocating => l10n.returnsReasonRelocating,
  ReturnReason.changingJob => l10n.returnsReasonChangingJob,
  ReturnReason.takingBreak => l10n.returnsReasonTakingBreak,
  ReturnReason.lowEarnings => l10n.returnsReasonLowEarnings,
  ReturnReason.tooExpensive => l10n.returnsReasonTooExpensive,
  ReturnReason.vehicleIssues => l10n.returnsReasonVehicleIssues,
  ReturnReason.batteryIssues => l10n.returnsReasonBatteryIssues,
  ReturnReason.serviceIssues => l10n.returnsReasonServiceIssues,
  ReturnReason.ownVehicle => l10n.returnsReasonOwnVehicle,
  ReturnReason.healthOrFamily => l10n.returnsReasonHealthOrFamily,
  ReturnReason.other => l10n.commonOther,
  null => _humanize(code),
};

String _humanize(String code) {
  final String spaced = code.replaceAll('_', ' ').trim().toLowerCase();
  if (spaced.isEmpty) return '—';
  return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
