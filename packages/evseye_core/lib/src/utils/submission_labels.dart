import '../l10n/l10n.dart';

const String damagePhotoType = 'DAMAGE';

String submissionPhotoLabel(AppL10n l10n, String photoType) {
  switch (photoType) {
    case 'FRONT':
      return l10n.allocationPhotoFront;
    case 'BACK':
      return l10n.allocationPhotoBack;
    case 'LEFT':
      return l10n.allocationPhotoLeft;
    case 'RIGHT':
      return l10n.allocationPhotoRight;
    case 'OTHER':
      return l10n.submissionPhotoChecklist;
    case damagePhotoType:
      return l10n.submissionPhotoDamage;
  }
  final String spaced = photoType.replaceAll('_', ' ').toLowerCase().trim();
  return spaced.isEmpty ? photoType : '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
