// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppL10nKn extends AppL10n {
  AppL10nKn([String locale = 'kn']) : super(locale);

  @override
  String get allocationAddItem => 'ವಸ್ತು ಸೇರಿಸಿ';

  @override
  String get allocationAddLeastOneItem => 'ಕನಿಷ್ಠ ಒಂದು ವಸ್ತು ಸೇರಿಸಿ';

  @override
  String get allocationAllHubs => 'ಎಲ್ಲಾ ಹಬ್‌ಗಳು';

  @override
  String get allocationAllocateVehicle => 'ವಾಹನ ನೀಡಿ';

  @override
  String get allocationAllocateVehicleWaitingRiderStart => 'ಪ್ರಾರಂಭಿಸಲು ಕಾಯುತ್ತಿರುವ ರೈಡರ್‌ಗೆ ವಾಹನ ನೀಡಿ.';

  @override
  String get allocationAskPayment => 'ಪಾವತಿ ಕೇಳಿ';

  @override
  String get allocationAskPaymentConfirm =>
      'ಮೊತ್ತವನ್ನು ರೈಡರ್ ಒಪ್ಪಿದ ಪ್ಲಾನ್‌ನಿಂದ ಲೆಕ್ಕ ಹಾಕಲಾಗುತ್ತದೆ. ರೈಡರ್‌ಗೆ ಪಾವತಿ ವಿನಂತಿ ಕಳುಹಿಸಬೇಕೆ?';

  @override
  String get allocationAskPaymentExchange =>
      'ಇದು ಎಕ್ಸ್‌ಚೇಂಜ್ ಸ್ಕೂಟರ್. ಇದರ ಪ್ಲಾನ್ ಈಗಾಗಲೇ ಒಪ್ಪಿಗೆಯಾಗಿದೆ, ಆದ್ದರಿಂದ ಈ ಹಸ್ತಾಂತರಕ್ಕೆ ಏನನ್ನೂ ಸಂಗ್ರಹಿಸುವುದಿಲ್ಲ. ಮುಂದುವರಿಯಬೇಕೆ?';

  @override
  String get allocationAssign => 'ನಿಯೋಜಿಸಿ';

  @override
  String get allocationAssignTeamLead => 'ಟೀಮ್ ಲೀಡ್ ನೇಮಿಸಿ';

  @override
  String get allocationAssignVehicle => 'ವಾಹನ ನಿಯೋಜಿಸಿ';

  @override
  String get allocationBack => 'ಹಿಂದೆ';

  @override
  String get allocationBackDesk => 'ಮತ್ತೆ ಡೆಸ್ಕ್‌ಗೆ';

  @override
  String get allocationBackToAllocations => 'ಹಂಚಿಕೆಗಳಿಗೆ ಹಿಂತಿರುಗಿ';

  @override
  String get allocationBatteryChargeCharger => 'ಬ್ಯಾಟರಿ ಚಾರ್ಜ್ ಮತ್ತು ಚಾರ್ಜರ್';

  @override
  String get allocationBodyPaintwork => 'ಬಾಡಿ ಮತ್ತು ಬಣ್ಣದ ಕೆಲಸ';

  @override
  String get allocationCallRider => 'ಕರೆ ಮಾಡಿ';

  @override
  String get allocationChangePlan => 'ಪ್ಲಾನ್ ಬದಲಿಸಿ';

  @override
  String get allocationChangeTeamLead => 'ಟೀಮ್ ಲೀಡ್ ಬದಲಿಸಿ';

  @override
  String get allocationChecklistRiderWillAcceptItem => 'ರೈಡರ್ ಒಂದೊಂದಾಗಿ ಒಪ್ಪಿಕೊಳ್ಳುವ ಪಟ್ಟಿ';

  @override
  String get allocationChecklistTapToggleMandatory => 'ಪಟ್ಟಿ · ಕಡ್ಡಾಯ ಬದಲಾಯಿಸಲು ಒತ್ತಿ';

  @override
  String get allocationChoosePlan => 'ಬಾಡಿಗೆ ಪ್ಲಾನ್ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get allocationChooseTeamLead => 'ಟೀಮ್ ಲೀಡ್ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get allocationChooseWorkPartner => 'ಕೆಲಸದ ಪಾಲುದಾರರನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get allocationComplete2 => 'ಪೂರ್ಣಗೊಂಡಿದೆ.';

  @override
  String get allocationConfirmHaveReceivedAmountRider =>
      'ರೈಡರ್ ಉಲ್ಲೇಖ ನೀಡಿದ ಮೊತ್ತ ನಿಮಗೆ ಸಿಕ್ಕಿದೆ ಎಂದು ಖಚಿತಪಡಿಸಿ. ಇದನ್ನು ಹಿಂದಕ್ಕೆ ಪಡೆಯಲಾಗದು.';

  @override
  String allocationConfirmReceivedAmount(String amount) {
    return 'ರೈಡರ್‌ನಿಂದ $amount ಸ್ವೀಕರಿಸಿದ್ದೀರಿ ಎಂದು ದೃಢೀಕರಿಸಿ.';
  }

  @override
  String get allocationContinueHandover => 'ಹಸ್ತಾಂತರ ಮುಂದುವರಿಸಿ';

  @override
  String get allocationCouldNotAllocateVehicle => 'ವಾಹನ ಹಂಚಿಕೆ ಆಗಲಿಲ್ಲ';

  @override
  String get allocationCouldNotLoadAllocations => 'ಹಂಚಿಕೆಗಳು ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get allocationCouldNotLoadAvailableVehicles => 'ಲಭ್ಯ ವಾಹನಗಳು ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get allocationCouldNotLoadHandover => 'ಈ ಹಸ್ತಾಂತರ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get allocationCouldNotLoadTeamLeads => 'ಟೀಮ್ ಲೀಡ್‌ಗಳು ಲೋಡ್ ಆಗಲಿಲ್ಲ';

  @override
  String get allocationCouldNotLoadWorkPartners => 'ಕೆಲಸದ ಪಾಲುದಾರರು ಲೋಡ್ ಆಗಲಿಲ್ಲ';

  @override
  String get allocationDeAllocateVehicle => 'ವಾಹನ ಹಿಂಪಡೆಯಿರಿ';

  @override
  String get allocationDeployed => 'ನಿಯೋಜಿಸಲಾಗಿದೆ';

  @override
  String allocationDeployedMessage(String vehicle, String rider) {
    return '$vehicle ಈಗ $rider ಅವರೊಂದಿಗೆ ರಸ್ತೆಯಲ್ಲಿದೆ.';
  }

  @override
  String get allocationDeployedTitle => 'ಸ್ಕೂಟರ್ ನಿಯೋಜಿಸಲಾಗಿದೆ!';

  @override
  String get allocationEveryOnboardedRiderHubsHas =>
      'ನಿಮ್ಮ ಹಬ್‌ಗಳ ಪ್ರತಿ ನೋಂದಾಯಿತ ರೈಡರ್‌ಗೂ ವಾಹನವಿದೆ ಅಥವಾ ಹಸ್ತಾಂತರ ನಡೆಯುತ್ತಿದೆ.';

  @override
  String get allocationFleetOnlyBody => 'ಸ್ಕೂಟರ್ ನೀಡುವ ಕೆಲಸ ಹಬ್‌ನ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ಲಾಗಿನ್‌ನಿಂದ ಆಗುತ್ತದೆ.';

  @override
  String get allocationFleetOnlyTitle => 'ಈ ಲಾಗಿನ್‌ಗೆ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get allocationFront => 'ಮುಂಭಾಗ';

  @override
  String get allocationHandoverCompleteMessage =>
      'ತರಬೇತಿ ಮುಗಿದಿದೆ ಮತ್ತು ಸ್ಕೂಟರ್ ರೈಡರ್ ಬಳಿ ಇದೆ. ಈ ಹಸ್ತಾಂತರ ಪೂರ್ಣಗೊಂಡಿದೆ.';

  @override
  String get allocationHandoverHistory => 'ಹಸ್ತಾಂತರ ಇತಿಹಾಸ';

  @override
  String get allocationHelmetHandedOver => 'ಹೆಲ್ಮೆಟ್ ಹಸ್ತಾಂತರಿಸಲಾಗಿದೆ';

  @override
  String get allocationHornMirrors => 'ಹಾರ್ನ್ ಮತ್ತು ಕನ್ನಡಿಗಳು';

  @override
  String get allocationIdle => 'ಖಾಲಿ';

  @override
  String get allocationInspectionAcceptedTraining => 'ಪರಿಶೀಲನೆ ಸ್ವೀಕೃತ · ತರಬೇತಿ';

  @override
  String get allocationInspectionSentRider => 'ಪರಿಶೀಲನೆ ರೈಡರ್‌ಗೆ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get allocationInspectionSentRider2 => 'ಪರಿಶೀಲನೆ ರೈಡರ್‌ಗೆ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get allocationLeftSide => 'ಎಡಭಾಗ';

  @override
  String get allocationLightsIndicators => 'ದೀಪಗಳು ಮತ್ತು ಸೂಚಕಗಳು';

  @override
  String get allocationMarkAsPaid => 'ಪಾವತಿಯಾಗಿದೆ ಎಂದು ಗುರುತಿಸಿ';

  @override
  String get allocationMatchWaitingRiderWithVehicle => 'ಕಾಯುತ್ತಿರುವ ರೈಡರ್‌ಗೆ ವಾಹನ ಹೊಂದಿಸಿ, ನಂತರ ಹಸ್ತಾಂತರ ಪೂರ್ಣಗೊಳಿಸಿ';

  @override
  String get allocationMove => 'ಈಗ ನಿಮ್ಮ ಸರದಿ';

  @override
  String get allocationNoBatteryPlan => 'ಬ್ಯಾಟರಿ ಪ್ಲಾನ್ ಇಲ್ಲ';

  @override
  String get allocationNobodyWaiting => 'ಯಾರೂ ಕಾಯುತ್ತಿಲ್ಲ';

  @override
  String get allocationNoHandoversProgress => 'ಯಾವುದೇ ಹಸ್ತಾಂತರ ನಡೆಯುತ್ತಿಲ್ಲ';

  @override
  String get allocationNoTeamLeads => 'ಯಾವುದೇ ಟೀಮ್ ಲೀಡ್ ಸಿಗಲಿಲ್ಲ';

  @override
  String get allocationNoTeamLeadsMessage => 'ಸಕ್ರಿಯ ಟೀಮ್ ಲೀಡ್ ಸೇರಿಸಲು ನಿಮ್ಮ ಅಡ್ಮಿನ್‌ಗೆ ಹೇಳಿ.';

  @override
  String get allocationNothingCurrentlyAllocatedRider => 'ಪ್ರಸ್ತುತ ಯಾವ ರೈಡರ್‌ಗೂ ಏನೂ ನೀಡಿಲ್ಲ.';

  @override
  String get allocationNoVehiclesOut => 'ಯಾವ ವಾಹನವೂ ಹೊರಗಿಲ್ಲ';

  @override
  String get allocationNoVehiclesReady => 'ಯಾವ ವಾಹನವೂ ಸಿದ್ಧವಿಲ್ಲ';

  @override
  String get allocationNoWorkPartners => 'ಯಾವುದೇ ಕೆಲಸದ ಪಾಲುದಾರರು ಸಿಗಲಿಲ್ಲ';

  @override
  String get allocationNoWorkPartnersMessage => 'ಕೆಲಸದ ಪಾಲುದಾರರನ್ನು ಸೇರಿಸಲು ನಿಮ್ಮ ಅಡ್ಮಿನ್‌ಗೆ ಹೇಳಿ.';

  @override
  String get allocationPaymentCouldNotLoad => 'ಪಾವತಿ ಲೋಡ್ ಮಾಡಲು ಆಗಲಿಲ್ಲ';

  @override
  String get allocationPaymentNoScreenshot => 'ರೈಡರ್ ಸ್ಕ್ರೀನ್‌ಶಾಟ್ ಸೇರಿಸಿಲ್ಲ.';

  @override
  String get allocationPaymentReceived => 'ಪಾವತಿ ಬಂದಿದೆಯೆ?';

  @override
  String get allocationPaymentRejected => 'ಪಾವತಿ ತಿರಸ್ಕರಿಸಲಾಗಿದೆ. ರೈಡರ್ ಸರಿಪಡಿಸಿ ಮತ್ತೆ ಕಳುಹಿಸಬಹುದು.';

  @override
  String allocationPaymentRejectedNote(String reason) {
    return 'ನೀವು ಈ ಪಾವತಿಯನ್ನು ತಿರಸ್ಕರಿಸಿದ್ದೀರಿ: $reason. ರೈಡರ್ ಮತ್ತೆ ಕಳುಹಿಸುವವರೆಗೆ ಕಾಯಲಾಗುತ್ತಿದೆ.';
  }

  @override
  String get allocationPaymentRequested => 'ಪಾವತಿ ಕೇಳಲಾಗಿದೆ';

  @override
  String get allocationPaymentRequestedAmount => 'ಕೇಳಲಾದ ಪಾವತಿ';

  @override
  String get allocationPaymentRequestedRiderSeesNow => 'ಪಾವತಿ ಕೇಳಲಾಗಿದೆ, ರೈಡರ್‌ಗೆ ಈಗ ಕಾಣಿಸುತ್ತಿದೆ';

  @override
  String get allocationPaymentScreenshots => 'ಪಾವತಿಯ ಸ್ಕ್ರೀನ್‌ಶಾಟ್‌ಗಳು';

  @override
  String get allocationPaymentVerified => 'ಪಾವತಿ ಪರಿಶೀಲಿಸಲಾಗಿದೆ';

  @override
  String get allocationPaymentWaitingRider => 'ರೈಡರ್ ಇನ್ನೂ ಪಾವತಿ ವಿವರಗಳನ್ನು ಕಳುಹಿಸಿಲ್ಲ.';

  @override
  String get allocationPhotoBack => 'ಹಿಂಭಾಗ';

  @override
  String get allocationPhotoCannotOpen => 'ಈ ಫೋಟೋವನ್ನು ಈಗ ತೆರೆಯಲು ಆಗುವುದಿಲ್ಲ.';

  @override
  String get allocationPhotoDeclaration => 'ಘೋಷಣಾ ಪತ್ರ';

  @override
  String get allocationPhotoFront => 'ಮುಂಭಾಗ';

  @override
  String get allocationPhotoLeft => 'ಎಡಭಾಗ';

  @override
  String get allocationPhotoRider => 'ವಾಹನದೊಂದಿಗೆ ರೈಡರ್';

  @override
  String get allocationPhotoRight => 'ಬಲಭಾಗ';

  @override
  String get allocationPhotoUploaded => 'ಅಪ್‌ಲೋಡ್ ಆಗಿದೆ';

  @override
  String get allocationPlanAcceptedChip => 'ರೈಡರ್ ಒಪ್ಪಿದ್ದಾರೆ';

  @override
  String get allocationPlanAwaitingBody =>
      'ರೈಡರ್ ತಮ್ಮ ಆ್ಯಪ್‌ನಲ್ಲಿ ಈ ಪ್ಲಾನ್ ಒಪ್ಪಲು ಕಾಯಲಾಗುತ್ತಿದೆ. ಅವರು ಒಪ್ಪುವವರೆಗೆ ನೀವು ಇದನ್ನು ಬದಲಿಸಬಹುದು.';

  @override
  String get allocationPlanAwaitingChip => 'ರೈಡರ್‌ಗಾಗಿ ಕಾಯಲಾಗುತ್ತಿದೆ';

  @override
  String get allocationPlanCouldNotLoad => 'ಬಾಡಿಗೆ ಪ್ಲಾನ್‌ಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get allocationPlanExchangeBody =>
      'ಈ ಸ್ಕೂಟರ್ ಎಕ್ಸ್‌ಚೇಂಜ್‌ನ ಬದಲಿ ಸ್ಕೂಟರ್. ರೈಡರ್‌ನ ಎಕ್ಸ್‌ಚೇಂಜ್ ಪ್ಲಾನ್ ಮುಂದುವರಿಯುತ್ತದೆ, ಆದ್ದರಿಂದ ಹೊಸ ಪ್ಲಾನ್ ಅಥವಾ ಠೇವಣಿ ಸಂಗ್ರಹಿಸಬೇಕಿಲ್ಲ.';

  @override
  String get allocationPlanExchangeChip => 'ಎಕ್ಸ್‌ಚೇಂಜ್ ಪ್ಲಾನ್';

  @override
  String get allocationPlanExpiredBody =>
      'ಪ್ಲಾನ್ ಆಫರ್ ಅವಧಿ ಮುಗಿದಿದೆ ಅಥವಾ ಬದಲಾಗಿದೆ. ಮತ್ತೆ ಪ್ಲಾನ್ ಆಯ್ಕೆಮಾಡಿ ರೈಡರ್‌ಗೆ ಕಳುಹಿಸಿ.';

  @override
  String get allocationPlanNoneBody =>
      'ಈ ಸ್ಕೂಟರ್ ಮತ್ತು ಹಬ್‌ಗೆ ಹೊಂದುವ ಪ್ರಕಟಿತ ಬಾಡಿಗೆ ಪ್ಲಾನ್ ಇಲ್ಲ. ರೇಟ್ ಕಾರ್ಡ್ ಪ್ರಕಟಿಸಲು ನಿಮ್ಮ ಅಡ್ಮಿನ್‌ಗೆ ಹೇಳಿ.';

  @override
  String get allocationPlanNoneTitle => 'ಯಾವುದೇ ಪ್ಲಾನ್ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get allocationPlanNotChosenBody =>
      'ಈ ರೈಡರ್‌ಗೆ ಬಾಡಿಗೆ ಪ್ಲಾನ್ ಆಯ್ಕೆಮಾಡಿ. ರೈಡರ್ ಅದನ್ನು ತಮ್ಮ ಆ್ಯಪ್‌ನಲ್ಲಿ ನೋಡಿ ಒಪ್ಪುತ್ತಾರೆ, ಮತ್ತು ಪಾವತಿಯನ್ನು ಅದರಿಂದಲೇ ಲೆಕ್ಕ ಹಾಕಲಾಗುತ್ತದೆ.';

  @override
  String get allocationPlanNotChosenChip => 'ಆಯ್ಕೆಮಾಡಿಲ್ಲ';

  @override
  String get allocationPlanPickSubtitle => 'ಬೆಲೆಗಳನ್ನು ಈ ರೈಡರ್, ಸ್ಕೂಟರ್ ಮತ್ತು ಹಬ್‌ಗೆ ಲೆಕ್ಕ ಹಾಕಲಾಗುತ್ತದೆ.';

  @override
  String get allocationPlanPickTitle => 'ಬಾಡಿಗೆ ಪ್ಲಾನ್ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get allocationPlanSend => 'ರೈಡರ್‌ಗೆ ಕಳುಹಿಸಿ';

  @override
  String get allocationPlanSentSnack => 'ಪ್ಲಾನ್ ಕಳುಹಿಸಲಾಗಿದೆ. ರೈಡರ್ ತಮ್ಮ ಆ್ಯಪ್‌ನಲ್ಲಿ ಒಪ್ಪಬಹುದು.';

  @override
  String get allocationPlanTitle => 'ಬಾಡಿಗೆ ಪ್ಲಾನ್';

  @override
  String get allocationPlanWaitingButton => 'ರೈಡರ್ ಒಪ್ಪಿಗೆಗಾಗಿ ಕಾಯಲಾಗುತ್ತಿದೆ';

  @override
  String get allocationReason => 'ಕಾರಣ';

  @override
  String get allocationRejectConfirm => 'ಪಾವತಿ ತಿರಸ್ಕರಿಸಿ';

  @override
  String get allocationRejectPayment => 'ತಿರಸ್ಕರಿಸಿ';

  @override
  String get allocationRejectReason => 'ನೀವು ಇದನ್ನು ಏಕೆ ತಿರಸ್ಕರಿಸುತ್ತಿದ್ದೀರಿ?';

  @override
  String get allocationRejectReasonHint => 'ಉದಾ: ರೆಫರೆನ್ಸ್ ಬಂದ ಹಣಕ್ಕೆ ಹೊಂದುತ್ತಿಲ್ಲ';

  @override
  String get allocationRejectReasonNeeded => 'ಕನಿಷ್ಠ 3 ಅಕ್ಷರಗಳನ್ನು ನಮೂದಿಸಿ';

  @override
  String get allocationReserved2 => 'ಕಾಯ್ದಿರಿಸಿದ ದಿನಾಂಕ';

  @override
  String get allocationReviewPayment => 'ಪಾವತಿ ಪರಿಶೀಲಿಸಿ';

  @override
  String get allocationRider => 'ರೈಡರ್';

  @override
  String get allocationRiderCompletingSafetyTrainingTheir =>
      'ರೈಡರ್ ತಮ್ಮ ಆ್ಯಪ್‌ನಲ್ಲಿ ಸುರಕ್ಷತಾ ತರಬೇತಿ ಮುಗಿಸುತ್ತಿದ್ದಾರೆ. ಪ್ರತಿ ಕಡ್ಡಾಯ ಪಾಠ ಮುಗಿದ ಮೇಲೆ ಸ್ಕೂಟರ್ ಹಸ್ತಾಂತರವಾಗುತ್ತದೆ.';

  @override
  String get allocationRiderGoingThroughChecklistTheir =>
      'ರೈಡರ್ ತಮ್ಮ ಆ್ಯಪ್‌ನಲ್ಲಿ ನಿಮ್ಮ ಪಟ್ಟಿಯನ್ನು ನೋಡುತ್ತಿದ್ದಾರೆ. ಅವರು ತಿರಸ್ಕರಿಸಿದವು ಟಿಪ್ಪಣಿಯೊಂದಿಗೆ ಮರಳುತ್ತವೆ.';

  @override
  String get allocationRiderNoLongerWaitingVehicle => 'ಈ ರೈಡರ್ ಈಗ ವಾಹನಕ್ಕಾಗಿ ಕಾಯುತ್ತಿಲ್ಲ.';

  @override
  String get allocationRiding => 'ಸವಾರಿಯಲ್ಲಿದೆ';

  @override
  String get allocationRightSide => 'ಬಲಭಾಗ';

  @override
  String get allocationRoad => 'ರಸ್ತೆಯಲ್ಲಿ';

  @override
  String allocationScooterAge(int months) {
    return 'ಸ್ಕೂಟರ್ ವಯಸ್ಸು (ತಿಂಗಳು): $months';
  }

  @override
  String get allocationSearchRiderNameCodeMobile => 'ರೈಡರ್ ಹೆಸರು, ಕೋಡ್ ಅಥವಾ ಮೊಬೈಲ್ ಹುಡುಕಿ';

  @override
  String get allocationSearchRiderVehicle => 'ರೈಡರ್ ಅಥವಾ ವಾಹನ ಹುಡುಕಿ';

  @override
  String get allocationSearchRiderVehicleNumber => 'ರೈಡರ್ ಅಥವಾ ವಾಹನ ಸಂಖ್ಯೆ ಹುಡುಕಿ';

  @override
  String get allocationSearchTeamLead => 'ಹೆಸರು, ಮೊಬೈಲ್ ಅಥವಾ ಉದ್ಯೋಗಿ ಕೋಡ್ ಮೂಲಕ ಹುಡುಕಿ';

  @override
  String get allocationSearchWorkPartner => 'ಕೆಲಸದ ಪಾಲುದಾರರನ್ನು ಹುಡುಕಿ';

  @override
  String get allocationSendPaymentRequest => 'ಪಾವತಿ ಮನವಿ ಕಳುಹಿಸಿ';

  @override
  String get allocationSendRider => 'ರೈಡರ್‌ಗೆ ಕಳುಹಿಸಿ';

  @override
  String get allocationStartReturn => 'ಹಿಂತಿರುಗಿಸುವಿಕೆ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get allocationStepPhotos => 'ಫೋಟೋ ಮತ್ತು ಪರಿಶೀಲನೆ';

  @override
  String get allocationStepRider => 'ರೈಡರ್ ಪರಿಶೀಲನೆ ಮತ್ತು ತರಬೇತಿ';

  @override
  String get allocationTeamLead => 'ಟೀಮ್ ಲೀಡ್';

  @override
  String get allocationTeamLeadMissing =>
      'ಇನ್ನೂ ಟೀಮ್ ಲೀಡ್ ಇಲ್ಲ. ಅದು ಇಲ್ಲದೆ ಹ್ಯಾಂಡ್‌ಓವರ್ ಪೂರ್ಣಗೊಳ್ಳುವುದಿಲ್ಲ, ಆದ್ದರಿಂದ ಒಬ್ಬರನ್ನು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get allocationTeamLeadNotSaved =>
      'ಸ್ಕೂಟರ್ ಕಾಯ್ದಿರಿಸಲಾಗಿದೆ, ಆದರೆ ಟೀಮ್ ಲೀಡ್ ಉಳಿಸಲಾಗಿಲ್ಲ. ಹಂಚಿಕೆ ಪುಟದಲ್ಲಿ ಅದನ್ನು ನೇಮಿಸಿ.';

  @override
  String get allocationTeamLeadPickerSubtitle => 'ಟೀಮ್ ಲೀಡ್ ಈ ರೈಡರ್‌ನನ್ನು ನೋಡಿಕೊಳ್ಳುತ್ತಾರೆ.';

  @override
  String get allocationTeamLeadRequired =>
      'ಈ ಹ್ಯಾಂಡ್‌ಓವರ್‌ಗೆ ಮೊದಲು ಟೀಮ್ ಲೀಡ್ ಬೇಕು. ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ಹಂಚಿಕೆ ಪುಟದಲ್ಲಿ ಅವರನ್ನು ನೇಮಿಸಬಹುದು.';

  @override
  String allocationTeamLeadRiderCount(int count) {
    return 'ರೈಡರ್‌ಗಳು: $count';
  }

  @override
  String get allocationTeamLeadSaved => 'ಟೀಮ್ ಲೀಡ್ ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get allocationTyresPressure => 'ಟೈರ್ ಮತ್ತು ಒತ್ತಡ';

  @override
  String get allocationUploadEvidenceContinue => 'ಮುಂದುವರಿಯಲು ಸಾಕ್ಷ್ಯ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ';

  @override
  String get allocationVehicleHasAvailableOnboardedAllocation =>
      'ಇಲ್ಲಿ ಕಾಣಿಸಲು ವಾಹನ ನಿಮ್ಮ ಯಾವುದಾದರೂ ಹಬ್‌ನಲ್ಲಿ ಲಭ್ಯವಿರಬೇಕು, ನೋಂದಾಯಿತವಾಗಿರಬೇಕು ಮತ್ತು ಹಂಚಿಕೆಗೆ ಸಿದ್ಧವಿರಬೇಕು.';

  @override
  String get allocationVehiclePhotos => 'ವಾಹನದ ಫೋಟೋಗಳು';

  @override
  String get allocationVehiclePhotosHint =>
      'ವಾಹನದ ಪ್ರತಿ ಬದಿಯ ಫೋಟೋ, ವಾಹನದೊಂದಿಗೆ ರೈಡರ್‌ನ ಒಂದು ಫೋಟೋ ಮತ್ತು ಸಹಿ ಮಾಡಿದ ಘೋಷಣಾ ಪತ್ರದ ಒಂದು ಫೋಟೋ ತೆಗೆಯಿರಿ. ತಪಾಸಣೆ ಸಲ್ಲಿಸುವ ಮೊದಲು ಎಲ್ಲಾ ಫೋಟೋಗಳು ಬೇಕು.';

  @override
  String get allocationVehicleReserved => 'ವಾಹನ ಕಾಯ್ದಿರಿಸಲಾಗಿದೆ';

  @override
  String get allocationVerifyPayment => 'ಪಾವತಿ ಪರಿಶೀಲಿಸಿ';

  @override
  String get allocationWaiting => 'ಕಾಯುತ್ತಿದೆ';

  @override
  String get allocationWaitingRider => 'ರೈಡರ್‌ಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get allocationWaitingRiderAcceptInspection => 'ರೈಡರ್ ಪರಿಶೀಲನೆ ಸ್ವೀಕರಿಸುವುದಕ್ಕಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get allocationWaitingRiderFinishTraining => 'ರೈಡರ್ ತರಬೇತಿ ಮುಗಿಸುವುದಕ್ಕಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get allocationWaitingRiderInspection => 'ರೈಡರ್‌ಗಾಗಿ ಕಾಯುತ್ತಿದೆ: ಪರಿಶೀಲನೆ';

  @override
  String get allocationWaitingRiderPageRefreshesIts => 'ರೈಡರ್‌ಗಾಗಿ ಕಾಯುತ್ತಿದೆ, ಈ ಪುಟ ತಾನಾಗಿಯೇ ರಿಫ್ರೆಶ್ ಆಗುತ್ತದೆ.';

  @override
  String get allocationWaitingRiderTraining => 'ರೈಡರ್‌ಗಾಗಿ ಕಾಯುತ್ತಿದೆ: ತರಬೇತಿ';

  @override
  String get allocationWorkPartner => 'ಕೆಲಸದ ಪಾಲುದಾರ';

  @override
  String get allocationWorkPartnerHelper => 'ಈ ರೈಡರ್ ಕೆಲಸ ಮಾಡುವ ಕಂಪನಿ.';

  @override
  String get allocationWorkPartnerNeeded => 'ರೈಡರ್‌ನ ಕೆಲಸದ ಪಾಲುದಾರರನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get appGoHome => 'ಮುಖಪುಟಕ್ಕೆ ಹೋಗಿ';

  @override
  String get authChangeNumber => 'ಸಂಖ್ಯೆ ಬದಲಾಯಿಸಿ';

  @override
  String get authCodeDidNotVerifyPlease => 'ಈ ಕೋಡ್ ಪರಿಶೀಲನೆಯಲ್ಲಿ ಸರಿಯಾಗಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get authContinue => 'ಮುಂದುವರಿಸಿ';

  @override
  String get authEditNumber => 'ಸಂಖ್ಯೆ ಬದಲಾಯಿಸಿ';

  @override
  String authLegalAgreement(String terms, String privacy) {
    return 'ಮುಂದುವರಿಸಿ ಮೇಲೆ ಕ್ಲಿಕ್ ಮಾಡುವ ಮೂಲಕ ನೀವು ನಮ್ಮ $terms ಮತ್ತು $privacy ಒಪ್ಪಿಕೊಳ್ಳುತ್ತಿದ್ದೀರಿ';
  }

  @override
  String get authLegalPrivacy => 'ಗೌಪ್ಯತಾ ನೀತಿ';

  @override
  String get authLegalTerms => 'ಸೇವಾ ನಿಯಮಗಳು';

  @override
  String get authLiveFleetVisibility => 'ಫ್ಲೀಟ್‌ನ\nನೇರ ಮಾಹಿತಿ';

  @override
  String get authNumberVerified => 'ಸಂಖ್ಯೆ ಪರಿಶೀಲಿಸಲಾಗಿದೆ';

  @override
  String get authOnlyNumbersRegisteredByAdmin => 'ನಿಮ್ಮ ಆಡಳಿತ ನೋಂದಾಯಿಸಿದ ಸಂಖ್ಯೆಗಳು ಮಾತ್ರ ಸೈನ್ ಇನ್ ಮಾಡಬಹುದು';

  @override
  String get authOpsSupport => '24x7 ಕಾರ್ಯಾಚರಣೆ\nಬೆಂಬಲ';

  @override
  String authOtpSentTo(String mobile) {
    return '+91 $mobile ಗೆ 6 ಅಂಕಿಯ ಕೋಡ್ ಕಳುಹಿಸಲಾಗಿದೆ';
  }

  @override
  String get authResendCode => 'ಕೋಡ್ ಮತ್ತೆ ಕಳುಹಿಸಿ';

  @override
  String authResendCodeIn(String seconds) {
    return '$seconds ರಲ್ಲಿ ಕೋಡ್ ಮತ್ತೆ ಕಳುಹಿಸಿ';
  }

  @override
  String get authRoadsideHelp => '24x7\nರಸ್ತೆಬದಿ ನೆರವು';

  @override
  String get authSameDayPayouts => 'ಅದೇ ದಿನ\nಪಾವತಿ';

  @override
  String get authSessionEncryptedEndEnd => 'ನಿಮ್ಮ ಸೆಷನ್ ಸಂಪೂರ್ಣ ಸುರಕ್ಷಿತವಾಗಿದೆ';

  @override
  String get authSignRunHub => 'ನಿಮ್ಮ ಹಬ್ ನಡೆಸಲು ಸೈನ್ ಇನ್ ಮಾಡಿ';

  @override
  String get authSignWithMobileNumberRegistered =>
      'ಹಂಚಿಕೆ, ರೈಡರ್ ಮತ್ತು ನಿರ್ವಹಣೆ ನೋಡಿಕೊಳ್ಳಲು ನಿಮ್ಮ ಹಬ್‌ಗೆ ನೋಂದಾಯಿತ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯಿಂದ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get authSignWithMobileNumberRegistered2 =>
      'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಆಪರೇಟರ್ ಬಳಿ ನೋಂದಾಯಿತ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯಿಂದ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get authVerifiedHubNetwork => 'ಪರಿಶೀಲಿತ\nಹಬ್ ಜಾಲ';

  @override
  String get authVerifiedOperators => 'ಪರಿಶೀಲಿತ\nಆಪರೇಟರ್';

  @override
  String get authVerifying => 'ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String get authVerifyingNumber => 'ನಿಮ್ಮ ಸಂಖ್ಯೆ ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String get authVerifyNumber => 'ನಿಮ್ಮ ಸಂಖ್ಯೆ ಪರಿಶೀಲಿಸಿ';

  @override
  String get authWelcomeBack => 'ಮತ್ತೆ ಸ್ವಾಗತ';

  @override
  String get authWhyChooseUs => 'ನಮ್ಮನ್ನೇ ಏಕೆ ಆರಿಸಬೇಕು';

  @override
  String get authWhyRideWithUs => 'ನಮ್ಮ ಜೊತೆ ಏಕೆ ಸವಾರಿ ಮಾಡಬೇಕು';

  @override
  String get authWillText6DigitCode => 'ನಾವು ನಿಮಗೆ 6 ಅಂಕಿಯ ಕೋಡ್ ಕಳುಹಿಸುತ್ತೇವೆ';

  @override
  String get authWrongNumber => 'ತಪ್ಪು ಸಂಖ್ಯೆಯೆ?';

  @override
  String get checkInBasicReport => 'ಮೆಕ್ಯಾನಿಕ್ ವರದಿ';

  @override
  String checkInConfirmedByManager(String reason) {
    return 'ನಿಮ್ಮ ಕೋಡ್ ಇಲ್ಲದೆ ಹಬ್ ತಂಡ ದೃಢೀಕರಿಸಿದೆ: $reason';
  }

  @override
  String get checkInCouldNotLoad => 'ಸಬ್‌ಮಿಷನ್ ಲೋಡ್ ಆಗಲಿಲ್ಲ.';

  @override
  String get checkInDeepReport => 'ಅಂತಿಮ ಮೆಕ್ಯಾನಿಕ್ ತಪಾಸಣೆ';

  @override
  String get checkInHub => 'ಹಬ್';

  @override
  String get checkInNoCharges => 'ಯಾವುದೇ ಶುಲ್ಕವಿಲ್ಲ';

  @override
  String get checkInOtpHint =>
      'ನಿಮ್ಮ ಫೋನ್‌ಗೆ ಒಂದು ಕೋಡ್ ಬರುತ್ತದೆ. ಈ ವರದಿ ಮತ್ತು ಅದರ ಶುಲ್ಕಗಳನ್ನು ದೃಢೀಕರಿಸಲು ಅದನ್ನು ಹಬ್ ತಂಡಕ್ಕೆ ತಿಳಿಸಿ.';

  @override
  String get checkInPhotos => 'ಫೋಟೋಗಳು';

  @override
  String checkInPhotosCount(int taken, int total) {
    return '$total ರಲ್ಲಿ $taken ತೆಗೆಯಲಾಗಿದೆ';
  }

  @override
  String get checkInSafe => 'ಮತ್ತೆ ಬಳಸಲು ಸುರಕ್ಷಿತ';

  @override
  String get checkInStatusDraft => 'ಪರಿಶೀಲನೆಯಲ್ಲಿದೆ';

  @override
  String get checkInStatusPosted => 'ದೃಢೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get checkInStatusSubmitted => 'ದೃಢೀಕರಣ ಬಾಕಿ';

  @override
  String get checkInTitle => 'ಸ್ಕೂಟರ್ ಸಬ್‌ಮಿಷನ್';

  @override
  String checkInUnsafe(String reason) {
    return 'ಮರುಬಳಕೆಗೆ ಸುರಕ್ಷಿತವಲ್ಲ: $reason';
  }

  @override
  String get checkInViewPhotos => 'ನೋಡಿ';

  @override
  String get checkInWaitingReport =>
      'ಹಬ್ ತಂಡ ಫೋಟೋಗಳನ್ನು ತೆಗೆಯುತ್ತಿದೆ. ಮೆಕ್ಯಾನಿಕ್ ವರದಿ ಸಿದ್ಧವಾದ ತಕ್ಷಣ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get commonAboutApp => 'ಈ ಆ್ಯಪ್ ಬಗ್ಗೆ';

  @override
  String get commonAbsent => 'ಗೈರು';

  @override
  String get commonAccountCannotDo => 'ನಿಮ್ಮ ಖಾತೆಗೆ ಇದು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get commonAccountNumbersDoNotMatch => 'ಖಾತೆ ಸಂಖ್ಯೆಗಳು ಹೊಂದಿಕೆಯಾಗಿಲ್ಲ';

  @override
  String get commonAccountNumbersMatch => 'ಖಾತೆ ಸಂಖ್ಯೆಗಳು ಹೊಂದಿಕೆಯಾಗಿವೆ';

  @override
  String get commonAddAnotherReference => 'ಇನ್ನೊಂದು ಉಲ್ಲೇಖ ಸೇರಿಸಿ';

  @override
  String get commonAddNominee => 'ನಾಮಿನಿ ಸೇರಿಸಿ';

  @override
  String get commonAddPhoto => 'ಫೋಟೋ ಸೇರಿಸಿ';

  @override
  String get commonAllocated => 'ನೀಡಿದ ದಿನಾಂಕ';

  @override
  String get commonAllocation => 'ಹಂಚಿಕೆ';

  @override
  String get commonAppWillChangeRightAway => 'ಆ್ಯಪ್ ತಕ್ಷಣ ಬದಲಾಗುತ್ತದೆ.';

  @override
  String get commonAttendance => 'ಹಾಜರಾತಿ';

  @override
  String get commonBankAccountNumber => 'ಬ್ಯಾಂಕ್ ಖಾತೆ ಸಂಖ್ಯೆ';

  @override
  String get commonBrakes => 'ಬ್ರೇಕ್';

  @override
  String get commonBrother => 'ಸಹೋದರ';

  @override
  String get commonCamera => 'ಕ್ಯಾಮೆರಾ';

  @override
  String get commonCameraAccessNeeded => 'ಫೋಟೋ ತೆಗೆಯಲು Settings ನಲ್ಲಿ ಕ್ಯಾಮೆರಾ ಅನುಮತಿ ನೀಡಿ.';

  @override
  String get commonCancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get commonCanChangeLaterFromMenu => 'ನೀವು ಇದನ್ನು ನಂತರ ಮೆನುವಿನಿಂದ ಬದಲಾಯಿಸಬಹುದು.';

  @override
  String get commonCategory => 'ವರ್ಗ';

  @override
  String get commonChooseLanguage => 'ನಿಮ್ಮ ಭಾಷೆ ಆರಿಸಿ';

  @override
  String get commonCity => 'ನಗರ';

  @override
  String get commonColleague => 'ಸಹೋದ್ಯೋಗಿ';

  @override
  String get commonColour => 'ಬಣ್ಣ';

  @override
  String get commonConfirm => 'ಖಚಿತಪಡಿಸಿ';

  @override
  String get commonConfirmAccountNumber => 'ಖಾತೆ ಸಂಖ್ಯೆ ಮತ್ತೆ ಬರೆಯಿರಿ';

  @override
  String get commonCouldNotOpenDocumentTry => 'ದಾಖಲೆ ತೆರೆಯಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get commonCouldNotReadLocalData => 'ಫೋನ್‌ನ ಮಾಹಿತಿ ಓದಲು ಆಗಲಿಲ್ಲ.';

  @override
  String get commonDaughter => 'ಮಗಳು';

  @override
  String get commonEnterAccountNumber => 'ನಿಮ್ಮ ಖಾತೆ ಸಂಖ್ಯೆ ಬರೆಯಿರಿ';

  @override
  String get commonEnterValid10DigitMobile => 'ಸರಿಯಾದ 10 ಅಂಕಿಯ ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ಬರೆಯಿರಿ';

  @override
  String get commonFather => 'ತಂದೆ';

  @override
  String get commonFriend => 'ಸ್ನೇಹಿತ';

  @override
  String get commonFullName => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get commonGallery => 'ಗ್ಯಾಲರಿ';

  @override
  String get commonHandover => 'ಹಸ್ತಾಂತರ';

  @override
  String get commonHaveAlreadyUsedNumberAnother => 'ಈ ಸಂಖ್ಯೆಯನ್ನು ಬೇರೊಂದು ಉಲ್ಲೇಖಕ್ಕೆ ಈಗಾಗಲೇ ಬಳಸಿದ್ದೀರಿ';

  @override
  String get commonHintGuardian => 'ಉದಾ. ಪೋಷಕ';

  @override
  String get commonHowTheyRelated => 'ಅವರು ನಿಮಗೆ ಏನಾಗಬೇಕು?';

  @override
  String get commonIncentives => 'ಪ್ರೋತ್ಸಾಹ';

  @override
  String get commonIotUnit => 'ಸಾಧನ';

  @override
  String get commonJpgPngPdfUp5 => 'JPG, PNG ಅಥವಾ PDF · 5 MB ವರೆಗೆ';

  @override
  String get commonLanguage => 'ಭಾಷೆ';

  @override
  String get commonLoadMore => 'ಇನ್ನಷ್ಟು ತೋರಿಸಿ';

  @override
  String get commonMake100 => 'ಇದನ್ನು 100% ಮಾಡಿ';

  @override
  String get commonManager => 'ಮ್ಯಾನೇಜರ್';

  @override
  String get commonMandatory => 'ಕಡ್ಡಾಯ';

  @override
  String get commonMarkedPresentShiftHasStarted => 'ಹಾಜರಾತಿ ಹಾಕಲಾಗಿದೆ. ನಿಮ್ಮ ಪಾಳಿ ಶುರುವಾಗಿದೆ.';

  @override
  String get commonMobile => 'ಮೊಬೈಲ್';

  @override
  String get commonMobileNumber => 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ';

  @override
  String get commonModel => 'ಮಾದರಿ';

  @override
  String get commonMother => 'ತಾಯಿ';

  @override
  String get commonNoInternetConnection => 'ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕ ಇಲ್ಲ.';

  @override
  String get commonNominationComplete => 'ನಿಮ್ಮ ನಾಮನಿರ್ದೇಶನ ಪೂರ್ಣಗೊಂಡಿದೆ.';

  @override
  String get commonNotFound => 'ಸಿಗಲಿಲ್ಲ.';

  @override
  String get commonNow => 'ಈಗ';

  @override
  String get commonOdometer => 'ಓಡೋಮೀಟರ್';

  @override
  String get commonOff => 'ಆಫ್';

  @override
  String get commonOn => 'ಆನ್';

  @override
  String get commonOpen => 'ತೆರೆಯಿರಿ';

  @override
  String get commonOptional => 'ಐಚ್ಛಿಕ';

  @override
  String get commonOther => 'ಇತರೆ';

  @override
  String get commonOtherRelationship => 'ಬೇರೆ ಸಂಬಂಧ';

  @override
  String get commonOwnNumberUseDifferentOne => 'ಇದು ನಿಮ್ಮದೇ ಸಂಖ್ಯೆ. ಬೇರೊಂದು ಬಳಸಿ.';

  @override
  String get commonPaidDate => 'ಇಲ್ಲಿಯವರೆಗೆ ಪಾವತಿ';

  @override
  String get commonPayment => 'ಪಾವತಿ';

  @override
  String get commonPending => 'ಬಾಕಿ';

  @override
  String get commonPreDeliveryInspection => 'ವಿತರಣೆಯ ಮೊದಲಿನ ಪರಿಶೀಲನೆ';

  @override
  String get commonPresent => 'ಹಾಜರು';

  @override
  String get commonPrivacyPolicy => 'ಗೌಪ್ಯತಾ ನೀತಿ';

  @override
  String get commonProfile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get commonRaised => 'ದಾಖಲಾಗಿದೆ';

  @override
  String get commonRefresh => 'ರಿಫ್ರೆಶ್ ಮಾಡಿ';

  @override
  String get commonRejectedUploadAgain => 'ತಿರಸ್ಕೃತ, ಮತ್ತೆ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ';

  @override
  String commonRejectionReason(String reason) {
    return 'ಕಾರಣ: $reason';
  }

  @override
  String get commonRelationship => 'ಸಂಬಂಧ';

  @override
  String get commonRemove => 'ತೆಗೆದುಹಾಕಿ';

  @override
  String get commonRetake => 'ಮತ್ತೆ ತೆಗೆಯಿರಿ';

  @override
  String get commonRetry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get commonSave => 'ಉಳಿಸಿ';

  @override
  String get commonScooter => 'ನಿಮ್ಮ ಸ್ಕೂಟರ್';

  @override
  String get commonSearch => 'ಹುಡುಕಿ';

  @override
  String get commonSelect => 'ಆರಿಸಿ';

  @override
  String get commonSelectDate => 'ದಿನಾಂಕ ಆರಿಸಿ';

  @override
  String get commonSessionHasExpiredPleaseSign => 'ನಿಮ್ಮ ಸೆಷನ್ ಮುಗಿದಿದೆ. ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get commonShare => 'ಪಾಲು';

  @override
  String get commonSharesAddUp100 => 'ಪಾಲುಗಳ ಒಟ್ಟು 100% ಆಗಿದೆ';

  @override
  String get commonSignBeforeReadingClientConfiguration => 'ಕ್ಲೈಂಟ್ ಸಂರಚನೆ ಓದುವ ಮೊದಲು ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get commonSignContinue => 'ಮುಂದುವರಿಯಲು ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get commonSignOut => 'ಸೈನ್ ಔಟ್';

  @override
  String get commonSignOut2 => 'ಸೈನ್ ಔಟ್ ಮಾಡಬೇಕೆ?';

  @override
  String get commonSister => 'ಸಹೋದರಿ';

  @override
  String get commonSkip => 'ಬಿಟ್ಟುಬಿಡಿ';

  @override
  String get commonSomethingWentWrongPleaseTry => 'ಏನೋ ತಪ್ಪಾಗಿದೆ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get commonSon => 'ಮಗ';

  @override
  String get commonSpouse => 'ಸಂಗಾತಿ';

  @override
  String get commonStatus => 'ಸ್ಥಿತಿ';

  @override
  String get commonSubmitInspection => 'ಪರಿಶೀಲನೆ ಸಲ್ಲಿಸಿ';

  @override
  String get commonSupport => 'ಸಹಾಯ';

  @override
  String get commonTakeOneNowChooseFrom => 'ಈಗ ಒಂದು ತೆಗೆಯಿರಿ, ಅಥವಾ ಗ್ಯಾಲರಿಯಿಂದ ಆರಿಸಿ';

  @override
  String get commonTeamLead => 'ತಂಡದ ಮುಖ್ಯಸ್ಥ';

  @override
  String get commonTellUsHowTheyRelated => 'ಅವರು ನಿಮಗೆ ಏನಾಗಬೇಕು ಎಂದು ತಿಳಿಸಿ';

  @override
  String get commonTermsService => 'ಸೇವಾ ನಿಯಮಗಳು';

  @override
  String get commonTheirName => 'ಅವರ ಹೆಸರು';

  @override
  String get commonTooManyAttemptsWaitMoment => 'ತುಂಬಾ ಬಾರಿ ಪ್ರಯತ್ನಿಸಲಾಗಿದೆ. ಸ್ವಲ್ಪ ಕಾಯಿರಿ.';

  @override
  String get commonTotal => 'ಒಟ್ಟು';

  @override
  String get commonTryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get commonTypeAgain => 'ಇದನ್ನು ಮತ್ತೆ ಬರೆಯಿರಿ';

  @override
  String get commonUpload => 'ಅಪ್‌ಲೋಡ್ ಮಾಡಿ';

  @override
  String get commonUploaded => 'ಅಪ್‌ಲೋಡ್ ಆಯಿತು';

  @override
  String get commonVehicle => 'ವಾಹನ';

  @override
  String get commonVersion => 'ಆವೃತ್ತಿ';

  @override
  String get commonWallet => 'ವ್ಯಾಲೆಟ್';

  @override
  String get commonWhatHappensNext => 'ಮುಂದೆ ಏನಾಗುತ್ತದೆ';

  @override
  String get commonWillNeedMobileNumberOtp => 'ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಲು ನಿಮಗೆ ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ಮತ್ತು ಒಟಿಪಿ ಬೇಕಾಗುತ್ತದೆ.';

  @override
  String get companyCodeHint => 'ಉದಾ. yogmaya';

  @override
  String get companyCodeLabel => 'ಕಂಪನಿ ಕೋಡ್';

  @override
  String get companyCodeRequired => 'ನಿಮ್ಮ ಕಂಪನಿ ಕೋಡ್ ನಮೂದಿಸಿ';

  @override
  String get companyHelp => 'ಈ ಕೋಡ್ ನಿಮ್ಮ ಸ್ವಾಗತ ಸಂದೇಶದಲ್ಲಿ ಇರುತ್ತದೆ. ನಿಮ್ಮ ಬಳಿ ಇಲ್ಲದಿದ್ದರೆ, ನಿಮ್ಮ ಹಬ್ ತಂಡವನ್ನು ಕೇಳಿ.';

  @override
  String get companyNotFound => 'ಈ ಕೋಡ್‌ನ ಯಾವುದೇ ಕಂಪನಿ ಸಿಗಲಿಲ್ಲ. ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get companyNotReady =>
      'ಈ ಕಂಪನಿಯನ್ನು ಇನ್ನೂ ಆ್ಯಪ್‌ಗಾಗಿ ಹೊಂದಿಸಿಲ್ಲ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಫ್ಲೀಟ್ ಆಪರೇಟರ್ ಅನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get companySubtitle => 'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಆಪರೇಟರ್ ನೀಡಿದ ಕಂಪನಿ ಕೋಡ್ ನಮೂದಿಸಿ. ಇದನ್ನು ಒಮ್ಮೆ ಮಾತ್ರ ಮಾಡಬೇಕು.';

  @override
  String get companyTitle => 'ನಿಮ್ಮ ಕಂಪನಿಯನ್ನು ಹುಡುಕಿ';

  @override
  String companyWelcome(String name) {
    return '$name ಗೆ ಸ್ವಾಗತ';
  }

  @override
  String get consentAgree =>
      'ಈ ಸಮ್ಮತಿ ಪತ್ರದಲ್ಲಿರುವ ಅಂಶಗಳನ್ನು ನಾನು ಅರ್ಥಮಾಡಿಕೊಂಡಿದ್ದೇನೆ ಮತ್ತು \'ದತ್ತಾಂಶದ ಮೂಲ ಮಾಲೀಕ\'ನ (data principal) ಸಾಮರ್ಥ್ಯದಲ್ಲಿ ಇದಕ್ಕೆ ಸಮ್ಮತಿಸುತ್ತೇನೆ ಎಂದು ಘೋಷಿಸುತ್ತೇನೆ.';

  @override
  String get consentReviewLatest =>
      'ಆ್ಯಪ್ ಬಳಸುವುದನ್ನು ಮುಂದುವರಿಸಲು ದಯವಿಟ್ಟು ಈ ಒಪ್ಪಿಗೆಯ ಹೊಸ ಆವೃತ್ತಿಯನ್ನು ಓದಿ ಮತ್ತು ಅದನ್ನು ಒಪ್ಪಿಕೊಳ್ಳಿ.';

  @override
  String get consentRiderTitle => 'ರೈಡರ್ ಒಪ್ಪಿಗೆ';

  @override
  String get consentSubtitle =>
      'ನಿಮ್ಮ ಮಾಹಿತಿಯನ್ನು ನಾವು ಹೇಗೆ ಸಂಗ್ರಹಿಸುತ್ತೇವೆ ಮತ್ತು ಬಳಸುತ್ತೇವೆ ಎಂದು ಓದಿ, ನಂತರ ಮುಂದುವರಿಯಲು ನಿಮ್ಮ ಒಪ್ಪಿಗೆ ನೀಡಿ.';

  @override
  String get damageChargeAmountToPay => 'ಪಾವತಿಸಬೇಕಾದ ಮೊತ್ತ';

  @override
  String get damageChargeCancelledBody => 'ಈ ಶುಲ್ಕವನ್ನು ರದ್ದುಪಡಿಸಲಾಗಿದೆ. ನೀವು ಇದನ್ನು ಪಾವತಿಸಬೇಕಿಲ್ಲ.';

  @override
  String get damageChargeCouldNotLoad => 'ಈ ಶುಲ್ಕವನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get damageChargeCreditUsed => 'ಬಳಸಿದ ಕ್ರೆಡಿಟ್';

  @override
  String damageChargeEach(String amount) {
    return 'ಪ್ರತಿಯೊಂದಕ್ಕೆ $amount';
  }

  @override
  String get damageChargeLeftToPay => 'ಉಳಿದ ಮೊತ್ತ';

  @override
  String get damageChargePaidSoFar => 'ಈವರೆಗೆ ಪಾವತಿಸಿದ್ದು';

  @override
  String get damageChargePaidTitle => 'ಪೂರ್ತಿ ಪಾವತಿಯಾಗಿದೆ';

  @override
  String damageChargePay(String amount) {
    return '$amount ಪಾವತಿಸಿ';
  }

  @override
  String damageChargeRaisedOn(String date) {
    return '$date ರಂದು ವಿಧಿಸಲಾಗಿದೆ';
  }

  @override
  String get damageChargesCouldNotLoad => 'ಹಾನಿ ಶುಲ್ಕಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get damageChargesNoneMessage =>
      'ಸ್ಕೂಟರ್ ಹಿಂತಿರುಗಿಸುವಾಗ ಅಥವಾ ಬದಲಾಯಿಸುವಾಗ ಹಬ್‌ಗೆ ಹಾನಿ ಕಂಡುಬಂದರೆ, ಅದರ ಶುಲ್ಕ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get damageChargesNoneTitle => 'ಯಾವುದೇ ಹಾನಿ ಶುಲ್ಕವಿಲ್ಲ';

  @override
  String get damageChargesNothingToPay => 'ಪಾವತಿಸಲು ಏನೂ ಇಲ್ಲ';

  @override
  String get damageChargesNoUnpaid => 'ಯಾವುದೇ ಹಾನಿ ಶುಲ್ಕ ಬಾಕಿ ಇಲ್ಲ';

  @override
  String get damageChargeStatusCancelled => 'ರದ್ದಾಗಿದೆ';

  @override
  String get damageChargeStatusPaid => 'ಪಾವತಿಯಾಗಿದೆ';

  @override
  String get damageChargeStatusPartlyPaid => 'ಭಾಗಶಃ ಪಾವತಿ';

  @override
  String get damageChargesTitle => 'ಹಾನಿ ಶುಲ್ಕಗಳು';

  @override
  String damageChargesToPay(int count) {
    return '$count ಪಾವತಿಸಬೇಕಿದೆ';
  }

  @override
  String get damageChargesUnpaid => 'ಬಾಕಿ';

  @override
  String get damageChargesViewAndPay => 'ನೋಡಿ ಮತ್ತು ಪಾವತಿಸಿ';

  @override
  String get damageChargeTitle => 'ಹಾನಿ ಶುಲ್ಕ';

  @override
  String get damageChargeTotal => 'ಒಟ್ಟು ಶುಲ್ಕ';

  @override
  String get damageChargeWhatWasCharged => 'ಯಾವುದಕ್ಕೆ ಶುಲ್ಕ';

  @override
  String get deallocAccessoriesReturned => 'ಹಿಂತಿರುಗಿಸಿದ ಪರಿಕರಗಳು';

  @override
  String get deallocAnyNewDamageRecordHere =>
      'ಇಲ್ಲಿ ದಾಖಲಿಸಿದ ಯಾವುದೇ ಹೊಸ ಹಾನಿಯನ್ನು ರೈಡರ್ ಭದ್ರತಾ ಠೇವಣಿಯಿಂದ ಅಂದಾಜಿಸಲಾಗುತ್ತದೆ, ಹಾಗಾಗಿ ಅದನ್ನು ಸ್ಪಷ್ಟವಾಗಿ ದಾಖಲಿಸಿ.';

  @override
  String get deallocAssessment => 'ಮೌಲ್ಯಮಾಪನ';

  @override
  String get deallocAvailable => 'ಲಭ್ಯ';

  @override
  String get deallocBatteryReturnedHub => 'ಬ್ಯಾಟರಿ ಹಬ್‌ಗೆ ಹಿಂತಿರುಗಿಸಲಾಗಿದೆ';

  @override
  String get deallocBothRiderTeamLeadMust => 'ರೈಡರ್ ಮತ್ತು ತಂಡದ ಮುಖ್ಯಸ್ಥ ಇಬ್ಬರೂ ಖಚಿತಪಡಿಸಬೇಕು';

  @override
  String get deallocChargerCable => 'ಚಾರ್ಜರ್ ಮತ್ತು ಕೇಬಲ್';

  @override
  String get deallocChargeReturn => 'ಹಿಂತಿರುಗಿಸುವಾಗ ಚಾರ್ಜ್';

  @override
  String get deallocCloseRide => 'ಸವಾರಿ ಮುಚ್ಚಿ';

  @override
  String get deallocCodesValid10MinutesAsk =>
      'ಕೋಡ್‌ಗಳು 10 ನಿಮಿಷ ಮಾನ್ಯ. ಪ್ರತಿಯೊಬ್ಬರಿಂದಲೂ ಅವರ ಕೋಡ್ ಓದಿಸಿ, ಅವರ ಫೋನ್ ತೆಗೆದುಕೊಳ್ಳಬೇಡಿ.';

  @override
  String get deallocCompareAgainstHandoverSet => 'ಹಸ್ತಾಂತರದ ಫೋಟೋಗಳೊಂದಿಗೆ ಹೋಲಿಸಿ';

  @override
  String get deallocCompleteDeAllocation => 'ಹಿಂಪಡೆಯುವಿಕೆ ಪೂರ್ಣಗೊಳಿಸಿ';

  @override
  String get deallocComponents => 'ಘಟಕಗಳು';

  @override
  String get deallocConditionAssessment => 'ಸ್ಥಿತಿ ಮೌಲ್ಯಮಾಪನ';

  @override
  String get deallocConfirmBatteryBack => 'ಬ್ಯಾಟರಿ ಮರಳಿದೆ ಎಂದು ಖಚಿತಪಡಿಸಿ';

  @override
  String get deallocContinueAssessment => 'ಮೌಲ್ಯಮಾಪನಕ್ಕೆ ಸಾಗಿ';

  @override
  String get deallocContinueVerification => 'ಪರಿಶೀಲನೆಗೆ ಸಾಗಿ';

  @override
  String get deallocDamaged => 'ಹಾನಿಯಾಗಿದೆ';

  @override
  String get deallocDamageDescription => 'ಹಾನಿಯ ವಿವರಣೆ';

  @override
  String get deallocDeductedFromRidersSecurityDeposit => 'ಪರಿಶೀಲನೆಯ ನಂತರ ರೈಡರ್ ಭದ್ರತಾ ಠೇವಣಿಯಿಂದ ಕಡಿತಗೊಳಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get deallocDescribeDamage => 'ಹಾನಿಯನ್ನು ವಿವರಿಸಿ';

  @override
  String get deallocEndRideContinue => 'ಮುಂದುವರಿಯಲು ಸವಾರಿ ಮುಚ್ಚಿ';

  @override
  String get deallocEndRidersActiveRide => 'ರೈಡರ್ ಅವರ ಚಾಲ್ತಿ ಸವಾರಿ ಮುಚ್ಚಿ';

  @override
  String get deallocEnterAll6Digits => 'ಎಲ್ಲಾ 6 ಅಂಕಿ ಬರೆಯಿರಿ';

  @override
  String get deallocEnterClosingOdometer => 'ಮುಕ್ತಾಯದ ಓಡೋಮೀಟರ್ ಬರೆಯಿರಿ';

  @override
  String get deallocEnterRidersCode => 'ರೈಡರ್ ಕೋಡ್ ಬರೆಯಿರಿ';

  @override
  String get deallocEnterTeamLeadsCode => 'ತಂಡದ ಮುಖ್ಯಸ್ಥರ ಕೋಡ್ ಬರೆಯಿರಿ';

  @override
  String get deallocEstimatedRecovery => 'ಅಂದಾಜು ವಸೂಲಿ';

  @override
  String get deallocExcellent => 'ಅತ್ಯುತ್ತಮ';

  @override
  String get deallocGood => 'ಚೆನ್ನಾಗಿದೆ';

  @override
  String get deallocLoggedBackIntoChargingBay => 'ಚಾರ್ಜಿಂಗ್ ಬೇ ಪಟ್ಟಿಗೆ ಮತ್ತೆ ದಾಖಲಾಗಿದೆ.';

  @override
  String get deallocMinorScuffsNothingRecover => 'ಸಣ್ಣ ಗೀರುಗಳು, ವಸೂಲಿ ಮಾಡುವಂಥದ್ದೇನೂ ಇಲ್ಲ';

  @override
  String get deallocNoDamageBeyondNormalWear => 'ಸಾಮಾನ್ಯ ಸವೆತ ಹೊರತಾಗಿ ಯಾವ ಹಾನಿಯೂ ಇಲ್ಲ';

  @override
  String get deallocNotUsableUntilFurtherNotice => 'ಮುಂದಿನ ಸೂಚನೆವರೆಗೆ ಬಳಕೆಗೆ ಯೋಗ್ಯವಲ್ಲ';

  @override
  String get deallocOdometerReturn => 'ಹಿಂತಿರುಗಿಸುವಾಗ ಓಡೋಮೀಟರ್';

  @override
  String get deallocOffRoad => 'ರಸ್ತೆಯಿಂದ ಹೊರಗೆ';

  @override
  String get deallocPhotographVehicleExactlyAsCame => 'ವಾಹನ ಮರಳಿದ ಸ್ಥಿತಿಯಲ್ಲೇ ಅದರ ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get deallocRcInsurancePuc => 'ಆರ್‌ಸಿ, ವಿಮೆ ಮತ್ತು ಪಿಯುಸಿ';

  @override
  String get deallocReadyAllocateAnotherRider => 'ಇನ್ನೊಬ್ಬ ರೈಡರ್‌ಗೆ ನೀಡಲು ಸಿದ್ಧ';

  @override
  String get deallocRecordVehicleCondition => 'ವಾಹನದ ಸ್ಥಿತಿ ದಾಖಲಿಸಿ';

  @override
  String get deallocRecordWhatComesBackWhat => 'ಏನು ಮರಳಿದೆ ಮತ್ತು ಏನು ಇಲ್ಲ ಎಂದು ದಾಖಲಿಸಿ';

  @override
  String get deallocRecoverableDamageRaiseMaintenanceJob => 'ವಸೂಲಿ ಮಾಡಬಹುದಾದ ಹಾನಿ, ನಿರ್ವಹಣಾ ಕೆಲಸ ದಾಖಲಿಸಿ';

  @override
  String get deallocReturnCondition => 'ಹಿಂತಿರುಗಿಸುವ ಸ್ಥಿತಿ';

  @override
  String get deallocReturnPhotos => 'ಹಿಂತಿರುಗಿಸುವ ಫೋಟೋಗಳು';

  @override
  String get deallocRiderConfirmation => 'ರೈಡರ್ ಖಚಿತಪಡಿಸುವಿಕೆ';

  @override
  String get deallocSendWorkshopFirst => 'ಮೊದಲು ವರ್ಕ್‌ಶಾಪ್‌ಗೆ ಕಳುಹಿಸಿ';

  @override
  String get deallocService => 'ಸೇವೆಯಲ್ಲಿ';

  @override
  String get deallocSetFleetStatus => 'ವಾಹನದ ಸ್ಥಿತಿ ನಿಗದಿಪಡಿಸಿ';

  @override
  String get deallocSetFleetStatus2 => 'ವಾಹನದ ಸ್ಥಿತಿ ನಿಗದಿಪಡಿಸಿ';

  @override
  String get deallocStopsTelemetryClosesShiftSettles =>
      'ಮಾಹಿತಿ ಬರುವುದು ನಿಲ್ಲುತ್ತದೆ, ಪಾಳಿ ಮುಚ್ಚುತ್ತದೆ ಮತ್ತು ಕೊನೆಯ ಟ್ರಿಪ್ ಇತ್ಯರ್ಥವಾಗುತ್ತದೆ.';

  @override
  String get deallocTeamLeadConfirmation => 'ತಂಡದ ಮುಖ್ಯಸ್ಥರ ಖಚಿತಪಡಿಸುವಿಕೆ';

  @override
  String get deallocTwoPartyVerification => 'ಎರಡೂ ಕಡೆಯ ಪರಿಶೀಲನೆ';

  @override
  String get deallocVehicleAngles => 'ವಾಹನದ ಕೋನಗಳು';

  @override
  String get deallocVehicleCondition => 'ವಾಹನದ ಸ್ಥಿತಿ';

  @override
  String get deallocVerification => 'ಪರಿಶೀಲನೆ';

  @override
  String get deallocWhatDamagedHowBadly => 'ಏನು ಹಾನಿಯಾಗಿದೆ, ಎಷ್ಟು ಕೆಟ್ಟದಾಗಿ';

  @override
  String get deploymentAcceptScooter => 'ಸ್ಕೂಟರ್ ಸ್ವೀಕರಿಸಿ';

  @override
  String get deploymentAcceptScooter2 => 'ಈ ಸ್ಕೂಟರ್ ಸ್ವೀಕರಿಸಬೇಕೆ?';

  @override
  String get deploymentAllSetUp => 'ನೀವು ಸಂಪೂರ್ಣ ಸಿದ್ಧರಿದ್ದೀರಿ';

  @override
  String get deploymentAlmostThere => 'ಬಹುತೇಕ ಮುಗಿಯಿತು';

  @override
  String get deploymentAmountDue => 'ಬಾಕಿ ಮೊತ್ತ';

  @override
  String get deploymentAwaitingVerification => 'ಪರಿಶೀಲನೆ ಬಾಕಿ ಇದೆ';

  @override
  String get deploymentAwaitingVerificationHint => 'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ಶೀಘ್ರದಲ್ಲೇ ಇದನ್ನು ದೃಢೀಕರಿಸುತ್ತಾರೆ.';

  @override
  String get deploymentCashHub => 'ಹಬ್‌ನಲ್ಲಿ ನಗದು';

  @override
  String get deploymentCheckEachItem => 'ಪ್ರತಿ ವಸ್ತುವನ್ನು ಪರಿಶೀಲಿಸಿ';

  @override
  String get deploymentCheckingWithFleetManagerEvery =>
      'ಪ್ರತಿ ಕೆಲವು ಕ್ಷಣಕ್ಕೂ ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ಬಳಿ ಕೇಳಲಾಗುತ್ತಿದೆ…';

  @override
  String get deploymentConfirmEveryItemHasBeen =>
      'ಪ್ರತಿ ವಸ್ತುವನ್ನೂ ತಂಡದ ಮುಖ್ಯಸ್ಥರ ಜೊತೆ ಪರಿಶೀಲಿಸಲಾಗಿದೆ ಮತ್ತು ಸ್ಕೂಟರ್ ಓಡಿಸಲು ಯೋಗ್ಯ ಎಂದು ನೀವು ಖಚಿತಪಡಿಸುತ್ತೀರಿ.';

  @override
  String get deploymentCouldNotLoadChecklist => 'ಪಟ್ಟಿ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get deploymentCouldNotLoadTraining => 'ತರಬೇತಿ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get deploymentCouldNotReachServer => 'ಸರ್ವರ್ ಸಂಪರ್ಕ ಸಿಗಲಿಲ್ಲ';

  @override
  String get deploymentCouldNotSubmitInspection => 'ಪರಿಶೀಲನೆ ಸಲ್ಲಿಸಲು ಆಗಲಿಲ್ಲ';

  @override
  String get deploymentDone => 'ಮುಗಿಯಿತು';

  @override
  String get deploymentEnterTransactionReferencePaidWith => 'ಪಾವತಿಸಿದ ವ್ಯವಹಾರ ಉಲ್ಲೇಖ ಬರೆಯಿರಿ';

  @override
  String get deploymentFinishHygieneCheck => 'ಸ್ವಚ್ಛತಾ ಪರಿಶೀಲನೆ ಮುಗಿಸಿ';

  @override
  String get deploymentFlagAsProblem => 'ಸಮಸ್ಯೆ ಎಂದು ಗುರುತಿಸಿ';

  @override
  String get deploymentFlaggedByRider => 'ರೈಡರ್ ಗುರುತಿಸಿದ್ದಾರೆ';

  @override
  String get deploymentFleetManagerHasNotAsked => 'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ಇನ್ನೂ ಪಾವತಿ ಕೇಳಿಲ್ಲ.';

  @override
  String get deploymentFleetManagerHasNotSubmitted => 'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ಇನ್ನೂ ಪರಿಶೀಲನೆ ಸಲ್ಲಿಸಿಲ್ಲ.';

  @override
  String get deploymentFleetManagerPreparingVehicleIts =>
      'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ವಾಹನವನ್ನು ಸಿದ್ಧಪಡಿಸುತ್ತಿದ್ದಾರೆ. ಸಿದ್ಧವಾದ ಕೂಡಲೇ ಪಾವತಿ ವಿವರ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get deploymentFleetManagerPuttingTogetherPayment =>
      'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ಪಾವತಿ ವಿವರ ಸಿದ್ಧಪಡಿಸುತ್ತಿದ್ದಾರೆ. ಸ್ವಲ್ಪ ಹೊತ್ತಿನಲ್ಲಿ ಪಾವತಿಸಲು ಕೇಳಲಾಗುತ್ತದೆ.';

  @override
  String get deploymentFleetManagerWillAllocateScooter =>
      'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ನಿಮಗೆ ಸ್ಕೂಟರ್ ನೀಡುತ್ತಾರೆ. ಹಾಗಾದ ಕೂಡಲೇ ನಾವು ನಿಮ್ಮನ್ನು ನೇರವಾಗಿ ಇಲ್ಲಿಗೆ ಕರೆತರುತ್ತೇವೆ.';

  @override
  String get deploymentGoThroughEachItemWith =>
      'ಪ್ರತಿ ವಸ್ತುವನ್ನೂ ನಿಮ್ಮ ತಂಡದ ಮುಖ್ಯಸ್ಥರ ಜೊತೆ ಪರಿಶೀಲಿಸಿ. ಸರಿ ಇಲ್ಲದ್ದನ್ನು ಗುರುತಿಸಿ, ಅದು ನಿಮ್ಮ ಟಿಪ್ಪಣಿಯೊಂದಿಗೆ ವರ್ಕ್‌ಶಾಪ್‌ಗೆ ಹೋಗುತ್ತದೆ.';

  @override
  String get deploymentHygieneComplete => 'ಸ್ವಚ್ಛತಾ ಪರಿಶೀಲನೆ ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String get deploymentInspection => 'ಪರಿಶೀಲನೆ';

  @override
  String get deploymentInspectionAccepted => 'ಪರಿಶೀಲನೆ ಸ್ವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get deploymentItemsMarkedAsProblemGo =>
      'ಸಮಸ್ಯೆ ಎಂದು ಗುರುತಿಸಿದ ವಸ್ತುಗಳು ನಿಮ್ಮ ಟಿಪ್ಪಣಿಯೊಂದಿಗೆ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್‌ಗೆ ಹೋಗುತ್ತವೆ. ಉಳಿದವುಗಳ ಮೇಲೆ ಹಸ್ತಾಂತರ ಮುಂದುವರಿಯುತ್ತದೆ.';

  @override
  String deploymentManagerNextStep(String vehicle) {
    return 'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ $vehicle ನ ಮುಂದಿನ ಹಂತದಲ್ಲಿದ್ದಾರೆ.';
  }

  @override
  String get deploymentNoPaymentShow => 'ತೋರಿಸಲು ಪಾವತಿ ಇಲ್ಲ';

  @override
  String get deploymentNoteWorkshopTeam => 'ವರ್ಕ್‌ಶಾಪ್ ತಂಡಕ್ಕೆ ಟಿಪ್ಪಣಿ';

  @override
  String get deploymentOpenEachModuleReadThrough =>
      'ಪ್ರತಿ ಪಾಠ ತೆರೆದು ಪೂರ್ತಿ ಓದಿ. ಕಡ್ಡಾಯ ಪಾಠ ಮುಗಿಸದೆ ನೀವು ಪೂರ್ಣಗೊಳಿಸಲಾಗದು.';

  @override
  String get deploymentPaidVia => 'ಇದರ ಮೂಲಕ ಪಾವತಿ';

  @override
  String get deploymentPaymentReceived => 'ಪಾವತಿ ಸ್ವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String deploymentPaymentRejectedBody(String reason) {
    return 'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ಈ ಪಾವತಿಯನ್ನು ದೃಢೀಕರಿಸಲಾಗಲಿಲ್ಲ: $reason. ವಿವರಗಳನ್ನು ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಕಳುಹಿಸಿ.';
  }

  @override
  String get deploymentPaymentRejectedTitle => 'ಪಾವತಿ ದೃಢೀಕರಿಸಲಾಗಿಲ್ಲ';

  @override
  String get deploymentPaymentSubmitted => 'ಪಾವತಿ ಸಲ್ಲಿಸಲಾಗಿದೆ';

  @override
  String get deploymentPaymentSupport =>
      'ಈ ಪಾವತಿಯನ್ನು ಈಗ ಆ್ಯಪ್‌ನಿಂದ ಕಳುಹಿಸಲು ಆಗುವುದಿಲ್ಲ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಹಬ್ ಅಥವಾ ಸಪೋರ್ಟ್ ಅನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get deploymentPayScooter => 'ನಿಮ್ಮ ಸ್ಕೂಟರ್‌ಗೆ ಪಾವತಿಸಿ';

  @override
  String get deploymentPlanAcceptedSnack => 'ಪ್ಲಾನ್ ಒಪ್ಪಲಾಗಿದೆ. ಮುಂದೆ ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ಪಾವತಿ ಕೇಳುತ್ತಾರೆ.';

  @override
  String get deploymentPlanCouldNotLoad => 'ನಿಮ್ಮ ಪ್ಲಾನ್ ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get deploymentPlanIntro =>
      'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ನಿಮಗಾಗಿ ಈ ಪ್ಲಾನ್ ಆಯ್ಕೆಮಾಡಿದ್ದಾರೆ. ಬಾಡಿಗೆ ಮತ್ತು ಇಂದು ಪಾವತಿಸಬೇಕಾದ ಮೊತ್ತ ನೋಡಿ, ನಂತರ ಮುಂದುವರಿಯಲು ಒಪ್ಪಿ.';

  @override
  String get deploymentPlanNextPayment => 'ನೀವು ಈ ಪ್ಲಾನ್ ಒಪ್ಪಿದ್ದೀರಿ. ಮುಂದೆ ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ಪಾವತಿ ಕೇಳುತ್ತಾರೆ.';

  @override
  String get deploymentPlanTitle => 'ನಿಮ್ಮ ಬಾಡಿಗೆ ಪ್ಲಾನ್';

  @override
  String get deploymentPreparingScooter => 'ನಿಮ್ಮ ಸ್ಕೂಟರ್ ಸಿದ್ಧವಾಗುತ್ತಿದೆ';

  @override
  String get deploymentProgressSavedSignAgainAny =>
      'ನಿಮ್ಮ ಪ್ರಗತಿ ಉಳಿಸಲಾಗಿದೆ. ಯಾವಾಗ ಬೇಕಾದರೂ ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಿ ಅಲ್ಲಿಂದಲೇ ಮುಂದುವರಿಸಿ.';

  @override
  String get deploymentReceiptAdd => 'ಸ್ಕ್ರೀನ್‌ಶಾಟ್ ಸೇರಿಸಿ';

  @override
  String get deploymentReceiptAdded => 'ಸ್ಕ್ರೀನ್‌ಶಾಟ್ ಸೇರಿಸಲಾಗಿದೆ';

  @override
  String get deploymentReceiptsSent => 'ಕಳುಹಿಸಿದ ಸ್ಕ್ರೀನ್‌ಶಾಟ್‌ಗಳು';

  @override
  String get deploymentReceiptTitle => 'ಪಾವತಿಯ ಸ್ಕ್ರೀನ್‌ಶಾಟ್ (ಐಚ್ಛಿಕ)';

  @override
  String get deploymentReceiptTooLarge => 'ಈ ಚಿತ್ರ 5 MB ಗಿಂತ ದೊಡ್ಡದಿದೆ. ಚಿಕ್ಕದನ್ನು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get deploymentReference => 'ಉಲ್ಲೇಖ';

  @override
  String get deploymentReferenceReceiptNumber => 'ಉಲ್ಲೇಖ ಅಥವಾ ರಸೀದಿ ಸಂಖ್ಯೆ';

  @override
  String get deploymentRequired => 'ಅಗತ್ಯ';

  @override
  String get deploymentRide => 'ಸವಾರಿ';

  @override
  String get deploymentRiderHygiene => 'ರೈಡರ್ ಸ್ವಚ್ಛತೆ';

  @override
  String get deploymentScooterReserved => 'ಸ್ಕೂಟರ್ ಕಾಯ್ದಿರಿಸಲಾಗಿದೆ';

  @override
  String get deploymentSubmitted => 'ಸಲ್ಲಿಸಲಾಗಿದೆ';

  @override
  String get deploymentSubmitWithProblemsFlagged => 'ಸಮಸ್ಯೆಗಳನ್ನು ಗುರುತಿಸಿ ಸಲ್ಲಿಸಬೇಕೆ?';

  @override
  String get deploymentTransactionReference => 'ವ್ಯವಹಾರ ಉಲ್ಲೇಖ';

  @override
  String get deploymentWaitingAllocation => 'ಹಂಚಿಕೆಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get deploymentWhatWrong => 'ಏನು ತೊಂದರೆ?';

  @override
  String deploymentWritingPdi(String vehicle) {
    return 'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ $vehicle ನ ವಿತರಣಾಪೂರ್ವ ಪರಿಶೀಲನೆ ಬರೆಯುತ್ತಿದ್ದಾರೆ. ಮುಂದೆ ನೀವು ಅದನ್ನು ನೋಡುತ್ತೀರಿ.';
  }

  @override
  String get deploymentYourPlan => 'ನಿಮ್ಮ ಪ್ಲಾನ್';

  @override
  String get errorActiveScooterRequired => 'ಇದಕ್ಕೆ ನಿಮಗೆ ಸ್ಕೂಟರ್ ನೀಡಿರಬೇಕು.';

  @override
  String get errorCouldNotReachServerCheck => 'ಸರ್ವರ್ ಸಂಪರ್ಕ ಸಿಗಲಿಲ್ಲ. ನಿಮ್ಮ ಸಂಪರ್ಕ ಪರಿಶೀಲಿಸಿ.';

  @override
  String get errorDidNotLookRight => 'ಇದು ಸರಿ ಕಾಣಲಿಲ್ಲ.';

  @override
  String get errorInspectionWithRider => 'ಪರಿಶೀಲನೆ ರೈಡರ್ ಬಳಿ';

  @override
  String get errorPaymentPending => 'ಪಾವತಿ ಬಾಕಿ';

  @override
  String get errorRiderProfileMissing => 'ರೈಡರ್ ಪ್ರೊಫೈಲ್ ಸಿಗಲಿಲ್ಲ.';

  @override
  String get errorServerTookTooLongAnswer => 'ಸರ್ವರ್ ಉತ್ತರಿಸಲು ತುಂಬಾ ಸಮಯ ತೆಗೆದುಕೊಂಡಿತು.';

  @override
  String get errorSessionHasExpiredSignAgain => 'ನಿಮ್ಮ ಸೆಷನ್ ಮುಗಿದಿದೆ. ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get errorTrainingProgress => 'ತರಬೇತಿ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get errorUnknown => 'ಗೊತ್ತಿಲ್ಲ';

  @override
  String get esignAddNameFirst => 'ಮೊದಲು ಪ್ರೊಫೈಲ್ ಹಂತದಲ್ಲಿ ನಿಮ್ಮ ಪೂರ್ಣ ಹೆಸರನ್ನು ಸೇರಿಸಿ';

  @override
  String get esignSigned => 'ಸಹಿ ಮಾಡಲಾಗಿದೆ';

  @override
  String get esignTapToSign => 'ಸಹಿ ಮಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get esignTitle => 'ನಿಮ್ಮ ಇ-ಸಹಿ';

  @override
  String get esignYourName => 'ನಿಮ್ಮ ಹೆಸರು';

  @override
  String get exchangeAcceptConfirm => 'ಸ್ವೀಕರಿಸಿದರೆ ಈ ಸ್ಕೂಟರ್‌ನ ಹೊಸ ನಿಯಮಗಳಿಗೆ ನೀವು ಒಪ್ಪಿದಂತೆ.';

  @override
  String get exchangeAccepted => 'ಆಫರ್ ಸ್ವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get exchangeAcceptedOfferTitle => 'ನಿಮ್ಮ ಹೊಸ ಪ್ಲಾನ್';

  @override
  String get exchangeAcceptOffer => 'ಆಫರ್ ಸ್ವೀಕರಿಸಿ';

  @override
  String get exchangeAgreementHistory => 'ಒಪ್ಪಂದದ ಇತಿಹಾಸ';

  @override
  String get exchangeCancelConfirm => 'ಈ ಮನವಿಯನ್ನು ಮುಚ್ಚಲಾಗುತ್ತದೆ.';

  @override
  String get exchangeCancelled => 'ಮನವಿ ರದ್ದಾಗಿದೆ';

  @override
  String get exchangeCancelRequest => 'ಮನವಿ ರದ್ದುಮಾಡಿ';

  @override
  String get exchangeChooseReason => 'ನಿಮಗೆ ಬದಲಾವಣೆ ಯಾಕೆ ಬೇಕು?';

  @override
  String get exchangeCompleted => 'ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String get exchangeConsent => 'ನಾನು ಈ ಆಫರ್ ಅನ್ನು ಓದಿದ್ದೇನೆ ಮತ್ತು ಒಪ್ಪುತ್ತೇನೆ';

  @override
  String get exchangeCouldNotLoad => 'ಬದಲಾವಣೆ ಮಾಹಿತಿ ಸಿಗಲಿಲ್ಲ';

  @override
  String get exchangeCurrentScooter => 'ಈಗಿನ ಸ್ಕೂಟರ್';

  @override
  String exchangeDepositDue(String amount) {
    return 'ಹೊಸ ಸ್ಕೂಟರ್ ಪಡೆಯುವ ಮೊದಲು ಇನ್ನೂ $amount ಠೇವಣಿ ಪಾವತಿಸಿ.';
  }

  @override
  String get exchangeDepositHeld => 'ಹಬ್ ಬಳಿ ಉಳಿದ ಹೆಚ್ಚುವರಿ ಠೇವಣಿ';

  @override
  String get exchangeDepositMoved => 'ವರ್ಗಾಯಿಸಿದ ಠೇವಣಿ';

  @override
  String get exchangeDepositRefund => 'ಠೇವಣಿ ಮರುಪಾವತಿ';

  @override
  String get exchangeDepositToPay => 'ಪಾವತಿಸಬೇಕಾದ ಹೆಚ್ಚುವರಿ ಠೇವಣಿ';

  @override
  String get exchangeDetails => 'ಮನವಿಯ ವಿವರಗಳು';

  @override
  String get exchangeDetailTitle => 'ಬದಲಾವಣೆ ಮನವಿ';

  @override
  String get exchangeErrorAlreadyReturned => 'ಹಳೆಯ ಸ್ಕೂಟರ್ ಈಗಾಗಲೇ ಹಿಂದಿರುಗಿಸಲಾಗಿದೆ.';

  @override
  String get exchangeErrorBatteryPlan => 'ಈ ಸ್ಕೂಟರ್‌ಗೆ ರೈಡರ್‌ನ ಬ್ಯಾಟರಿ ಪ್ಲಾನ್ ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get exchangeErrorBillingChanged => 'ಆಫರ್ ಸ್ವೀಕರಿಸಿದ ನಂತರ ಬಿಲ್ಲಿಂಗ್ ಬದಲಾಗಿದೆ. ದಯವಿಟ್ಟು ಸಪೋರ್ಟ್ ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get exchangeErrorCannotCancel =>
      'ನಿಮ್ಮ ಸ್ಕೂಟರ್ ಈಗಾಗಲೇ ಹಿಂದಿರುಗಿಸಲಾಗಿದೆ, ಆದ್ದರಿಂದ ಇಲ್ಲಿ ಮನವಿ ರದ್ದುಮಾಡಲು ಆಗುವುದಿಲ್ಲ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಹಬ್ ಅನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get exchangeErrorChanged => 'ಈ ಮನವಿ ಈಗಷ್ಟೇ ಬದಲಾಗಿದೆ. ಕೆಳಗೆ ಎಳೆದು ರಿಫ್ರೆಶ್ ಮಾಡಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get exchangeErrorDepositsUnsettled => 'ಠೇವಣಿ ಇನ್ನೂ ಹೊಂದಿಸಿಲ್ಲ. ಮೊದಲು ಠೇವಣಿ ಹೊಂದಿಸಿ.';

  @override
  String get exchangeErrorDisabled => 'ಈಗ ವಾಹನ ಬದಲಾವಣೆ ಲಭ್ಯವಿಲ್ಲ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಹಬ್ ಅನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get exchangeErrorDuesPending =>
      'ಮೊದಲು ನಿಮ್ಮ ಬಾಕಿ ಪಾವತಿಸಿ. ವಾಹನ ಕೆಟ್ಟಿದ್ದರೆ ಅಥವಾ ಸುರಕ್ಷತೆಗಾಗಿ ಬದಲಾವಣೆ ಈಗಲೂ ಸಾಧ್ಯ.';

  @override
  String get exchangeErrorHandoverUnfinished => 'ಹೊಸ ಸ್ಕೂಟರ್ ಇನ್ನೂ ಹಸ್ತಾಂತರಿಸಿಲ್ಲ. ಮೊದಲು ಹಸ್ತಾಂತರದ ಹಂತಗಳನ್ನು ಮುಗಿಸಿ.';

  @override
  String get exchangeErrorHoldExpired => 'ಸ್ಕೂಟರ್ ಕಾಯ್ದಿರಿಸುವಿಕೆ ಅವಧಿ ಮುಗಿದಿದೆ. ಬದಲಿಯನ್ನು ಮತ್ತೆ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get exchangeErrorInspectionUnfinished => 'ಮೊದಲು ಹಿಂದಿರುಗಿಸುವಿಕೆ ತಪಾಸಣೆ ಪೂರ್ಣಗೊಳಿಸಿ.';

  @override
  String get exchangeErrorNoRental => 'ನಿಮ್ಮ ಸಕ್ರಿಯ ಬಾಡಿಗೆ ಕಂಡುಬಂದಿಲ್ಲ.';

  @override
  String get exchangeErrorNotEligible => 'ರೈಡರ್ ಈ ಸ್ಕೂಟರ್‌ಗೆ ಅರ್ಹರಲ್ಲ.';

  @override
  String get exchangeErrorNoTerms => 'ರೈಡರ್ ನಿಯಮಗಳು ಹೊಂದಿಸಿಲ್ಲ. ಒಂದು ಸಕ್ರಿಯ ನಿಯಮಾವಳಿ ಪ್ರಕಟಿಸಲು ಅಡ್ಮಿನ್‌ಗೆ ಹೇಳಿ.';

  @override
  String get exchangeErrorNotFound => 'ಈ ಬದಲಾವಣೆ ಮನವಿ ಈಗ ಇಲ್ಲ.';

  @override
  String get exchangeErrorOfferClosed => 'ಈ ಆಫರ್ ಈಗ ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get exchangeErrorOfferInvalid => 'ಈ ಆಫರ್ ಪರಿಶೀಲಿಸಲು ಆಗಲಿಲ್ಲ. ನಿಮ್ಮ ಹಬ್‌ಗೆ ಮತ್ತೆ ಕಳುಹಿಸಲು ಹೇಳಿ.';

  @override
  String get exchangeErrorPricingSetup => 'ಈ ಸ್ಕೂಟರ್‌ಗೆ ಬೆಲೆ ಇನ್ನೂ ಹೊಂದಿಸಿಲ್ಲ. ರೇಟ್ ಕಾರ್ಡ್ ಪರಿಶೀಲಿಸಲು ಆಪರೇಟರ್‌ಗೆ ಹೇಳಿ.';

  @override
  String get exchangeErrorRecordsMissing => 'ಈ ಬದಲಾವಣೆಯ ಕೆಲವು ದಾಖಲೆಗಳು ಕಾಣೆಯಾಗಿವೆ. ದಯವಿಟ್ಟು ಸಪೋರ್ಟ್ ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get exchangeErrorRentalInactive => 'ನಿಮ್ಮ ಬಾಡಿಗೆ ಸಕ್ರಿಯವಾಗಿಲ್ಲ, ಆದ್ದರಿಂದ ಬದಲಾವಣೆ ಮನವಿ ಕಳುಹಿಸಲು ಆಗುವುದಿಲ್ಲ.';

  @override
  String get exchangeErrorReturnFirst => 'ಬದಲಿ ಆಯ್ಕೆಮಾಡುವ ಮೊದಲು ಹಳೆಯ ಸ್ಕೂಟರ್ ಹಿಂದಿರುಗಿಸುವಿಕೆ ಮುಗಿಸಿ.';

  @override
  String get exchangeErrorReturnUnfinished =>
      'ಹಿಂದಿರುಗಿಸುವಿಕೆ ಇನ್ನೂ ಮುಗಿದಿಲ್ಲ. ಮೊದಲು ರೈಡರ್ OTP ಪರಿಶೀಲಿಸಿ ಮತ್ತು ಹಿಂದಿರುಗಿಸುವಿಕೆ ಪೂರ್ಣಗೊಳಿಸಿ.';

  @override
  String get exchangeErrorSameScooter => 'ರೈಡರ್‌ನ ಈಗಿನ ಸ್ಕೂಟರ್‌ಗಿಂತ ಬೇರೆಯದನ್ನು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get exchangeErrorScooterReserved => 'ಆ ಸ್ಕೂಟರ್ ಬೇರೆ ಬದಲಾವಣೆಗೆ ಕಾಯ್ದಿರಿಸಲಾಗಿದೆ.';

  @override
  String get exchangeErrorScooterUnavailable => 'ಆ ಸ್ಕೂಟರ್ ಈಗ ಲಭ್ಯವಿಲ್ಲ. ಬೇರೆಯದನ್ನು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get exchangeErrorSecurityChange =>
      'ಈ ಸ್ಕೂಟರ್‌ಗೆ ಬೇರೆ ಭದ್ರತಾ ಠೇವಣಿ ಬೇಕು. ಮೊದಲು ಠೇವಣಿಯನ್ನು ಪ್ರತ್ಯೇಕವಾಗಿ ಬದಲಿಸಿ.';

  @override
  String get exchangeErrorSecurityTopUp => 'ಪೂರ್ಣಗೊಳಿಸುವ ಮೊದಲು ರೈಡರ್ ಭದ್ರತಾ ಠೇವಣಿ ತುಂಬಬೇಕು.';

  @override
  String get exchangeErrorStale => 'ಈ ಆಫರ್ ನಂತರ ನಿಮ್ಮ ಬಾಡಿಗೆ ಬದಲಾಗಿದೆ. ನಿಮ್ಮ ಹಬ್‌ನಿಂದ ಹೊಸ ಆಫರ್ ಕೇಳಿ.';

  @override
  String get exchangeErrorTooSoon =>
      'ಈ ಸ್ಕೂಟರ್ ನಿಮಗೆ ಸಿಕ್ಕಿ ಸ್ವಲ್ಪ ದಿನಗಳಷ್ಟೇ ಆಗಿದೆ. ಕೆಲವು ದಿನಗಳ ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get exchangeExtraRentNow => 'ಈಗ ಹೆಚ್ಚುವರಿ ಬಾಡಿಗೆ';

  @override
  String get exchangeFee => 'ಬದಲಾವಣೆ ಶುಲ್ಕ';

  @override
  String get exchangeFeeWaived => 'ಮನ್ನಾ';

  @override
  String get exchangeHubReason => 'ಹಬ್ ನೀಡಿದ ಕಾರಣ';

  @override
  String get exchangeNeedsYou => 'ನಿಮ್ಮ ಉತ್ತರ ಬೇಕು';

  @override
  String get exchangeNewRent => 'ಹೊಸ ಬಾಡಿಗೆ';

  @override
  String get exchangeNewRentFrom => 'ಹೊಸ ಬಾಡಿಗೆ ಆರಂಭ';

  @override
  String get exchangeNewScooter => 'ಹೊಸ ಸ್ಕೂಟರ್';

  @override
  String get exchangeNone => 'ಯಾವುದೇ ಮನವಿ ಇಲ್ಲ';

  @override
  String get exchangeNoneMessage => 'ನಿಮ್ಮ ಸ್ಕೂಟರ್‌ನಲ್ಲಿ ಸಮಸ್ಯೆ ಇದ್ದರೆ, ಬದಲಾವಣೆಗೆ ಮನವಿ ಮಾಡಿ, ನಿಮ್ಮ ಹಬ್ ಸಹಾಯ ಮಾಡುತ್ತದೆ.';

  @override
  String get exchangeNoRentalBody => 'ಸ್ಕೂಟರ್ ಬಾಡಿಗೆಗೆ ಸಿಕ್ಕ ನಂತರ ನೀವು ಬದಲಾವಣೆಗೆ ಮನವಿ ಮಾಡಬಹುದು.';

  @override
  String get exchangeNoRentalTitle => 'ಸಕ್ರಿಯ ಬಾಡಿಗೆ ಇಲ್ಲ';

  @override
  String get exchangeNoteHint => 'ಸಮಸ್ಯೆಯನ್ನು ವಿವರಿಸಿ (ಐಚ್ಛಿಕ)';

  @override
  String get exchangeNoteLabel => 'ಹಬ್‌ಗೆ ಟಿಪ್ಪಣಿ';

  @override
  String get exchangeNotes => 'ನಿಮ್ಮ ಟಿಪ್ಪಣಿ';

  @override
  String get exchangeOfferExpiredMessage => 'ಈ ಆಫರ್ ಅವಧಿ ಮುಗಿದಿದೆ. ನಿಮ್ಮ ಹಬ್ ಹೊಸದನ್ನು ಕಳುಹಿಸಬಹುದು.';

  @override
  String get exchangeOfferExpires => 'ಆಫರ್ ಮಾನ್ಯತೆ';

  @override
  String get exchangeOfferTitle => 'ನಿಮ್ಮ ಆಫರ್';

  @override
  String get exchangeOpen => 'ನಡೆಯುತ್ತಿದೆ';

  @override
  String get exchangeOpenExists => 'ನಿಮ್ಮ ಒಂದು ಬದಲಾವಣೆ ಈಗಾಗಲೇ ನಡೆಯುತ್ತಿದೆ.';

  @override
  String get exchangePast => 'ಮುಗಿದಿದೆ';

  @override
  String get exchangePerDay => '/ ದಿನ';

  @override
  String get exchangePerFortnight => '/ 2 ವಾರ';

  @override
  String get exchangePerMonth => '/ ತಿಂಗಳು';

  @override
  String get exchangePerQuarter => '/ 3 ತಿಂಗಳು';

  @override
  String get exchangePerWeek => '/ ವಾರ';

  @override
  String get exchangeProgress => 'ಪ್ರಗತಿ';

  @override
  String get exchangeRaised => 'ಸಲ್ಲಿಸಿದ್ದು';

  @override
  String get exchangeReason => 'ಕಾರಣ';

  @override
  String get exchangeReasonBreakdown => 'ವಾಹನ ಕೆಟ್ಟಿದೆ';

  @override
  String get exchangeReasonBreakdownHint => 'ಸ್ಕೂಟರ್ ನಿಂತುಹೋಗಿದೆ ಅಥವಾ ಪದೇ ಪದೇ ಕೆಡುತ್ತಿದೆ';

  @override
  String get exchangeReasonOtherHint => 'ಬೇರೆ ಕಾರಣ';

  @override
  String get exchangeReasonSafety => 'ಸುರಕ್ಷತೆ ಬದಲಾವಣೆ';

  @override
  String get exchangeReasonSafetyHint => 'ಸುರಕ್ಷತಾ ತಪಾಸಣೆಯ ಕಾರಣ ಬೇರೆ ಸ್ಕೂಟರ್ ಬೇಕು';

  @override
  String get exchangeReasonUnsafe => 'ಓಡಿಸಲು ಸುರಕ್ಷಿತವಲ್ಲ';

  @override
  String get exchangeReasonUnsafeHint => 'ಬ್ರೇಕ್, ಲೈಟ್ ಅಥವಾ ಟೈರ್ ಸುರಕ್ಷಿತವಾಗಿಲ್ಲ';

  @override
  String get exchangeReasonUpgrade => 'ಅಪ್‌ಗ್ರೇಡ್';

  @override
  String get exchangeReasonUpgradeHint => 'ನಿಮಗೆ ಬೇರೆ ಮಾದರಿ ಬೇಕು';

  @override
  String get exchangeRejected => 'ಆಫರ್ ನಿರಾಕರಿಸಲಾಗಿದೆ';

  @override
  String get exchangeRejectOffer => 'ಆಫರ್ ನಿರಾಕರಿಸಿ';

  @override
  String get exchangeRejectReason => 'ಕಾರಣ';

  @override
  String get exchangeRejectReasonRequired => 'ದಯವಿಟ್ಟು ಕಾರಣ ಬರೆಯಿರಿ';

  @override
  String get exchangeRejectSubtitle => 'ಕಾರಣವನ್ನು ನಿಮ್ಮ ಹಬ್‌ಗೆ ತಿಳಿಸಿ, ಅವರು ಉತ್ತಮವಾದದ್ದನ್ನು ಕಳುಹಿಸಬಹುದು.';

  @override
  String get exchangeRentalCouldNotLoad => 'ನಿಮ್ಮ ಬಾಡಿಗೆ ಲೋಡ್ ಆಗಲಿಲ್ಲ';

  @override
  String get exchangeRentCredit => 'ಬಾಡಿಗೆ ಕ್ರೆಡಿಟ್';

  @override
  String get exchangeRequestAction => 'ಬದಲಾವಣೆಗೆ ಮನವಿ ಮಾಡಿ';

  @override
  String get exchangeRequestSent => 'ಬದಲಾವಣೆ ಮನವಿ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get exchangeRequestSubtitle => 'ನಿಮಗೆ ಬೇರೆ ಸ್ಕೂಟರ್ ಯಾಕೆ ಬೇಕು ಎಂದು ನಿಮ್ಮ ಹಬ್‌ಗೆ ತಿಳಿಸಿ.';

  @override
  String get exchangeReturnDate => 'ಒಪ್ಪಿಸುವ ದಿನಾಂಕ';

  @override
  String get exchangeSendRequest => 'ಮನವಿ ಕಳುಹಿಸಿ';

  @override
  String get exchangeStageAccepted => 'ಸ್ವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get exchangeStageCompleted => 'ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String get exchangeStageHandover => 'ಹಸ್ತಾಂತರ';

  @override
  String get exchangeStageOfferReady => 'ಆಫರ್ ಸಿದ್ಧ';

  @override
  String get exchangeStageRequested => 'ಮನವಿ ಸಲ್ಲಿಸಲಾಗಿದೆ';

  @override
  String get exchangeStatusApproved => 'ಅನುಮೋದಿಸಲಾಗಿದೆ';

  @override
  String get exchangeStatusCancelled => 'ರದ್ದಾಗಿದೆ';

  @override
  String get exchangeStatusCheckingIn => 'ಎಕ್ಸ್‌ಚೇಂಜ್ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get exchangeStatusChoosing => 'ಸ್ಕೂಟರ್ ಆಯ್ಕೆಯಾಗುತ್ತಿದೆ';

  @override
  String get exchangeStatusExpired => 'ಅವಧಿ ಮುಗಿದಿದೆ';

  @override
  String get exchangeStatusRejected => 'ತಿರಸ್ಕರಿಸಲಾಗಿದೆ';

  @override
  String get exchangeStatusReturn => 'ಸ್ಕೂಟರ್ ಹಿಂದಿರುಗಿಸಿ';

  @override
  String get exchangeStepApproval => 'ಹಬ್ ಅನುಮೋದನೆ';

  @override
  String get exchangeStepDeposit => 'ಠೇವಣಿ';

  @override
  String get exchangeStepHandover => 'ಹೊಸ ಸ್ಕೂಟರ್ ಪಡೆಯುವುದು';

  @override
  String get exchangeStepOffer => 'ಹೊಸ ಸ್ಕೂಟರ್ ಆಫರ್';

  @override
  String get exchangeStepRequested => 'ಮನವಿ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get exchangeStepReturn => 'ಹಳೆಯ ಸ್ಕೂಟರ್ ಹಿಂದಿರುಗಿಸುವುದು';

  @override
  String get exchangeSubtitle => 'ಬೇರೆ ಸ್ಕೂಟರ್‌ಗಾಗಿ ಕೇಳಿ';

  @override
  String get exchangeTitle => 'ವಾಹನ ಬದಲಾವಣೆ';

  @override
  String get exchangeVersionCurrent => 'ಪ್ರಸ್ತುತ';

  @override
  String exchangeVersionFrom(String date) {
    return '$date ರಿಂದ';
  }

  @override
  String exchangeVersionNumber(String number) {
    return 'ಆವೃತ್ತಿ $number';
  }

  @override
  String get exchangeVersionPrevious => 'ಹಿಂದಿನ';

  @override
  String get exchangeWhenWhere => 'ಯಾವಾಗ ಮತ್ತು ಎಲ್ಲಿ';

  @override
  String get exchangeWhenWhereHint => 'ನಿಮ್ಮ ಈಗಿನ ಸ್ಕೂಟರ್ ಅನ್ನು ಯಾವಾಗ ಮತ್ತು ಎಲ್ಲಿಗೆ ತರುತ್ತೀರಿ ಎಂದು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get fleetOnboardingActive => 'ಸಕ್ರಿಯ';

  @override
  String get fleetOnboardingArchived => 'ಆರ್ಕೈವ್ ಮಾಡಲಾಗಿದೆ';

  @override
  String get fleetOnboardingDraft => 'ಕರಡು';

  @override
  String get fleetOnboardingInProgress => 'ಪ್ರಗತಿಯಲ್ಲಿದೆ';

  @override
  String get fleetOnboardingPendingReview => 'ಪರಿಶೀಲನೆಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get fleetOnboardingRejected => 'ತಿರಸ್ಕೃತ';

  @override
  String get fleetSearchAllocationActive => 'ರೈಡರ್ ಬಳಿ';

  @override
  String get fleetSearchAllocationCancelled => 'ರದ್ದಾಗಿದೆ';

  @override
  String get fleetSearchAllocationHandover => 'ಹಸ್ತಾಂತರ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get fleetSearchAllocationReturned => 'ಹಿಂತಿರುಗಿಸಲಾಗಿದೆ';

  @override
  String get fleetSearchAllocationReturning => 'ರಿಟರ್ನ್ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get fleetSearchCouldNotLoad => 'ಸ್ಕೂಟರ್‌ಗಳನ್ನು ಹುಡುಕಲು ಆಗಲಿಲ್ಲ';

  @override
  String get fleetSearchCouldNotLoadRiderHistory => 'ರೈಡರ್ ಇತಿಹಾಸ ಲೋಡ್ ಮಾಡಲು ಆಗಲಿಲ್ಲ';

  @override
  String get fleetSearchCouldNotLoadScooter => 'ಈ ಸ್ಕೂಟರ್ ಲೋಡ್ ಮಾಡಲು ಆಗಲಿಲ್ಲ';

  @override
  String get fleetSearchCurrentRider => 'ಪ್ರಸ್ತುತ ರೈಡರ್';

  @override
  String get fleetSearchEmptyMessage => 'ವಾಹನ ಸಂಖ್ಯೆ, ಫ್ಲೀಟ್ ಕೋಡ್ ಅಥವಾ ಚಾಸಿಸ್ ಸಂಖ್ಯೆ ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get fleetSearchEmptyTitle => 'ಯಾವುದೇ ಸ್ಕೂಟರ್ ಸಿಗಲಿಲ್ಲ';

  @override
  String get fleetSearchHint => 'ಸಂಖ್ಯೆ, ಕೋಡ್ ಅಥವಾ ಚಾಸಿಸ್ ಮೂಲಕ ಸ್ಕೂಟರ್ ಹುಡುಕಿ';

  @override
  String get fleetSearchLatestSubmission => 'ಇತ್ತೀಚಿನ ರಿಟರ್ನ್ ಅಥವಾ ಎಕ್ಸ್‌ಚೇಂಜ್';

  @override
  String get fleetSearchNoRider => 'ಈಗ ಈ ಸ್ಕೂಟರ್ ಯಾವುದೇ ರೈಡರ್ ಬಳಿ ಇಲ್ಲ.';

  @override
  String get fleetSearchNoRiderHistory => 'ಇದುವರೆಗೆ ಈ ಸ್ಕೂಟರ್ ಯಾವುದೇ ರೈಡರ್‌ಗೆ ನೀಡಿಲ್ಲ.';

  @override
  String get fleetSearchNoSubmission => 'ಇನ್ನೂ ಯಾವುದೇ ರಿಟರ್ನ್ ಅಥವಾ ಎಕ್ಸ್‌ಚೇಂಜ್ ಆಗಿಲ್ಲ.';

  @override
  String get fleetSearchOtherHub => 'ಬೇರೆ ಹಬ್';

  @override
  String get fleetSearchRiderHistory => 'ರೈಡರ್ ಇತಿಹಾಸ';

  @override
  String get fleetSearchRiderHistoryOtherHub => 'ರೈಡರ್ ಇತಿಹಾಸ ನಿಮ್ಮ ಹಬ್‌ಗಳ ಸ್ಕೂಟರ್‌ಗಳಿಗೆ ಮಾತ್ರ ಕಾಣುತ್ತದೆ.';

  @override
  String fleetSearchSince(String date) {
    return '$date ರಿಂದ';
  }

  @override
  String get fleetSearchStartMessage => 'ವಾಹನ ಸಂಖ್ಯೆ, ಫ್ಲೀಟ್ ಕೋಡ್ ಅಥವಾ ಚಾಸಿಸ್ ಸಂಖ್ಯೆಯ ಕನಿಷ್ಠ 2 ಅಕ್ಷರಗಳನ್ನು ಟೈಪ್ ಮಾಡಿ.';

  @override
  String get fleetSearchStartTitle => 'ಎಲ್ಲಾ ಹಬ್‌ಗಳಲ್ಲಿ ಹುಡುಕಿ';

  @override
  String get fleetSearchSubmissionDone => 'ಮುಗಿದಿದೆ';

  @override
  String get fleetSearchSubmissionOpen => 'ಪ್ರಗತಿಯಲ್ಲಿದೆ';

  @override
  String get fleetSearchTitle => 'ಸ್ಕೂಟರ್ ಹುಡುಕಿ';

  @override
  String get fleetStatusAllocated => 'ಹಂಚಿಕೆಯಾಗಿದೆ';

  @override
  String get fleetStatusAllocating => 'ಹಂಚಿಕೆ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get fleetStatusAvailable => 'ಲಭ್ಯವಿದೆ';

  @override
  String get fleetStatusAwaitingParts => 'ಬಿಡಿಭಾಗಗಳಿಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get fleetStatusBroken => 'ಕೆಟ್ಟಿದೆ';

  @override
  String get fleetStatusInspectionPending => 'ತಪಾಸಣೆಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get fleetStatusInTransit => 'ಸಾಗಣೆಯಲ್ಲಿದೆ';

  @override
  String get fleetStatusInUse => 'ಬಳಕೆಯಲ್ಲಿದೆ';

  @override
  String get fleetStatusMaintenance => 'ನಿರ್ವಹಣೆಯಲ್ಲಿದೆ';

  @override
  String get fleetStatusOutOfService => 'ಸೇವೆಯಿಂದ ಹೊರಗಿದೆ';

  @override
  String get fleetStatusReserved => 'ಕಾಯ್ದಿರಿಸಲಾಗಿದೆ';

  @override
  String get fleetStatusReturning => 'ಹಿಂತಿರುಗಿಸಲಾಗುತ್ತಿದೆ';

  @override
  String get homeCouldNotLoadDashboard => 'ನಿಮ್ಮ ಡ್ಯಾಶ್‌ಬೋರ್ಡ್ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get homeDailyRental => 'ದೈನಂದಿನ ಬಾಡಿಗೆ';

  @override
  String get homeDepositsHandoverFees => 'ಠೇವಣಿ ಮತ್ತು ಹಸ್ತಾಂತರ ಶುಲ್ಕ';

  @override
  String get homeHelpSupport => 'ಸಹಾಯ ಮತ್ತು ಬೆಂಬಲ';

  @override
  String get homeHistory => 'ಇತಿಹಾಸ';

  @override
  String get homeLastPayment => 'ಕೊನೆಯ ಪಾವತಿ';

  @override
  String get homeMarkAbsent => 'ಗೈರು ಎಂದು ಗುರುತಿಸಿ';

  @override
  String get homeMarkedAbsentScooterNowDisabled => 'ಗೈರು ಎಂದು ಗುರುತಿಸಲಾಗಿದೆ. ಸ್ಕೂಟರ್ ಈಗ ಬಂದ್ ಆಗಿದೆ.';

  @override
  String get homeMarkYourselfAbsent => 'ನಿಮ್ಮನ್ನು ಗೈರು ಎಂದು ಗುರುತಿಸಬೇಕೆ?';

  @override
  String get homeMarkYourselfPresentSwitchVehicle => 'ವಾಹನ ಆನ್ ಮಾಡಲು ಮೊದಲು ಹಾಜರಾತಿ ಹಾಕಿ.';

  @override
  String homeNextDebitOn(String date) {
    return 'ಮುಂದಿನ ಕಡಿತ $date';
  }

  @override
  String get homeRent => 'ಬಾಡಿಗೆ';

  @override
  String get homeRentDue => 'ಬಾಕಿ ಬಾಡಿಗೆ';

  @override
  String homeRentDueOn(String date) {
    return 'ಪಾವತಿ ದಿನಾಂಕ $date';
  }

  @override
  String homeRentOverdue(String amount) {
    return '$amount ಅವಧಿ ಮೀರಿದೆ';
  }

  @override
  String get homeScooter => 'ಸ್ಕೂಟರ್';

  @override
  String get homeShiftWillEndScooterWill =>
      'ನಿಮ್ಮ ಪಾಳಿ ಮುಗಿಯುತ್ತದೆ ಮತ್ತು ಸ್ಕೂಟರ್ ಬಂದ್ ಆಗುತ್ತದೆ. ವಾರದ ಮತ್ತು ಮಾಸಿಕ ಯೋಜನೆಗಳಲ್ಲಿ ಬಾಡಿಗೆ ಅನ್ವಯವಾಗುತ್ತದೆ.';

  @override
  String get homeWithdraw => 'ಹಿಂಪಡೆಯಿರಿ';

  @override
  String get homeWorkingDays => 'ಕೆಲಸದ ದಿನಗಳು';

  @override
  String get hubAllHubs => 'ಎಲ್ಲಾ ಹಬ್‌ಗಳು';

  @override
  String get hubAllocate => 'ಹಂಚಿಕೆ ಮಾಡಿ';

  @override
  String get hubAllotmentsInQueue => 'ಸರದಿಯಲ್ಲಿರುವ ಹಂಚಿಕೆಗಳು';

  @override
  String get hubAllotmentsInQueueInfo => 'ವಾಹನಕ್ಕಾಗಿ ಕಾಯುತ್ತಿರುವ ಈ ಹಬ್‌ನ ಸಕ್ರಿಯ ರೈಡರ್‌ಗಳು.';

  @override
  String get hubChooseHub => 'ಹಬ್ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get hubChooseHubSubtitle => 'ಒಂದು ಹಬ್ ನೋಡಿ, ಅಥವಾ ನಿಮ್ಮ ಎಲ್ಲಾ ಹಬ್‌ಗಳನ್ನು ಒಟ್ಟಿಗೆ.';

  @override
  String get hubCouldNotLoadHub => 'ನಿಮ್ಮ ಹಬ್ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String hubCount(int count) {
    return '$count ಹಬ್‌ಗಳು';
  }

  @override
  String get hubFleetAtHub => 'ಹಬ್‌ನಲ್ಲಿ';

  @override
  String get hubFleetManager => 'ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್';

  @override
  String get hubFleetMapped => 'ಒಟ್ಟು ಫ್ಲೀಟ್';

  @override
  String get hubFleetOnField => 'ಫೀಲ್ಡ್‌ನಲ್ಲಿ';

  @override
  String get hubFleetUtilisation => 'ಫ್ಲೀಟ್ ಬಳಕೆ';

  @override
  String hubGstinLine(String gstin) {
    return 'GSTIN: $gstin';
  }

  @override
  String get hubHome => 'ಮುಖಪುಟ';

  @override
  String get hubHubGlance => 'ನಿಮ್ಮ ಹಬ್‌ನ ನೋಟ';

  @override
  String get hubMaintenance => 'ನಿರ್ವಹಣೆ';

  @override
  String get hubMarkedAbsentShiftClosed => 'ಗೈರು ಎಂದು ಗುರುತಿಸಲಾಗಿದೆ. ನಿಮ್ಮ ಪಾಳಿ ಮುಗಿದಿದೆ.';

  @override
  String get hubNoHubAssigned => 'ನಿಮಗೆ ಯಾವ ಹಬ್ ಕೂಡ ನಿಯೋಜಿಸಿಲ್ಲ.';

  @override
  String hubQuickSupportLine(String number) {
    return 'ತ್ವರಿತ ಸಹಾಯ: $number';
  }

  @override
  String get hubQuickView => 'ಹಬ್ ತ್ವರಿತ ನೋಟ';

  @override
  String get hubQuickViewInfo => 'ನೀವು ಆಯ್ಕೆ ಮಾಡಿದ ಹಬ್‌ನ ಲೈವ್ ಎಣಿಕೆಗಳು.';

  @override
  String get hubReturn => 'ಹಿಂತಿರುಗಿಸುವಿಕೆ';

  @override
  String get hubRfdsAvailable => 'ಲಭ್ಯವಿರುವ RFD';

  @override
  String get hubRfdsAvailableInfo => 'ನಿಯೋಜನೆಗೆ ಸಿದ್ಧ: ಹಂಚಿಕೆಗೆ ಲಭ್ಯವಿರುವ ಈ ಹಬ್‌ನ ವಾಹನಗಳು.';

  @override
  String get hubsCouldNotLoad => 'ಹತ್ತಿರದ ಹಬ್‌ಗಳು ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get hubService => 'ಸೇವೆ';

  @override
  String get hubShowDataFor => 'ಇದರ ಡೇಟಾ ತೋರಿಸಿ';

  @override
  String get hubsNoneBody => 'ನಿಮ್ಮ ಸ್ಥಳದ ಸಮೀಪದಲ್ಲಿ ಯಾವುದೇ ಸಕ್ರಿಯ ಹಬ್ ಇಲ್ಲ.';

  @override
  String get hubsNoneTitle => 'ನಿಮ್ಮ ಹತ್ತಿರ ಯಾವುದೇ ಹಬ್ ಇಲ್ಲ';

  @override
  String get hubSomethingWentWrong => 'ಏನೋ ತಪ್ಪಾಗಿದೆ.';

  @override
  String get hubsSubtitle => 'ನಿಮಗೆ ಹತ್ತಿರದ ಹಬ್‌ಗಳು';

  @override
  String get hubSubmissionsInQueue => 'ಸರದಿಯಲ್ಲಿರುವ ಸಲ್ಲಿಕೆಗಳು';

  @override
  String get hubSubmissionsInQueueInfo =>
      'ಈ ಹಬ್‌ನಲ್ಲಿ ಬಾಕಿ ಇರುವ ರಿಟರ್ನ್ ಮತ್ತು ಎಕ್ಸ್‌ಚೇಂಜ್‌ಗಳು; ಇವುಗಳ ವಾಹನ ಸಬ್‌ಮಿಷನ್ ಇನ್ನೂ ಮುಗಿದಿಲ್ಲ.';

  @override
  String get hubUnderMaintenanceFleet => 'ನಿರ್ವಹಣೆಯಲ್ಲಿರುವ ಫ್ಲೀಟ್';

  @override
  String get hubUnderMaintenanceFleetInfo => 'ಈಗ ನಿರ್ವಹಣೆಯಲ್ಲಿರುವ ಈ ಹಬ್‌ನ ವಾಹನಗಳು.';

  @override
  String get inspectionErrorSafeForReuse => 'ಸ್ಕೂಟರ್ ಅನ್ನು ಮತ್ತೆ ನೀಡಲು ಸುರಕ್ಷಿತವೇ ಎಂದು ತಿಳಿಸಿ.';

  @override
  String get inspectionErrorUnsafeReason => 'ಸ್ಕೂಟರ್ ಅನ್ನು ಮತ್ತೆ ನೀಡಲು ಏಕೆ ಸುರಕ್ಷಿತವಲ್ಲ ಎಂದು ಸೇರಿಸಿ.';

  @override
  String get introCouldNotLoad => 'ಪರಿಚಯ ಸ್ಲೈಡ್‌ಗಳು ತೆರೆಯಲಿಲ್ಲ.';

  @override
  String get introEarnBody =>
      'ದಿನನಿತ್ಯದ ಪಾವತಿ, ಸ್ಪಷ್ಟ ಪ್ರೋತ್ಸಾಹ ಮತ್ತು ನೀವು ನಿಜವಾಗಿ ಎಷ್ಟು ಓಡಿಸುತ್ತೀರೋ ಅದಕ್ಕೆ ಹೊಂದುವ ಬಾಡಿಗೆ ಯೋಜನೆ.';

  @override
  String get introEarnHighlight1 => 'ಅದೇ ದಿನ ಇತ್ಯರ್ಥ';

  @override
  String get introEarnHighlight2 => 'ಗುಪ್ತ ಕಡಿತ ಇಲ್ಲ';

  @override
  String get introEarnTitle => 'ಹೆಚ್ಚು ಗಳಿಸಿ,\nಸ್ವಚ್ಛ ಸವಾರಿ ಮಾಡಿ';

  @override
  String get introSupportBody => 'ರಸ್ತೆಬದಿ ನೆರವು, ಸೇವಾ ಕಾಯ್ದಿರಿಸುವಿಕೆ ಮತ್ತು ನೀವು ನೋಡುವುದನ್ನೇ ನೋಡಬಲ್ಲ ತಂಡದ ಮುಖ್ಯಸ್ಥ.';

  @override
  String get introSupportHighlight1 => '24x7 ರಸ್ತೆಬದಿ ನೆರವು';

  @override
  String get introSupportHighlight2 => 'ನಿಮ್ಮ ಹಬ್‌ನಲ್ಲಿ ಸೇವೆ';

  @override
  String get introSupportTitle => 'ನಿಜವಾಗಿ ಬರುವ\nನೆರವು';

  @override
  String get introVehicleBody =>
      'ವಾಹನದ ಸಾಧನದಿಂದ ಬ್ಯಾಟರಿ, ವ್ಯಾಪ್ತಿ ಮತ್ತು ಸ್ಥಿತಿಯ ನೇರ ಮಾಹಿತಿ. ಆ್ಯಪ್‌ನಿಂದಲೇ ಅನ್‌ಲಾಕ್ ಮಾಡಿ ಪಾಳಿ ಶುರು ಮಾಡಿ.';

  @override
  String get introVehicleHighlight1 => 'ನೇರ ಮಾಹಿತಿ';

  @override
  String get introVehicleHighlight2 => 'ಒಂದೇ ಒತ್ತಿನಲ್ಲಿ ಶುರು';

  @override
  String get introVehicleTitle => 'ನಿಮ್ಮ ಸ್ಕೂಟರ್,\nಸಂಪೂರ್ಣ ಸಂಪರ್ಕಿತ';

  @override
  String get legalAppName => 'ಆ್ಯಪ್';

  @override
  String get legalDocumentCouldNotLoad => 'ಈ ದಾಖಲೆಯನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get maintenanceAllocation => 'ಹಂಚಿಕೆ';

  @override
  String get maintenanceAllocationOff => 'ಆಫ್ ಆಗಿದೆ';

  @override
  String get maintenanceAllocationOn => 'ಅನುಮತಿಸಲಾಗಿದೆ';

  @override
  String get maintenanceBattery => 'ಬ್ಯಾಟರಿ';

  @override
  String get maintenanceCategory => 'ವರ್ಗ';

  @override
  String get maintenanceChangeStatus => 'ಸ್ಥಿತಿ ಬದಲಾಯಿಸಿ';

  @override
  String get maintenanceChassis => 'ಚಾಸಿಸ್ ಸಂಖ್ಯೆ';

  @override
  String get maintenanceChecksOpen => 'ಕೆಲವು ಮೆಕ್ಯಾನಿಕ್ ಪರಿಶೀಲನೆಗಳು ಇನ್ನೂ ಬಾಕಿ ಇವೆ';

  @override
  String get maintenanceColour => 'ಬಣ್ಣ';

  @override
  String get maintenanceCouldNotLoad => 'ಸರ್ವೀಸ್‌ನಲ್ಲಿರುವ ವಾಹನಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get maintenanceCurrentHub => 'ಪ್ರಸ್ತುತ ಹಬ್';

  @override
  String get maintenanceEarlierReports => 'ಹಿಂದಿನ ಮೆಕ್ಯಾನಿಕ್ ವರದಿಗಳು';

  @override
  String get maintenanceEmptyBody => 'ನಿಮ್ಮ ಹಬ್‌ನ ಸ್ಕೂಟರ್ ನಿರ್ವಹಣೆಗೆ ಹೋದಾಗ ಅದು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get maintenanceEmptyTitle => 'ಸರ್ವೀಸ್‌ನಲ್ಲಿ ಯಾವುದೇ ವಾಹನವಿಲ್ಲ';

  @override
  String get maintenanceEvidence => 'ಸಾಕ್ಷ್ಯ ಫೋಟೋಗಳು';

  @override
  String get maintenanceFleetCode => 'ಫ್ಲೀಟ್ ಕೋಡ್';

  @override
  String get maintenanceHistory => 'ಸ್ಥಿತಿ ಇತಿಹಾಸ';

  @override
  String maintenanceHistoryLimit(int limit) {
    return 'ಇತ್ತೀಚಿನ $limit ಬದಲಾವಣೆಗಳನ್ನು ತೋರಿಸಲಾಗುತ್ತಿದೆ.';
  }

  @override
  String get maintenanceHomeHub => 'ಹೋಮ್ ಹಬ್';

  @override
  String get maintenanceInServiceSince => 'ಸರ್ವೀಸ್‌ಗೆ ಬಂದ ದಿನಾಂಕ';

  @override
  String get maintenanceLatestReport => 'ಇತ್ತೀಚಿನ ಮೆಕ್ಯಾನಿಕ್ ವರದಿ';

  @override
  String get maintenanceMaker => 'ತಯಾರಕರು';

  @override
  String get maintenanceModel => 'ಮಾದರಿ';

  @override
  String maintenanceMovedOn(String date) {
    return 'ನಿರ್ವಹಣೆಗೆ ಕಳುಹಿಸಲಾಗಿದೆ $date';
  }

  @override
  String get maintenanceNoHistory => 'ಯಾವುದೇ ಸ್ಥಿತಿ ಬದಲಾವಣೆ ದಾಖಲಾಗಿಲ್ಲ.';

  @override
  String get maintenanceNoMatchBody => 'ಬೇರೆ ವಾಹನ ಸಂಖ್ಯೆ, ಫ್ಲೀಟ್ ಕೋಡ್, ಚಾಸಿಸ್ ಅಥವಾ ಮಾದರಿ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get maintenanceNoMatchTitle => 'ಹೊಂದುವ ವಾಹನಗಳಿಲ್ಲ';

  @override
  String get maintenanceNoReportYet => 'ಈ ವಾಹನಕ್ಕೆ ಇನ್ನೂ ಯಾವುದೇ ಮೆಕ್ಯಾನಿಕ್ ವರದಿ ದಾಖಲಾಗಿಲ್ಲ.';

  @override
  String get maintenanceNotSafe => 'ಸುರಕ್ಷಿತವಲ್ಲ';

  @override
  String get maintenanceOdometer => 'ಓಡೋಮೀಟರ್';

  @override
  String get maintenanceOnboarding => 'ಆನ್‌ಬೋರ್ಡಿಂಗ್';

  @override
  String get maintenanceProgress => 'ನಡೆಯುತ್ತಿದೆ';

  @override
  String maintenanceReasonFromReport(String reason) {
    return 'ಮೆಕ್ಯಾನಿಕ್ ವರದಿ: $reason';
  }

  @override
  String maintenanceReasonLine(String reason) {
    return 'ಕಾರಣ: $reason';
  }

  @override
  String get maintenanceReportConfirmed => 'ದೃಢೀಕರಿಸಿದ ದಿನಾಂಕ';

  @override
  String get maintenanceReportMechanic => 'ಮೆಕ್ಯಾನಿಕ್';

  @override
  String get maintenanceReportPhotos => 'ಫೋಟೋಗಳು';

  @override
  String get maintenanceReportRecorded => 'ದಾಖಲಿಸಿದ ದಿನಾಂಕ';

  @override
  String maintenanceReportsLimit(int limit) {
    return 'ಇತ್ತೀಚಿನ $limit ವರದಿಗಳನ್ನು ತೋರಿಸಲಾಗುತ್ತಿದೆ.';
  }

  @override
  String get maintenanceReportStatus => 'ಸ್ಕೂಟರ್ ಸ್ಥಿತಿ';

  @override
  String get maintenanceSafeToReuse => 'ಮರುಬಳಕೆಗೆ ಸುರಕ್ಷಿತ';

  @override
  String get maintenanceSearchHint => 'ವಾಹನ ಸಂಖ್ಯೆ, ಫ್ಲೀಟ್ ಕೋಡ್, ಚಾಸಿಸ್ ಅಥವಾ ಮಾದರಿ ಹುಡುಕಿ';

  @override
  String get maintenanceSelectVehicle => 'ವಾಹನ ಆರಿಸಿ';

  @override
  String maintenanceStatusChanged(String status) {
    return 'ಸ್ಥಿತಿಯನ್ನು $status ಗೆ ಬದಲಾಯಿಸಲಾಗಿದೆ';
  }

  @override
  String maintenanceStatusNow(String status) {
    return 'ಈಗಿನ ಸ್ಥಿತಿ: $status';
  }

  @override
  String get maintenanceStatusOutOfServiceHint =>
      'ರಸ್ತೆಯಿಂದ ತೆಗೆದುಹಾಕಲಾಗಿದೆ. ಇದು ಸರ್ವೀಸ್‌ನಿಂದ ಹೊರಬರುತ್ತದೆ, ಮತ್ತು ನಿಮ್ಮ ಅಡ್ಮಿನ್ ಮಾತ್ರ ಇದನ್ನು ಮರಳಿ ತರಬಹುದು.';

  @override
  String get maintenanceTitle => 'ಸರ್ವೀಸ್‌ನಲ್ಲಿರುವ ವಾಹನಗಳು';

  @override
  String get maintenanceUnderMaintenance => 'ನಿರ್ವಹಣೆಯಲ್ಲಿ';

  @override
  String get maintenanceVariant => 'ವೇರಿಯಂಟ್';

  @override
  String get maintenanceVehicleCouldNotLoad => 'ಈ ವಾಹನವನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get maintenanceVehicleDetails => 'ವಾಹನದ ವಿವರಗಳು';

  @override
  String get maintenanceVehicleTitle => 'ಸರ್ವೀಸ್‌ನಲ್ಲಿರುವ ವಾಹನ';

  @override
  String get maintenanceVehicleType => 'ವಾಹನದ ಪ್ರಕಾರ';

  @override
  String get mapsAllowLocation => 'ಅನುಮತಿ ನೀಡಿ';

  @override
  String mapsAway(String distance) {
    return '$distance ದೂರ';
  }

  @override
  String get mapsCouldNotOpenMaps => 'Google Maps ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get mapsLocating => 'ನಿಮ್ಮ ಸ್ಥಳವನ್ನು ಹುಡುಕುತ್ತಿದ್ದೇವೆ…';

  @override
  String get mapsLocationDeniedBody =>
      'ನಿಮ್ಮ ಹತ್ತಿರದ ಹಬ್‌ಗಳು ಮತ್ತು ಸ್ವಾಪ್ ಸ್ಟೇಷನ್‌ಗಳನ್ನು ತೋರಿಸಲು ನಾವು ನಿಮ್ಮ ಸ್ಥಳವನ್ನು ಬಳಸುತ್ತೇವೆ.';

  @override
  String get mapsLocationDeniedTitle => 'ಸ್ಥಳ ಪ್ರವೇಶಕ್ಕೆ ಅನುಮತಿ ನೀಡಿ';

  @override
  String get mapsLocationOffBody => 'ನಿಮ್ಮ ಹತ್ತಿರದ ಸ್ಥಳಗಳನ್ನು ನೋಡಲು ಸ್ಥಳ ಸೇವೆಗಳನ್ನು ಆನ್ ಮಾಡಿ.';

  @override
  String get mapsLocationOffTitle => 'ಸ್ಥಳ ಸೇವೆ ಆಫ್ ಆಗಿದೆ';

  @override
  String get mapsLocationUnavailable => 'ನಿಮ್ಮ ಸ್ಥಳ ಸಿಗಲಿಲ್ಲ';

  @override
  String mapsMinutes(String minutes) {
    return '$minutes ನಿಮಿಷ';
  }

  @override
  String get mapsNavigate => 'ದಾರಿ ತೋರಿಸಿ';

  @override
  String get mapsOpenSettings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳನ್ನು ತೆರೆಯಿರಿ';

  @override
  String get navBatterySwap => 'ಬ್ಯಾಟರಿ ಸ್ವಾಪ್';

  @override
  String get navNearbyHubs => 'ಹತ್ತಿರದ ಹಬ್‌ಗಳು';

  @override
  String get navReferEarn => 'ರೆಫರ್ ಮಾಡಿ ಮತ್ತು ಗಳಿಸಿ';

  @override
  String get navScooterDetails => 'ಸ್ಕೂಟರ್ ವಿವರಗಳು';

  @override
  String get notificationsAll => 'ಎಲ್ಲಾ';

  @override
  String get notificationsAllCaughtUp => 'ನೀವು ಎಲ್ಲವನ್ನೂ ನೋಡಿ ಮುಗಿಸಿದ್ದೀರಿ';

  @override
  String get notificationsAllClear => 'ಎಲ್ಲವೂ ಸರಿಯಾಗಿದೆ';

  @override
  String get notificationsCouldNotLoadNotifications => 'ಸೂಚನೆಗಳು ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get notificationsEarlier => 'ಹಿಂದೆ';

  @override
  String get notificationsEmptyMessage => 'ಹೊಸ ಅಪ್‌ಡೇಟ್‌ಗಳು ಮತ್ತು ಎಚ್ಚರಿಕೆಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get notificationsGotIt => 'ಸರಿ';

  @override
  String notificationsInboxCount(int count) {
    return 'ನಿಮ್ಮ ಇನ್‌ಬಾಕ್ಸ್‌ನಲ್ಲಿ $count ಅಧಿಸೂಚನೆಗಳು';
  }

  @override
  String get notificationsNoMatchingNotifications => 'ಹೊಂದುವ ಸೂಚನೆ ಇಲ್ಲ';

  @override
  String get notificationsNothingNewNeedsAttention => 'ಹೊಸದೇನೂ ಇಲ್ಲ';

  @override
  String get notificationsNotifications => 'ಸೂಚನೆಗಳು';

  @override
  String get notificationsSearchNotifications => 'ಸೂಚನೆಗಳನ್ನು ಹುಡುಕಿ';

  @override
  String get notificationsToday => 'ಇಂದು';

  @override
  String get notificationsUnread => 'ಓದದಿರುವ';

  @override
  String notificationsUnreadCount(int count) {
    return '$count ಓದದವು';
  }

  @override
  String get onboardingAcceptAgreementContinue => 'ಮುಂದುವರಿಯಲು ಒಪ್ಪಂದ ಸ್ವೀಕರಿಸಿ';

  @override
  String get onboardingAddDateBirthFirstStep => 'ಮುಂದುವರಿಯುವ ಮೊದಲು ಮೊದಲ ಹಂತದಲ್ಲಿ ಹುಟ್ಟಿದ ದಿನಾಂಕ ಬರೆಯಿರಿ';

  @override
  String get onboardingAddLeastOneReference => 'ಕನಿಷ್ಠ ಒಂದು ಉಲ್ಲೇಖ ಸೇರಿಸಿ';

  @override
  String onboardingAddYourField(String field) {
    return 'ನಿಮ್ಮ $field ಸೇರಿಸಿ';
  }

  @override
  String get onboardingAgreementBody =>
      'ಈ ಒಪ್ಪಂದ ನಿಮ್ಮ ಮತ್ತು ನಿಮ್ಮ ಫ್ಲೀಟ್ ಆಪರೇಟರ್ ನಡುವಿನದು. ಇದರಲ್ಲಿ ನಿಮಗೆ ನೀಡಿದ ವಾಹನ, ಅದನ್ನು ಹೇಗೆ ಬಳಸಬಹುದು, ಅದರ ಆರೈಕೆಯ ನಿಮ್ಮ ಜವಾಬ್ದಾರಿ, ನಿಮ್ಮ ಯೋಜನೆಯ ಠೇವಣಿ ಮತ್ತು ಶುಲ್ಕ, ಹಾಗೂ ಈ ವ್ಯವಸ್ಥೆ ಹೇಗೆ ಮುಗಿಯುತ್ತದೆ ಎಂಬುದೆಲ್ಲ ಸೇರಿದೆ. ಸ್ವೀಕರಿಸುವ ಮೊದಲು ಪೂರ್ತಿ ಓದಿ. ಕೆಳಗಿನ ಪೆಟ್ಟಿಗೆಗೆ ಗುರುತು ಹಾಕುವ ಮೂಲಕ ನೀವು ರೈಡರ್ ಒಪ್ಪಂದ ಮತ್ತು ಆಪರೇಟರ್ ಅವರ ರೈಡರ್ ನೀತಿಗಳನ್ನು ಓದಿದ್ದೀರಿ ಮತ್ತು ಅವುಗಳಿಗೆ ಬದ್ಧರಾಗಿರಲು ಒಪ್ಪುತ್ತೀರಿ ಎಂದು ಖಚಿತಪಡಿಸುತ್ತೀರಿ.';

  @override
  String get onboardingAgreeToRiderAgreement => 'ನಾನು ರೈಡರ್ ಒಪ್ಪಂದ ಓದಿದ್ದೇನೆ ಮತ್ತು ಒಪ್ಪುತ್ತೇನೆ';

  @override
  String get onboardingAnswered => 'ಉತ್ತರಿಸಲಾಗಿದೆ';

  @override
  String get onboardingApplicationSubmitted => 'ಅರ್ಜಿ ಸಲ್ಲಿಸಲಾಗಿದೆ';

  @override
  String get onboardingAttached => 'ಲಗತ್ತಿಸಲಾಗಿದೆ';

  @override
  String get onboardingBankAccount => 'ಬ್ಯಾಂಕ್ ಖಾತೆ';

  @override
  String get onboardingBankAccountNeeded => 'ನಿಮ್ಮ ಖಾತೆ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ ಮತ್ತು ಖಚಿತಪಡಿಸಲು ಮತ್ತೆ ಟೈಪ್ ಮಾಡಿ.';

  @override
  String get onboardingBankAccountTooShort => 'ಈ ಖಾತೆ ಸಂಖ್ಯೆ ತುಂಬಾ ಚಿಕ್ಕದಾಗಿದೆ.';

  @override
  String get onboardingBankBranch => 'ಶಾಖೆ';

  @override
  String get onboardingBankCity => 'ನಗರ';

  @override
  String get onboardingBankIfsc => 'IFSC ಕೋಡ್';

  @override
  String get onboardingBankIfscFailed => 'ಈಗ ಈ IFSC ಪರಿಶೀಲಿಸಲು ಆಗಲಿಲ್ಲ. ಕೆಳಗೆ ನಿಮ್ಮ ಬ್ಯಾಂಕ್ ವಿವರಗಳನ್ನು ತುಂಬಿ.';

  @override
  String get onboardingBankIfscHelper => '11 ಅಕ್ಷರಗಳು. ಇದು ನಿಮ್ಮ ಪಾಸ್‌ಬುಕ್ ಅಥವಾ ಚೆಕ್‌ನಲ್ಲಿ ಇರುತ್ತದೆ.';

  @override
  String get onboardingBankIfscHint => 'ಉದಾ. SBIN0001234';

  @override
  String get onboardingBankIfscNotFound =>
      'ಈ IFSC ಗೆ ಯಾವುದೇ ಬ್ಯಾಂಕ್ ಸಿಗಲಿಲ್ಲ. ಕೋಡ್ ಪರಿಶೀಲಿಸಿ, ಅಥವಾ ಕೆಳಗೆ ನಿಮ್ಮ ಬ್ಯಾಂಕ್ ವಿವರಗಳನ್ನು ತುಂಬಿ.';

  @override
  String get onboardingBankIfscPending => 'ನಿಮ್ಮ IFSC ನಮೂದಿಸಿ ಮತ್ತು ಬ್ಯಾಂಕ್ ಕಾಣಿಸುವವರೆಗೆ ಕಾಯಿರಿ.';

  @override
  String get onboardingBankName => 'ಬ್ಯಾಂಕ್ ಹೆಸರು';

  @override
  String get onboardingBankProof => 'ಬ್ಯಾಂಕ್ ಪುರಾವೆ (ಪಾಸ್‌ಬುಕ್ ಅಥವಾ ರದ್ದುಪಡಿಸಿದ ಚೆಕ್)';

  @override
  String get onboardingBankState => 'ರಾಜ್ಯ';

  @override
  String get onboardingCheckEverythingBeforeSubmitCan =>
      'ಸಲ್ಲಿಸುವ ಮೊದಲು ಎಲ್ಲವನ್ನೂ ಪರಿಶೀಲಿಸಿ. ಯಾವುದೇ ಹಂತವನ್ನು ಇನ್ನೂ ಬದಲಾಯಿಸಬಹುದು.';

  @override
  String get onboardingCouldNotLoadOnboarding => 'ಅರ್ಜಿ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get onboardingDateBirthNotValid => 'ಈ ಹುಟ್ಟಿದ ದಿನಾಂಕ ಸರಿಯಾಗಿಲ್ಲ';

  @override
  String get onboardingDocumentApproved => 'ಅನುಮೋದಿತ';

  @override
  String get onboardingDocumentHasExpiredEnterDate => 'ಈ ದಾಖಲೆಯ ಅವಧಿ ಮುಗಿದಿದೆ. ಇಂದಿನ ನಂತರದ ದಿನಾಂಕ ಬರೆಯಿರಿ.';

  @override
  String get onboardingDocumentInReview => 'ಅಪ್‌ಲೋಡ್ ಆಗಿದೆ · ಪರಿಶೀಲನೆಯಲ್ಲಿದೆ';

  @override
  String get onboardingDocuments => 'ದಾಖಲೆಗಳು';

  @override
  String get onboardingEdit => 'ಬದಲಾಯಿಸಿ';

  @override
  String onboardingEnterValidField(String field) {
    return 'ಸರಿಯಾದ $field ಬರೆಯಿರಿ';
  }

  @override
  String get onboardingEveryStepHaveCompletedSaved =>
      'ನೀವು ಪೂರ್ಣಗೊಳಿಸಿದ ಪ್ರತಿ ಹಂತವೂ ಉಳಿಸಲಾಗಿದೆ. ಮುಂದಿನ ಬಾರಿ ಸೈನ್ ಇನ್ ಮಾಡಿದಾಗ ಅಲ್ಲಿಂದಲೇ ಮುಂದುವರಿಸಬಹುದು.';

  @override
  String get onboardingExit => 'ಹೊರಗೆ ಬನ್ನಿ';

  @override
  String get onboardingExitOnboarding => 'ಅರ್ಜಿಯಿಂದ ಹೊರಬರಬೇಕೆ?';

  @override
  String onboardingFieldRequired(String field) {
    return '$field ಅಗತ್ಯವಿದೆ';
  }

  @override
  String get onboardingGoOnboarding => 'ಅರ್ಜಿಗೆ ಹೋಗಿ';

  @override
  String get onboardingIntroGetStarted => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get onboardingIntroNext => 'ಮುಂದೆ';

  @override
  String get onboardingLoadingOnboardingForm => 'ನಿಮ್ಮ ಅರ್ಜಿ ತೆರೆಯುತ್ತಿದೆ…';

  @override
  String get onboardingNoStepsConfigured =>
      'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಆಪರೇಟರ್ ಪ್ಯಾಕೇಜ್‌ನಲ್ಲಿ ಇನ್ನೂ ನೋಂದಣಿ ಹಂತಗಳನ್ನು ಸಿದ್ಧಪಡಿಸಿಲ್ಲ. ಅವರಿಂದ ರೈಡರ್ ನೋಂದಣಿ ಸಿದ್ಧಪಡಿಸಿಕೊಳ್ಳಿ, ನಂತರ ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get onboardingNothingFill => 'ಭರ್ತಿ ಮಾಡಲು ಏನೂ ಇಲ್ಲ';

  @override
  String get onboardingNothingFillStep => 'ಈ ಹಂತದಲ್ಲಿ ಭರ್ತಿ ಮಾಡಲು ಏನೂ ಇಲ್ಲ.';

  @override
  String get onboardingNothingReviewYet => 'ಇನ್ನೂ ಪರಿಶೀಲಿಸಲು ಏನೂ ಇಲ್ಲ';

  @override
  String get onboardingNothingToFillHere => 'ಇಲ್ಲಿ ಭರ್ತಿ ಮಾಡಲು ಏನೂ ಇಲ್ಲ';

  @override
  String get onboardingNotProvided => 'ನೀಡಿಲ್ಲ';

  @override
  String get onboardingPackage => 'ಪ್ಯಾಕೇಜ್';

  @override
  String get onboardingPleaseFixHighlightedFieldsBefore => 'ಮುಂದುವರಿಯುವ ಮೊದಲು ಗುರುತಿಸಿದ ಜಾಗಗಳನ್ನು ಸರಿಪಡಿಸಿ';

  @override
  String get onboardingReferences => 'ಉಲ್ಲೇಖಗಳು';

  @override
  String get onboardingReferralApplied => 'ಅನ್ವಯಿಸಲಾಗಿದೆ';

  @override
  String get onboardingReferralApply => 'ಅನ್ವಯಿಸಿ';

  @override
  String get onboardingReferralCodeApplied => 'ರೆಫರಲ್ ಕೋಡ್ ಅನ್ವಯಿಸಲಾಗಿದೆ';

  @override
  String get onboardingReferralFromInvite => 'ನಿಮ್ಮ ಆಹ್ವಾನ ಲಿಂಕ್‌ನಿಂದ ಸೇರಿಸಲಾಗಿದೆ';

  @override
  String get onboardingReferralNotFound => 'ಇದಕ್ಕೆ ಯಾವುದೇ ರೆಫರಲ್ ಸಿಗಲಿಲ್ಲ. ಕೋಡ್ ಅಥವಾ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು ಪರಿಶೀಲಿಸಿ.';

  @override
  String get onboardingReferralScan => 'ರೆಫರಲ್ QR ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get onboardingReferralTapApply => 'ಈ ಕೋಡ್ ಬಳಸಲು ಅನ್ವಯಿಸಿ ಒತ್ತಿ, ಅಥವಾ ಅದನ್ನು ಅಳಿಸಿ';

  @override
  String onboardingRejectedMessage(String documents) {
    return 'ಮುಂದುವರಿಯಲು ಮತ್ತೆ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ: $documents';
  }

  @override
  String get onboardingRejectedTitle => 'ಪರಿಶೀಲನೆಯಲ್ಲಿ ತಿರಸ್ಕೃತ';

  @override
  String get onboardingReview => 'ಪರಿಶೀಲಿಸಿ';

  @override
  String get onboardingReviewApplication => 'ಅರ್ಜಿ ಪರಿಶೀಲಿಸಿ';

  @override
  String get onboardingRiderOnboarding => 'ರೈಡರ್ ನೋಂದಣಿ';

  @override
  String get onboardingSaving => 'ಉಳಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String get onboardingSignAgreementContinue => 'ಮುಂದುವರಿಯಲು ಒಪ್ಪಂದಕ್ಕೆ ಸಹಿ ಮಾಡಿ';

  @override
  String get onboardingSomeStepsStillIncompleteGo => 'ಕೆಲವು ಹಂತಗಳು ಇನ್ನೂ ಅಪೂರ್ಣವಾಗಿವೆ. ಹಿಂದೆ ಹೋಗಿ ಪೂರ್ಣಗೊಳಿಸಿ.';

  @override
  String get onboardingStartOnboardingSeeAnswersHere => 'ನಿಮ್ಮ ಉತ್ತರಗಳನ್ನು ಇಲ್ಲಿ ನೋಡಲು ಅರ್ಜಿ ತುಂಬಲು ಪ್ರಾರಂಭಿಸಿ.';

  @override
  String get onboardingStepAgreement => 'ಒಪ್ಪಂದ';

  @override
  String get onboardingStepEligibility => 'ಅರ್ಹತೆ';

  @override
  String get onboardingStepHandledByOperator => 'ಈ ಹಂತವನ್ನು ನಿಮ್ಮ ಫ್ಲೀಟ್ ಆಪರೇಟರ್ ನಿರ್ವಹಿಸುತ್ತಾರೆ. ಮುಂದಿನದಕ್ಕೆ ಸಾಗಿ.';

  @override
  String get onboardingStepTraining => 'ತರಬೇತಿ';

  @override
  String get onboardingSubmitApplication => 'ಅರ್ಜಿ ಸಲ್ಲಿಸಿ';

  @override
  String get onboardingTakePhotoDocumentChooseOne => 'ದಾಖಲೆಯ ಫೋಟೋ ತೆಗೆಯಿರಿ, ಅಥವಾ ಈಗಾಗಲೇ ಇರುವ ಫೋಟೋ ಆರಿಸಿ';

  @override
  String get onboardingUploadRejectedAgain => 'ಸಲ್ಲಿಸುವ ಮೊದಲು ತಿರಸ್ಕೃತ ದಾಖಲೆಗಳನ್ನು ಮತ್ತೆ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ.';

  @override
  String get paymentRefundableDeposit => 'ಮರುಪಾವತಿಸಬಹುದಾದ ಠೇವಣಿ';

  @override
  String get paymentRentAndFees => 'ಬಾಡಿಗೆ ಮತ್ತು ಶುಲ್ಕಗಳು';

  @override
  String get paymentsAllClear => 'ನಿಮ್ಮ ಎಲ್ಲಾ ಪಾವತಿ ಆಗಿದೆ';

  @override
  String get paymentsAllClearMessage => 'ಈಗ ಏನೂ ಬಾಕಿ ಇಲ್ಲ. ಮುಂದಿನದಕ್ಕೆ ಮೊದಲು ನಾವು ತಿಳಿಸುತ್ತೇವೆ.';

  @override
  String get paymentsAmountDue => 'ಬಾಕಿ ಮೊತ್ತ';

  @override
  String get paymentsAutoPay => 'ಸ್ವಯಂ-ಡೆಬಿಟ್';

  @override
  String get paymentsAutoPayActive => 'ಆನ್';

  @override
  String get paymentsAutoPayAttention => 'ಸ್ವಯಂ-ಡೆಬಿಟ್‌ಗೆ ಗಮನ ಬೇಕು. ಮತ್ತೆ ಹೊಂದಿಸಲು ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್‌ಗೆ ಹೇಳಿ.';

  @override
  String get paymentsAutoPayAuthPending => 'ಅನುಮೋದನೆಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get paymentsAutoPayExpired => 'ಅವಧಿ ಮುಗಿದಿದೆ';

  @override
  String get paymentsAutoPayFailed => 'ವಿಫಲ';

  @override
  String get paymentsAutoPayNotEnabled => 'ಹೊಂದಿಸಿಲ್ಲ';

  @override
  String get paymentsAutoPayPaused => 'ವಿರಾಮ';

  @override
  String get paymentsAutoPayRevoked => 'ರದ್ದು';

  @override
  String get paymentsAutoPaySetupRequired => 'ಸೆಟಪ್ ಬೇಕು';

  @override
  String get paymentsBreakdown => 'ವಿವರ';

  @override
  String get paymentsCouldNotLoad => 'ಪಾವತಿಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String paymentsDueOnDate(String date) {
    return 'ಪಾವತಿ ದಿನಾಂಕ: $date';
  }

  @override
  String get paymentsHistory => 'ಹಿಂದಿನ ಪಾವತಿಗಳು';

  @override
  String get paymentsMandateExpires => 'ಮ್ಯಾಂಡೇಟ್ ಮುಗಿಯುತ್ತದೆ';

  @override
  String get paymentsMandateLimit => 'ಪ್ರತಿ ಕಡಿತದ ಮಿತಿ';

  @override
  String get paymentsMethod => 'ವಿಧಾನ';

  @override
  String get paymentsNextDebit => 'ಮುಂದಿನ ಕಡಿತ';

  @override
  String get paymentsNoPayments => 'ಇನ್ನೂ ಪಾವತಿ ಇಲ್ಲ';

  @override
  String get paymentsNoPaymentsMessage => 'ನಿಮ್ಮ ಪಾವತಿಗಳು ಖಚಿತವಾದ ಮೇಲೆ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get paymentsNothingDue => 'ಏನೂ ಬಾಕಿ ಇಲ್ಲ';

  @override
  String get paymentsOverdue => 'ಅವಧಿ ಮೀರಿದೆ';

  @override
  String get paymentsPayAtHub => 'ನಿಮ್ಮ ಹಬ್‌ನಲ್ಲಿ ಪಾವತಿಸಿ, ಅಥವಾ ಪಾವತಿ ದಿನಾಂಕದಂದು ಸ್ವಯಂ-ಡೆಬಿಟ್ ಆಗಲಿ.';

  @override
  String get paymentsPayment => 'ಪಾವತಿ';

  @override
  String get paymentsSubtitle => 'ಬಾಕಿ, ಸ್ವಯಂ-ಡೆಬಿಟ್ ಮತ್ತು ರಸೀದಿಗಳು';

  @override
  String get paymentsTitle => 'ಪಾವತಿಗಳು';

  @override
  String get pdiHintTyreWorn => 'ಉದಾ. ಮುಂದಿನ ಟೈರ್ ಮಿತಿಗಿಂತ ಹೆಚ್ಚು ಸವೆದಿದೆ';

  @override
  String pdiWorkPartner(String partner) {
    return 'ಕೆಲಸದ ಪಾಲುದಾರ: $partner';
  }

  @override
  String get planAccept => 'ಪ್ಲಾನ್ ಒಪ್ಪಿ';

  @override
  String get planAdvanceRental => 'ಮುಂಗಡ ಬಾಡಿಗೆ';

  @override
  String get planBatteryDeposit => 'ಬ್ಯಾಟರಿ ಭದ್ರತಾ ಠೇವಣಿ';

  @override
  String get planConsent => 'ನಾನು ಈ ಪ್ಲಾನ್ ಅನ್ನು ಓದಿದ್ದೇನೆ ಮತ್ತು ಒಪ್ಪುತ್ತೇನೆ';

  @override
  String get planCustom => 'ಕಸ್ಟಮ್ ಪ್ಲಾನ್';

  @override
  String get planDaily => 'ದೈನಂದಿನ ಪ್ಲಾನ್';

  @override
  String planDays(int count) {
    return '$count ದಿನಗಳ ಪ್ಲಾನ್';
  }

  @override
  String get planDiscount => 'ರಿಯಾಯಿತಿ';

  @override
  String get planErrorAgreementMismatch => 'ಈ ಬಾಡಿಗೆ ಸ್ಕೂಟರ್‌ಗೆ ಹೊಂದುತ್ತಿಲ್ಲ. ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ಅನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get planErrorAgreementNotActive => 'ನಿಮ್ಮ ಬಾಡಿಗೆ ಇನ್ನೂ ಸಕ್ರಿಯವಾಗಿಲ್ಲ, ಆದ್ದರಿಂದ ಇದನ್ನು ಈಗ ಮಾಡಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get planErrorAgreementNotReady => 'ಒಪ್ಪಿದ ಪ್ಲಾನ್ ಹಸ್ತಾಂತರಕ್ಕೆ ಸಿದ್ಧವಾಗಿಲ್ಲ. ರಿಫ್ರೆಶ್ ಮಾಡಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get planErrorDepositNotConfigured =>
      'ಈ ಪ್ಲಾನ್‌ಗೆ ಸ್ಕೂಟರ್ ಭದ್ರತಾ ಠೇವಣಿ ಹೊಂದಿಸಿಲ್ಲ. ಶೂನ್ಯವಾದರೂ ಅದನ್ನು ಸೇರಿಸಲು ನಿಮ್ಮ ಅಡ್ಮಿನ್‌ಗೆ ಹೇಳಿ.';

  @override
  String get planErrorExchangePlan => 'ಇದು ಎಕ್ಸ್‌ಚೇಂಜ್ ಸ್ಕೂಟರ್, ಆದ್ದರಿಂದ ಇದರ ಪ್ಲಾನ್ ಈಗಾಗಲೇ ಒಪ್ಪಿಗೆಯಾಗಿದೆ.';

  @override
  String get planErrorFeeNotConfigured =>
      'ಈ ಪ್ಲಾನ್‌ಗೆ ಆನ್‌ಬೋರ್ಡಿಂಗ್ ಶುಲ್ಕ ಹೊಂದಿಸಿಲ್ಲ. ಶೂನ್ಯವಾದರೂ ಅದನ್ನು ಸೇರಿಸಲು ನಿಮ್ಮ ಅಡ್ಮಿನ್‌ಗೆ ಹೇಳಿ.';

  @override
  String get planErrorFleetRequestRequired => 'ಪಾವತಿ ಕೇಳುವ ಮೊದಲು ಸ್ಕೂಟರ್‌ಗೆ ವಿನಂತಿಸಿ.';

  @override
  String get planErrorOfferNotValid => 'ಈ ಪ್ಲಾನ್ ಆಫರ್ ಈಗ ಮಾನ್ಯವಾಗಿಲ್ಲ. ಹೊಸದನ್ನು ಕೇಳಿ.';

  @override
  String get planErrorPaymentReferenceRequired => 'ರೈಡರ್ ಇನ್ನೂ ಪಾವತಿ ರೆಫರೆನ್ಸ್ ಕಳುಹಿಸಿಲ್ಲ.';

  @override
  String get planErrorPaymentStale => 'ಮೊತ್ತ ಬದಲಾಗಿದೆ. ರಿಫ್ರೆಶ್ ಮಾಡಿ ಮತ್ತೆ ಪಾವತಿ ಕೇಳಿ.';

  @override
  String get planErrorRequired => 'ಮೊದಲು ಬಾಡಿಗೆ ಪ್ಲಾನ್ ಆಯ್ಕೆಮಾಡಿ ಮತ್ತು ರೈಡರ್ ಅದನ್ನು ಒಪ್ಪುವಂತೆ ಮಾಡಿ.';

  @override
  String get planErrorSelectionChanged => 'ಈಗಷ್ಟೇ ಬೇರೊಂದು ಪ್ಲಾನ್ ಆಯ್ಕೆಯಾಗಿದೆ. ರಿಫ್ರೆಶ್ ಮಾಡಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get planErrorSelectionClosed => 'ಪ್ಲಾನ್ ಅನ್ನು ಇನ್ನು ಬದಲಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get planErrorTermsChanged => 'ಪ್ಲಾನ್ ನಿಯಮಗಳು ಬದಲಾಗಿವೆ. ರಿಫ್ರೆಶ್ ಮಾಡಿ ಮತ್ತೆ ಒಪ್ಪಿ.';

  @override
  String get planFortnightly => 'ಹದಿನೈದು ದಿನಗಳ ಪ್ಲಾನ್';

  @override
  String get planFree => 'ಉಚಿತ';

  @override
  String get planIncluded => 'ಒಳಗೊಂಡಿದೆ';

  @override
  String get planInsurance => 'ವಿಮೆ';

  @override
  String get planMonthly => 'ಮಾಸಿಕ ಪ್ಲಾನ್';

  @override
  String get planOfferNotLive => 'ಈ ಆಫರ್ ಈಗ ತೆರೆದಿಲ್ಲ. ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ಹೊಸದನ್ನು ಕಳುಹಿಸುತ್ತಾರೆ.';

  @override
  String get planOnboardingFee => 'ಆನ್‌ಬೋರ್ಡಿಂಗ್ ಶುಲ್ಕ';

  @override
  String get planPayableToday => 'ಇಂದು ಪಾವತಿಸಿ';

  @override
  String get planQuarterly => 'ತ್ರೈಮಾಸಿಕ ಪ್ಲಾನ್';

  @override
  String planRefundableNote(String amount) {
    return 'ಇದರಲ್ಲಿ $amount ಮರುಪಾವತಿಸಬಹುದಾದ ಠೇವಣಿ ಸೇರಿದೆ';
  }

  @override
  String get planRent => 'ಬಾಡಿಗೆ';

  @override
  String get planScooterAgeAdjustment => 'ಸ್ಕೂಟರ್ ವಯಸ್ಸಿನ ಹೊಂದಾಣಿಕೆ';

  @override
  String get planScooterDeposit => 'ಸ್ಕೂಟರ್ ಭದ್ರತಾ ಠೇವಣಿ';

  @override
  String planUsageRate(String rate, String unit) {
    return 'ಪ್ರತಿ $unitಗೆ $rate';
  }

  @override
  String get planValidUntil => 'ಆಫರ್ ಈ ಸಮಯದವರೆಗೆ ಮಾನ್ಯ';

  @override
  String get planWeekly => 'ಸಾಪ್ತಾಹಿಕ ಪ್ಲಾನ್';

  @override
  String planWeeks(int count) {
    return '$count ವಾರಗಳ ಪ್ಲಾನ್';
  }

  @override
  String get profileHub => 'ಹಬ್';

  @override
  String get profilePersonalDetails => 'ವೈಯಕ್ತಿಕ ವಿವರಗಳು';

  @override
  String get referActivity => 'ಚಟುವಟಿಕೆ';

  @override
  String referCardReward(String amount) {
    return 'ನನ್ನ ಕೋಡ್‌ನೊಂದಿಗೆ ಸೇರಿ ಮತ್ತು $amount ಪಡೆಯಿರಿ';
  }

  @override
  String get referCodeCopied => 'ರೆಫರಲ್ ಕೋಡ್ ನಕಲಿಸಲಾಗಿದೆ';

  @override
  String referCompleteBy(String date) {
    return 'ಇವನ್ನು $date ರೊಳಗೆ ಪೂರ್ಣಗೊಳಿಸಿ';
  }

  @override
  String get referCopyCode => 'ಕೋಡ್ ನಕಲಿಸಿ';

  @override
  String get referCopyMessage => 'ಆಹ್ವಾನ ಸಂದೇಶ ನಕಲಿಸಿ';

  @override
  String get referCouldNotLoad => 'ರೆಫರ್ ಮತ್ತು ಗಳಿಕೆ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get referDetailTitle => 'ರೆಫರಲ್ ವಿವರಗಳು';

  @override
  String get referDrawerHint =>
      'ನಿಮ್ಮ ಕೋಡ್‌ನೊಂದಿಗೆ ಸೇರಲು ಸ್ನೇಹಿತರು ಇದನ್ನು ಸ್ಕ್ಯಾನ್ ಮಾಡಬಹುದು. ದೊಡ್ಡದಾಗಿಸಲು ಟ್ಯಾಪ್ ಮಾಡಿ.';

  @override
  String get referDrawerTitle => 'ನನ್ನ ರೆಫರಲ್ QR';

  @override
  String get referErrorAlreadyLinked => 'ನಿಮ್ಮ ಖಾತೆ ಈಗಾಗಲೇ ಬೇರೆ ರೆಫರಲ್ ಕೋಡ್‌ಗೆ ಲಿಂಕ್ ಆಗಿದೆ.';

  @override
  String get referErrorCampaignInactive => 'ರೆಫರ್ ಮಾಡಿ ಮತ್ತು ಗಳಿಸಿ ಈಗ ಚಾಲ್ತಿಯಲ್ಲಿಲ್ಲ.';

  @override
  String get referErrorCodeExpired => 'ಈ ಆಹ್ವಾನದ ಅವಧಿ ಮುಗಿದಿದೆ. ಹೊಸದನ್ನು ಕಳುಹಿಸಲು ನಿಮ್ಮ ಸ್ನೇಹಿತರನ್ನು ಕೇಳಿ.';

  @override
  String get referErrorLimit => 'ಈ ರೈಡರ್ ತಮ್ಮ ರೆಫರಲ್ ಮಿತಿ ತಲುಪಿದ್ದಾರೆ.';

  @override
  String get referErrorNotEligible => 'ನಿಮ್ಮ ರೈಡರ್ ಪ್ರೊಫೈಲ್ ಇನ್ನೂ ರೆಫರಲ್‌ಗಳಿಗೆ ಸಿದ್ಧವಾಗಿಲ್ಲ.';

  @override
  String get referErrorNotEnabled => 'ನಿಮ್ಮ ಕಂಪನಿಗೆ ರೆಫರ್ ಮಾಡಿ ಮತ್ತು ಗಳಿಸಿ ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get referErrorNotFound => 'ರೆಫರಲ್ ಸಿಗಲಿಲ್ಲ.';

  @override
  String get referErrorSelf => 'ನಿಮ್ಮ ಸ್ವಂತ ರೆಫರಲ್ ಕೋಡ್ ಬಳಸಲು ಆಗುವುದಿಲ್ಲ.';

  @override
  String get referEventExpired => 'ಒಂದು ರೆಫರಲ್ ಅವಧಿ ಮುಗಿದಿದೆ';

  @override
  String get referEventOther => 'ರೆಫರಲ್ ಅಪ್‌ಡೇಟ್';

  @override
  String get referEventProgress => 'ಒಂದು ರೆಫರಲ್ ಮುಂದುವರಿದಿದೆ';

  @override
  String get referEventQualified => 'ಒಂದು ರೆಫರಲ್ ಬಹುಮಾನಕ್ಕೆ ಅರ್ಹವಾಗಿದೆ';

  @override
  String get referEventRegistered => 'ಒಬ್ಬ ರೈಡರ್ ರೆಫರಲ್ ಕೋಡ್‌ನೊಂದಿಗೆ ಸೇರಿದರು';

  @override
  String get referEventRewardPaid => 'ಒಂದು ರೆಫರಲ್ ಬಹುಮಾನ ಪಾವತಿಯಾಗಿದೆ';

  @override
  String get referFriendGets => 'ನಿಮ್ಮ ಸ್ನೇಹಿತರಿಗೆ ಸಿಗುವುದು';

  @override
  String get referHowItWorks => 'ಇದು ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ';

  @override
  String get referHowItWorksBody =>
      'ನಿಮ್ಮ ಕೋಡ್ ಹಂಚಿಕೊಳ್ಳಿ. ನಿಮ್ಮ ಸ್ನೇಹಿತರು ಸೇರಿ ಈ ಹಂತಗಳನ್ನು ಪೂರ್ಣಗೊಳಿಸಿದಾಗ ರೆಫರಲ್ ಬಹುಮಾನ ಸಿಗುತ್ತದೆ.';

  @override
  String get referInvited => 'ಆಹ್ವಾನಿಸಲಾಗಿದೆ';

  @override
  String referInviteValidTill(String date) {
    return 'ಈ ಆಹ್ವಾನ $date ವರೆಗೆ ಮಾನ್ಯ';
  }

  @override
  String get referMessageCopied => 'ಆಹ್ವಾನ ಸಂದೇಶ ನಕಲಿಸಲಾಗಿದೆ';

  @override
  String get referMilestoneActivated => 'ರೈಡರ್ ಆಗಿ ಸಕ್ರಿಯರಾಗಿ';

  @override
  String referMilestoneActiveDays(String count) {
    return '$count ದಿನ ಸಕ್ರಿಯರಾಗಿರಿ';
  }

  @override
  String referMilestoneAttendance(String count) {
    return '$count ದಿನ ಹಾಜರಾತಿ ಗುರುತಿಸಿ';
  }

  @override
  String referMilestoneDeliveries(String count) {
    return '$count ಡೆಲಿವರಿಗಳನ್ನು ಪೂರ್ಣಗೊಳಿಸಿ';
  }

  @override
  String get referMilestoneKyc => 'KYC ಪೂರ್ಣಗೊಳಿಸಿ';

  @override
  String get referMilestoneOther => 'ಅಭಿಯಾನದ ಹಂತ ಪೂರ್ಣಗೊಳಿಸಿ';

  @override
  String get referMilestonePayment => 'ಮೊದಲ ಪಾವತಿ ಮಾಡಿ';

  @override
  String referMilestoneRides(String count) {
    return '$count ರೈಡ್‌ಗಳನ್ನು ಪೂರ್ಣಗೊಳಿಸಿ';
  }

  @override
  String get referMilestoneTraining => 'ತರಬೇತಿ ಮುಗಿಸಿ';

  @override
  String get referMilestoneVehicle => 'ಸ್ಕೂಟರ್ ಹಂಚಿಕೆ ಪಡೆಯಿರಿ';

  @override
  String get referNoCampaignBody => 'ಹೊಸ ಬಹುಮಾನಗಳಿಗಾಗಿ ಶೀಘ್ರದಲ್ಲೇ ಮತ್ತೆ ನೋಡಿ.';

  @override
  String get referNoCampaignTitle => 'ಸದ್ಯಕ್ಕೆ ಯಾವುದೇ ರೆಫರಲ್ ಅಭಿಯಾನ ಇಲ್ಲ';

  @override
  String get referNoReferralsBody => 'ರೈಡರ್‌ಗಳನ್ನು ಆಹ್ವಾನಿಸಲು ನಿಮ್ಮ ಕೋಡ್ ಹಂಚಿಕೊಳ್ಳಿ.';

  @override
  String get referNoReferralsTitle => 'ಇನ್ನೂ ಯಾವುದೇ ರೆಫರಲ್ ಇಲ್ಲ';

  @override
  String get referPaid => 'ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get referPending => 'ಬಾಕಿ';

  @override
  String get referProgress => 'ಪ್ರಗತಿ';

  @override
  String get referQrSemantics => 'ರೆಫರಲ್ QR ಕೋಡ್';

  @override
  String get referQualified => 'ಅರ್ಹ';

  @override
  String get referRegistered => 'ನೋಂದಾಯಿತ';

  @override
  String get referRewardEarned => 'ಗಳಿಸಲಾಗಿದೆ';

  @override
  String get referRewardPending => 'ಬಾಕಿ';

  @override
  String get referRewardProcessing => 'ಪ್ರಕ್ರಿಯೆಯಲ್ಲಿದೆ';

  @override
  String get referRewardReversed => 'ಹಿಂಪಡೆಯಲಾಗಿದೆ';

  @override
  String get referRewards => 'ಬಹುಮಾನಗಳು';

  @override
  String get referScanCameraFailed => 'ಕ್ಯಾಮೆರಾ ಪ್ರಾರಂಭವಾಗಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ, ಅಥವಾ QR ಕೋಡ್‌ನ ಫೋಟೋ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String referScanFound(String code) {
    return '$code ಕೋಡ್ ಸಿಕ್ಕಿದೆ';
  }

  @override
  String get referScanFromPhotos => 'ಫೋಟೋಗಳಿಂದ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get referScanHint => 'ಕ್ಯಾಮೆರಾವನ್ನು ರೆಫರಲ್ QR ಕೋಡ್ ಕಡೆಗೆ ಹಿಡಿಯಿರಿ';

  @override
  String get referScanNoCamera => 'ಈ ಸಾಧನದಲ್ಲಿ ಸ್ಕ್ಯಾನ್ ಮಾಡಲು ಕ್ಯಾಮೆರಾ ಇಲ್ಲ. ಬದಲಿಗೆ QR ಕೋಡ್‌ನ ಫೋಟೋ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get referScanNoQrInPhoto => 'ಆ ಫೋಟೋದಲ್ಲಿ ಯಾವುದೇ QR ಕೋಡ್ ಸಿಗಲಿಲ್ಲ.';

  @override
  String get referScanNotReferral => 'ಆ QR ಕೋಡ್ ರೆಫರಲ್ ಕೋಡ್ ಅಲ್ಲ.';

  @override
  String get referScanPermissionDenied =>
      'ಕ್ಯಾಮೆರಾ ಅನುಮತಿ ಆಫ್ ಆಗಿದೆ. ಸ್ಕ್ಯಾನ್ ಮಾಡಲು ಸೆಟ್ಟಿಂಗ್ಸ್‌ನಲ್ಲಿ ಅನುಮತಿಸಿ, ಅಥವಾ QR ಕೋಡ್‌ನ ಫೋಟೋ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get referScanTitle => 'ರೆಫರಲ್ QR ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get referScanToJoin => 'ನನ್ನ ರೆಫರಲ್ ಕೋಡ್‌ನೊಂದಿಗೆ ಸೇರಲು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String referShareAndroid(String link) {
    return 'Android ನಲ್ಲಿ ಆ್ಯಪ್ ಪಡೆಯಿರಿ: $link';
  }

  @override
  String referShareCodeLine(String code) {
    return 'ಸೈನ್ ಅಪ್ ಮಾಡುವಾಗ ನನ್ನ ರೆಫರಲ್ ಕೋಡ್ $code ಬಳಸಿ.';
  }

  @override
  String referShareIntro(String app) {
    return '$app ನಲ್ಲಿ ರೈಡರ್ ಆಗಿ ನನ್ನೊಂದಿಗೆ ಸೇರಿ!';
  }

  @override
  String get referShareInvite => 'ಆಹ್ವಾನ ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String referShareIphone(String link) {
    return 'iPhone ನಲ್ಲಿ ಆ್ಯಪ್ ಪಡೆಯಿರಿ: $link';
  }

  @override
  String get referShareNow => 'ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String referShareReward(String amount) {
    return 'ಸೇರುವ ಹಂತಗಳನ್ನು ಪೂರ್ಣಗೊಳಿಸಿದಾಗ ನಿಮಗೆ $amount ಸಿಗುತ್ತದೆ.';
  }

  @override
  String get referShareSubtitle => 'ನಿಮ್ಮ ಸ್ನೇಹಿತರು QR ಸ್ಕ್ಯಾನ್ ಮಾಡಿ ಅಥವಾ ಲಿಂಕ್ ಬಳಸಿ ಸೇರಬಹುದು.';

  @override
  String get referShareTitle => 'ನಿಮ್ಮ ಆಹ್ವಾನ ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String get referShowQr => 'QR ತೋರಿಸಿ';

  @override
  String get referStatusActivated => 'ಸಕ್ರಿಯಗೊಂಡಿದೆ';

  @override
  String get referStatusCancelled => 'ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get referStatusDisqualified => 'ಅನರ್ಹ';

  @override
  String get referStatusExpired => 'ಅವಧಿ ಮುಗಿದಿದೆ';

  @override
  String get referStatusInProgress => 'ಪ್ರಗತಿಯಲ್ಲಿದೆ';

  @override
  String get referStatusKycVerified => 'KYC ಪರಿಶೀಲಿಸಲಾಗಿದೆ';

  @override
  String get referStatusPaid => 'ಬಹುಮಾನ ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get referStatusRejected => 'ತಿರಸ್ಕರಿಸಲಾಗಿದೆ';

  @override
  String get referStatusRewardApproved => 'ಬಹುಮಾನ ಅನುಮೋದಿಸಲಾಗಿದೆ';

  @override
  String get referStatusRewardPending => 'ಬಹುಮಾನ ಬಾಕಿ';

  @override
  String get referStatusUnderReview => 'ಪರಿಶೀಲನೆಯಲ್ಲಿದೆ';

  @override
  String referStepsDone(int done, int total) {
    return '$done/$total ಹಂತಗಳು';
  }

  @override
  String get referSubtitle => 'ರೈಡರ್‌ಗಳನ್ನು ಆಹ್ವಾನಿಸಿ ಮತ್ತು ಬಹುಮಾನ ಗಳಿಸಿ';

  @override
  String get referTimeline => 'ಸಮಯರೇಖೆ';

  @override
  String get referTotalEarned => 'ಒಟ್ಟು ಗಳಿಕೆ';

  @override
  String referValidTill(String date) {
    return '$date ವರೆಗೆ ಮಾನ್ಯ';
  }

  @override
  String get referYouGet => 'ನಿಮಗೆ ಸಿಗುವುದು';

  @override
  String get referYourCode => 'ನಿಮ್ಮ ರೆಫರಲ್ ಕೋಡ್';

  @override
  String get referYourQr => 'ನಿಮ್ಮ ರೆಫರಲ್ QR';

  @override
  String get referYourQrSubtitle => 'ಆ್ಯಪ್‌ನ ಆನ್‌ಬೋರ್ಡಿಂಗ್‌ನಲ್ಲಿ ಇದನ್ನು ಸ್ಕ್ಯಾನ್ ಮಾಡಲು ನಿಮ್ಮ ಸ್ನೇಹಿತರಿಗೆ ಹೇಳಿ.';

  @override
  String get referYourReferrals => 'ನಿಮ್ಮ ರೆಫರಲ್‌ಗಳು';

  @override
  String get rentalsAutoDebit => 'ಸ್ವಯಂ ಕಡಿತ';

  @override
  String get rentalsAutoDebitKeepsEveryCycle =>
      'ಸ್ವಯಂ ಕಡಿತದಿಂದ ಪ್ರತಿ ಬಾರಿಯೂ ಸಮಯಕ್ಕೆ ಪಾವತಿ ಆಗುತ್ತದೆ, ನೀವೇ ಕಳುಹಿಸಬೇಕಾಗಿಲ್ಲ';

  @override
  String get rentalsBillingPeriod => 'ಬಿಲ್ ಅವಧಿ';

  @override
  String get rentalsBills => 'ಬಿಲ್‌ಗಳು';

  @override
  String get rentalsCouldNotLoadBill => 'ಈ ಬಿಲ್ ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get rentalsCouldNotLoadLedger => 'ನಿಮ್ಮ ಲೆಡ್ಜರ್ ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get rentalsCouldNotLoadPayments => 'ನಿಮ್ಮ ಪಾವತಿಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get rentalsCouldNotLoadRentPlan => 'ನಿಮ್ಮ ಬಾಡಿಗೆ ಯೋಜನೆ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get rentalsCredit => 'ಲಭ್ಯವಿರುವ ಕ್ರೆಡಿಟ್';

  @override
  String get rentalsCreditsApplied => 'ಅನ್ವಯಿಸಿದ ಕ್ರೆಡಿಟ್';

  @override
  String get rentalsCurrentPlan => 'ಪ್ರಸ್ತುತ ಯೋಜನೆ';

  @override
  String get rentalsDepositHeld => 'ಇರಿಸಿದ ಠೇವಣಿ';

  @override
  String get rentalsDue => 'ಪಾವತಿ ದಿನಾಂಕ';

  @override
  String get rentalsDueLater => 'ನಂತರ ಪಾವತಿಸಬೇಕು';

  @override
  String get rentalsFromWallet => 'ನಿಮ್ಮ ವಾಲೆಟ್‌ನಿಂದ';

  @override
  String get rentalsInvoiceHistory => 'ಬಿಲ್ ಇತಿಹಾಸ';

  @override
  String get rentalsLedger => 'ಲೆಡ್ಜರ್';

  @override
  String get rentalsLedgerAdjustment => 'ಹೊಂದಾಣಿಕೆ';

  @override
  String get rentalsLedgerCharge => 'ಶುಲ್ಕ';

  @override
  String get rentalsLedgerCredit => 'ಕ್ರೆಡಿಟ್';

  @override
  String get rentalsLedgerDeposit => 'ಠೇವಣಿ';

  @override
  String get rentalsLedgerHint => 'ನಿಮ್ಮ ಖಾತೆಯ ಪ್ರತಿ ಶುಲ್ಕ, ಪಾವತಿ ಮತ್ತು ಕ್ರೆಡಿಟ್, ಹೊಸದು ಮೊದಲು.';

  @override
  String get rentalsLedgerPayment => 'ಪಾವತಿ';

  @override
  String get rentalsLedgerRefund => 'ಮರುಪಾವತಿ';

  @override
  String get rentalsLedgerReversal => 'ಹಿಮ್ಮುಖ';

  @override
  String get rentalsNoInvoicesYet => 'ಇನ್ನೂ ಬಿಲ್ ಇಲ್ಲ';

  @override
  String get rentalsNoLedger => 'ನಿಮ್ಮ ಲೆಡ್ಜರ್‌ನಲ್ಲಿ ಇನ್ನೂ ಏನೂ ಇಲ್ಲ';

  @override
  String get rentalsNoLedgerBody => 'ಶುಲ್ಕ ಮತ್ತು ಪಾವತಿಗಳು ನಡೆದಂತೆ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get rentalsNoPayments => 'ಇನ್ನೂ ಯಾವುದೇ ಪಾವತಿ ಇಲ್ಲ';

  @override
  String get rentalsNoPaymentsBody => 'ನಿಮ್ಮ ಬಿಲ್‌ಗಳಿಗೆ ಮಾಡುವ ಪಾವತಿಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get rentalsOutstanding => 'ಬಾಕಿ';

  @override
  String rentalsOverdueNotice(String amount) {
    return '$amount ಅವಧಿ ಮೀರಿದೆ. ಅಡಚಣೆಯಿಲ್ಲದೆ ಓಡಿಸಲು ಬೇಗ ಪಾವತಿಸಿ.';
  }

  @override
  String get rentalsPaid => 'ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get rentalsPaid2 => 'ಪಾವತಿ ದಿನಾಂಕ';

  @override
  String get rentalsPaidSoFar => 'ಇಲ್ಲಿಯವರೆಗೆ ಪಾವತಿಸಿದ್ದು';

  @override
  String get rentalsPayments => 'ಪಾವತಿಗಳು';

  @override
  String rentalsReceiptInvoices(int count) {
    return '$count ಬಿಲ್(ಗಳು) ಪಾವತಿಯಾಗಿವೆ';
  }

  @override
  String rentalsRefunded(String amount) {
    return '$amount ಮರುಪಾವತಿಸಲಾಗಿದೆ';
  }

  @override
  String get rentalsRentals => 'ಬಾಡಿಗೆ';

  @override
  String get rentalsRentHandledAutomatically => 'ಬಾಡಿಗೆ, ತಾನಾಗಿಯೇ ಕಡಿತವಾಗುತ್ತದೆ';

  @override
  String get rentalsRentReceipt => 'ಬಾಡಿಗೆ ರಸೀದಿ';

  @override
  String get rentalsRentReceiptsWillAppearHere => 'ನಿಮ್ಮ ಬಾಡಿಗೆ ರಸೀದಿಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get rentalsStatusDraft => 'ಕರಡು';

  @override
  String get rentalsStatusDue => 'ಬಾಕಿ ಇದೆ';

  @override
  String get rentalsStatusOverdue => 'ಅವಧಿ ಮೀರಿದೆ';

  @override
  String get rentalsStatusPartlyPaid => 'ಭಾಗಶಃ ಪಾವತಿ';

  @override
  String get rentalsStatusVoid => 'ರದ್ದು';

  @override
  String get rentalsStillDue => 'ಇನ್ನೂ ಬಾಕಿ';

  @override
  String get rentalsSubtitle => 'ನಿಮ್ಮ ಪ್ಲಾನ್, ಬಿಲ್‌ಗಳು ಮತ್ತು ಖಾತೆಯ ಇತಿಹಾಸ';

  @override
  String get rentalsSubtotal => 'ಉಪಮೊತ್ತ';

  @override
  String get rentalsTapReceiptSeeFullBreakdown => 'ಪೂರ್ಣ ವಿವರ ನೋಡಲು ರಸೀದಿ ಒತ್ತಿ';

  @override
  String get rentalsTax => 'ತೆರಿಗೆ';

  @override
  String get rentalsUnallocated => 'ಇನ್ನೂ ಅನ್ವಯಿಸದ ಪಾವತಿಗಳು';

  @override
  String get rentalsYourAccount => 'ನಿಮ್ಮ ಖಾತೆ';

  @override
  String get reportStatusMechanicallyOk => 'ಮೆಕ್ಯಾನಿಕಲಿ ಸರಿಯಿದೆ';

  @override
  String get reportStatusReadyForAllotment => 'ಹಂಚಿಕೆಗೆ ಸಿದ್ಧ';

  @override
  String get reportStatusUnderRepairMajor => 'ದುರಸ್ತಿಯಲ್ಲಿ: ದೊಡ್ಡದು';

  @override
  String get reportStatusUnderRepairMinor => 'ದುರಸ್ತಿಯಲ್ಲಿ: ಸಣ್ಣದು';

  @override
  String get returnsApproveCharges => 'ಶುಲ್ಕಗಳನ್ನು ಅನುಮೋದಿಸಿ';

  @override
  String returnsApproveSubtitle(String amount) {
    return 'ನಿಮ್ಮ ಫೋನ್‌ಗೆ 6 ಅಂಕಿಯ ಕೋಡ್ ಕಳುಹಿಸಿದ್ದೇವೆ. ಅದನ್ನು ನಮೂದಿಸಿದರೆ $amount ಶುಲ್ಕಗಳು ಅನುಮೋದನೆಯಾಗುತ್ತವೆ.';
  }

  @override
  String get returnsApproveTitle => 'ಕೋಡ್ ನಮೂದಿಸಿ';

  @override
  String get returnsCancel => 'ಹಿಂದಿರುಗಿಸುವಿಕೆ ರದ್ದುಮಾಡಿ';

  @override
  String get returnsCancelBody => 'ಸ್ಕೂಟರ್ ನಿಮ್ಮ ಬಳಿಯೇ ಇರುತ್ತದೆ, ಬಾಡಿಗೆ ಮೊದಲಿನಂತೆ ಮುಂದುವರಿಯುತ್ತದೆ.';

  @override
  String get returnsCancelled => 'ಹಿಂದಿರುಗಿಸುವಿಕೆ ರದ್ದಾಗಿದೆ';

  @override
  String get returnsCancelTitle => 'ಈ ಹಿಂದಿರುಗಿಸುವಿಕೆ ರದ್ದುಮಾಡಬೇಕೆ?';

  @override
  String get returnsCharges => 'ಶುಲ್ಕಗಳು';

  @override
  String get returnsChargesApproved => 'ಶುಲ್ಕಗಳು ಅನುಮೋದನೆಯಾದವು';

  @override
  String get returnsChargesPending => 'ಹಬ್ ಇನ್ನೂ ಸ್ಕೂಟರ್ ಪರಿಶೀಲಿಸುತ್ತಿದೆ. ಶುಲ್ಕಗಳಿದ್ದರೆ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get returnsCodeExpired => 'ಆ ಕೋಡ್ ಅವಧಿ ಮುಗಿದಿದೆ. ಹೊಸದನ್ನು ಕೇಳಿ.';

  @override
  String get returnsCodeInvalid => 'ಆ ಕೋಡ್ ಕೆಲಸ ಮಾಡಲಿಲ್ಲ. ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get returnsCouldNotLoad => 'ನಿಮ್ಮ ಹಿಂದಿರುಗಿಸುವಿಕೆಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get returnsCouldNotLoadHubs => 'ಹಬ್‌ಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get returnsDate => 'ಹಿಂದಿರುಗಿಸುವ ದಿನಾಂಕ';

  @override
  String get returnsDetailTitle => 'ಹಿಂದಿರುಗಿಸುವಿಕೆ';

  @override
  String get returnsDisputeCharges => 'ಶುಲ್ಕಗಳನ್ನು ಆಕ್ಷೇಪಿಸಿ';

  @override
  String get returnsDisputeReason => 'ಏನು ತಪ್ಪಾಗಿದೆ?';

  @override
  String get returnsDisputeReasonRequired => 'ಹಬ್ ತಂಡ ಪರಿಶೀಲಿಸಲು ಕಾರಣವನ್ನು ಸೇರಿಸಿ.';

  @override
  String get returnsDisputeSent => 'ಆಕ್ಷೇಪವನ್ನು ಹಬ್ ತಂಡಕ್ಕೆ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get returnsDisputeSubtitle => 'ಈ ಶುಲ್ಕಗಳಲ್ಲಿ ಏನು ತಪ್ಪಿದೆ ಎಂದು ಹಬ್ ತಂಡಕ್ಕೆ ತಿಳಿಸಿ.';

  @override
  String get returnsEndRentalBody =>
      'ಅದನ್ನು ಯಾವಾಗ ಮತ್ತು ಎಲ್ಲಿ ಹಿಂದಿರುಗಿಸುತ್ತೀರಿ ಎಂದು ತಿಳಿಸಿ. ಹಬ್ ತಂಡ ಅದನ್ನು ಪರಿಶೀಲಿಸುತ್ತದೆ, ಯಾವುದೇ ಶುಲ್ಕ ಮೊದಲು ನಿಮ್ಮ ಅನುಮೋದನೆಗೆ ಬರುತ್ತದೆ.';

  @override
  String get returnsEndRentalTitle => 'ಸ್ಕೂಟರ್ ಬೇಕಾಗಿಲ್ಲವೇ?';

  @override
  String get returnsErrorAlreadyReceived => 'ಈ ಸ್ಕೂಟರ್ ಅನ್ನು ಈಗಾಗಲೇ ಸ್ವೀಕರಿಸಲಾಗಿದೆ.';

  @override
  String get returnsErrorAlreadyRequested => 'ಈ ಬಾಡಿಗೆಗೆ ಈಗಾಗಲೇ ಹಿಂತಿರುಗಿಸುವ ಮನವಿ ಇದೆ.';

  @override
  String get returnsErrorApprovalNotPending => 'ಈ ದಂಡಗಳು ನಿಮ್ಮ ಅನುಮೋದನೆಗೆ ಕಾಯುತ್ತಿಲ್ಲ.';

  @override
  String get returnsErrorBeforeAgreement => 'ಹಿಂತಿರುಗಿಸುವ ಸಮಯ ಬಾಡಿಗೆ ಆರಂಭಕ್ಕಿಂತ ಮೊದಲಿದೆ.';

  @override
  String get returnsErrorInspectFirst => 'ದಂಡ ಸೇರಿಸುವ ಮೊದಲು ಹಿಂತಿರುಗಿಸುವಿಕೆಯ ತಪಾಸಣೆ ಮುಗಿಸಿ.';

  @override
  String get returnsErrorNotCancellable => 'ಈ ಹಿಂತಿರುಗಿಸುವಿಕೆಯನ್ನು ಇನ್ನು ರದ್ದುಗೊಳಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get returnsErrorNotDisputable => 'ಈ ದಂಡಗಳನ್ನು ಈಗ ಆಕ್ಷೇಪಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get returnsErrorNotReceivable =>
      'ಈ ಹಿಂತಿರುಗಿಸುವಿಕೆ ರದ್ದಾಗಿದೆ, ಆದ್ದರಿಂದ ಇದರ ಮೇಲೆ ಸ್ಕೂಟರ್ ಸ್ವೀಕರಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get returnsErrorNotSubmittable => 'ಈ ದಂಡಗಳನ್ನು ಈಗ ಸಲ್ಲಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get returnsErrorNotTerminable => 'ಈ ಬಾಡಿಗೆಯನ್ನು ಈಗ ಹಿಂತಿರುಗಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get returnsErrorOverrideNotAllowed => 'ಈ ಹಂತದಲ್ಲಿ ರೈಡರ್ ಅನುಮೋದನೆಯನ್ನು ಓವರ್‌ರೈಡ್ ಮಾಡಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get returnsErrorPenaltiesLocked => 'ರೈಡರ್ ಬಳಿ ಇರುವಾಗ ಅಥವಾ ಶುಲ್ಕ ವಿಧಿಸಿದ ನಂತರ ದಂಡಗಳನ್ನು ಬದಲಾಯಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get returnsErrorReceiveFirst => 'ದಂಡ ಸೇರಿಸುವ ಮೊದಲು ಸ್ಕೂಟರ್ ಸ್ವೀಕರಿಸಿ.';

  @override
  String get returnsErrorRevisePenalties => 'ರೈಡರ್ ಈ ದಂಡಗಳನ್ನು ಆಕ್ಷೇಪಿಸಿದ್ದಾರೆ. ಪಟ್ಟಿಯನ್ನು ಪರಿಷ್ಕರಿಸಿ ಮತ್ತೆ ಸಲ್ಲಿಸಿ.';

  @override
  String get returnsErrorStateChanged => 'ಈ ದಂಡಗಳು ಈಗಷ್ಟೇ ಬದಲಾಗಿವೆ. ರಿಫ್ರೆಶ್ ಮಾಡಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get returnsErrorSubmitFirst => 'ಅನುಮೋದಿಸುವ ಮೊದಲು ದಂಡಗಳನ್ನು ಸಲ್ಲಿಸಿ.';

  @override
  String returnsEvidenceCount(int count) {
    return 'ಸಾಕ್ಷಿಯಾಗಿ $count ಫೋಟೋ(ಗಳು)';
  }

  @override
  String get returnsHub => 'ಹಿಂದಿರುಗಿಸುವ ಹಬ್';

  @override
  String get returnsKindDamage => 'ಹಾನಿ';

  @override
  String get returnsKindMissing => 'ಕಾಣೆಯಾದ ವಸ್ತು';

  @override
  String get returnsLocationForHubs => 'ನಿಮಗೆ ಹತ್ತಿರದ ಹಬ್‌ಗಳನ್ನು ತೋರಿಸಲು ನಿಮ್ಮ ಸ್ಥಳವನ್ನು ಬಳಸುತ್ತೇವೆ.';

  @override
  String get returnsNextCheckIn => 'ಹಬ್ ತಂಡ ಸ್ಕೂಟರ್‌ನ ಫೋಟೋ ತೆಗೆಯುತ್ತದೆ ಮತ್ತು ಮೆಕ್ಯಾನಿಕ್ ಅದನ್ನು ಪರಿಶೀಲಿಸುತ್ತಾರೆ.';

  @override
  String get returnsNextConfirm =>
      'ವರದಿ ಮತ್ತು ಯಾವುದೇ ಶುಲ್ಕಗಳನ್ನು ದೃಢೀಕರಿಸಲು ನಿಮ್ಮ ಫೋನ್‌ಗೆ ಕೋಡ್ ಬರುತ್ತದೆ. ದೃಢೀಕರಿಸಿದ ತಕ್ಷಣ ನಿಮ್ಮ ಬಾಡಿಗೆ ಕೊನೆಗೊಳ್ಳುತ್ತದೆ.';

  @override
  String get returnsNextHandOver => 'ಆಯ್ಕೆ ಮಾಡಿದ ದಿನಾಂಕದಂದು ಸ್ಕೂಟರ್, ಅದರ ಬ್ಯಾಟರಿ ಮತ್ತು ಚಾರ್ಜರ್ ಅನ್ನು ಹಬ್‌ಗೆ ತನ್ನಿ.';

  @override
  String get returnsNoCharges => 'ಈ ಹಿಂದಿರುಗಿಸುವಿಕೆಗೆ ಯಾವುದೇ ಶುಲ್ಕವಿಲ್ಲ.';

  @override
  String get returnsNoHubsNearby => 'ನಿಮ್ಮ ಹತ್ತಿರ ಯಾವುದೇ ಹಬ್ ಸಿಗಲಿಲ್ಲ';

  @override
  String get returnsNone => 'ಇನ್ನೂ ಯಾವುದೇ ಹಿಂದಿರುಗಿಸುವಿಕೆ ಇಲ್ಲ';

  @override
  String get returnsNoneBody => 'ನೀವು ಸ್ಕೂಟರ್ ಹಿಂದಿರುಗಿಸಿದಾಗ, ಅದರ ಸ್ಥಿತಿಯನ್ನು ಇಲ್ಲಿ ನೋಡಬಹುದು.';

  @override
  String get returnsNotes => 'ಬೇರೆ ಏನಾದರೂ?';

  @override
  String get returnsNotesHint => 'ಹಬ್ ತಂಡಕ್ಕೆ ಐಚ್ಛಿಕ ಟಿಪ್ಪಣಿ';

  @override
  String get returnsNothingToReturn => 'ಈಗ ಹಿಂದಿರುಗಿಸಲು ಏನೂ ಇಲ್ಲ';

  @override
  String get returnsNothingToReturnBody => 'ನಿಮಗೆ ಸಕ್ರಿಯ ಬಾಡಿಗೆ ಇಲ್ಲ, ಅಥವಾ ಅದರ ಹಿಂದಿರುಗಿಸುವಿಕೆ ಈಗಾಗಲೇ ನಡೆಯುತ್ತಿದೆ.';

  @override
  String get returnsPickDate => 'ಹಿಂದಿರುಗಿಸುವ ದಿನಾಂಕ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get returnsPickHub => 'ಹಬ್ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get returnsPickHubSubtitle => 'ನಿಮಗೆ ಹತ್ತಿರದ ಹಬ್‌ಗಳು ಮೇಲೆ ಇವೆ';

  @override
  String get returnsPickReason => 'ಒಂದು ಕಾರಣ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String returnsPlannedFor(String date) {
    return '$date ಕ್ಕೆ ಯೋಜಿಸಲಾಗಿದೆ';
  }

  @override
  String get returnsProgress => 'ಪ್ರಗತಿ';

  @override
  String get returnsReasonBatteryIssues => 'ಬ್ಯಾಟರಿ ಅಥವಾ ಚಾರ್ಜಿಂಗ್ ಸಮಸ್ಯೆ';

  @override
  String get returnsReasonChangingJob => 'ಕೆಲಸ ಬದಲಾಯಿಸುತ್ತಿದ್ದೇನೆ';

  @override
  String get returnsReasonHealthOrFamily => 'ಆರೋಗ್ಯ ಅಥವಾ ಕುಟುಂಬದ ಕಾರಣಗಳು';

  @override
  String get returnsReasonLowEarnings => 'ಸಾಕಷ್ಟು ಸಂಪಾದನೆ ಆಗುತ್ತಿಲ್ಲ';

  @override
  String get returnsReasonNoLongerNeeded => 'ಇನ್ನು ಇದು ಬೇಕಾಗಿಲ್ಲ';

  @override
  String get returnsReasonOwnVehicle => 'ನನ್ನದೇ ವಾಹನ ಖರೀದಿಸಿದ್ದೇನೆ';

  @override
  String get returnsReasonRelocating => 'ಬೇರೆ ನಗರಕ್ಕೆ ಹೋಗುತ್ತಿದ್ದೇನೆ';

  @override
  String get returnsReasonServiceIssues => 'ಸೇವೆಯಿಂದ ತೃಪ್ತಿ ಇಲ್ಲ';

  @override
  String get returnsReasonTakingBreak => 'ಕೆಲಸದಿಂದ ಸ್ವಲ್ಪ ವಿರಾಮ ತೆಗೆದುಕೊಳ್ಳುತ್ತಿದ್ದೇನೆ';

  @override
  String get returnsReasonTooExpensive => 'ಬಾಡಿಗೆ ತುಂಬಾ ಹೆಚ್ಚು';

  @override
  String get returnsReasonVehicleIssues => 'ಸ್ಕೂಟರ್‌ನಲ್ಲಿ ಸಮಸ್ಯೆಗಳು';

  @override
  String get returnsRequested => 'ಹಿಂದಿರುಗಿಸುವ ವಿನಂತಿ ಸಲ್ಲಿಸಲಾಗಿದೆ. ಹಬ್‌ನಲ್ಲಿ ಭೇಟಿಯಾಗೋಣ.';

  @override
  String get returnsRequestReturn => 'ಹಿಂದಿರುಗಿಸಲು ವಿನಂತಿಸಿ';

  @override
  String get returnsRequestSubtitle => 'ದಿನಾಂಕ ಮತ್ತು ನೀವು ತರುವ ಹಬ್ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get returnsSendDispute => 'ಆಕ್ಷೇಪ ಕಳುಹಿಸಿ';

  @override
  String get returnsStatusAwaitingManager => 'ಹಬ್ ಮ್ಯಾನೇಜರ್ ಬಳಿ';

  @override
  String get returnsStatusCancelled => 'ರದ್ದಾಗಿದೆ';

  @override
  String get returnsStatusCheckingIn => 'ಸಬ್‌ಮಿಷನ್ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get returnsStatusClosed => 'ಮುಕ್ತಾಯ';

  @override
  String get returnsStatusDisputed => 'ಆಕ್ಷೇಪಿಸಲಾಗಿದೆ';

  @override
  String get returnsStatusFinalChecks => 'ಅಂತಿಮ ತಪಾಸಣೆ';

  @override
  String get returnsStatusInspecting => 'ಪರಿಶೀಲನೆ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get returnsStatusNeedsYou => 'ನಿಮ್ಮ ಅನುಮೋದನೆ ಬೇಕು';

  @override
  String get returnsStatusRequested => 'ಹಿಂದಿರುಗಿಸುವ ವಿನಂತಿ';

  @override
  String get returnsStepCheckIn => 'ಸ್ಕೂಟರ್ ಸಬ್‌ಮಿಟ್ ಆಗಿದೆ';

  @override
  String get returnsStepClosed => 'ಹಿಂದಿರುಗಿಸುವಿಕೆ ಪೂರ್ಣ';

  @override
  String get returnsStepFinalChecks => 'ಅಂತಿಮ ಮೆಕ್ಯಾನಿಕ್ ತಪಾಸಣೆ';

  @override
  String get returnsStepHandedOver => 'ಸ್ಕೂಟರ್ ಹಸ್ತಾಂತರ';

  @override
  String get returnsStepInspection => 'ಪರಿಶೀಲನೆ ಮತ್ತು ಶುಲ್ಕಗಳು';

  @override
  String get returnsStepRequested => 'ಹಿಂದಿರುಗಿಸುವ ವಿನಂತಿ';

  @override
  String get returnsSubtitle => 'ನಿಮ್ಮ ಬಾಡಿಗೆ ಮುಗಿಸಿ ಸ್ಕೂಟರ್ ಹಿಂದಿರುಗಿಸಿ';

  @override
  String get returnsTitle => 'ಸ್ಕೂಟರ್ ಹಿಂದಿರುಗಿಸಿ';

  @override
  String get returnsWhenWhere => 'ಯಾವಾಗ ಮತ್ತು ಎಲ್ಲಿ';

  @override
  String get returnsWhy => 'ನೀವು ಇದನ್ನು ಏಕೆ ಹಿಂದಿರುಗಿಸುತ್ತಿದ್ದೀರಿ?';

  @override
  String get returnsYourDispute => 'ನಿಮ್ಮ ಆಕ್ಷೇಪ';

  @override
  String get returnsYourReturns => 'ನಿಮ್ಮ ಹಿಂದಿರುಗಿಸುವಿಕೆಗಳು';

  @override
  String get rideParkedLocked => 'ನಿಲ್ಲಿಸಿ ಬೀಗ ಹಾಕಲಾಗಿದೆ.';

  @override
  String get rideRideSafeHelmetLightsChecked => 'ಸುರಕ್ಷಿತವಾಗಿ ಓಡಿಸಿ. ಹೆಲ್ಮೆಟ್ ಹಾಕಿ, ದೀಪ ಪರಿಶೀಲಿಸಿ.';

  @override
  String get ridersActive => 'ಸಕ್ರಿಯ';

  @override
  String get ridersCall => 'ಕರೆ ಮಾಡಿ';

  @override
  String get ridersExited => 'ಬಿಟ್ಟಿದ್ದಾರೆ';

  @override
  String get ridersOnboarding => 'ನೋಂದಣಿ ಪ್ರಕ್ರಿಯೆ';

  @override
  String get ridersTeam => 'ತಂಡ';

  @override
  String get rideScooterConnectedUsePowerButton => 'ನಿಮ್ಮ ಸ್ಕೂಟರ್ ಜೋಡಿಸಲಾಗಿದೆ. ಆನ್ ಮಾಡಲು ಪವರ್ ಬಟನ್ ಒತ್ತಿ.';

  @override
  String get rideVehicle => 'ವಾಹನ ಆನ್ ಆಗಿದೆ';

  @override
  String get rideVehicleOff => 'ವಾಹನ ಆಫ್ ಆಗಿದೆ';

  @override
  String routerNoScreenAt(String location) {
    return '$location ನಲ್ಲಿ ಯಾವ ಪರದೆಯೂ ಇಲ್ಲ';
  }

  @override
  String get scooterAllowedFromHub => 'ಹಬ್‌ನಿಂದ ಅನುಮತಿ';

  @override
  String get scooterBatteryCharge => 'ಬ್ಯಾಟರಿ ಚಾರ್ಜ್';

  @override
  String get scooterBatterySerial => 'ಬ್ಯಾಟರಿ ಸೀರಿಯಲ್';

  @override
  String get scooterBatteryType => 'ಬ್ಯಾಟರಿ ಬಗೆ';

  @override
  String get scooterCharging => 'ಚಾರ್ಜಿಂಗ್';

  @override
  String get scooterClusterManager => 'ಕ್ಲಸ್ಟರ್ ಮ್ಯಾನೇಜರ್';

  @override
  String get scooterControllerNumber => 'ಕಂಟ್ರೋಲರ್ ಸಂಖ್ಯೆ';

  @override
  String get scooterCouldNotLoadVehicle => 'ನಿಮ್ಮ ವಾಹನದ ಮಾಹಿತಿ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get scooterDeliveryBox => 'ಡೆಲಿವರಿ ಬಾಕ್ಸ್';

  @override
  String get scooterHealth => 'ಸ್ಥಿತಿ';

  @override
  String get scooterHelmet => 'ಹೆಲ್ಮೆಟ್';

  @override
  String get scooterIdentity => 'ಗುರುತು';

  @override
  String get scooterMotorNumber => 'ಮೋಟಾರ್ ಸಂಖ್ಯೆ';

  @override
  String get scooterNextService => 'ಮುಂದಿನ ಸೇವೆ';

  @override
  String get scooterNoScooterHasBeenAllocated => 'ನಿಮಗೆ ಇನ್ನೂ ಸ್ಕೂಟರ್ ನೀಡಿಲ್ಲ.';

  @override
  String get scooterNoScooterMessage => 'ನಿಮ್ಮ ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್ ನಿಮಗೆ ಸ್ಕೂಟರ್ ನೀಡಿದಾಗ, ಅದರ ವಿವರಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get scooterNoScooterTitle => 'ಸದ್ಯಕ್ಕೆ ಯಾವುದೇ ಸ್ಕೂಟರ್ ಇಲ್ಲ';

  @override
  String get scooterOdometerService => 'ಓಡೋಮೀಟರ್ ಮತ್ತು ಸೇವೆ';

  @override
  String get scooterParked => 'ನಿಲ್ಲಿಸಿದ ಸ್ಥಳ';

  @override
  String get scooterPowertrain => 'ಪವರ್‌ಟ್ರೈನ್';

  @override
  String get scooterRange => 'ವ್ಯಾಪ್ತಿ';

  @override
  String get scooterVehicleDetails => 'ವಾಹನದ ವಿವರ';

  @override
  String get scooterVehicleNumber => 'ವಾಹನ ಸಂಖ್ಯೆ';

  @override
  String get scooterViewFullDetails => 'ಪೂರ್ಣ ವಿವರ ನೋಡಿ';

  @override
  String get scooterWhereBelongs => 'ಇದು ಎಲ್ಲಿಯದು';

  @override
  String get scooterWhoLooksAfter => 'ನಿಮ್ಮನ್ನು ಯಾರು ನೋಡಿಕೊಳ್ಳುತ್ತಾರೆ';

  @override
  String get submissionAddDamagedItem => 'ಹಾನಿಯಾದ ಭಾಗ ಸೇರಿಸಿ';

  @override
  String get submissionBypass => 'ಕೋಡ್ ಬಳಸಲು ಆಗುತ್ತಿಲ್ಲವೇ?';

  @override
  String get submissionBypassing => 'ಕೋಡ್ ಬಿಡಲಾಗುತ್ತಿದೆ';

  @override
  String get submissionBypassReason => 'ಅವರು ಕೋಡ್‌ನಿಂದ ಏಕೆ ದೃಢೀಕರಿಸಲು ಆಗುತ್ತಿಲ್ಲ?';

  @override
  String submissionBypassRider(String reason) {
    return 'ರೈಡರ್ ಕೋಡ್ ಬಿಡಲಾಗಿದೆ: $reason';
  }

  @override
  String submissionBypassTeamLead(String reason) {
    return 'ಟೀಮ್ ಲೀಡ್ ಕೋಡ್ ಬಿಡಲಾಗಿದೆ: $reason';
  }

  @override
  String submissionCancelledBecause(String reason) {
    return 'ರದ್ದು: $reason';
  }

  @override
  String get submissionCancelReason => 'ಕಾರಣ';

  @override
  String get submissionCancelReasonNeeded => 'ವರದಿ ರದ್ದುಮಾಡಲು ಕಾರಣ ನಮೂದಿಸಿ.';

  @override
  String get submissionCancelReport => 'ವರದಿ ರದ್ದುಮಾಡಿ';

  @override
  String get submissionCancelReportHint => 'ಕಾರಣ ತಿಳಿಸಿ. ನಂತರ ಹೊಸ ವರದಿ ದಾಖಲಿಸಬಹುದು.';

  @override
  String get submissionCancelReportTitle => 'ಈ ವರದಿ ರದ್ದುಮಾಡಬೇಕೇ?';

  @override
  String get submissionCharges => 'ಶುಲ್ಕಗಳು';

  @override
  String get submissionChassis => 'ಚಾಸಿಸ್';

  @override
  String get submissionChecksComplete => 'ಎಲ್ಲಾ ಮೆಕ್ಯಾನಿಕ್ ತಪಾಸಣೆಗಳು ಮುಗಿದಿವೆ';

  @override
  String get submissionChooseSparePart => 'ಹಾನಿಯಾದ ಭಾಗವನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get submissionChooseSparePartHint => 'ಬೆಲೆಗಳು ನಿಮ್ಮ ಬಿಡಿಭಾಗಗಳ ಪಟ್ಟಿಯಿಂದ ಬರುತ್ತವೆ.';

  @override
  String get submissionCodeNotSent => 'ಕೋಡ್ ಕಳುಹಿಸಲು ಆಗಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ ಅಥವಾ ಕಾರಣ ದಾಖಲಿಸಿ.';

  @override
  String get submissionCodePending => 'ಇನ್ನೂ ಕೋಡ್ ಇಲ್ಲ';

  @override
  String get submissionCodeSent => 'ಕೋಡ್ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String submissionCodeSentTo(String phone) {
    return '$phone ಗೆ ಕೋಡ್ ಕಳುಹಿಸಲಾಗಿದೆ';
  }

  @override
  String get submissionCodesSent => 'ಕೋಡ್‌ಗಳನ್ನು ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get submissionCollect => 'ದೃಢೀಕರಣ ಪಡೆಯಿರಿ';

  @override
  String get submissionConfirm => 'ವರದಿ ದೃಢೀಕರಿಸಿ';

  @override
  String get submissionConfirmed => 'ವರದಿ ದೃಢೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get submissionConfirmHint =>
      'ರೈಡರ್ ಮತ್ತು ಟೀಮ್ ಲೀಡ್ ಇಬ್ಬರಿಗೂ SMS ಮೂಲಕ ಕೋಡ್ ಬರುತ್ತದೆ. ದೃಢೀಕರಿಸಲು ಎರಡೂ ಕೋಡ್‌ಗಳನ್ನು ನಮೂದಿಸಿ. ಯಾರಾದರೂ ಕೋಡ್ ಬಳಸಲು ಆಗದಿದ್ದರೆ, ಕಾರಣ ದಾಖಲಿಸಿ.';

  @override
  String get submissionConfirmTitle => 'ವರದಿ ದೃಢೀಕರಣ';

  @override
  String get submissionCouldNotLoad => 'ಈ ಸಬ್‌ಮಿಷನ್ ಲೋಡ್ ಆಗಲಿಲ್ಲ';

  @override
  String get submissionCouldNotLoadParts => 'ಬಿಡಿಭಾಗಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get submissionDamagedItems => 'ಹಾನಿಯಾದ ಭಾಗಗಳು';

  @override
  String get submissionDamagedItemsHint =>
      'ಬಿಡಿಭಾಗಗಳ ಪಟ್ಟಿಯಿಂದ ಪ್ರತಿಯೊಂದು ಹಾನಿಯಾದ ಭಾಗವನ್ನು ಸೇರಿಸಿ. ಅದರ ಬೆಲೆ ತಾನಾಗಿಯೇ ತುಂಬುತ್ತದೆ.';

  @override
  String get submissionEvidence => 'ಪುರಾವೆ ಫೋಟೋಗಳು';

  @override
  String get submissionEvidenceHint => 'ಈ ವರದಿಗೆ ಆಧಾರವಾಗುವ ಫೋಟೋಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String submissionEvidenceLimit(int count) {
    return 'ನೀವು ಗರಿಷ್ಠ $count ಫೋಟೋಗಳನ್ನು ಆಯ್ಕೆಮಾಡಬಹುದು.';
  }

  @override
  String get submissionEvidenceNeeded => 'ಕನಿಷ್ಠ ಒಂದು ಪುರಾವೆ ಫೋಟೋ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get submissionExchangeStarted => 'ಎಕ್ಸ್‌ಚೇಂಜ್ ಪ್ರಾರಂಭವಾಗಿದೆ';

  @override
  String get submissionFindings => 'ಪರಿಶೀಲನೆಯ ಫಲಿತಾಂಶ';

  @override
  String get submissionImpose => 'ವರದಿ ಜಾರಿಗೊಳಿಸಿ';

  @override
  String get submissionImposeBody =>
      'ರೈಡರ್ ಪರಿಶೀಲನೆಯ ಫಲಿತಾಂಶ ಮತ್ತು ಶುಲ್ಕಗಳನ್ನು ನೋಡಿದ್ದಾರೆ ಎಂದು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ. ಇದರ ನಂತರ ವರದಿಯನ್ನು ಬದಲಿಸಲು ಆಗುವುದಿಲ್ಲ, ರದ್ದು ಮಾತ್ರ ಮಾಡಬಹುದು.';

  @override
  String get submissionImposed => 'ವರದಿ ಜಾರಿಯಾಗಿದೆ';

  @override
  String get submissionImposeTitle => 'ಈ ವರದಿ ಜಾರಿಗೊಳಿಸಬೇಕೇ?';

  @override
  String get submissionItemNote => 'ಟಿಪ್ಪಣಿ (ಐಚ್ಛಿಕ)';

  @override
  String get submissionItemNoteHint => 'ಹಾನಿ ಎಲ್ಲಿದೆ?';

  @override
  String get submissionItemPhotoNeeded => 'ಈ ಭಾಗದ ಕನಿಷ್ಠ ಒಂದು ಫೋಟೋ ತೆಗೆಯಿರಿ.';

  @override
  String get submissionItemPhotoOptionalHint =>
      'ಈ ಭಾಗಕ್ಕೆ ಫೋಟೋ ಕಡ್ಡಾಯವಲ್ಲ, ಆದರೆ ರೈಡರ್‌ಗೆ ಪ್ರಶ್ನೆಗಳಿದ್ದರೆ ಸಹಾಯವಾಗುತ್ತದೆ.';

  @override
  String get submissionItemPhotoRequiredHint => 'ಈ ಭಾಗಕ್ಕೆ ಪುರಾವೆಯಾಗಿ ಫೋಟೋ ಬೇಕು. ಹಾನಿಯ ಸ್ಪಷ್ಟ ಹತ್ತಿರದ ಫೋಟೋ ತೆಗೆಯಿರಿ.';

  @override
  String get submissionMaintenanceDetails => 'ಏನು ಸರಿಪಡಿಸಬೇಕು?';

  @override
  String get submissionMechanicName => 'ಸಲ್ಲಿಸಿದವರು / ಮೆಕ್ಯಾನಿಕ್ ಹೆಸರು';

  @override
  String get submissionNameNeeded => 'ಮೆಕ್ಯಾನಿಕ್ ಹೆಸರು ನಮೂದಿಸಿ';

  @override
  String get submissionNoDamagedItems => 'ಯಾವುದೇ ಹಾನಿಯಾದ ಭಾಗ ಸೇರಿಸಿಲ್ಲ, ಆದ್ದರಿಂದ ರೈಡರ್‌ಗೆ ಶುಲ್ಕ ವಿಧಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get submissionNoPrices =>
      'ಇನ್ನೂ ಯಾವುದೇ ದಂಡದ ದರಗಳನ್ನು ಹೊಂದಿಸಿಲ್ಲ. ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ನಲ್ಲಿ ಸೇರಿಸಲು ಅಡ್ಮಿನ್‌ಗೆ ಕೇಳಿ.';

  @override
  String get submissionNoSparePartMatch => 'ನಿಮ್ಮ ಹುಡುಕಾಟಕ್ಕೆ ಯಾವುದೇ ಭಾಗ ಹೊಂದುತ್ತಿಲ್ಲ';

  @override
  String get submissionNothingToConfirm => 'ದೃಢೀಕರಿಸಲು ಏನೂ ಇಲ್ಲ';

  @override
  String get submissionNothingToConfirmBody => 'ಈ ಸಬ್‌ಮಿಷನ್‌ನಲ್ಲಿ ಕೋಡ್‌ಗಾಗಿ ಕಾಯುತ್ತಿರುವ ಯಾವುದೇ ಜಾರಿಯಾದ ವರದಿ ಇಲ್ಲ.';

  @override
  String get submissionPartyRider => 'ರೈಡರ್';

  @override
  String get submissionPartyTeamLead => 'ಟೀಮ್ ಲೀಡ್';

  @override
  String submissionPhotoBattery(String name) {
    return 'ಬ್ಯಾಟರಿ $name';
  }

  @override
  String get submissionPhotoBatteryGeneric => 'ಬ್ಯಾಟರಿ';

  @override
  String get submissionPhotoChecklist => 'ಹಿಂತಿರುಗಿಸುವ ಪರಿಶೀಲನಾ ಪಟ್ಟಿ';

  @override
  String submissionPhotoController(String number) {
    return 'ಕಂಟ್ರೋಲರ್ $number';
  }

  @override
  String get submissionPhotoControllerGeneric => 'ಕಂಟ್ರೋಲರ್';

  @override
  String get submissionPhotoDamage => 'ಹಾನಿಯ ಫೋಟೋ';

  @override
  String get submissionPhotoIot => 'IoT ಸಾಧನ';

  @override
  String get submissionPhotos => 'ಅಗತ್ಯ ಫೋಟೋಗಳು';

  @override
  String get submissionPhotosHint => 'ಫೋಟೋ ತೆಗೆಯಲು ಖಾಲಿ ಸ್ಲಾಟ್ ಟ್ಯಾಪ್ ಮಾಡಿ. ತೆಗೆದ ಫೋಟೋ ನೋಡಲು ಅದನ್ನು ಟ್ಯಾಪ್ ಮಾಡಿ.';

  @override
  String get submissionPriceChanged =>
      'ಒಂದು ಭಾಗದ ಬೆಲೆ ಅಥವಾ ಫೋಟೋ ನಿಯಮ ಈಗಷ್ಟೇ ಬದಲಾಗಿದೆ. ಅದನ್ನು ತೆಗೆದುಹಾಕಿ ಪಟ್ಟಿಯಿಂದ ಮತ್ತೆ ಸೇರಿಸಿ.';

  @override
  String get submissionQuantity => 'ಪ್ರಮಾಣ';

  @override
  String get submissionReceivingHub => 'ಸ್ವೀಕರಿಸುವ ಹಬ್';

  @override
  String get submissionRecordReport => 'ಮೆಕ್ಯಾನಿಕ್ ವರದಿ ದಾಖಲಿಸಿ';

  @override
  String get submissionRemovePhoto => 'ಫೋಟೋ ತೆಗೆದುಹಾಕಿ';

  @override
  String submissionReportBy(String name) {
    return '$name ಅವರಿಂದ';
  }

  @override
  String get submissionReportCancelled => 'ವರದಿ ರದ್ದಾಗಿದೆ';

  @override
  String get submissionReports => 'ಮೆಕ್ಯಾನಿಕ್ ವರದಿಗಳು';

  @override
  String get submissionReportSaved => 'ವರದಿ ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get submissionReportSummary => 'ಸಾರಾಂಶ';

  @override
  String get submissionReportSummaryHint =>
      'ಉಳಿಸುವ ಮೊದಲು ಪುರಾವೆ ಫೋಟೋಗಳು ಮತ್ತು ಶುಲ್ಕಗಳನ್ನು ಪರಿಶೀಲಿಸಿ. ವರದಿಯನ್ನು ಜಾರಿಗೊಳಿಸಿದಾಗ ರೈಡರ್‌ಗೆ ಈ ಶುಲ್ಕ ಪಾವತಿಸಲು ಕೇಳಲಾಗುತ್ತದೆ.';

  @override
  String get submissionResendAll => 'ಕೋಡ್‌ಗಳನ್ನು ಮತ್ತೆ ಕಳುಹಿಸಿ';

  @override
  String get submissionRiderNote => 'ರೈಡರ್‌ನ ಟಿಪ್ಪಣಿ';

  @override
  String get submissionSafeQuestion => 'ಸ್ಕೂಟರ್‌ನ ಪ್ರಸ್ತುತ ಸ್ಥಿತಿ';

  @override
  String get submissionSafetyNeeded => 'ಸ್ಕೂಟರ್‌ನ ಪ್ರಸ್ತುತ ಸ್ಥಿತಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get submissionsAll => 'ಎಲ್ಲಾ';

  @override
  String get submissionSaveItem => 'ಭಾಗ ಉಳಿಸಿ';

  @override
  String get submissionSaveReport => 'ವರದಿ ಉಳಿಸಿ';

  @override
  String submissionScooterStatusLine(String status) {
    return 'ಸ್ಕೂಟರ್ ಸ್ಥಿತಿ: $status';
  }

  @override
  String get submissionsCouldNotLoad => 'ಹಿಂತಿರುಗಿಸುವಿಕೆ ಮತ್ತು ಬದಲಾವಣೆಗಳು ಲೋಡ್ ಆಗಲಿಲ್ಲ';

  @override
  String get submissionsDrawerSubtitle => 'ಹಿಂತಿರುಗಿದ ಸ್ಕೂಟರ್‌ಗಳ ಸಬ್‌ಮಿಷನ್';

  @override
  String submissionsDropOff(String date) {
    return 'ಒಪ್ಪಿಸುವಿಕೆ $date';
  }

  @override
  String get submissionsDropOffDate => 'ಒಪ್ಪಿಸುವ ದಿನಾಂಕ';

  @override
  String get submissionSearchSpareParts => 'ಭಾಗದ ಹೆಸರು ಅಥವಾ ಕೋಡ್‌ನಿಂದ ಹುಡುಕಿ';

  @override
  String get submissionsEmptyAll => 'ನಿಮ್ಮ ಹಬ್‌ನ ಹಿಂತಿರುಗಿಸುವಿಕೆ ಮತ್ತು ಬದಲಾವಣೆಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get submissionsEmptyChecks => 'ಯಾವುದೇ ಸಬ್‌ಮಿಷನ್ ನಡೆಯುತ್ತಿಲ್ಲ.';

  @override
  String get submissionsEmptyScheduled => 'ಈಗ ನಿಮ್ಮ ಹಬ್‌ಗೆ ಯಾವುದೇ ಸ್ಕೂಟರ್ ಬರಬೇಕಿಲ್ಲ.';

  @override
  String get submissionsEmptyTitle => 'ಇಲ್ಲಿ ಏನೂ ಇಲ್ಲ';

  @override
  String get submissionSendCodes => 'ಕೋಡ್‌ಗಳನ್ನು ಕಳುಹಿಸಿ';

  @override
  String get submissionsExchanges => 'ಬದಲಾವಣೆಗಳು';

  @override
  String get submissionsExchangesDue => 'ಬಾಕಿ ಬದಲಾವಣೆ';

  @override
  String get submissionsInChecks => 'ತಪಾಸಣೆಯಲ್ಲಿ';

  @override
  String get submissionSourceExchange => 'ಬದಲಾವಣೆ';

  @override
  String get submissionSourceReturn => 'ಹಿಂತಿರುಗಿಸುವಿಕೆ';

  @override
  String get submissionsReturns => 'ಹಿಂತಿರುಗಿಸುವಿಕೆಗಳು';

  @override
  String get submissionsReturnsDue => 'ಬಾಕಿ ಹಿಂತಿರುಗಿಸುವಿಕೆ';

  @override
  String get submissionsScheduled => 'ನಿಗದಿತ';

  @override
  String get submissionsSubtitle => 'ರೈಡರ್‌ಗಳು ನಿಮ್ಮ ಹಬ್‌ಗೆ ಹಿಂತಿರುಗಿಸುವ ಸ್ಕೂಟರ್‌ಗಳ ಸಬ್‌ಮಿಷನ್ ಪ್ರಾರಂಭಿಸಿ.';

  @override
  String submissionStaffReturnBody(String rider, String vehicle) {
    return 'ಇದು $vehicle ನ ಸಬ್‌ಮಿಷನ್ ಅನ್ನು ಈಗ ಪ್ರಾರಂಭಿಸುತ್ತದೆ. ಮೆಕ್ಯಾನಿಕ್ ವರದಿ ದೃಢೀಕರಿಸಿದ ತಕ್ಷಣ $rider ಅವರ ಬಾಡಿಗೆ ಕೊನೆಗೊಳ್ಳುತ್ತದೆ.';
  }

  @override
  String get submissionStaffReturnTitle => 'ಈ ಸ್ಕೂಟರ್ ಹಿಂಪಡೆಯಬೇಕೇ?';

  @override
  String get submissionStageCheckingIn => 'ಸಬ್‌ಮಿಷನ್ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get submissionStageDone => 'ಮುಗಿದಿದೆ';

  @override
  String get submissionStageScheduled => 'ನಿಗದಿತ';

  @override
  String get submissionStart => 'ಸಬ್‌ಮಿಷನ್ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get submissionStartBody =>
      'ರೈಡರ್ ಸ್ಕೂಟರ್ ಜೊತೆ ಹಬ್‌ಗೆ ಬಂದ ನಂತರ ಪ್ರಾರಂಭಿಸಿ. ಸಬ್‌ಮಿಷನ್ ಮುಗಿಯುವವರೆಗೆ ಸ್ಕೂಟರ್ ಅನ್ನು ಮತ್ತೆ ಹಂಚಲು ಆಗುವುದಿಲ್ಲ.';

  @override
  String get submissionStartBodyExchange =>
      'ರೈಡರ್ ಸ್ಕೂಟರ್ ಜೊತೆ ಹಬ್‌ಗೆ ಬಂದ ನಂತರ ಪ್ರಾರಂಭಿಸಿ. ಎಕ್ಸ್‌ಚೇಂಜ್ ಮುಗಿಯುವವರೆಗೆ ಸ್ಕೂಟರ್ ಅನ್ನು ಮತ್ತೆ ಹಂಚಲು ಆಗುವುದಿಲ್ಲ.';

  @override
  String get submissionStarted => 'ಸಬ್‌ಮಿಷನ್ ಪ್ರಾರಂಭವಾಗಿದೆ';

  @override
  String get submissionStartedAt => 'ಪ್ರಾರಂಭ';

  @override
  String get submissionStartExchange => 'ಎಕ್ಸ್‌ಚೇಂಜ್ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get submissionStartTitle => 'ಸಬ್‌ಮಿಷನ್ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get submissionStatusAvailableHint => 'ಓಡಿಸಲು ಸುರಕ್ಷಿತ. ಸ್ಕೂಟರ್ ಫ್ಲೀಟ್‌ಗೆ ಮರಳುತ್ತದೆ.';

  @override
  String get submissionStatusAwaitingPartsHint =>
      'ಬಿಡಿಭಾಗಗಳಿಗಾಗಿ ಕಾಯುತ್ತಿದೆ. ಅವುಗಳನ್ನು ಅಳವಡಿಸುವವರೆಗೆ ಇದನ್ನು ನೀಡಲು ಆಗುವುದಿಲ್ಲ.';

  @override
  String get submissionStatusBrokenHint => 'ದೊಡ್ಡ ದುರಸ್ತಿ ಬೇಕು. ದುರಸ್ತಿಯಾಗುವವರೆಗೆ ಇದನ್ನು ನೀಡಲು ಆಗುವುದಿಲ್ಲ.';

  @override
  String get submissionStatusCancelled => 'ರದ್ದಾಗಿದೆ';

  @override
  String get submissionStatusMaintenanceHint => 'ದುರಸ್ತಿ ಬೇಕು. ಸರಿಯಾಗುವವರೆಗೆ ಇದನ್ನು ನೀಡಲು ಆಗುವುದಿಲ್ಲ.';

  @override
  String get submissionsTitle => 'ಹಿಂತಿರುಗಿಸುವಿಕೆ ಮತ್ತು ಬದಲಾವಣೆ';

  @override
  String get submissionSummary => 'ಮೆಕ್ಯಾನಿಕ್ ಕಂಡುಕೊಂಡದ್ದು';

  @override
  String get submissionSummaryHint => 'ಬಾಡಿ, ಬ್ಯಾಟರಿ, ಕಂಟ್ರೋಲರ್ ಮತ್ತು ಪರಿಕರಗಳ ಸ್ಥಿತಿ';

  @override
  String get submissionSummaryNeeded => 'ಮೆಕ್ಯಾನಿಕ್ ಕಂಡುಕೊಂಡದ್ದನ್ನು ವಿವರಿಸಿ';

  @override
  String get submissionUseCode => 'ಬದಲಿಗೆ ಕೋಡ್ ಬಳಸಿ';

  @override
  String get submissionVerifiedRider => 'ರೈಡರ್ ಕೋಡ್‌ನಿಂದ ದೃಢೀಕರಿಸಿದ್ದಾರೆ';

  @override
  String get submissionVerifiedTeamLead => 'ಟೀಮ್ ಲೀಡ್ ಕೋಡ್‌ನಿಂದ ದೃಢೀಕರಿಸಿದ್ದಾರೆ';

  @override
  String get submissionVerify => 'ಕೋಡ್ ಪರಿಶೀಲಿಸಿ';

  @override
  String get submissionViewPhoto => 'ಫೋಟೋ ನೋಡಿ';

  @override
  String get submissionWhatNeedsWorkNeeded => 'ಏನು ಸರಿಪಡಿಸಬೇಕು ಎಂದು ವಿವರಿಸಿ';

  @override
  String get supportAccidentTheft => 'ಅಪಘಾತ ಅಥವಾ ಕಳ್ಳತನ';

  @override
  String get supportAddFewMoreDetails10 => 'ಇನ್ನಷ್ಟು ವಿವರ ಬರೆಯಿರಿ (10+ ಅಕ್ಷರ)';

  @override
  String get supportAll => 'ಎಲ್ಲಾ';

  @override
  String get supportBatteryCharging => 'ಬ್ಯಾಟರಿ ಅಥವಾ ಚಾರ್ಜಿಂಗ್';

  @override
  String get supportBreakdownRoad => 'ರಸ್ತೆಯಲ್ಲಿ ಕೆಟ್ಟುಹೋಗಿದೆ';

  @override
  String get supportCouldNotLoadSupport => 'ಸಹಾಯ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get supportCouldNotLoadTicket => 'ಈ ಟಿಕೆಟ್ ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get supportDescription => 'ವಿವರಣೆ';

  @override
  String get supportDeskEmpty => 'ಇಲ್ಲಿ ಯಾವುದೇ ಟಿಕೆಟ್ ಇಲ್ಲ';

  @override
  String get supportDeskEmptyBody => 'ನಿಮ್ಮ ಹಬ್‌ಗಳಲ್ಲಿ ರೈಡರ್‌ಗಳು ಸಲ್ಲಿಸುವ ಟಿಕೆಟ್‌ಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get supportDeskSubtitle => 'ನಿಮ್ಮ ಹಬ್‌ಗಳ ರೈಡರ್ ಟಿಕೆಟ್‌ಗಳು';

  @override
  String get supportDeskTitle => 'ಸಹಾಯ ಡೆಸ್ಕ್';

  @override
  String get supportDocumentsKyc => 'ದಾಖಲೆಗಳು ಮತ್ತು ಕೆವೈಸಿ';

  @override
  String get supportHub => 'ಹಬ್';

  @override
  String get supportInProgress => 'ಪ್ರಗತಿಯಲ್ಲಿದೆ';

  @override
  String get supportMarkResolved => 'ಪರಿಹರಿಸಲಾಗಿದೆ';

  @override
  String get supportMoreDetailGiveFasterCan => 'ನೀವು ಹೆಚ್ಚು ವಿವರ ನೀಡಿದಷ್ಟೂ ನಾವು ಬೇಗ ಸಹಾಯ ಮಾಡಬಹುದು';

  @override
  String get supportNeedHelpWithSomething => 'ಏನಾದರೂ ಸಹಾಯ ಬೇಕೆ?';

  @override
  String get supportNothingOpenRightNow => 'ಈಗ ಏನೂ ತೆರೆದಿಲ್ಲ';

  @override
  String get supportNoTicketsYet => 'ಇನ್ನೂ ದೂರು ಇಲ್ಲ';

  @override
  String get supportOneLineSumsUpIssue => 'ಸಮಸ್ಯೆಯನ್ನು ಒಂದು ಸಾಲಿನಲ್ಲಿ ಬರೆಯಿರಿ';

  @override
  String supportOpenCount(int count) {
    return '$count ತೆರೆದಿವೆ';
  }

  @override
  String get supportOpenTickets => 'ತೆರೆದ ದೂರುಗಳು';

  @override
  String get supportPaymentWallet => 'ಪಾವತಿ ಅಥವಾ ವ್ಯಾಲೆಟ್';

  @override
  String get supportPdfAttachment => 'PDF ದಾಖಲೆ';

  @override
  String supportPhotosHint(int count) {
    return 'ಸಮಸ್ಯೆಯನ್ನು ವಿವರಿಸಲು ಸಹಾಯವಾದರೆ $count ಫೋಟೋಗಳವರೆಗೆ ಸೇರಿಸಿ.';
  }

  @override
  String supportPhotosNotAttached(int count) {
    return 'ಟಿಕೆಟ್ ಸಲ್ಲಿಸಲಾಗಿದೆ, ಆದರೆ $count ಫೋಟೋ(ಗಳನ್ನು) ಲಗತ್ತಿಸಲಾಗಲಿಲ್ಲ. ಟಿಕೆಟ್‌ನಿಂದ ಅವುಗಳನ್ನು ಸೇರಿಸಬಹುದು.';
  }

  @override
  String get supportPhotosOptional => 'ಫೋಟೋಗಳು (ಐಚ್ಛಿಕ)';

  @override
  String get supportPickTopic => 'ಒಂದು ವಿಷಯ ಆರಿಸಿ, ಅಥವಾ ಕೆಳಗೆ ನಿಮ್ಮದೇ ವಿಷಯ ಬರೆಯಿರಿ.';

  @override
  String supportRaisedOn(String date) {
    return '$date ರಂದು ಸಲ್ಲಿಸಲಾಗಿದೆ';
  }

  @override
  String get supportRaiseOneAboveIfSomething => 'ಏನಾದರೂ ಸರಿಪಡಿಸಬೇಕಿದ್ದರೆ ಮೇಲೆ ದಾಖಲಿಸಿ.';

  @override
  String get supportRaiseTicket => 'ದೂರು ದಾಖಲಿಸಿ';

  @override
  String get supportResolveBody => 'ರೈಡರ್ ಇನ್ನೂ ಉತ್ತರಿಸಬಹುದು. ಅವರ ಉತ್ತರ ಟಿಕೆಟ್ ಅನ್ನು ಮತ್ತೆ ತೆರೆಯುತ್ತದೆ.';

  @override
  String get supportResolved => 'ಪರಿಹರಿಸಲಾಗಿದೆ';

  @override
  String get supportResolvedReplyToReopen =>
      'ಈ ಟಿಕೆಟ್ ಪರಿಹರಿಸಲಾಗಿದೆ. ಇನ್ನೂ ಸಹಾಯ ಬೇಕಾದರೆ ಸಂದೇಶ ಕಳುಹಿಸಿ, ಅದು ಮತ್ತೆ ತೆರೆಯುತ್ತದೆ.';

  @override
  String get supportResolveTitle => 'ಈ ಟಿಕೆಟ್ ಪರಿಹರಿಸಲಾಗಿದೆ ಎಂದು ಗುರುತಿಸಬೇಕೆ?';

  @override
  String get supportSomethingElse => 'ಬೇರೇನೋ';

  @override
  String get supportStartWorking => 'ಕೆಲಸ ಆರಂಭಿಸಿ';

  @override
  String get supportStatusUpdated => 'ಟಿಕೆಟ್ ಸ್ಥಿತಿ ನವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get supportSubject => 'ವಿಷಯ';

  @override
  String get supportSubmitTicket => 'ದೂರು ಸಲ್ಲಿಸಿ';

  @override
  String get supportTeam => 'ಸಹಾಯ ತಂಡ';

  @override
  String get supportTeamLeadSeesStraightAway => 'ನಿಮ್ಮ ತಂಡದ ಮುಖ್ಯಸ್ಥರು ಇದನ್ನು ತಕ್ಷಣ ನೋಡುತ್ತಾರೆ.';

  @override
  String get supportTellUsMore => 'ಇನ್ನಷ್ಟು ತಿಳಿಸಿ';

  @override
  String get supportTellUsWhatAbout => 'ಇದು ಯಾವುದರ ಬಗ್ಗೆ ಎಂದು ತಿಳಿಸಿ';

  @override
  String get supportTellUsWhatHappenedAttach => 'ಏನಾಯಿತು ಎಂದು ತಿಳಿಸಿ, ಸಹಾಯವಾಗುವುದಾದರೆ ಫೋಟೋ ಲಗತ್ತಿಸಿ. ';

  @override
  String get supportTicket => 'ಟಿಕೆಟ್';

  @override
  String get supportTicketRaised => 'ಟಿಕೆಟ್ ಸಲ್ಲಿಸಲಾಗಿದೆ. ನಮ್ಮ ತಂಡ ಇದನ್ನು ನೋಡುತ್ತಿದೆ.';

  @override
  String get supportTicketReopened => 'ಟಿಕೆಟ್ ಮತ್ತೆ ತೆರೆಯಲಾಗಿದೆ. ನಮ್ಮ ತಂಡ ನಿಮ್ಮನ್ನು ಸಂಪರ್ಕಿಸುತ್ತದೆ.';

  @override
  String get supportTickets => 'ನಿಮ್ಮ ದೂರುಗಳು';

  @override
  String supportUpdated(String time) {
    return '$time ನವೀಕರಿಸಲಾಗಿದೆ';
  }

  @override
  String get supportWhatHappenedSinceWhen => 'ಏನಾಯಿತು, ಯಾವಾಗಿನಿಂದ?';

  @override
  String get supportWhatsTheIssue => 'ಏನು ಸಮಸ್ಯೆ';

  @override
  String get supportWriteMessage => 'ಸಂದೇಶ ಬರೆಯಿರಿ';

  @override
  String get supportYou => 'ನೀವು';

  @override
  String get swapCouldNotLoad => 'ಸ್ವಾಪ್ ಸ್ಟೇಷನ್‌ಗಳು ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get swapNoneBody => 'ಸದ್ಯಕ್ಕೆ ಯಾವುದೇ ಬ್ಯಾಟರಿ ಸ್ವಾಪ್ ಸ್ಟೇಷನ್ ಸಿಗಲಿಲ್ಲ.';

  @override
  String get swapNoneTitle => 'ಯಾವುದೇ ಸ್ವಾಪ್ ಸ್ಟೇಷನ್ ಸಿಗಲಿಲ್ಲ';

  @override
  String get swapSubtitle => 'ನಿಮಗೆ ಹತ್ತಿರದ ಸ್ವಾಪ್ ಸ್ಟೇಷನ್‌ಗಳು';

  @override
  String get swapTitle => 'ಬ್ಯಾಟರಿ ಸ್ವಾಪಿಂಗ್';

  @override
  String swapUnits(String count) {
    return 'ಘಟಕಗಳು: $count';
  }

  @override
  String get teamAdvisor => 'ಸಲಹೆಗಾರ';

  @override
  String get teamBatteryExpert => 'ಬ್ಯಾಟರಿ ತಜ್ಞ';

  @override
  String get teamMotorControllerRepair => 'ಮೋಟಾರ್ ಕಂಟ್ರೋಲರ್ ರಿಪೇರಿ';

  @override
  String get teamNotIncluded => 'ವೈಶಿಷ್ಟ್ಯ ಸೇರಿಲ್ಲ';

  @override
  String get teamNotIncludedMessage => 'ಈ ವೈಶಿಷ್ಟ್ಯ ನಿಮ್ಮ ಪ್ರಸ್ತುತ ಪ್ಯಾಕೇಜ್‌ನಲ್ಲಿ ಸೇರಿಲ್ಲ.';

  @override
  String get teamTechnician => 'ತಂತ್ರಜ್ಞ';

  @override
  String get trainingCareClean => 'ಸ್ವಚ್ಛವಾಗಿಡಿ';

  @override
  String get trainingCareCleanBody => 'ಸ್ಕೂಟರ್ ಅನ್ನು ಸ್ವಚ್ಛವಾಗಿ ಮತ್ತು ಉತ್ತಮ ಸ್ಥಿತಿಯಲ್ಲಿ ಇಡಿ.';

  @override
  String get trainingCareReport => 'ಸಮಸ್ಯೆಗಳನ್ನು ತಿಳಿಸಿ';

  @override
  String get trainingCareReportBody =>
      'ಯಾವುದೇ ಅಪಘಾತ, ಹಾನಿ, ಅಸಾಮಾನ್ಯ ಶಬ್ದ, ಎಚ್ಚರಿಕೆ ದೀಪ ಅಥವಾ ವಾಹನ ದೋಷವನ್ನು ತಕ್ಷಣ ನಮಗೆ ತಿಳಿಸಿ.';

  @override
  String get trainingCareTamper => 'ಹಸ್ತಕ್ಷೇಪ ಬೇಡ';

  @override
  String get trainingCareTamperBody =>
      'ಬ್ಯಾಟರಿ, ಮೋಟಾರ್, ಕಂಟ್ರೋಲರ್, ವೈರಿಂಗ್ ಅಥವಾ GPS ಸಾಧನವನ್ನು ತೆರೆಯಬೇಡಿ, ಬದಲಾಯಿಸಬೇಡಿ ಅಥವಾ ಅದರಲ್ಲಿ ಹಸ್ತಕ್ಷೇಪ ಮಾಡಬೇಡಿ.';

  @override
  String get trainingCareWater => 'ಆಳವಾದ ನೀರಿಗೆ ಬೇಡ';

  @override
  String get trainingCareWaterBody =>
      'ಪ್ರವಾಹ/ಆಳವಾದ ನೀರಿನ ಪ್ರದೇಶಗಳಲ್ಲಿ ಸ್ಕೂಟರ್ ಓಡಿಸಬೇಡಿ ಅಥವಾ ಅದರ ಮೇಲೆ ಹೆಚ್ಚಿನ ಒತ್ತಡದ ನೀರು ಬಳಸಬೇಡಿ.';

  @override
  String get trainingChargeEquipment => 'ಅನುಮೋದಿತ ಉಪಕರಣಗಳನ್ನು ಬಳಸಿ';

  @override
  String get trainingChargeEquipmentBody => 'ನಾವು ನೀಡಿದ ಅಥವಾ ಅನುಮೋದಿಸಿದ ಚಾರ್ಜರ್/ಬ್ಯಾಟರಿ/ಆಕ್ಸೆಸರಿಗಳನ್ನು ಮಾತ್ರ ಬಳಸಿ.';

  @override
  String get trainingChargePark => 'ಜವಾಬ್ದಾರಿಯಿಂದ ಪಾರ್ಕ್ ಮಾಡಿ';

  @override
  String get trainingChargeParkBody =>
      'ಅನುಮತಿ ಇರುವ ಸ್ಥಳಗಳಲ್ಲಿ ಸುರಕ್ಷಿತವಾಗಿ ಪಾರ್ಕ್ ಮಾಡಿ ಮತ್ತು ನೀರು, ಬೆಂಕಿ ಅಥವಾ ಕಳ್ಳತನದ ಅಪಾಯಗಳನ್ನು ತಪ್ಪಿಸಿ.';

  @override
  String get trainingChargeRide => 'ಜವಾಬ್ದಾರಿಯಿಂದ ಓಡಿಸಿ';

  @override
  String get trainingChargeRideBody =>
      'ಹೆಚ್ಚು ಭಾರ ಹೇರುವುದು, ಅಸುರಕ್ಷಿತ ಚಾಲನೆ, ಜಿಗಿಯುವುದು, ರೇಸಿಂಗ್ ಅಥವಾ ಸ್ಕೂಟರ್‌ನ ದುರ್ಬಳಕೆ ಬೇಡ.';

  @override
  String get trainingChargeStations => 'ನಿಗದಿತ ಸ್ಟೇಷನ್‌ಗಳಲ್ಲಿ ಮಾತ್ರ ಚಾರ್ಜ್/ಸ್ವಾಪ್ ಮಾಡಿ';

  @override
  String get trainingChargeStationsBody => 'ಅನುಮೋದಿತ ಚಾರ್ಜಿಂಗ್/ಸ್ವಾಪಿಂಗ್ ಸ್ಟೇಷನ್‌ಗಳನ್ನು ಮಾತ್ರ ಬಳಸಿ.';

  @override
  String get trainingCharging => 'ಚಾರ್ಜಿಂಗ್ ಮತ್ತು ಬಳಕೆ';

  @override
  String get trainingChargingSummary => 'ಸುರಕ್ಷಿತ, ಸುಗಮ ಮತ್ತು ತೊಂದರೆ ರಹಿತ ಸವಾರಿಗಾಗಿ ಈ ಸರಳ ಮಾರ್ಗಸೂಚಿಗಳನ್ನು ಪಾಲಿಸಿ.';

  @override
  String get trainingKeyPoints => 'ಮುಖ್ಯ ಅಂಶಗಳು';

  @override
  String get trainingPayApp => 'ಪಾವತಿ ಆ್ಯಪ್‌ನಲ್ಲಿ ಮಾತ್ರ';

  @override
  String get trainingPayAppBody =>
      'ಬಾಡಿಗೆ, ಠೇವಣಿ ಮತ್ತು ಇತರ ಎಲ್ಲಾ ಪಾವತಿಗಳನ್ನು ಅಧಿಕೃತ ಆ್ಯಪ್/ಪಾವತಿ ಪ್ರಕ್ರಿಯೆಯ ಮೂಲಕವೇ ಮಾಡಬೇಕು.';

  @override
  String get trainingPayBribe => 'ಲಂಚ / ಅನಧಿಕೃತ ಪಾವತಿ ಬೇಡ';

  @override
  String get trainingPayBribeBody =>
      'TL ಅಥವಾ ಕಂಪನಿ ಪ್ರತಿನಿಧಿಗೆ ಎಂದಿಗೂ ಲಂಚ, ಕಮಿಷನ್ ಅಥವಾ ವೈಯಕ್ತಿಕ ಪಾವತಿ ನೀಡಬೇಡಿ ಅಥವಾ ನೀಡುವ ಪ್ರಸ್ತಾಪ ಮಾಡಬೇಡಿ.';

  @override
  String get trainingPayCash => 'ನಗದು ಪಾವತಿ ಬೇಡ';

  @override
  String get trainingPayCashBody => 'ಯಾವುದೇ TL, ಸಿಬ್ಬಂದಿ ಅಥವಾ ಪ್ರತಿನಿಧಿಗೆ ನಗದು ಪಾವತಿ ಮಾಡಬೇಡಿ.';

  @override
  String get trainingPayments => 'ಪಾವತಿ ಮತ್ತು ನಡವಳಿಕೆ';

  @override
  String get trainingPaymentsSummary =>
      'ಸುರಕ್ಷಿತ, ಪಾರದರ್ಶಕ ಮತ್ತು ತೊಂದರೆ ರಹಿತ ವಹಿವಾಟುಗಳಿಗಾಗಿ ಈ ಸರಳ ಮಾರ್ಗಸೂಚಿಗಳನ್ನು ಪಾಲಿಸಿ.';

  @override
  String get trainingPayReport => 'ದೂರುಗಳನ್ನು ತಿಳಿಸಿ';

  @override
  String get trainingPayReportBody =>
      'ಯಾರಾದರೂ ನಗದು ಅಥವಾ ಲಂಚ ಕೇಳಿದರೆ, ಅನಧಿಕೃತ ಶುಲ್ಕ, ದುರ್ವರ್ತನೆ ಅಥವಾ ಇತರ ಸಮಸ್ಯೆ ಇದ್ದರೆ ನೇರವಾಗಿ ನಮಗೆ ತಿಳಿಸಿ.';

  @override
  String get trainingVehicleCare => 'ವಾಹನದ ಆರೈಕೆ';

  @override
  String get trainingVehicleCareSummary => 'ಪ್ರತಿ ಸವಾರಿಗೆ ಸ್ಕೂಟರ್ ಅನ್ನು ಸುರಕ್ಷಿತ, ಸ್ವಚ್ಛ ಮತ್ತು ಸಿದ್ಧವಾಗಿಡಿ.';

  @override
  String get trainingViewed => 'ನೋಡಲಾಗಿದೆ';

  @override
  String get validationEnterDateBeforeToday => 'ಇಂದು ಅಥವಾ ಅದಕ್ಕಿಂತ ಹಿಂದಿನ ದಿನಾಂಕ ಬರೆಯಿರಿ';

  @override
  String get validationEnterDateLaterThanToday => 'ಇಂದಿನ ನಂತರದ ದಿನಾಂಕ ಬರೆಯಿರಿ';

  @override
  String get validationEnterValid12DigitAadhaar => 'ಸರಿಯಾದ 12 ಅಂಕಿಯ ಆಧಾರ್ ಸಂಖ್ಯೆ ಬರೆಯಿರಿ';

  @override
  String get validationEnterValidEmailAddress => 'ಸರಿಯಾದ ಇಮೇಲ್ ವಿಳಾಸ ಬರೆಯಿರಿ';

  @override
  String get validationEnterValidIfscCode => 'ಸರಿಯಾದ ಐಎಫ್‌ಎಸ್‌ಸಿ ಕೋಡ್ ಬರೆಯಿರಿ';

  @override
  String get validationEnterValidPanAbcde1234f => 'ಸರಿಯಾದ ಪ್ಯಾನ್ ಬರೆಯಿರಿ (ABCDE1234F)';

  @override
  String get validationEnterValidUpiId => 'ಸರಿಯಾದ ಯುಪಿಐ ಐಡಿ ಬರೆಯಿರಿ';

  @override
  String get validationField => 'ಈ ಜಾಗ';

  @override
  String get verifyApprove => 'ಅನುಮೋದಿಸಿ';

  @override
  String get verifyApproveAllFirst => 'ವಾಹನ ಹಂಚಲು ಎಲ್ಲಾ ದಾಖಲೆಗಳನ್ನು ಅನುಮೋದಿಸಿ.';

  @override
  String get verifyApproved => 'ಅನುಮೋದಿತ';

  @override
  String get verifyApproveDocument => 'ಈ ದಾಖಲೆಯನ್ನು ಅನುಮೋದಿಸುವುದೇ?';

  @override
  String verifyApproveMessage(String name) {
    return '$name ಅನ್ನು ಪರಿಶೀಲಿಸಲಾಗಿದೆ ಎಂದು ಗುರುತಿಸಲಾಗುತ್ತದೆ. ಇದನ್ನು ನಂತರ ಬದಲಾಯಿಸಲು ಆಗುವುದಿಲ್ಲ.';
  }

  @override
  String get verifyApproveReference => 'ಈ ರೆಫರೆನ್ಸ್ ಅನುಮೋದಿಸುವುದೇ?';

  @override
  String get verifyContinue => 'ವಾಹನ ಹಂಚಿಕೆಗೆ ಮುಂದುವರಿಸಿ';

  @override
  String get verifyCouldNotCall => 'ಕರೆ ಪ್ರಾರಂಭಿಸಲು ಆಗಲಿಲ್ಲ.';

  @override
  String get verifyCouldNotLoad => 'ಈ ಪಟ್ಟಿಯನ್ನು ಲೋಡ್ ಮಾಡಲು ಆಗಲಿಲ್ಲ.';

  @override
  String get verifyDocumentApproved => 'ದಾಖಲೆ ಅನುಮೋದಿಸಲಾಗಿದೆ';

  @override
  String get verifyDocumentRejected => 'ದಾಖಲೆ ತಿರಸ್ಕರಿಸಲಾಗಿದೆ';

  @override
  String get verifyDocuments => 'ದಾಖಲೆಗಳು';

  @override
  String get verifyDocumentsHint =>
      'ರೈಡರ್ ಅಪ್‌ಲೋಡ್ ಮಾಡಿದ ಪ್ರತಿಯೊಂದು ದಾಖಲೆಯನ್ನು ತೆರೆದು ನೋಡಿ, ನಂತರ ಅನುಮೋದಿಸಿ ಅಥವಾ ತಿರಸ್ಕರಿಸಿ.';

  @override
  String get verifyDocumentsLocked =>
      'ಫ್ಲೀಟ್ ಮ್ಯಾನೇಜರ್‌ಗಳು ಇನ್ನೂ ದಾಖಲೆಗಳನ್ನು ಪರಿಶೀಲಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ. ನಿಮ್ಮ ಅಡ್ಮಿನ್ ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ನಲ್ಲಿ ಅವುಗಳನ್ನು ಪರಿಶೀಲಿಸಬಹುದು.';

  @override
  String get verifyNoDocuments => 'ರೈಡರ್ ಇನ್ನೂ ಯಾವುದೇ ದಾಖಲೆ ಅಪ್‌ಲೋಡ್ ಮಾಡಿಲ್ಲ.';

  @override
  String get verifyNoReferences => 'ರೈಡರ್ ಯಾವುದೇ ರೆಫರೆನ್ಸ್ ಸೇರಿಸಿಲ್ಲ.';

  @override
  String get verifyReason => 'ಕಾರಣ';

  @override
  String get verifyReasonHint => 'ಉದಾ. ಫೋಟೋ ಮಸುಕಾಗಿದೆ';

  @override
  String get verifyReasonRequired => 'ಕಾರಣ ನಮೂದಿಸಿ';

  @override
  String get verifyReferenceApproved => 'ರೆಫರೆನ್ಸ್ ಅನುಮೋದಿಸಲಾಗಿದೆ';

  @override
  String get verifyReferenceRejected => 'ರೆಫರೆನ್ಸ್ ತಿರಸ್ಕರಿಸಲಾಗಿದೆ';

  @override
  String get verifyReferences => 'ರೆಫರೆನ್ಸ್‌ಗಳು';

  @override
  String get verifyReferencesHint => 'ಖಚಿತಪಡಿಸಲು ಪ್ರತಿ ರೆಫರೆನ್ಸ್‌ಗೆ ಕರೆ ಮಾಡಿ, ನಂತರ ಅನುಮೋದಿಸಿ ಅಥವಾ ತಿರಸ್ಕರಿಸಿ.';

  @override
  String get verifyReject => 'ತಿರಸ್ಕರಿಸಿ';

  @override
  String get verifyRejected => 'ತಿರಸ್ಕೃತ';

  @override
  String get verifyRejectSubtitle => 'ತಿರಸ್ಕರಿಸಲು ಒಂದು ಚಿಕ್ಕ ಕಾರಣ ಬರೆಯಿರಿ.';

  @override
  String verifyRejectTitle(String name) {
    return '$name ತಿರಸ್ಕರಿಸಿ';
  }

  @override
  String verifyReviewedBy(String name) {
    return '$name ಪರಿಶೀಲಿಸಿದ್ದಾರೆ';
  }

  @override
  String get verifyTitle => 'ರೈಡರ್ ಪರಿಶೀಲಿಸಿ';

  @override
  String verifyUploadedOn(String date) {
    return '$date ರಂದು ಅಪ್‌ಲೋಡ್ ಮಾಡಲಾಗಿದೆ';
  }

  @override
  String get verifyView => 'ನೋಡಿ';

  @override
  String get walletAvailable => 'ಲಭ್ಯ';

  @override
  String get walletCash => 'ನಗದು';

  @override
  String get walletClosingBalance => 'ಅಂತಿಮ ಬ್ಯಾಲೆನ್ಸ್';

  @override
  String walletCompletedOn(String date) {
    return '$date ರಂದು ಪೂರ್ಣ';
  }

  @override
  String get walletCouldNotLoadDeposit => 'ಠೇವಣಿ ವಿವರಗಳನ್ನು ರಿಫ್ರೆಶ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get walletCouldNotLoadReceipt => 'ರಸೀದಿ ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get walletCouldNotLoadStatement => 'ನಿಮ್ಮ ಸ್ಟೇಟ್‌ಮೆಂಟ್ ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get walletCouldNotLoadWallet => 'ನಿಮ್ಮ ವ್ಯಾಲೆಟ್ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get walletCredited => 'ಜಮಾ ಆಗಿದೆ';

  @override
  String get walletCredits => 'ಜಮಾ';

  @override
  String get walletDateTime => 'ದಿನಾಂಕ ಮತ್ತು ಸಮಯ';

  @override
  String get walletDebits => 'ಖರ್ಚು';

  @override
  String get walletDeducted => 'ಕಡಿತಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get walletDeploymentPayment => 'ನಿಯೋಜನೆ ಪಾವತಿ';

  @override
  String get walletDeposit => 'ಠೇವಣಿ';

  @override
  String get walletDepositDeducted => 'ಕಡಿತಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get walletDepositHeld => 'ಇರಿಸಲಾಗಿದೆ';

  @override
  String get walletDepositLocked => 'ನಿಮ್ಮ ಬಾಡಿಗೆಗೆ ಲಾಕ್';

  @override
  String walletDepositMoved(String amount) {
    return 'ಠೇವಣಿ $amount';
  }

  @override
  String get walletDepositPaidIn => 'ಪಾವತಿಸಿದ್ದು';

  @override
  String get walletDepositRequired => 'ಅಗತ್ಯ ಮೊತ್ತ';

  @override
  String get walletDepositReturnedAmount => 'ಹಿಂದಿರುಗಿಸಲಾಗಿದೆ';

  @override
  String get walletDepositReturnedSeparately => 'ನೀವು ಬಿಟ್ಟು ಹೋಗುವಾಗ ನಿಮ್ಮ ಠೇವಣಿ ಪ್ರತ್ಯೇಕವಾಗಿ ಹಿಂತಿರುಗುತ್ತದೆ.';

  @override
  String get walletDepositReturns => 'ಹಿಂದಿರುಗಿಸುವಿಕೆಗಳು';

  @override
  String get walletDepositStatusCancelled => 'ರದ್ದು';

  @override
  String get walletDepositStatusForfeited => 'ಮುಟ್ಟುಗೋಲು';

  @override
  String get walletDepositStatusLocked => 'ನಿಮ್ಮ ಬಾಡಿಗೆಗಾಗಿ ಇರಿಸಲಾಗಿದೆ';

  @override
  String get walletDepositStatusPaid => 'ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get walletDepositStatusPartlyDeducted => 'ಭಾಗಶಃ ಕಡಿತ';

  @override
  String get walletDepositStatusPartlyPaid => 'ಭಾಗಶಃ ಪಾವತಿ';

  @override
  String get walletDepositStatusPending => 'ಪಾವತಿಗಾಗಿ ಕಾಯಲಾಗುತ್ತಿದೆ';

  @override
  String get walletDepositStatusReturnable => 'ಹಿಂದಿರುಗಿಸಲು ಸಿದ್ಧ';

  @override
  String get walletDepositStatusReturned => 'ಹಿಂದಿರುಗಿಸಲಾಗಿದೆ';

  @override
  String get walletDepositStatusReturnRequested => 'ಹಿಂದಿರುಗಿಸಲು ವಿನಂತಿಸಲಾಗಿದೆ';

  @override
  String get walletDepositToPay => 'ಇನ್ನೂ ಪಾವತಿಸಬೇಕು';

  @override
  String get walletDestination => 'ಯಾರಿಗೆ ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get walletDueNow => 'ಈಗ ಪಾವತಿಸಬೇಕು';

  @override
  String get walletErrorDepositNotFound => 'ಈ ಠೇವಣಿ ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get walletErrorNotFound => 'ನಿಮ್ಮ ವಾಲೆಟ್ ಇನ್ನೂ ಸಿದ್ಧವಾಗಿಲ್ಲ.';

  @override
  String get walletErrorReceiptNotFound => 'ಈ ರಸೀದಿ ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get walletErrorStatementPeriod => 'ಆ ಅವಧಿಗೆ ಸ್ಟೇಟ್‌ಮೆಂಟ್ ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get walletErrorTransactionNotFound => 'ಈ ವ್ಯವಹಾರ ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get walletExpiringSoon => '7 ದಿನಗಳಲ್ಲಿ ಮುಗಿಯುತ್ತದೆ';

  @override
  String walletFundedOf(String funded, String required) {
    return '$required ರಲ್ಲಿ $funded';
  }

  @override
  String get walletInvoicesSettled => 'ಪಾವತಿಸಿದ ಬಿಲ್‌ಗಳು';

  @override
  String get walletIssued => 'ನೀಡಲಾಗಿದೆ';

  @override
  String get walletKindAdjustment => 'ಹೊಂದಾಣಿಕೆ';

  @override
  String get walletKindDeposit => 'ಭದ್ರತಾ ಠೇವಣಿ';

  @override
  String get walletKindPayment => 'ಪಾವತಿ';

  @override
  String get walletKindPenalty => 'ದಂಡ';

  @override
  String get walletKindRefund => 'ಮರುಪಾವತಿ';

  @override
  String get walletKindRental => 'ಬಾಡಿಗೆ';

  @override
  String get walletKindReward => 'ಬಹುಮಾನ';

  @override
  String get walletKindService => 'ಸೇವಾ ಶುಲ್ಕ';

  @override
  String get walletKindTopUp => 'ಹಣ ಸೇರಿಸಲಾಗಿದೆ';

  @override
  String get walletLedgerWillFillUpAs => 'ನೀವು ಓಡಿಸಿ ಗಳಿಸಿದಂತೆ ನಿಮ್ಮ ಲೆಕ್ಕ ತುಂಬುತ್ತದೆ.';

  @override
  String get walletMethod => 'ವಿಧಾನ';

  @override
  String get walletMoney => 'ನಿಮ್ಮ ಹಣ';

  @override
  String get walletMoneyIn => 'ಬಂದ ಹಣ';

  @override
  String get walletMoneyOut => 'ಹೋದ ಹಣ';

  @override
  String get walletNothingMatchesFilterYet => 'ಈ ಶೋಧಕ್ಕೆ ಇನ್ನೂ ಏನೂ ಹೊಂದಿಲ್ಲ.';

  @override
  String get walletNoTransactionsHere => 'ಇಲ್ಲಿ ಯಾವುದೇ ವ್ಯವಹಾರ ಇಲ್ಲ';

  @override
  String get walletOnHold => 'ತಡೆಹಿಡಿದಿದೆ';

  @override
  String get walletOpeningBalance => 'ಆರಂಭಿಕ ಬ್ಯಾಲೆನ್ಸ್';

  @override
  String get walletPayments => 'ಪಾವತಿಗಳು';

  @override
  String get walletReceipt => 'ರಸೀದಿ';

  @override
  String get walletReceiptNumber => 'ರಸೀದಿ ಸಂಖ್ಯೆ';

  @override
  String get walletReferenceId => 'ಉಲ್ಲೇಖ ಐಡಿ';

  @override
  String get walletRefundable => 'ಮರುಪಾವತಿ ಯೋಗ್ಯ';

  @override
  String walletRequestedOn(String date) {
    return '$date ರಂದು ವಿನಂತಿ';
  }

  @override
  String get walletReturnApproved => 'ಅನುಮೋದಿಸಲಾಗಿದೆ';

  @override
  String get walletReturnCancelled => 'ರದ್ದು';

  @override
  String get walletReturnDone => 'ಹಿಂದಿರುಗಿಸಲಾಗಿದೆ';

  @override
  String get walletReturnFailed => 'ವಿಫಲವಾಗಿದೆ';

  @override
  String get walletReturnProcessing => 'ಪ್ರಕ್ರಿಯೆಯಲ್ಲಿದೆ';

  @override
  String get walletReturnRejected => 'ತಿರಸ್ಕರಿಸಲಾಗಿದೆ';

  @override
  String get walletReturnRequested => 'ವಿನಂತಿಸಲಾಗಿದೆ';

  @override
  String get walletReturnReview => 'ಪರಿಶೀಲನೆಯಲ್ಲಿ';

  @override
  String get walletRewardExpired => 'ಬಹುಮಾನದ ಅವಧಿ ಮುಗಿದಿದೆ';

  @override
  String get walletRewardReversed => 'ಬಹುಮಾನ ಹಿಂಪಡೆಯಲಾಗಿದೆ';

  @override
  String get walletRewardsEarned => 'ಇಲ್ಲಿಯವರೆಗೆ ಗಳಿಸಿದ್ದು';

  @override
  String get walletSearchTransactions => 'ವ್ಯವಹಾರಗಳನ್ನು ಹುಡುಕಿ';

  @override
  String get walletSecurityDeposit => 'ಭದ್ರತಾ ಠೇವಣಿ';

  @override
  String get walletStateFailed => 'ವಿಫಲ';

  @override
  String get walletStatement => 'ಸ್ಟೇಟ್‌ಮೆಂಟ್';

  @override
  String get walletStatementEmpty => 'ಈ ತಿಂಗಳು ಏನೂ ಇಲ್ಲ';

  @override
  String get walletStatementEmptyBody => 'ಈ ತಿಂಗಳು ನಿಮ್ಮ ವಾಲೆಟ್‌ಗೆ ಬರುವ ಅಥವಾ ಹೋಗುವ ಹಣ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String walletStatementReference(String reference) {
    return 'ಸ್ಟೇಟ್‌ಮೆಂಟ್ ಉಲ್ಲೇಖ $reference';
  }

  @override
  String get walletStatementSubtitle => 'ತಿಂಗಳುವಾರು, ನಿಖರವಾದ ಒಳಬರುವ ಮತ್ತು ಹೊರಹೋಗುವ ಹಣ';

  @override
  String get walletStatementSummary => 'ಈ ತಿಂಗಳು';

  @override
  String get walletStatePending => 'ಬಾಕಿ';

  @override
  String get walletStateReversed => 'ಹಿಂಪಡೆಯಲಾಗಿದೆ';

  @override
  String get walletStateSettled => 'ಪೂರ್ಣ';

  @override
  String get walletToBank => 'ನಿಮ್ಮ ಬ್ಯಾಂಕ್ ಖಾತೆಗೆ';

  @override
  String get walletToWallet => 'ನಿಮ್ಮ ವಾಲೆಟ್‌ಗೆ';

  @override
  String get walletTransactions => 'ವ್ಯವಹಾರಗಳು';

  @override
  String get walletViewReceipt => 'ರಸೀದಿ';

  @override
  String get workPartnerEcommerce => 'ಇ-ಕಾಮರ್ಸ್';

  @override
  String get workPartnerFoodDelivery => 'ಆಹಾರ ಡೆಲಿವರಿ';

  @override
  String get workPartnerOnDemandLogistics => 'ಆನ್-ಡಿಮ್ಯಾಂಡ್ ಲಾಜಿಸ್ಟಿಕ್ಸ್';

  @override
  String get workPartnerParcelLogistics => 'ಪಾರ್ಸೆಲ್ ಲಾಜಿಸ್ಟಿಕ್ಸ್';

  @override
  String get workPartnerPharmacy => 'ಫಾರ್ಮಸಿ ಮತ್ತು ಆರೋಗ್ಯ ಸೇವೆ';

  @override
  String get workPartnerQuickCommerce => 'ಕ್ವಿಕ್ ಕಾಮರ್ಸ್';

  @override
  String get workPartnerSpecialtyDelivery => 'ವಿಶೇಷ ಡೆಲಿವರಿ';

  @override
  String deploymentPayOnline(String amount) {
    return '$amount ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ ಪಾವತಿಸಿ';
  }

  @override
  String submissionPhotoItemsLimit(int count) {
    return '$count ಹಾನಿಯಾದ ಭಾಗಗಳಿಗೆ ಮಾತ್ರ ಫೋಟೋ ಸೇರಿಸಬಹುದು. ಈ ಭಾಗ ಸೇರಿಸಲು ಅವುಗಳಲ್ಲಿ ಒಂದನ್ನು ತೆಗೆದುಹಾಕಿ.';
  }

  @override
  String submissionPhotoItemsLimitHint(int count) {
    return '$count ಹಾನಿಯಾದ ಭಾಗಗಳಿಗೆ ಮಾತ್ರ ಫೋಟೋ ಸೇರಿಸಬಹುದು, ಆ ಮಿತಿ ತಲುಪಿದೆ. ಈ ಭಾಗವನ್ನು ಫೋಟೋ ಇಲ್ಲದೆ ಸೇವ್ ಮಾಡಬಹುದು.';
  }

  @override
  String get profileDateOfBirth => 'ಹುಟ್ಟಿದ ದಿನಾಂಕ';

  @override
  String get profileAddress => 'ವಿಳಾಸ';

  @override
  String get profileState => 'ರಾಜ್ಯ';

  @override
  String get profilePinCode => 'ಪಿನ್ ಕೋಡ್';

  @override
  String get profileEmergencyContact => 'ತುರ್ತು ಸಂಪರ್ಕ';

  @override
  String get profileCouldNotLoad => 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ತೆರೆಯಲಿಲ್ಲ';

  @override
  String get profileCurrentAddress => 'ಪ್ರಸ್ತುತ ವಿಳಾಸ';

  @override
  String get profilePermanentAddress => 'ಶಾಶ್ವತ ವಿಳಾಸ';

  @override
  String get profileSameAsCurrentAddress => 'ಪ್ರಸ್ತುತ ವಿಳಾಸದಂತೆಯೇ';

  @override
  String damageChargesPaymentProcessing(String amount) {
    return '$amount ಪಾವತಿ ಪ್ರಕ್ರಿಯೆಯಲ್ಲಿದೆ. ದೃಢಪಡಿಸಿದ ನಂತರ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';
  }

  @override
  String get damageChargesSectionToPay => 'ಪಾವತಿಸಬೇಕಿರುವುದು';

  @override
  String get damageChargesSectionPaid => 'ಪಾವತಿಸಿದವು';

  @override
  String get deploymentHowToPay => 'ನೀವು ಹೇಗೆ ಪಾವತಿಸಲು ಬಯಸುತ್ತೀರಿ?';

  @override
  String get deploymentPayMethodOnline => 'ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ ಪಾವತಿಸಿ';

  @override
  String get deploymentPayMethodOnlineHint => 'UPI, ಕಾರ್ಡ್ ಅಥವಾ ನೆಟ್ ಬ್ಯಾಂಕಿಂಗ್. ತಕ್ಷಣ ದೃಢಪಡುತ್ತದೆ.';

  @override
  String get deploymentPayMethodCash => 'ನಗದು ಮೂಲಕ ಪಾವತಿಸಿ';

  @override
  String get deploymentPayMethodCashHint => 'ನಿಮ್ಮ ಹಬ್‌ನಲ್ಲಿ ಪಾವತಿಸಿ, ನಂತರ ರಸೀದಿ ಸಂಖ್ಯೆ ಸೇರಿಸಿ.';

  @override
  String deploymentIHavePaid(String amount) {
    return 'ನಾನು $amount ಪಾವತಿಸಿದ್ದೇನೆ';
  }

  @override
  String get deploymentOnlineUnavailable => 'ಈಗ ಆನ್‌ಲೈನ್ ಪಾವತಿ ಲಭ್ಯವಿಲ್ಲ. ದಯವಿಟ್ಟು ನಗದು ಮೂಲಕ ಪಾವತಿಸಿ.';

  @override
  String get onlinePaymentDone => 'ಪಾವತಿ ಆಗಿದೆ. ಧನ್ಯವಾದಗಳು!';

  @override
  String get onlinePaymentPending => 'ಪಾವತಿ ಸಿಕ್ಕಿದೆ. ಬ್ಯಾಂಕ್ ದೃಢೀಕರಣಕ್ಕಾಗಿ ಕಾಯುತ್ತಿದ್ದೇವೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪಾವತಿಸಬೇಡಿ.';

  @override
  String get onlinePaymentReview =>
      'ನಿಮ್ಮ ಪಾವತಿ ಸಿಕ್ಕಿದೆ, ಆದರೆ ಒಮ್ಮೆ ಪರಿಶೀಲಿಸಬೇಕಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪಾವತಿಸಬೇಡಿ. ಬೇಗ ಅಪ್‌ಡೇಟ್ ಆಗದಿದ್ದರೆ ಸಪೋರ್ಟ್ ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get onlinePaymentCancelled => 'ಪಾವತಿ ರದ್ದಾಗಿದೆ';

  @override
  String get onlinePaymentFailed => 'ಪಾವತಿ ಆಗಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get damageChargesOnlineUnavailable => 'ಈಗ ಆನ್‌ಲೈನ್ ಪಾವತಿ ಲಭ್ಯವಿಲ್ಲ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಹಬ್‌ನಲ್ಲಿ ಪಾವತಿಸಿ.';

  @override
  String get paymentsAutoPaySetUp => 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ಹೊಂದಿಸಿ';

  @override
  String paymentsAutoPaySetupMessage(String amount) {
    return 'ಪ್ರತಿ ಬಾಕಿ ದಿನಾಂಕದಂದು ನಿಮ್ಮ ಬಾಡಿಗೆ ನಿಮ್ಮ UPI ಖಾತೆಯಿಂದ ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಪಾವತಿಯಾಗುತ್ತದೆ, ಪ್ರತಿ ಬಾರಿ $amount ವರೆಗೆ. ನೀವು ಇದನ್ನು ಒಮ್ಮೆ ನಿಮ್ಮ UPI ಆ್ಯಪ್‌ನಲ್ಲಿ ಅನುಮೋದಿಸುತ್ತೀರಿ ಮತ್ತು ಪ್ರತಿ ಕಡಿತದ ಮೊದಲು ಸೂಚನೆ ಪಡೆಯುತ್ತೀರಿ.';
  }

  @override
  String get paymentsAutoPayEmail => 'ಇಮೇಲ್';

  @override
  String get paymentsAutoPayEmailHelp => 'Razorpay ಸ್ವಯಂ-ಡೆಬಿಟ್ ಮಾಹಿತಿಯನ್ನು ಈ ಇಮೇಲ್‌ಗೆ ಕಳುಹಿಸುತ್ತದೆ.';

  @override
  String get paymentsAutoPayEmailInvalid => 'ಸರಿಯಾದ ಇಮೇಲ್ ವಿಳಾಸ ನಮೂದಿಸಿ.';

  @override
  String get paymentsAutoPayContinue => 'UPI ಆ್ಯಪ್‌ಗೆ ಮುಂದುವರಿಯಿರಿ';

  @override
  String get paymentsAutoPayFinishSetup => 'ಸೆಟಪ್ ಪೂರ್ಣಗೊಳಿಸಿ';

  @override
  String get paymentsAutoPayCheckStatus => 'ಸ್ಥಿತಿ ಪರಿಶೀಲಿಸಿ';

  @override
  String get paymentsAutoPayTurnedOn => 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ಆನ್ ಆಗಿದೆ';

  @override
  String get paymentsAutoPayStillWaiting =>
      'ನಿಮ್ಮ ಬ್ಯಾಂಕ್ ದೃಢೀಕರಣಕ್ಕಾಗಿ ಕಾಯುತ್ತಿದೆ. ಕೆಲವು ನಿಮಿಷಗಳ ನಂತರ ಮತ್ತೆ ಪರಿಶೀಲಿಸಿ.';

  @override
  String get paymentsAutoPaySetupFailed => 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ಹೊಂದಿಸಲು ಆಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get paymentsAutoPayUnavailable => 'ಈಗ ಸ್ವಯಂ-ಡೆಬಿಟ್ ಸೆಟಪ್ ಲಭ್ಯವಿಲ್ಲ. ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get paymentsAutoPayOpenFailed => 'ಅನುಮೋದನೆ ಪುಟ ತೆರೆಯಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get paymentsAutoPayTurnOff => 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ಆಫ್ ಮಾಡಿ';

  @override
  String get paymentsAutoPayTurnOn => 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ಆನ್ ಮಾಡಿ';

  @override
  String get paymentsAutoPayOffNote => 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ಆಫ್ ಆಗಿದೆ. ಬಾಡಿಗೆ ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಕಡಿತವಾಗುವುದಿಲ್ಲ.';

  @override
  String get paymentsAutoPayPause => 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ವಿರಾಮಗೊಳಿಸಿ';

  @override
  String get paymentsAutoPayResume => 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ಮುಂದುವರಿಸಿ';

  @override
  String get paymentsAutoPayManageInUpiApp => 'ವಿರಾಮ ಅಥವಾ ಮುಂದುವರಿಸಲು ನಿಮ್ಮ UPI ಆ್ಯಪ್ ಬಳಸಿ.';

  @override
  String get paymentsAutoPayCancel => 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ರದ್ದುಮಾಡಿ';

  @override
  String get paymentsAutoPayCancelTitle => 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ರದ್ದುಮಾಡಬೇಕೇ?';

  @override
  String get paymentsAutoPayCancelMessage =>
      'ನಿಮ್ಮ ಬಾಡಿಗೆ ಇನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಪಾವತಿಯಾಗುವುದಿಲ್ಲ. ನಂತರ ಮತ್ತೆ ಹೊಂದಿಸಬಹುದು.';

  @override
  String get paymentsAutoPayKeep => 'ಹಾಗೇ ಇರಲಿ';

  @override
  String get paymentsAutoPayCancelled => 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ರದ್ದಾಗಿದೆ';

  @override
  String get paymentsAutoPayCancelPending => 'ರದ್ದು ವಿನಂತಿ ಕಳುಹಿಸಲಾಗಿದೆ. ನಿಮ್ಮ ಬ್ಯಾಂಕ್ ದೃಢೀಕರಣಕ್ಕಾಗಿ ಕಾಯುತ್ತಿದೆ.';

  @override
  String get paymentsAutoPayUpdated => 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ಅಪ್‌ಡೇಟ್ ಆಗಿದೆ';

  @override
  String get commonContinue => 'ಮುಂದುವರಿಸಿ';

  @override
  String get exchangeDeskAcceptForRider => 'ರೈಡರ್ ಪರವಾಗಿ ಒಪ್ಪಿಕೊಳ್ಳಿ';

  @override
  String get exchangeDeskAcceptedForRider => 'ರೈಡರ್ ಪರವಾಗಿ ಆಫರ್ ಒಪ್ಪಿಕೊಳ್ಳಲಾಗಿದೆ';

  @override
  String get exchangeDeskApprove => 'ಮನವಿ ಅನುಮೋದಿಸಿ';

  @override
  String get exchangeDeskApproved => 'ಮನವಿ ಅನುಮೋದಿಸಲಾಗಿದೆ';

  @override
  String get exchangeDeskAssistedHint =>
      'ರೈಡರ್ ಆ್ಯಪ್ ಬಳಸಲು ಸಾಧ್ಯವಾಗದಿದ್ದರೆ, ಅವರ ಉತ್ತರವನ್ನು ನೀವು ದಾಖಲಿಸಬಹುದು. ಅವರ ಸ್ಪಷ್ಟ ಒಪ್ಪಿಗೆಯೊಂದಿಗೆ ಮಾತ್ರ ಮಾಡಿ.';

  @override
  String get exchangeDeskAssistedReason => 'ಕಾರಣ';

  @override
  String get exchangeDeskAssistedReasonNeeded => 'ಅವರ ಪರವಾಗಿ ಒಪ್ಪಲು ಕಾರಣ ಸೇರಿಸಿ';

  @override
  String get exchangeDeskAssistedReasonSubtitle => 'ರೈಡರ್ ತಾವೇ ಆ್ಯಪ್‌ನಲ್ಲಿ ಏಕೆ ಒಪ್ಪುತ್ತಿಲ್ಲ?';

  @override
  String get exchangeDeskChangeScooter => 'ಸ್ಕೂಟರ್ ಬದಲಿಸಿ';

  @override
  String get exchangeDeskChooseScooter => 'ಬದಲಿ ಸ್ಕೂಟರ್ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get exchangeDeskComplete => 'ಬದಲಾವಣೆ ಪೂರ್ಣಗೊಳಿಸಿ';

  @override
  String get exchangeDeskConfirmReturn => 'ಸ್ಕೂಟರ್ ಹಿಂದಿರುಗಿದೆ ಎಂದು ದೃಢೀಕರಿಸಿ';

  @override
  String get exchangeDeskConsentNeeded => 'ರೈಡರ್ ಹೇಗೆ ಒಪ್ಪಿಗೆ ನೀಡಿದರು ಎಂದು ಸೇರಿಸಿ';

  @override
  String get exchangeDeskConsentReference => 'ಒಪ್ಪಿಗೆಯ ಉಲ್ಲೇಖ';

  @override
  String get exchangeDeskConsentSubtitle => 'ರೈಡರ್ ಹೇಗೆ ಒಪ್ಪಿದರು? ಉದಾಹರಣೆಗೆ ಸಹಿ ಮಾಡಿದ ಫಾರ್ಮ್ ಸಂಖ್ಯೆ ಅಥವಾ ದಾಖಲಾದ ಕರೆ.';

  @override
  String get exchangeDeskDeclineForRider => 'ರೈಡರ್ ನಿರಾಕರಿಸಿದರು';

  @override
  String get exchangeDeskDeclineSubtitle => 'ರೈಡರ್ ಆಫರ್ ಅನ್ನು ಏಕೆ ತಿರಸ್ಕರಿಸಿದರು ಎಂದು ದಾಖಲಿಸಿ.';

  @override
  String get exchangeDeskDeclinedForRider => 'ರೈಡರ್ ಪರವಾಗಿ ಆಫರ್ ತಿರಸ್ಕರಿಸಲಾಗಿದೆ';

  @override
  String exchangeDeskDepositBreakdown(String total, String newDeposit, String shortfall) {
    return '$total ಇನ್ನೂ ಬಾಕಿ ಇದೆ: ಹೊಸ ಸ್ಕೂಟರ್‌ಗೆ $newDeposit ಮತ್ತು ರೈಡರ್ ಭದ್ರತಾ ಠೇವಣಿ ಪೂರ್ಣಗೊಳಿಸಲು $shortfall.';
  }

  @override
  String exchangeDeskDepositDue(String amount) {
    return 'ರೈಡರ್ ಇನ್ನೂ $amount ಠೇವಣಿ ಪಾವತಿಸಬೇಕಿದೆ.';
  }

  @override
  String get exchangeDeskDepositsSettled => 'ಠೇವಣಿ ಹೊಂದಿಸಲಾಗಿದೆ';

  @override
  String get exchangeDeskEmptyBody => 'ರೈಡರ್ ಬೇರೆ ಸ್ಕೂಟರ್ ಕೇಳಿದಾಗ, ಮನವಿ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get exchangeDeskExchangeCompleted => 'ಬದಲಾವಣೆ ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String get exchangeDeskGuideChoose => 'ಹಳೆಯ ಸ್ಕೂಟರ್ ಹಿಂದಿರುಗಿದೆ. ರೈಡರ್‌ಗೆ ಬದಲಿ ಸ್ಕೂಟರ್ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get exchangeDeskGuideDeposits => 'ರೈಡರ್ ಸ್ವೀಕರಿಸಿದ್ದಾರೆ. ಹಸ್ತಾಂತರಕ್ಕೆ ಮುಂದುವರಿಯಲು ಠೇವಣಿ ಹೊಂದಿಸಿ.';

  @override
  String get exchangeDeskGuideReview => 'ಮನವಿಯನ್ನು ಪರಿಶೀಲಿಸಿ, ನಂತರ ಅನುಮೋದಿಸಿ ಅಥವಾ ತಿರಸ್ಕರಿಸಿ.';

  @override
  String get exchangeDeskGuideSendOffer => 'ಕೆಳಗಿನ ಆಫರ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತು ರೈಡರ್‌ಗೆ ಕಳುಹಿಸಿ.';

  @override
  String get exchangeDeskGuideStartHandover => 'ಠೇವಣಿ ಹೊಂದಿಸಲಾಗಿದೆ. ಹೊಸ ಸ್ಕೂಟರ್ ಹಸ್ತಾಂತರ ಶುರು ಮಾಡಿ.';

  @override
  String get exchangeDeskHandoverHint =>
      'ಹೊಸ ಸ್ಕೂಟರ್ ಅನ್ನು ಹಂಚಿಕೆ ಹಂತಗಳಲ್ಲಿ ಹಸ್ತಾಂತರಿಸಿ. ಅದು ರೈಡರ್ ಬಳಿ ಸಕ್ರಿಯವಾದ ನಂತರ ಬದಲಾವಣೆ ಪೂರ್ಣಗೊಳಿಸಿ.';

  @override
  String get exchangeDeskHandoverStarted => 'ಹಸ್ತಾಂತರ ಶುರುವಾಗಿದೆ';

  @override
  String get exchangeDeskNeedsAction => 'ಕ್ರಮ ಬೇಕು';

  @override
  String get exchangeDeskNoScooters => 'ಈಗ ಯಾವುದೇ ಸ್ಕೂಟರ್ ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get exchangeDeskOfferPreview => 'ಆಫರ್ ಮುನ್ನೋಟ';

  @override
  String get exchangeDeskOfferSent => 'ರೈಡರ್‌ಗೆ ಆಫರ್ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get exchangeDeskOpenAllocation => 'ಹೊಸ ಹಂಚಿಕೆಯನ್ನು ತೆರೆಯಿರಿ';

  @override
  String get exchangeDeskReject => 'ಮನವಿ ತಿರಸ್ಕರಿಸಿ';

  @override
  String get exchangeDeskRejectSubtitle => 'ಇದನ್ನು ಯಾಕೆ ಅನುಮೋದಿಸಲು ಆಗುವುದಿಲ್ಲ ಎಂದು ರೈಡರ್‌ಗೆ ತಿಳಿಸಿ.';

  @override
  String get exchangeDeskRejectedDone => 'ಮನವಿ ತಿರಸ್ಕರಿಸಲಾಗಿದೆ';

  @override
  String get exchangeDeskReplacement => 'ಬದಲಿ ಸ್ಕೂಟರ್';

  @override
  String get exchangeDeskReserveScooter => 'ಈ ಸ್ಕೂಟರ್ ಕಾಯ್ದಿರಿಸಿ';

  @override
  String exchangeDeskReservedUntil(String time) {
    return '$time ವರೆಗೆ';
  }

  @override
  String get exchangeDeskReturnConfirmed => 'ಹಿಂದಿರುಗಿಸುವಿಕೆ ದೃಢೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get exchangeDeskReturnHint =>
      'ರಿಟರ್ನ್‌ನಲ್ಲಿ ಹಿಂದಿರುಗಿಸುವಿಕೆ ಮುಗಿಸಿ: ರೈಡರ್ OTP ಪರಿಶೀಲಿಸಿ ಮತ್ತು ತಪಾಸಣೆ ಪೂರ್ಣಗೊಳಿಸಿ. ನಂತರ ಇಲ್ಲಿ ದೃಢೀಕರಿಸಿ.';

  @override
  String get exchangeDeskRiderNote => 'ರೈಡರ್ ಟಿಪ್ಪಣಿ';

  @override
  String get exchangeDeskScooterReserved => 'ಸ್ಕೂಟರ್ ಕಾಯ್ದಿರಿಸಲಾಗಿದೆ';

  @override
  String get exchangeDeskSendOffer => 'ರೈಡರ್‌ಗೆ ಆಫರ್ ಕಳುಹಿಸಿ';

  @override
  String get exchangeDeskSettleDeposits => 'ಠೇವಣಿ ಹೊಂದಿಸಿ';

  @override
  String get exchangeDeskStartHandover => 'ಹಸ್ತಾಂತರ ಶುರು ಮಾಡಿ';

  @override
  String get exchangeDeskStatusOfferSent => 'ಆಫರ್ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get exchangeDeskStatusReserved => 'ಸ್ಕೂಟರ್ ಕಾಯ್ದಿರಿಸಲಾಗಿದೆ';

  @override
  String get exchangeDeskSubtitle => 'ಬೇರೆ ಸ್ಕೂಟರ್ ಕೇಳುತ್ತಿರುವ ರೈಡರ್‌ಗಳು';

  @override
  String get exchangeDeskWaitingRider => 'ಆಫರ್ ಕಳುಹಿಸಲಾಗಿದೆ. ರೈಡರ್ ತಮ್ಮ ಆ್ಯಪ್‌ನಲ್ಲಿ ಸ್ವೀಕರಿಸುವುದನ್ನು ಕಾಯಲಾಗುತ್ತಿದೆ.';

  @override
  String get exchangeDeskWithRider => 'ರೈಡರ್‌ಗಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get exchangeDeskCheckIn => 'ಹಳೆಯ ಸ್ಕೂಟರ್ ಚೆಕ್-ಇನ್ ಮಾಡಿ';

  @override
  String get exchangeDeskOpenCheckIn => 'ಚೆಕ್-ಇನ್ ತೆರೆಯಿರಿ';

  @override
  String get exchangeDeskCheckInStarted => 'ಚೆಕ್-ಇನ್ ಪ್ರಾರಂಭವಾಗಿದೆ';

  @override
  String get exchangeDeskGuideCheckIn =>
      'ರೈಡರ್ ಸ್ಕೂಟರ್ ಅನ್ನು ಹಬ್‌ಗೆ ತಂದಾಗ ಅದನ್ನು ಚೆಕ್-ಇನ್ ಮಾಡಿ. ವಿನಂತಿ ಸರಿಯಿಲ್ಲದಿದ್ದರೆ ಅದನ್ನು ತಿರಸ್ಕರಿಸಿ.';

  @override
  String get exchangeDeskCheckInHint =>
      'ಹಳೆಯ ಸ್ಕೂಟರ್ ಚೆಕ್-ಇನ್ ನಡೆಯುತ್ತಿದೆ. ಫೋಟೋಗಳು, ವರದಿ ಮತ್ತು ಎರಡೂ OTP ದೃಢೀಕರಣಗಳನ್ನು ಮುಗಿಸಿ, ನಂತರ ಇಲ್ಲಿ ಬದಲಿ ಸ್ಕೂಟರ್ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get exchangeDeskCompletedBody => 'ರೈಡರ್ ಬಳಿ ಹೊಸ ಸ್ಕೂಟರ್ ಇದೆ ಮತ್ತು ಅವರ ಒಪ್ಪಂದದಲ್ಲಿ ಈಗ ಅದೇ ತೋರಿಸುತ್ತದೆ.';

  @override
  String get exchangeDeskClosedBody => 'ಈ ವಿನಂತಿಯನ್ನು ಮುಚ್ಚಲಾಗಿದೆ. ಇನ್ನು ಯಾವುದೇ ಹಂತಗಳು ಬೇಕಿಲ್ಲ.';

  @override
  String get exchangeDeskAcceptedPlan => 'ಒಪ್ಪಿಕೊಂಡ ಪ್ಲಾನ್';

  @override
  String exchangeDeskForRider(String name) {
    return '$name ಅವರಿಗಾಗಿ';
  }

  @override
  String exchangeDeskScootersReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ನಿಮ್ಮ ಹಬ್‌ಗಳಲ್ಲಿ $count ಸ್ಕೂಟರ್‌ಗಳು ಸಿದ್ಧವಾಗಿವೆ',
      one: 'ನಿಮ್ಮ ಹಬ್‌ಗಳಲ್ಲಿ 1 ಸ್ಕೂಟರ್ ಸಿದ್ಧವಾಗಿದೆ',
    );
    return '$_temp0';
  }

  @override
  String damageChargePayAll(String amount) {
    return 'ಎಲ್ಲಾ $amount ಪಾವತಿಸಿ';
  }

  @override
  String get damageChargePayAllHint => 'ಇದರಿಂದ ನಿಮ್ಮ ಉಳಿದ ಬಾಕಿ ಡ್ಯಾಮೇಜ್ ಶುಲ್ಕಗಳೂ ಪಾವತಿಯಾಗುತ್ತವೆ.';

  @override
  String checkInChargesSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count ಐಟಂಗಳು', one: '1 ಐಟಂ');
    return '$_temp0';
  }

  @override
  String get returnsDetails => 'ವಿವರಗಳು';

  @override
  String get returnsReason => 'ಕಾರಣ';

  @override
  String get returnsHandedOver => 'ಹಸ್ತಾಂತರಿಸಲಾಗಿದೆ';

  @override
  String exchangeDeskStepOf(int current, int total) {
    return '$total ರಲ್ಲಿ ಹಂತ $current';
  }

  @override
  String get exchangeHandoverTitle => 'ನಿಮ್ಮ ಹೊಸ ಸ್ಕೂಟರ್';

  @override
  String get exchangeHandoverBody =>
      'ಹಬ್ ನಿಮ್ಮ ಹೊಸ ಸ್ಕೂಟರ್ ಅನ್ನು ಹಸ್ತಾಂತರಿಸುತ್ತಿದೆ. ಅವರು ತಪಾಸಣಾ ಪಟ್ಟಿ ಕಳುಹಿಸಿದಾಗ, ಅದನ್ನು ಪರಿಶೀಲಿಸಿ ಒಪ್ಪಿಕೊಳ್ಳಲು ಕೆಳಗೆ ಟ್ಯಾಪ್ ಮಾಡಿ.';

  @override
  String get exchangeHandoverCheck => 'ನನ್ನ ಹೊಸ ಸ್ಕೂಟರ್ ಪರಿಶೀಲಿಸಿ';

  @override
  String get exchangeHandoverNotReady =>
      'ಹಬ್ ಇನ್ನೂ ತಪಾಸಣಾ ಪಟ್ಟಿಯನ್ನು ಕಳುಹಿಸಿಲ್ಲ. ದಯವಿಟ್ಟು ಸ್ವಲ್ಪ ಸಮಯದ ನಂತರ ಮತ್ತೆ ನೋಡಿ.';
}
