import '../api/vehicle_submission_api.dart';
import '../l10n/l10n.dart';

const List<String> vehicleSidePhotoTypes = ['VEHICLE_FRONT', 'VEHICLE_REAR', 'VEHICLE_LEFT', 'VEHICLE_RIGHT'];

const String returnChecklistPhotoType = 'RETURN_CHECKLIST';

const String damagePhotoPrefix = 'DAMAGE_';

String submissionPhotoLabel(AppL10n l10n, String photoType, [SubmissionAssets assets = const SubmissionAssets()]) {
  switch (photoType) {
    case 'VEHICLE_FRONT':
      return l10n.allocationPhotoFront;
    case 'VEHICLE_REAR':
      return l10n.allocationPhotoBack;
    case 'VEHICLE_LEFT':
      return l10n.allocationPhotoLeft;
    case 'VEHICLE_RIGHT':
      return l10n.allocationPhotoRight;
    case returnChecklistPhotoType:
      return l10n.submissionPhotoChecklist;
    case 'BATTERY':
      return l10n.submissionPhotoBatteryGeneric;
    case 'CONTROLLER':
      return l10n.submissionPhotoControllerGeneric;
  }
  if (photoType.startsWith('BATTERY_')) {
    final String id = photoType.substring('BATTERY_'.length);
    final SubmissionBattery? battery = assets.batteries.where((item) => item.id == id).firstOrNull;
    final String? name = battery?.code ?? battery?.serialNumber;
    return name == null ? l10n.submissionPhotoBatteryGeneric : l10n.submissionPhotoBattery(name);
  }
  if (photoType.startsWith('CONTROLLER_')) {
    final String id = photoType.substring('CONTROLLER_'.length);
    final String? number = assets.controllers.where((item) => item.id == id).firstOrNull?.number;
    return number == null ? l10n.submissionPhotoControllerGeneric : l10n.submissionPhotoController(number);
  }
  if (photoType.startsWith('IOT_')) return l10n.submissionPhotoIot;
  if (photoType.startsWith(damagePhotoPrefix)) return l10n.submissionPhotoDamage;
  final String spaced = photoType.replaceAll('_', ' ').toLowerCase().trim();
  return spaced.isEmpty ? photoType : '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
