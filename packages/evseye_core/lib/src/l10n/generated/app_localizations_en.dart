// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get allocationAddItem => 'Add an item';

  @override
  String get allocationAddLeastOneItem => 'Add at least one item';

  @override
  String get allocationAllHubs => 'All hubs';

  @override
  String get allocationAllocateVehicle => 'Allocate vehicle';

  @override
  String get allocationAllocateVehicleWaitingRiderStart => 'Allocate a vehicle to a waiting rider to start one.';

  @override
  String get allocationAskPayment => 'Ask for payment';

  @override
  String get allocationAskPaymentConfirm =>
      'The amount is worked out from the plan the rider accepted. Send the payment request to the rider?';

  @override
  String get allocationAskPaymentExchange =>
      'This is an exchange scooter. Its plan is already agreed, so nothing is collected for this handover. Continue?';

  @override
  String get allocationAssign => 'Assign';

  @override
  String get allocationAssignTeamLead => 'Assign team lead';

  @override
  String get allocationAssignVehicle => 'Assign a vehicle';

  @override
  String get allocationBack => 'Back';

  @override
  String get allocationBackDesk => 'Back to the desk';

  @override
  String get allocationBackToAllocations => 'Back to allocations';

  @override
  String get allocationBatteryChargeCharger => 'Battery charge and charger';

  @override
  String get allocationBodyPaintwork => 'Body and paintwork';

  @override
  String get allocationCallRider => 'Call';

  @override
  String get allocationChangePlan => 'Change plan';

  @override
  String get allocationChangeTeamLead => 'Change team lead';

  @override
  String get allocationChecklistRiderWillAcceptItem => 'The checklist the rider will accept item by item';

  @override
  String get allocationChecklistTapToggleMandatory => 'Checklist · tap to toggle mandatory';

  @override
  String get allocationChoosePlan => 'Choose rental plan';

  @override
  String get allocationChooseTeamLead => 'Choose a team lead';

  @override
  String get allocationChooseWorkPartner => 'Choose work partner';

  @override
  String get allocationComplete2 => 'Complete.';

  @override
  String get allocationConfirmHaveReceivedAmountRider =>
      'Confirm you have received the amount the rider submitted a reference for. This cannot be undone.';

  @override
  String allocationConfirmReceivedAmount(String amount) {
    return 'Confirm you have received $amount from the rider.';
  }

  @override
  String get allocationContinueHandover => 'Continue the handover';

  @override
  String get allocationCouldNotAllocateVehicle => 'Could not allocate the vehicle';

  @override
  String get allocationCouldNotLoadAllocations => 'Could not load allocations';

  @override
  String get allocationCouldNotLoadAvailableVehicles => 'Could not load available vehicles';

  @override
  String get allocationCouldNotLoadHandover => 'Could not load this handover';

  @override
  String get allocationCouldNotLoadTeamLeads => 'Couldn\'t load team leads';

  @override
  String get allocationCouldNotLoadWorkPartners => 'Couldn\'t load work partners';

  @override
  String get allocationDeAllocateVehicle => 'De-allocate vehicle';

  @override
  String get allocationDeployed => 'Deployed';

  @override
  String allocationDeployedMessage(String vehicle, String rider) {
    return '$vehicle is now on the road with $rider.';
  }

  @override
  String get allocationDeployedTitle => 'Scooter deployed!';

  @override
  String get allocationEveryOnboardedRiderHubsHas =>
      'Every onboarded rider in your hubs has a vehicle or a handover under way.';

  @override
  String get allocationFleetOnlyBody => 'Scooter assignment is done with the hub\'s fleet manager login.';

  @override
  String get allocationFleetOnlyTitle => 'Not available for this login';

  @override
  String get allocationFront => 'Front';

  @override
  String get allocationHandoverCompleteMessage =>
      'Training is done and the scooter is with the rider. This handover is complete.';

  @override
  String get allocationHandoverHistory => 'Handover history';

  @override
  String get allocationHelmetHandedOver => 'Helmet handed over';

  @override
  String get allocationHornMirrors => 'Horn and mirrors';

  @override
  String get allocationIdle => 'Idle';

  @override
  String get allocationInspectionAcceptedTraining => 'Inspection accepted · training';

  @override
  String get allocationInspectionSentRider => 'Inspection sent to rider';

  @override
  String get allocationInspectionSentRider2 => 'Inspection sent to the rider';

  @override
  String get allocationLeftSide => 'Left side';

  @override
  String get allocationLightsIndicators => 'Lights and indicators';

  @override
  String get allocationMarkAsPaid => 'Mark as paid';

  @override
  String get allocationMatchWaitingRiderWithVehicle =>
      'Match a waiting rider with a vehicle, then walk the handover through';

  @override
  String get allocationMove => 'Your move';

  @override
  String get allocationNoBatteryPlan => 'No battery plan';

  @override
  String get allocationNobodyWaiting => 'Nobody waiting';

  @override
  String get allocationNoHandoversProgress => 'No handovers in progress';

  @override
  String get allocationNoTeamLeads => 'No team leads found';

  @override
  String get allocationNoTeamLeadsMessage => 'Ask your admin to add an active team lead.';

  @override
  String get allocationNothingCurrentlyAllocatedRider => 'Nothing is currently allocated to a rider.';

  @override
  String get allocationNoVehiclesOut => 'No vehicles out';

  @override
  String get allocationNoVehiclesReady => 'No vehicles ready';

  @override
  String get allocationNoWorkPartners => 'No work partners found';

  @override
  String get allocationNoWorkPartnersMessage => 'Ask your admin to add work partners.';

  @override
  String get allocationPaymentCouldNotLoad => 'Couldn\'t load the payment';

  @override
  String get allocationPaymentNoScreenshot => 'The rider didn\'t attach a screenshot.';

  @override
  String get allocationPaymentReceived => 'Payment received?';

  @override
  String get allocationPaymentRejected => 'Payment rejected. The rider can fix it and send it again.';

  @override
  String allocationPaymentRejectedNote(String reason) {
    return 'You rejected this payment: $reason. Waiting for the rider to send it again.';
  }

  @override
  String get allocationPaymentRequested => 'Payment requested';

  @override
  String get allocationPaymentRequestedAmount => 'Payment requested';

  @override
  String get allocationPaymentRequestedRiderSeesNow => 'Payment requested — the rider sees it now';

  @override
  String get allocationPaymentScreenshots => 'Payment screenshots';

  @override
  String get allocationPaymentVerified => 'Payment verified';

  @override
  String get allocationPaymentWaitingRider => 'The rider hasn\'t sent payment details yet.';

  @override
  String get allocationPhotoBack => 'Back';

  @override
  String get allocationPhotoCannotOpen => 'This photo can\'t be opened right now.';

  @override
  String get allocationPhotoDeclaration => 'Declaration form';

  @override
  String get allocationPhotoFront => 'Front';

  @override
  String get allocationPhotoLeft => 'Left';

  @override
  String get allocationPhotoRider => 'Rider with vehicle';

  @override
  String get allocationPhotoRight => 'Right';

  @override
  String get allocationPhotoUploaded => 'Uploaded';

  @override
  String get allocationPlanAcceptedChip => 'Accepted by rider';

  @override
  String get allocationPlanAwaitingBody =>
      'Waiting for the rider to accept this plan in their app. You can still change it until they accept.';

  @override
  String get allocationPlanAwaitingChip => 'Waiting for rider';

  @override
  String get allocationPlanCouldNotLoad => 'Couldn\'t load rental plans';

  @override
  String get allocationPlanExchangeBody =>
      'This scooter replaces one from an exchange. The rider\'s exchange plan carries over, so there\'s no new plan or deposit to collect.';

  @override
  String get allocationPlanExchangeChip => 'Exchange plan';

  @override
  String get allocationPlanExpiredBody =>
      'The plan offer expired or was replaced. Choose a plan again and send it to the rider.';

  @override
  String get allocationPlanNoneBody =>
      'No published rental plan matches this scooter and hub. Ask your admin to publish a rate card.';

  @override
  String get allocationPlanNoneTitle => 'No plans available';

  @override
  String get allocationPlanNotChosenBody =>
      'Choose the rental plan for this rider. They review and accept it in their app, and the payment is worked out from it.';

  @override
  String get allocationPlanNotChosenChip => 'Not chosen';

  @override
  String get allocationPlanPickSubtitle => 'Prices are worked out for this rider, scooter and hub.';

  @override
  String get allocationPlanPickTitle => 'Choose a rental plan';

  @override
  String get allocationPlanSend => 'Send to rider';

  @override
  String get allocationPlanSentSnack => 'Plan sent. The rider can accept it in their app.';

  @override
  String get allocationPlanTitle => 'Rental plan';

  @override
  String get allocationPlanWaitingButton => 'Waiting for rider to accept';

  @override
  String get allocationReason => 'Reason';

  @override
  String get allocationRejectConfirm => 'Reject payment';

  @override
  String get allocationRejectPayment => 'Reject';

  @override
  String get allocationRejectReason => 'Why are you rejecting it?';

  @override
  String get allocationRejectReasonHint => 'For example: the reference doesn\'t match the money received';

  @override
  String get allocationRejectReasonNeeded => 'Enter at least 3 characters';

  @override
  String get allocationReserved2 => 'Reserved on';

  @override
  String get allocationReviewPayment => 'Review payment';

  @override
  String get allocationRider => 'Rider';

  @override
  String get allocationRiderCompletingSafetyTrainingTheir =>
      'The rider is completing the safety training in their app. The scooter is handed over once every mandatory module is done.';

  @override
  String get allocationRiderGoingThroughChecklistTheir =>
      'The rider is going through your checklist in their app. Items they reject come back with a note.';

  @override
  String get allocationRiderNoLongerWaitingVehicle => 'This rider is no longer waiting for a vehicle.';

  @override
  String get allocationRiding => 'Riding';

  @override
  String get allocationRightSide => 'Right side';

  @override
  String get allocationRoad => 'On road';

  @override
  String allocationScooterAge(int months) {
    return 'Scooter age (months): $months';
  }

  @override
  String get allocationSearchRiderNameCodeMobile => 'Search rider name, code or mobile';

  @override
  String get allocationSearchRiderVehicle => 'Search rider or vehicle';

  @override
  String get allocationSearchRiderVehicleNumber => 'Search rider or vehicle number';

  @override
  String get allocationSearchTeamLead => 'Search by name, mobile or employee code';

  @override
  String get allocationSearchWorkPartner => 'Search work partners';

  @override
  String get allocationSendPaymentRequest => 'Send payment request';

  @override
  String get allocationSendRider => 'Send to rider';

  @override
  String get allocationStartReturn => 'Start a return';

  @override
  String get allocationStepPhotos => 'Photos & inspection';

  @override
  String get allocationStepRider => 'Rider check & training';

  @override
  String get allocationTeamLead => 'Team lead';

  @override
  String get allocationTeamLeadMissing => 'No team lead yet. Assign one, the handover can\'t be completed without it.';

  @override
  String get allocationTeamLeadNotSaved =>
      'The scooter is reserved, but the team lead wasn\'t saved. Assign it on the allocation page.';

  @override
  String get allocationTeamLeadPickerSubtitle => 'The team lead looks after this rider.';

  @override
  String get allocationTeamLeadRequired =>
      'This handover needs a team lead first. The fleet manager can assign one on the allocation page.';

  @override
  String allocationTeamLeadRiderCount(int count) {
    return 'Riders: $count';
  }

  @override
  String get allocationTeamLeadSaved => 'Team lead saved';

  @override
  String get allocationTyresPressure => 'Tyres and pressure';

  @override
  String get allocationUploadEvidenceContinue => 'Upload evidence to continue';

  @override
  String get allocationVehicleHasAvailableOnboardedAllocation =>
      'A vehicle has to be available, onboarded and allocation-enabled in one of your hubs to appear here.';

  @override
  String get allocationVehiclePhotos => 'Vehicle photos';

  @override
  String get allocationVehiclePhotosHint =>
      'Take a photo of each side of the vehicle, one of the rider with the vehicle, and one of the signed declaration form. All are needed before you submit the inspection.';

  @override
  String get allocationVehicleReserved => 'Vehicle reserved';

  @override
  String get allocationVerifyPayment => 'Verify payment';

  @override
  String get allocationWaiting => 'Waiting';

  @override
  String get allocationWaitingRider => 'Waiting on the rider';

  @override
  String get allocationWaitingRiderAcceptInspection => 'Waiting for rider to accept inspection';

  @override
  String get allocationWaitingRiderFinishTraining => 'Waiting for rider to finish training';

  @override
  String get allocationWaitingRiderInspection => 'Waiting for rider: inspection';

  @override
  String get allocationWaitingRiderPageRefreshesIts => 'Waiting on the rider — this page refreshes on its own.';

  @override
  String get allocationWaitingRiderTraining => 'Waiting for rider: training';

  @override
  String get allocationWorkPartner => 'Work partner';

  @override
  String get allocationWorkPartnerHelper => 'The company this rider will work for.';

  @override
  String get allocationWorkPartnerNeeded => 'Choose the rider\'s work partner';

  @override
  String get appGoHome => 'Go home';

  @override
  String get authChangeNumber => 'Change number';

  @override
  String get authCodeDidNotVerifyPlease => 'That code did not verify. Please try again.';

  @override
  String get authContinue => 'Continue';

  @override
  String get authEditNumber => 'Edit number';

  @override
  String authLegalAgreement(String terms, String privacy) {
    return 'By clicking continue you are accepting our $terms and $privacy';
  }

  @override
  String get authLegalPrivacy => 'Privacy Policy';

  @override
  String get authLegalTerms => 'Terms of Service';

  @override
  String get authLiveFleetVisibility => 'Live fleet\nvisibility';

  @override
  String get authNumberVerified => 'Number verified';

  @override
  String get authOnlyNumbersRegisteredByAdmin => 'Only numbers registered by your admin can sign in';

  @override
  String get authOpsSupport => '24x7 ops\nsupport';

  @override
  String authOtpSentTo(String mobile) {
    return 'A 6-digit code was sent to +91 $mobile';
  }

  @override
  String get authResendCode => 'Resend code';

  @override
  String authResendCodeIn(String seconds) {
    return 'Resend code in $seconds';
  }

  @override
  String get authRoadsideHelp => '24x7\nroadside help';

  @override
  String get authSameDayPayouts => 'Same-day\npayouts';

  @override
  String get authSessionEncryptedEndEnd => 'Your session is encrypted end-to-end';

  @override
  String get authSignRunHub => 'Sign in to run your hub';

  @override
  String get authSignWithMobileNumberRegistered =>
      'Sign in with the mobile number registered to your hub to manage allocations, riders and maintenance.';

  @override
  String get authSignWithMobileNumberRegistered2 =>
      'Sign in with the mobile number registered with your fleet operator.';

  @override
  String get authVerifiedHubNetwork => 'Verified\nhub network';

  @override
  String get authVerifiedOperators => 'Verified\noperators';

  @override
  String get authVerifying => 'Verifying…';

  @override
  String get authVerifyingNumber => 'Verifying your number…';

  @override
  String get authVerifyNumber => 'Verify your number';

  @override
  String get authWelcomeBack => 'Welcome back';

  @override
  String get authWhyChooseUs => 'Why choose us';

  @override
  String get authWhyRideWithUs => 'Why ride with us';

  @override
  String get authWillText6DigitCode => 'We will text you a 6-digit code';

  @override
  String get authWrongNumber => 'Wrong number?';

  @override
  String get checkInBasicReport => 'Mechanic report';

  @override
  String checkInConfirmedByManager(String reason) {
    return 'Confirmed by the hub team without your code: $reason';
  }

  @override
  String get checkInConfirmedByOtp => 'Confirmed with your code.';

  @override
  String get checkInCouldNotLoad => 'Couldn\'t load the submission.';

  @override
  String get checkInDeepReport => 'Final mechanic check';

  @override
  String get checkInHub => 'Hub';

  @override
  String get checkInNoCharges => 'No charges';

  @override
  String get checkInOtpHint =>
      'You\'ll get a code on your phone. Share it with the hub team to confirm this report and its charges.';

  @override
  String get checkInPhotos => 'Photos';

  @override
  String checkInPhotosCount(int taken, int total) {
    return '$taken of $total taken';
  }

  @override
  String get checkInSafe => 'Safe to use again';

  @override
  String get checkInStatusDraft => 'Under review';

  @override
  String get checkInStatusPosted => 'Confirmed';

  @override
  String get checkInStatusSubmitted => 'Awaiting confirmation';

  @override
  String get checkInTitle => 'Scooter submission';

  @override
  String get checkInTotal => 'Total charges';

  @override
  String checkInUnsafe(String reason) {
    return 'Not safe to reuse: $reason';
  }

  @override
  String get checkInViewPhotos => 'View';

  @override
  String get checkInWaitingReport =>
      'The hub team is taking photos. The mechanic\'s report shows up here once it\'s ready.';

  @override
  String get commonAboutApp => 'About this app';

  @override
  String get commonAbsent => 'Absent';

  @override
  String get commonAccountCannotDo => 'Your account cannot do that.';

  @override
  String get commonAccountNumbersDoNotMatch => 'Account numbers do not match';

  @override
  String get commonAccountNumbersMatch => 'Account numbers match';

  @override
  String get commonAddAnotherReference => 'Add another reference';

  @override
  String get commonAddNominee => 'Add nominee';

  @override
  String get commonAddPhoto => 'Add a photo';

  @override
  String get commonAllocated => 'Allocated on';

  @override
  String get commonAllocation => 'Allocation';

  @override
  String get commonAppWillChangeRightAway => 'The app will change right away.';

  @override
  String get commonAttendance => 'Attendance';

  @override
  String get commonBankAccountNumber => 'Bank account number';

  @override
  String get commonBrakes => 'Brakes';

  @override
  String get commonBrother => 'Brother';

  @override
  String get commonCamera => 'Camera';

  @override
  String get commonCameraAccessNeeded => 'Allow camera access in Settings to take photos.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonCanChangeLaterFromMenu => 'You can change it later from the menu.';

  @override
  String get commonCategory => 'Category';

  @override
  String get commonChooseLanguage => 'Choose your language';

  @override
  String get commonCity => 'City';

  @override
  String get commonColleague => 'Colleague';

  @override
  String get commonColour => 'Colour';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonConfirmAccountNumber => 'Confirm account number';

  @override
  String get commonCouldNotOpenDocumentTry => 'Could not open the document. Try again.';

  @override
  String get commonCouldNotReadLocalData => 'Could not read local data.';

  @override
  String get commonDaughter => 'Daughter';

  @override
  String get commonEnterAccountNumber => 'Enter your account number';

  @override
  String get commonEnterValid10DigitMobile => 'Enter a valid 10-digit mobile number';

  @override
  String get commonFather => 'Father';

  @override
  String get commonFriend => 'Friend';

  @override
  String get commonFullName => 'Full name';

  @override
  String get commonGallery => 'Gallery';

  @override
  String get commonHandover => 'Handover';

  @override
  String get commonHaveAlreadyUsedNumberAnother => 'You have already used this number for another reference';

  @override
  String get commonHintGuardian => 'e.g. Guardian';

  @override
  String get commonHowTheyRelated => 'How are they related to you?';

  @override
  String get commonIncentives => 'Incentives';

  @override
  String get commonIotUnit => 'IoT unit';

  @override
  String get commonJpgPngPdfUp5 => 'JPG, PNG or PDF · up to 5 MB';

  @override
  String get commonLanguage => 'Language';

  @override
  String get commonLoadMore => 'Load more';

  @override
  String get commonMake100 => 'Make it 100%';

  @override
  String get commonManager => 'Manager';

  @override
  String get commonMandatory => 'Mandatory';

  @override
  String get commonMarkedPresentShiftHasStarted => 'Marked present. Your shift has started.';

  @override
  String get commonMobile => 'Mobile';

  @override
  String get commonMobileNumber => 'Mobile number';

  @override
  String get commonModel => 'Model';

  @override
  String get commonMother => 'Mother';

  @override
  String get commonNoInternetConnection => 'No internet connection.';

  @override
  String get commonNominationComplete => 'Your nomination is complete.';

  @override
  String get commonNotFound => 'Not found.';

  @override
  String get commonNow => 'Now';

  @override
  String get commonOdometer => 'Odometer';

  @override
  String get commonOff => 'Off';

  @override
  String get commonOn => 'On';

  @override
  String get commonOpen => 'Open';

  @override
  String get commonOptional => 'Optional';

  @override
  String get commonOther => 'Other';

  @override
  String get commonOtherRelationship => 'Other relationship';

  @override
  String get commonOwnNumberUseDifferentOne => 'This is your own number. Use a different one.';

  @override
  String get commonPaidDate => 'Paid to date';

  @override
  String get commonPayment => 'Payment';

  @override
  String get commonPending => 'Pending';

  @override
  String get commonPreDeliveryInspection => 'Pre-delivery inspection';

  @override
  String get commonPresent => 'Present';

  @override
  String get commonPrivacyPolicy => 'Privacy policy';

  @override
  String get commonProfile => 'Profile';

  @override
  String get commonRaised => 'Raised';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonRejectedUploadAgain => 'Rejected — upload again';

  @override
  String commonRejectionReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get commonRelationship => 'Relationship';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonRetake => 'Retake';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSave => 'Save';

  @override
  String get commonScooter => 'Your scooter';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonSelect => 'Select';

  @override
  String get commonSelectDate => 'Select a date';

  @override
  String get commonSessionHasExpiredPleaseSign => 'Your session has expired. Please sign in again.';

  @override
  String get commonShare => 'Share';

  @override
  String get commonSharesAddUp100 => 'Shares add up to 100%';

  @override
  String get commonSignBeforeReadingClientConfiguration => 'Sign in before reading the client configuration.';

  @override
  String get commonSignContinue => 'Sign in to continue.';

  @override
  String get commonSignOut => 'Sign out';

  @override
  String get commonSignOut2 => 'Sign out?';

  @override
  String get commonSister => 'Sister';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonSomethingWentWrongPleaseTry => 'Something went wrong. Please try again.';

  @override
  String get commonSon => 'Son';

  @override
  String get commonSpouse => 'Spouse';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonSubmitInspection => 'Submit inspection';

  @override
  String get commonSupport => 'Support';

  @override
  String get commonTakeOneNowChooseFrom => 'Take one now, or choose from your gallery';

  @override
  String get commonTeamLead => 'Team lead';

  @override
  String get commonTellUsHowTheyRelated => 'Tell us how they are related to you';

  @override
  String get commonTermsService => 'Terms of service';

  @override
  String get commonTheirName => 'Their name';

  @override
  String get commonTooManyAttemptsWaitMoment => 'Too many attempts. Wait a moment.';

  @override
  String get commonTotal => 'Total';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonTypeAgain => 'Type it again';

  @override
  String get commonUpload => 'Upload';

  @override
  String get commonUploaded => 'Uploaded';

  @override
  String get commonVehicle => 'Vehicle';

  @override
  String get commonVersion => 'Version';

  @override
  String get commonWallet => 'Wallet';

  @override
  String get commonWhatHappensNext => 'What happens next';

  @override
  String get commonWillNeedMobileNumberOtp => 'You will need your mobile number and an OTP to sign back in.';

  @override
  String get companyCodeHint => 'e.g. yogmaya';

  @override
  String get companyCodeLabel => 'Company code';

  @override
  String get companyCodeRequired => 'Enter your company code';

  @override
  String get companyHelp => 'You\'ll find the code in your welcome message. If you don\'t have it, ask your hub team.';

  @override
  String get companyNotFound => 'We couldn\'t find a company with that code. Check it and try again.';

  @override
  String get companyNotReady => 'This company isn\'t set up for the app yet. Please contact your fleet operator.';

  @override
  String get companySubtitle => 'Enter the company code your fleet operator gave you. You only need to do this once.';

  @override
  String get companyTitle => 'Find your company';

  @override
  String companyWelcome(String name) {
    return 'Welcome to $name';
  }

  @override
  String get consentAgree =>
      'I declare that I have understood the points of this consent form and agree in my capacity as the data principal.';

  @override
  String get consentReviewLatest =>
      'Please read the latest version of this consent and accept it to keep using the app.';

  @override
  String get consentRiderTitle => 'Rider Consent';

  @override
  String get consentSubtitle =>
      'Please read how we collect and use your information, then give your consent to continue.';

  @override
  String get damageChargeAmountToPay => 'Amount to pay';

  @override
  String get damageChargeCancelledBody => 'This charge was cancelled. You don\'t need to pay it.';

  @override
  String get damageChargeCouldNotLoad => 'Couldn\'t load this charge';

  @override
  String get damageChargeCreditUsed => 'Credit used';

  @override
  String damageChargeEach(String amount) {
    return '$amount each';
  }

  @override
  String get damageChargeLeftToPay => 'Left to pay';

  @override
  String get damageChargePaidBody => 'You\'ve paid this charge in full.';

  @override
  String get damageChargePaidSoFar => 'Paid so far';

  @override
  String get damageChargePaidTitle => 'All paid';

  @override
  String damageChargePay(String amount) {
    return 'Pay $amount';
  }

  @override
  String damageChargeRaisedOn(String date) {
    return 'Raised on $date';
  }

  @override
  String get damageChargesCouldNotLoad => 'Couldn\'t load damage charges';

  @override
  String get damageChargesNoneMessage =>
      'If the hub finds damage when you return or exchange a scooter, the charge shows up here.';

  @override
  String get damageChargesNoneTitle => 'No damage charges';

  @override
  String get damageChargesNothingToPay => 'Nothing to pay';

  @override
  String get damageChargesNoUnpaid => 'No unpaid damage charges';

  @override
  String get damageChargeStatusCancelled => 'Cancelled';

  @override
  String get damageChargeStatusPaid => 'Paid';

  @override
  String get damageChargeStatusPartlyPaid => 'Partly paid';

  @override
  String get damageChargesTitle => 'Damage charges';

  @override
  String damageChargesToPay(int count) {
    return '$count to pay';
  }

  @override
  String get damageChargesUnpaid => 'Unpaid';

  @override
  String get damageChargesViewAndPay => 'View and pay';

  @override
  String get damageChargeTitle => 'Damage charge';

  @override
  String get damageChargeTotal => 'Total charges';

  @override
  String get damageChargeWhatWasCharged => 'What was charged';

  @override
  String get deallocAccessoriesReturned => 'Accessories returned';

  @override
  String get deallocAnyNewDamageRecordHere =>
      'Any new damage you record here is assessed against the rider\'s security deposit, so capture it clearly.';

  @override
  String get deallocAssessment => 'Assessment';

  @override
  String get deallocAvailable => 'Available';

  @override
  String get deallocBatteryReturnedHub => 'Battery returned to the hub';

  @override
  String get deallocBothRiderTeamLeadMust => 'Both the rider and the team lead must confirm';

  @override
  String get deallocChargerCable => 'Charger & cable';

  @override
  String get deallocChargeReturn => 'Charge at return';

  @override
  String get deallocCloseRide => 'Close the ride';

  @override
  String get deallocCodesValid10MinutesAsk =>
      'Codes are valid for 10 minutes. Ask each person to read theirs out — do not take their phone.';

  @override
  String get deallocCompareAgainstHandoverSet => 'Compare against the handover set';

  @override
  String get deallocCompleteDeAllocation => 'Complete de-allocation';

  @override
  String get deallocComponents => 'Components';

  @override
  String get deallocConditionAssessment => 'Condition assessment';

  @override
  String get deallocConfirmBatteryBack => 'Confirm the battery is back';

  @override
  String get deallocContinueAssessment => 'Continue to assessment';

  @override
  String get deallocContinueVerification => 'Continue to verification';

  @override
  String get deallocDamaged => 'Damaged';

  @override
  String get deallocDamageDescription => 'Damage description';

  @override
  String get deallocDeductedFromRidersSecurityDeposit => 'Deducted from the rider\'s security deposit after review.';

  @override
  String get deallocDescribeDamage => 'Describe the damage';

  @override
  String get deallocEndRideContinue => 'End the ride to continue';

  @override
  String get deallocEndRidersActiveRide => 'End the rider\'s active ride';

  @override
  String get deallocEnterAll6Digits => 'Enter all 6 digits';

  @override
  String get deallocEnterClosingOdometer => 'Enter the closing odometer';

  @override
  String get deallocEnterRidersCode => 'Enter the rider\'s code';

  @override
  String get deallocEnterTeamLeadsCode => 'Enter the team lead\'s code';

  @override
  String get deallocEstimatedRecovery => 'Estimated recovery';

  @override
  String get deallocExcellent => 'Excellent';

  @override
  String get deallocGood => 'Good';

  @override
  String get deallocLoggedBackIntoChargingBay => 'Logged back into the charging bay inventory.';

  @override
  String get deallocMinorScuffsNothingRecover => 'Minor scuffs, nothing to recover';

  @override
  String get deallocNoDamageBeyondNormalWear => 'No damage beyond normal wear';

  @override
  String get deallocNotUsableUntilFurtherNotice => 'Not usable until further notice';

  @override
  String get deallocOdometerReturn => 'Odometer at return';

  @override
  String get deallocOffRoad => 'Off road';

  @override
  String get deallocPhotographVehicleExactlyAsCame => 'Photograph the vehicle exactly as it came back';

  @override
  String get deallocRcInsurancePuc => 'RC, insurance and PUC';

  @override
  String get deallocReadyAllocateAnotherRider => 'Ready to allocate to another rider';

  @override
  String get deallocRecordVehicleCondition => 'Record the vehicle condition';

  @override
  String get deallocRecordWhatComesBackWhat => 'Record what comes back and what is missing';

  @override
  String get deallocRecoverableDamageRaiseMaintenanceJob => 'Recoverable damage — raise a maintenance job';

  @override
  String get deallocReturnCondition => 'Return condition';

  @override
  String get deallocReturnPhotos => 'Return photos';

  @override
  String get deallocRiderConfirmation => 'Rider confirmation';

  @override
  String get deallocSendWorkshopFirst => 'Send to the workshop first';

  @override
  String get deallocService => 'In service';

  @override
  String get deallocSetFleetStatus => 'Set fleet status';

  @override
  String get deallocSetFleetStatus2 => 'Set the fleet status';

  @override
  String get deallocStopsTelemetryClosesShiftSettles => 'Stops telemetry, closes the shift and settles the final trip.';

  @override
  String get deallocTeamLeadConfirmation => 'Team lead confirmation';

  @override
  String get deallocTwoPartyVerification => 'Two-party verification';

  @override
  String get deallocVehicleAngles => 'Vehicle angles';

  @override
  String get deallocVehicleCondition => 'Vehicle condition';

  @override
  String get deallocVerification => 'Verification';

  @override
  String get deallocWhatDamagedHowBadly => 'What is damaged, and how badly';

  @override
  String get deploymentAcceptScooter => 'Accept scooter';

  @override
  String get deploymentAcceptScooter2 => 'Accept this scooter?';

  @override
  String get deploymentAllSetUp => 'You\'re all set up';

  @override
  String get deploymentAlmostThere => 'Almost there';

  @override
  String get deploymentAmountDue => 'Amount due';

  @override
  String get deploymentAwaitingVerification => 'Awaiting verification';

  @override
  String get deploymentAwaitingVerificationHint => 'Your fleet manager will verify it shortly.';

  @override
  String get deploymentCashHub => 'Cash at hub';

  @override
  String get deploymentCheckEachItem => 'Check each item';

  @override
  String get deploymentCheckingWithFleetManagerEvery => 'Checking with your fleet manager every few seconds…';

  @override
  String get deploymentConfirmEveryItemHasBeen =>
      'You confirm every item has been checked with your team lead and the scooter is fit to ride.';

  @override
  String get deploymentCouldNotLoadChecklist => 'Could not load the checklist';

  @override
  String get deploymentCouldNotLoadTraining => 'Could not load training';

  @override
  String get deploymentCouldNotReachServer => 'Could not reach the server';

  @override
  String get deploymentCouldNotSubmitInspection => 'Could not submit the inspection';

  @override
  String get deploymentDone => 'Done';

  @override
  String get deploymentEnterTransactionReferencePaidWith => 'Enter the transaction reference you paid with';

  @override
  String get deploymentFinishHygieneCheck => 'Finish hygiene check';

  @override
  String get deploymentFlagAsProblem => 'Flag as a problem';

  @override
  String get deploymentFlaggedByRider => 'Flagged by rider';

  @override
  String get deploymentFleetManagerHasNotAsked => 'Your fleet manager has not asked for a payment yet.';

  @override
  String get deploymentFleetManagerHasNotSubmitted => 'Your fleet manager has not submitted the inspection yet.';

  @override
  String get deploymentFleetManagerPreparingVehicleIts =>
      'Your fleet manager is preparing the vehicle. Your payment details appear here as soon as they are ready.';

  @override
  String get deploymentFleetManagerPuttingTogetherPayment =>
      'Your fleet manager is putting together your payment details. You will be asked to pay in a moment.';

  @override
  String get deploymentFleetManagerWillAllocateScooter =>
      'Your fleet manager will allocate a scooter to you. We will bring you straight here when they do.';

  @override
  String get deploymentGoThroughEachItemWith =>
      'Go through each item with your team lead. Flag anything that is not right — it goes to the workshop with your note.';

  @override
  String get deploymentHygieneComplete => 'Hygiene check complete';

  @override
  String get deploymentInspection => 'Inspection';

  @override
  String get deploymentInspectionAccepted => 'Inspection accepted';

  @override
  String get deploymentItemsMarkedAsProblemGo =>
      'Items marked as a problem go to your fleet manager with your notes. The handover continues on the rest.';

  @override
  String deploymentManagerNextStep(String vehicle) {
    return 'Your fleet manager is on the next step for $vehicle.';
  }

  @override
  String get deploymentNoPaymentShow => 'No payment to show';

  @override
  String get deploymentNoteWorkshopTeam => 'Note for the workshop team';

  @override
  String get deploymentOpenEachModuleReadThrough =>
      'Open each module and read it through. Mandatory ones must be completed before you can finish.';

  @override
  String get deploymentPaidVia => 'Paid via';

  @override
  String get deploymentPaymentReceived => 'Payment received';

  @override
  String deploymentPaymentRejectedBody(String reason) {
    return 'Your fleet manager couldn\'t confirm this payment: $reason. Check the details and send them again.';
  }

  @override
  String get deploymentPaymentRejectedTitle => 'Payment not confirmed';

  @override
  String get deploymentPaymentSubmitted => 'Payment submitted';

  @override
  String get deploymentPaymentSupport =>
      'This payment can\'t be sent from the app right now. Please contact your hub or support.';

  @override
  String get deploymentPayScooter => 'Pay for your scooter';

  @override
  String get deploymentPlanAcceptedSnack => 'Plan accepted. Your fleet manager will ask for payment next.';

  @override
  String get deploymentPlanCouldNotLoad => 'Couldn\'t load your plan';

  @override
  String get deploymentPlanIntro =>
      'Your fleet manager picked this plan for you. Check the rent and what you pay today, read the terms, then accept to continue.';

  @override
  String get deploymentPlanNextPayment => 'You\'ve accepted this plan. Your fleet manager will ask for payment next.';

  @override
  String get deploymentPlanTitle => 'Your rental plan';

  @override
  String get deploymentPreparingScooter => 'Preparing your scooter';

  @override
  String get deploymentProgressSavedSignAgainAny =>
      'Your progress is saved. Sign in again any time to pick up where you left off.';

  @override
  String get deploymentReceiptAdd => 'Add screenshot';

  @override
  String get deploymentReceiptAdded => 'Screenshot added';

  @override
  String get deploymentReceiptsSent => 'Screenshots sent';

  @override
  String get deploymentReceiptTitle => 'Payment screenshot (optional)';

  @override
  String get deploymentReceiptTooLarge => 'This image is over 5 MB. Pick a smaller one.';

  @override
  String get deploymentReference => 'Reference';

  @override
  String get deploymentReferenceReceiptNumber => 'Reference or receipt number';

  @override
  String get deploymentRequired => 'Required';

  @override
  String get deploymentRide => 'Ride';

  @override
  String get deploymentRiderHygiene => 'Rider Hygiene';

  @override
  String get deploymentScooterReserved => 'Scooter reserved';

  @override
  String get deploymentSubmitted => 'Submitted';

  @override
  String get deploymentSubmitWithProblemsFlagged => 'Submit with problems flagged?';

  @override
  String get deploymentTransactionReference => 'Transaction reference';

  @override
  String get deploymentWaitingAllocation => 'Waiting for an allocation';

  @override
  String get deploymentWhatWrong => 'What is wrong?';

  @override
  String deploymentWritingPdi(String vehicle) {
    return 'Your fleet manager is writing up the pre-delivery inspection for $vehicle. You will check it over next.';
  }

  @override
  String get deploymentYourPlan => 'Your plan';

  @override
  String get errorActiveScooterRequired => 'You need a scooter assigned to you for this.';

  @override
  String get errorCouldNotReachServerCheck => 'Could not reach the server. Check your connection.';

  @override
  String get errorDidNotLookRight => 'That did not look right.';

  @override
  String get errorInspectionWithRider => 'Inspection with rider';

  @override
  String get errorPaymentPending => 'Payment pending';

  @override
  String get errorRiderProfileMissing => 'We couldn\'t find the rider profile.';

  @override
  String get errorServerTookTooLongAnswer => 'The server took too long to answer.';

  @override
  String get errorSessionHasExpiredSignAgain => 'Your session has expired. Sign in again.';

  @override
  String get errorTrainingProgress => 'Training in progress';

  @override
  String get errorUnknown => 'Unknown';

  @override
  String get esignAddNameFirst => 'Add your full name in the profile step first';

  @override
  String get esignSigned => 'Signed';

  @override
  String get esignTapToSign => 'Tap to sign';

  @override
  String get esignTitle => 'Your e-signature';

  @override
  String get esignYourName => 'Your name';

  @override
  String get exchangeAcceptConfirm => 'Accepting means you agree to the new terms for this scooter.';

  @override
  String get exchangeAccepted => 'Offer accepted';

  @override
  String get exchangeAcceptedOfferTitle => 'Your new plan';

  @override
  String get exchangeAcceptOffer => 'Accept offer';

  @override
  String get exchangeAgreementHistory => 'Agreement history';

  @override
  String get exchangeCancelConfirm => 'This exchange request will be closed.';

  @override
  String get exchangeCancelled => 'Request cancelled';

  @override
  String get exchangeCancelRequest => 'Cancel request';

  @override
  String get exchangeChooseReason => 'Why do you need an exchange?';

  @override
  String get exchangeCompleted => 'Completed';

  @override
  String get exchangeConsent => 'I have read this offer and I agree to it';

  @override
  String get exchangeCouldNotLoad => 'Could not load exchanges';

  @override
  String get exchangeCurrentScooter => 'Current scooter';

  @override
  String exchangeDepositDue(String amount) {
    return 'Pay $amount more deposit before you collect your new scooter.';
  }

  @override
  String get exchangeDepositHeld => 'Extra deposit kept by hub';

  @override
  String get exchangeDepositMoved => 'Deposit moved over';

  @override
  String get exchangeDepositRefund => 'Deposit refund';

  @override
  String get exchangeDepositToPay => 'Extra deposit to pay';

  @override
  String get exchangeDetails => 'Request details';

  @override
  String get exchangeDetailTitle => 'Exchange request';

  @override
  String get exchangeErrorAlreadyReturned => 'The old scooter has already been returned.';

  @override
  String get exchangeErrorBatteryPlan => 'The rider\'s battery plan isn\'t available for this scooter.';

  @override
  String get exchangeErrorBillingChanged => 'Billing changed after the offer was accepted. Please contact support.';

  @override
  String get exchangeErrorCannotCancel =>
      'Your scooter has already been returned, so this request can\'t be cancelled here. Please contact your hub.';

  @override
  String get exchangeErrorChanged => 'This request was just updated. Pull down to refresh and try again.';

  @override
  String get exchangeErrorDepositsUnsettled => 'Deposits aren\'t settled yet. Settle the deposits first.';

  @override
  String get exchangeErrorDisabled => 'Vehicle exchange isn\'t open right now. Please contact your hub.';

  @override
  String get exchangeErrorDuesPending =>
      'Clear your pending dues first. Breakdown and safety exchanges are still allowed.';

  @override
  String get exchangeErrorHandoverUnfinished =>
      'The new scooter hasn\'t been handed over yet. Finish the handover steps first.';

  @override
  String get exchangeErrorHoldExpired => 'The scooter hold expired. Choose the replacement again.';

  @override
  String get exchangeErrorInspectionUnfinished => 'Complete the return inspection first.';

  @override
  String get exchangeErrorNoRental => 'We couldn\'t find an active rental for you.';

  @override
  String get exchangeErrorNotEligible => 'The rider isn\'t eligible for this scooter.';

  @override
  String get exchangeErrorNoTerms => 'Rider terms aren\'t set up. Ask an admin to publish one active set of terms.';

  @override
  String get exchangeErrorNotFound => 'This exchange request no longer exists.';

  @override
  String get exchangeErrorOfferClosed => 'This offer is no longer open.';

  @override
  String get exchangeErrorOfferInvalid => 'We couldn\'t verify this offer. Ask your hub to send it again.';

  @override
  String get exchangeErrorPricingSetup =>
      'Pricing isn\'t set up for this scooter yet. Ask your operator to check the rate card.';

  @override
  String get exchangeErrorRecordsMissing => 'Some records for this exchange are missing. Please contact support.';

  @override
  String get exchangeErrorRentalInactive => 'Your rental isn\'t active, so an exchange can\'t be requested.';

  @override
  String get exchangeErrorReturnFirst => 'Finish the old scooter\'s return before choosing a replacement.';

  @override
  String get exchangeErrorReturnUnfinished =>
      'The return isn\'t finished yet. Verify the rider\'s OTP and complete the return first.';

  @override
  String get exchangeErrorSameScooter => 'Pick a different scooter from the rider\'s current one.';

  @override
  String get exchangeErrorScooterReserved => 'That scooter is reserved for another exchange.';

  @override
  String get exchangeErrorScooterUnavailable => 'That scooter is no longer available. Pick another one.';

  @override
  String get exchangeErrorSecurityChange =>
      'This scooter needs a different security deposit. Change the deposit separately first.';

  @override
  String get exchangeErrorSecurityTopUp => 'The rider\'s security deposit needs a top-up before completing.';

  @override
  String get exchangeErrorStale => 'Your rental changed after this offer was made. Ask your hub for a new offer.';

  @override
  String get exchangeErrorTooSoon => 'You\'ve had this scooter for too short a time. Please try again in a few days.';

  @override
  String get exchangeExtraRentNow => 'Extra rent now';

  @override
  String get exchangeFee => 'Exchange fee';

  @override
  String get exchangeFeeWaived => 'Waived';

  @override
  String get exchangeHubReason => 'Reason from hub';

  @override
  String get exchangeNeedsYou => 'Needs your answer';

  @override
  String get exchangeNewRent => 'New rent';

  @override
  String get exchangeNewRentFrom => 'New rent starts';

  @override
  String get exchangeNewScooter => 'New scooter';

  @override
  String get exchangeNextApproved => 'Approved. Your hub will ask you to bring your current scooter in for a check.';

  @override
  String exchangeNextBringIn(String date) {
    return 'Bring your current scooter to the hub you picked on $date. The hub team will start the exchange.';
  }

  @override
  String get exchangeNextCancelled => 'This request was cancelled.';

  @override
  String get exchangeNextCheckingIn =>
      'The hub team is checking your current scooter. You\'ll get a code on your phone to confirm the mechanic\'s report.';

  @override
  String get exchangeNextChoosing => 'Your old scooter is returned. Your hub is picking a replacement for you.';

  @override
  String get exchangeNextCompleted => 'Exchange complete. Enjoy your new scooter!';

  @override
  String get exchangeNextDeposit => 'Offer accepted. Your hub is settling the deposit for your new scooter.';

  @override
  String get exchangeNextExpired => 'This request expired before it was completed.';

  @override
  String get exchangeNextHandover => 'Your new scooter is ready. Collect it from the hub.';

  @override
  String get exchangeNextOffer => 'Your offer is ready. Check the details and accept or reject it.';

  @override
  String get exchangeNextRejected => 'Your hub couldn\'t approve this request.';

  @override
  String get exchangeNextRequested => 'Your hub will review your request soon.';

  @override
  String get exchangeNextReserved => 'A replacement scooter is reserved for you. Your offer will be ready soon.';

  @override
  String get exchangeNextReturn => 'Return your current scooter at the hub so they can inspect it.';

  @override
  String get exchangeNone => 'No exchange requests';

  @override
  String get exchangeNoneMessage => 'If your scooter has a problem, request an exchange and your hub will help.';

  @override
  String get exchangeNoRentalBody => 'You can request an exchange once a scooter is rented to you.';

  @override
  String get exchangeNoRentalTitle => 'No active rental';

  @override
  String get exchangeNoteHint => 'Describe the problem (optional)';

  @override
  String get exchangeNoteLabel => 'Note for your hub';

  @override
  String get exchangeNotes => 'Your note';

  @override
  String get exchangeOfferExpiredMessage => 'This offer has expired. Your hub can send a new one.';

  @override
  String get exchangeOfferExpires => 'Offer valid till';

  @override
  String get exchangeOfferTitle => 'Your offer';

  @override
  String get exchangeOpen => 'In progress';

  @override
  String get exchangeOpenExists => 'You already have an exchange in progress.';

  @override
  String get exchangePast => 'Finished';

  @override
  String get exchangePerDay => '/ day';

  @override
  String get exchangePerFortnight => '/ 2 weeks';

  @override
  String get exchangePerMonth => '/ month';

  @override
  String get exchangePerQuarter => '/ 3 months';

  @override
  String get exchangePerWeek => '/ week';

  @override
  String get exchangeProgress => 'Progress';

  @override
  String get exchangeRaised => 'Raised';

  @override
  String get exchangeReason => 'Reason';

  @override
  String get exchangeReasonBreakdown => 'Breakdown';

  @override
  String get exchangeReasonBreakdownHint => 'It stopped working or keeps breaking down';

  @override
  String get exchangeReasonOtherHint => 'Something else';

  @override
  String get exchangeReasonSafety => 'Safety swap';

  @override
  String get exchangeReasonSafetyHint => 'A safety check needs a different scooter';

  @override
  String get exchangeReasonUnsafe => 'Not safe to ride';

  @override
  String get exchangeReasonUnsafeHint => 'Brakes, lights or tyres don\'t feel safe';

  @override
  String get exchangeReasonUpgrade => 'Upgrade';

  @override
  String get exchangeReasonUpgradeHint => 'You\'d like a different model';

  @override
  String get exchangeRejected => 'Offer rejected';

  @override
  String get exchangeRejectOffer => 'Reject offer';

  @override
  String get exchangeRejectReason => 'Reason';

  @override
  String get exchangeRejectReasonRequired => 'Please write a reason';

  @override
  String get exchangeRejectSubtitle => 'Tell your hub why, so they can send a better one.';

  @override
  String get exchangeRentalCouldNotLoad => 'Could not load your rental';

  @override
  String get exchangeRentCredit => 'Rent credit';

  @override
  String get exchangeRequestAction => 'Request an exchange';

  @override
  String get exchangeRequestSent => 'Exchange request sent';

  @override
  String get exchangeRequestSubtitle => 'Tell your hub why you need a different scooter.';

  @override
  String get exchangeReturnDate => 'Drop-off date';

  @override
  String get exchangeSendRequest => 'Send request';

  @override
  String get exchangeStageAccepted => 'Accepted';

  @override
  String get exchangeStageCompleted => 'Completed';

  @override
  String get exchangeStageHandover => 'Handover';

  @override
  String get exchangeStageOfferReady => 'Offer ready';

  @override
  String get exchangeStageRequested => 'Requested';

  @override
  String get exchangeStatusApproved => 'Approved';

  @override
  String get exchangeStatusCancelled => 'Cancelled';

  @override
  String get exchangeStatusCheckingIn => 'Exchange in progress';

  @override
  String get exchangeStatusChoosing => 'Choosing scooter';

  @override
  String get exchangeStatusExpired => 'Expired';

  @override
  String get exchangeStatusRejected => 'Rejected';

  @override
  String get exchangeStatusReturn => 'Return scooter';

  @override
  String get exchangeStepApproval => 'Hub approval';

  @override
  String get exchangeStepDeposit => 'Deposit';

  @override
  String get exchangeStepHandover => 'Get new scooter';

  @override
  String get exchangeStepOffer => 'Replacement offer';

  @override
  String get exchangeStepRequested => 'Request sent';

  @override
  String get exchangeStepReturn => 'Return old scooter';

  @override
  String get exchangeSubtitle => 'Ask for a different scooter';

  @override
  String get exchangeTitle => 'Vehicle exchange';

  @override
  String get exchangeVersionCurrent => 'Current';

  @override
  String exchangeVersionFrom(String date) {
    return 'From $date';
  }

  @override
  String exchangeVersionNumber(String number) {
    return 'Version $number';
  }

  @override
  String get exchangeVersionPrevious => 'Previous';

  @override
  String get exchangeWhenWhere => 'When and where';

  @override
  String get exchangeWhenWhereHint => 'Pick when and where you\'ll bring your current scooter in.';

  @override
  String get fleetOnboardingActive => 'Active';

  @override
  String get fleetOnboardingArchived => 'Archived';

  @override
  String get fleetOnboardingDraft => 'Draft';

  @override
  String get fleetOnboardingInProgress => 'In progress';

  @override
  String get fleetOnboardingPendingReview => 'Waiting for review';

  @override
  String get fleetOnboardingRejected => 'Rejected';

  @override
  String get fleetSearchAllocationActive => 'With rider';

  @override
  String get fleetSearchAllocationCancelled => 'Cancelled';

  @override
  String get fleetSearchAllocationHandover => 'Handover in progress';

  @override
  String get fleetSearchAllocationReturned => 'Returned';

  @override
  String get fleetSearchAllocationReturning => 'Return in progress';

  @override
  String get fleetSearchCouldNotLoad => 'Couldn\'t search scooters';

  @override
  String get fleetSearchCouldNotLoadRiderHistory => 'Couldn\'t load rider history';

  @override
  String get fleetSearchCouldNotLoadScooter => 'Couldn\'t load this scooter';

  @override
  String get fleetSearchCurrentRider => 'Current rider';

  @override
  String get fleetSearchEmptyMessage => 'Check the vehicle number, fleet code or chassis number and try again.';

  @override
  String get fleetSearchEmptyTitle => 'No scooter found';

  @override
  String get fleetSearchHint => 'Search scooters by number, code or chassis';

  @override
  String get fleetSearchLatestSubmission => 'Latest return or exchange';

  @override
  String get fleetSearchNoRider => 'No rider has this scooter right now.';

  @override
  String get fleetSearchNoRiderHistory => 'No rider has had this scooter yet.';

  @override
  String get fleetSearchNoSubmission => 'No return or exchange yet.';

  @override
  String get fleetSearchOtherHub => 'Other hub';

  @override
  String get fleetSearchRiderHistory => 'Rider history';

  @override
  String get fleetSearchRiderHistoryOtherHub => 'Rider history is shown only for scooters in your hubs.';

  @override
  String fleetSearchSince(String date) {
    return 'Since $date';
  }

  @override
  String get fleetSearchStartMessage => 'Type at least 2 characters of a vehicle number, fleet code or chassis number.';

  @override
  String get fleetSearchStartTitle => 'Search every hub';

  @override
  String get fleetSearchSubmissionDone => 'Done';

  @override
  String get fleetSearchSubmissionOpen => 'In progress';

  @override
  String get fleetSearchTitle => 'Find a scooter';

  @override
  String get fleetStatusAllocated => 'Allocated';

  @override
  String get fleetStatusAllocating => 'Being allocated';

  @override
  String get fleetStatusAvailable => 'Available';

  @override
  String get fleetStatusAwaitingParts => 'Awaiting parts';

  @override
  String get fleetStatusBroken => 'Broken';

  @override
  String get fleetStatusInspectionPending => 'Waiting for inspection';

  @override
  String get fleetStatusInTransit => 'In transit';

  @override
  String get fleetStatusInUse => 'In use';

  @override
  String get fleetStatusMaintenance => 'Under maintenance';

  @override
  String get fleetStatusOutOfService => 'Out of service';

  @override
  String get fleetStatusReserved => 'Reserved';

  @override
  String get fleetStatusReturning => 'Being returned';

  @override
  String get homeCouldNotLoadDashboard => 'Could not load your dashboard';

  @override
  String get homeDailyRental => 'Daily Rental';

  @override
  String get homeDepositsHandoverFees => 'Deposits and handover fees';

  @override
  String get homeHelpSupport => 'Help & support';

  @override
  String get homeHistory => 'History';

  @override
  String get homeLastPayment => 'Last payment';

  @override
  String get homeMarkAbsent => 'Mark absent';

  @override
  String get homeMarkedAbsentScooterNowDisabled => 'Marked absent. The scooter is now disabled.';

  @override
  String get homeMarkYourselfAbsent => 'Mark yourself absent?';

  @override
  String get homeMarkYourselfPresentSwitchVehicle => 'Mark yourself present to switch the vehicle on.';

  @override
  String homeNextDebitOn(String date) {
    return 'Next debit $date';
  }

  @override
  String get homeRent => 'Rent';

  @override
  String get homeRentDue => 'Rent due';

  @override
  String homeRentDueOn(String date) {
    return 'Due $date';
  }

  @override
  String homeRentOverdue(String amount) {
    return '$amount overdue';
  }

  @override
  String get homeScooter => 'Scooter';

  @override
  String get homeShiftWillEndScooterWill =>
      'Your shift will end and the scooter will switch off. Rent still applies on weekly and monthly plans.';

  @override
  String get homeWithdraw => 'Withdraw';

  @override
  String get homeWorkingDays => 'Working Days';

  @override
  String get hubAllHubs => 'All hubs';

  @override
  String get hubAllocate => 'Allocate';

  @override
  String get hubAllotmentsInQueue => 'Allotments in Queue';

  @override
  String get hubAllotmentsInQueueInfo => 'Active riders at this hub who are waiting for a vehicle.';

  @override
  String get hubChooseHub => 'Choose a hub';

  @override
  String get hubChooseHubSubtitle => 'See one hub, or all your hubs together.';

  @override
  String get hubCouldNotLoadHub => 'Could not load your hub';

  @override
  String hubCount(int count) {
    return '$count hubs';
  }

  @override
  String get hubFleetAtHub => 'At hub';

  @override
  String get hubFleetManager => 'Fleet Manager';

  @override
  String get hubFleetMapped => 'Total fleet';

  @override
  String get hubFleetOnField => 'On field';

  @override
  String get hubFleetUtilisation => 'Fleet utilisation';

  @override
  String hubGstinLine(String gstin) {
    return 'GSTIN: $gstin';
  }

  @override
  String get hubHome => 'Home';

  @override
  String get hubHubGlance => 'Your hub at a glance';

  @override
  String get hubMaintenance => 'Maintenance';

  @override
  String get hubMarkedAbsentShiftClosed => 'Marked absent. Your shift is closed.';

  @override
  String get hubNoHubAssigned => 'No hub is assigned to you.';

  @override
  String hubQuickSupportLine(String number) {
    return 'Quick support: $number';
  }

  @override
  String get hubQuickView => 'Quick Hub View';

  @override
  String get hubQuickViewInfo => 'Live counts for your selected hub.';

  @override
  String get hubReturn => 'Return';

  @override
  String get hubRfdsAvailable => 'RFDs available';

  @override
  String get hubRfdsAvailableInfo => 'Ready for deployment: vehicles at this hub that are free to allot.';

  @override
  String get hubsCouldNotLoad => 'Could not load nearby hubs';

  @override
  String get hubService => 'Service';

  @override
  String get hubShowDataFor => 'Show data for';

  @override
  String get hubsNoneBody => 'There are no active hubs within reach of your location.';

  @override
  String get hubsNoneTitle => 'No hubs near you';

  @override
  String get hubSomethingWentWrong => 'Something went wrong.';

  @override
  String get hubsSubtitle => 'Closest hubs to you';

  @override
  String get hubSubmissionsInQueue => 'Submissions in Queue';

  @override
  String get hubSubmissionsInQueueInfo =>
      'Returns and exchanges due at this hub whose vehicle submission isn\'t complete yet.';

  @override
  String get hubUnderMaintenanceFleet => 'Under Maintenance Fleet';

  @override
  String get hubUnderMaintenanceFleetInfo => 'Vehicles from this hub that are under maintenance right now.';

  @override
  String get inspectionErrorSafeForReuse => 'Say whether the scooter is safe to give out again.';

  @override
  String get inspectionErrorUnsafeReason => 'Add why the scooter isn\'t safe to give out again.';

  @override
  String get introCouldNotLoad => 'Could not load the intro slides.';

  @override
  String get introEarnBody =>
      'Daily payouts, transparent incentives and a rental plan that fits how much you actually ride.';

  @override
  String get introEarnHighlight1 => 'Same-day settlement';

  @override
  String get introEarnHighlight2 => 'No hidden deductions';

  @override
  String get introEarnTitle => 'Earn more,\nride cleaner';

  @override
  String get introSupportBody =>
      'Roadside assistance, service booking and a team lead who can see exactly what you see.';

  @override
  String get introSupportHighlight1 => '24x7 roadside help';

  @override
  String get introSupportHighlight2 => 'Service at your hub';

  @override
  String get introSupportTitle => 'Help that\nshows up';

  @override
  String get introVehicleBody =>
      'Live battery, range and health from the onboard IoT unit. Unlock and start your shift from the app.';

  @override
  String get introVehicleHighlight1 => 'Live telemetry';

  @override
  String get introVehicleHighlight2 => 'One-tap start';

  @override
  String get introVehicleTitle => 'Your scooter,\nfully connected';

  @override
  String get legalAppName => 'App';

  @override
  String get legalDocumentCouldNotLoad => 'Could not load this document';

  @override
  String get maintenanceAllocation => 'Allocation';

  @override
  String get maintenanceAllocationOff => 'Turned off';

  @override
  String get maintenanceAllocationOn => 'Allowed';

  @override
  String get maintenanceBattery => 'Battery';

  @override
  String get maintenanceCategory => 'Category';

  @override
  String get maintenanceChangeStatus => 'Change status';

  @override
  String get maintenanceChassis => 'Chassis number';

  @override
  String get maintenanceChecksOpen => 'Some mechanic checks are still open';

  @override
  String get maintenanceColour => 'Colour';

  @override
  String get maintenanceCouldNotLoad => 'Couldn\'t load vehicles in service';

  @override
  String get maintenanceCurrentHub => 'Current hub';

  @override
  String get maintenanceEarlierReports => 'Earlier mechanic reports';

  @override
  String get maintenanceEmptyBody => 'When a scooter at your hubs is moved to maintenance, it shows up here.';

  @override
  String get maintenanceEmptyTitle => 'No vehicles in service';

  @override
  String get maintenanceEvidence => 'Evidence photos';

  @override
  String get maintenanceFleetCode => 'Fleet code';

  @override
  String get maintenanceHistory => 'Status history';

  @override
  String maintenanceHistoryLimit(int limit) {
    return 'Showing the latest $limit changes.';
  }

  @override
  String get maintenanceHomeHub => 'Home hub';

  @override
  String get maintenanceInServiceSince => 'In service since';

  @override
  String get maintenanceLatestReport => 'Latest mechanic report';

  @override
  String get maintenanceMaker => 'Manufacturer';

  @override
  String get maintenanceModel => 'Model';

  @override
  String maintenanceMovedOn(String date) {
    return 'Moved to maintenance $date';
  }

  @override
  String get maintenanceNoHistory => 'No status changes have been recorded.';

  @override
  String get maintenanceNoMatchBody => 'Try a different vehicle number, fleet code, chassis or model.';

  @override
  String get maintenanceNoMatchTitle => 'No matching vehicles';

  @override
  String get maintenanceNoReportYet => 'No mechanic report has been recorded for this vehicle yet.';

  @override
  String get maintenanceNotSafe => 'Not safe';

  @override
  String get maintenanceOdometer => 'Odometer';

  @override
  String get maintenanceOnboarding => 'Onboarding';

  @override
  String get maintenanceProgress => 'In progress';

  @override
  String maintenanceReasonFromReport(String reason) {
    return 'Mechanic report: $reason';
  }

  @override
  String maintenanceReasonLine(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get maintenanceReportConfirmed => 'Confirmed on';

  @override
  String get maintenanceReportMechanic => 'Mechanic';

  @override
  String get maintenanceReportPhotos => 'Photos';

  @override
  String get maintenanceReportRecorded => 'Recorded on';

  @override
  String maintenanceReportsLimit(int limit) {
    return 'Showing the latest $limit reports.';
  }

  @override
  String get maintenanceReportStatus => 'Scooter status';

  @override
  String get maintenanceSafeToReuse => 'Safe to reuse';

  @override
  String get maintenanceSearchHint => 'Search vehicle number, fleet code, chassis or model';

  @override
  String get maintenanceSelectVehicle => 'Select a vehicle';

  @override
  String maintenanceStatusChanged(String status) {
    return 'Status changed to $status';
  }

  @override
  String maintenanceStatusNow(String status) {
    return 'Current status: $status';
  }

  @override
  String get maintenanceStatusOutOfServiceHint =>
      'Taken off the road. It leaves Service, and only your admin can bring it back.';

  @override
  String get maintenanceTitle => 'Vehicles in service';

  @override
  String get maintenanceUnderMaintenance => 'Under maintenance';

  @override
  String get maintenanceVariant => 'Variant';

  @override
  String get maintenanceVehicleCouldNotLoad => 'Couldn\'t load this vehicle';

  @override
  String get maintenanceVehicleDetails => 'Vehicle details';

  @override
  String get maintenanceVehicleTitle => 'Vehicle in service';

  @override
  String get maintenanceVehicleType => 'Vehicle type';

  @override
  String get mapsAllowLocation => 'Allow location';

  @override
  String mapsAway(String distance) {
    return '$distance away';
  }

  @override
  String get mapsCouldNotOpenMaps => 'Could not open Google Maps';

  @override
  String get mapsLocating => 'Finding your location…';

  @override
  String get mapsLocationDeniedBody => 'We use your location to show hubs and swap stations near you.';

  @override
  String get mapsLocationDeniedTitle => 'Allow location access';

  @override
  String get mapsLocationOffBody => 'Turn on location services to see places near you.';

  @override
  String get mapsLocationOffTitle => 'Location is turned off';

  @override
  String get mapsLocationUnavailable => 'Could not find your location';

  @override
  String mapsMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String get mapsNavigate => 'Navigate';

  @override
  String get mapsOpenSettings => 'Open settings';

  @override
  String get navBatterySwap => 'Battery swap';

  @override
  String get navNearbyHubs => 'Nearby hubs';

  @override
  String get navReferEarn => 'Refer & earn';

  @override
  String get navScooterDetails => 'Scooter details';

  @override
  String get notificationsAll => 'All';

  @override
  String get notificationsAllCaughtUp => 'You are all caught up';

  @override
  String get notificationsAllClear => 'All clear';

  @override
  String get notificationsCouldNotLoadNotifications => 'Could not load notifications';

  @override
  String get notificationsEarlier => 'Earlier';

  @override
  String get notificationsEmptyMessage => 'New updates and alerts will show up here.';

  @override
  String get notificationsGotIt => 'Got it';

  @override
  String notificationsInboxCount(int count) {
    return '$count notifications in your inbox';
  }

  @override
  String get notificationsNoMatchingNotifications => 'No matching notifications';

  @override
  String get notificationsNothingNewNeedsAttention => 'Nothing new needs your attention';

  @override
  String get notificationsNotifications => 'Notifications';

  @override
  String get notificationsSearchNotifications => 'Search notifications';

  @override
  String get notificationsToday => 'Today';

  @override
  String get notificationsUnread => 'Unread';

  @override
  String notificationsUnreadCount(int count) {
    return '$count unread';
  }

  @override
  String get onboardingAcceptAgreementContinue => 'Accept the agreement to continue';

  @override
  String get onboardingAddDateBirthFirstStep => 'Add your date of birth on the first step before continuing';

  @override
  String get onboardingAddLeastOneReference => 'Add at least one reference';

  @override
  String onboardingAddYourField(String field) {
    return 'Add your $field';
  }

  @override
  String get onboardingAgreementBody =>
      'This agreement is between you and your fleet operator. It covers the vehicle you are handed, how it may be used, your responsibility for its care, the deposits and fees on your plan, and how the arrangement ends. Read it fully before you accept. By ticking the box below you confirm that you have read and agree to be bound by the rider agreement and the operator\'s rider policies.';

  @override
  String get onboardingAgreeToRiderAgreement => 'I have read and agree to the rider agreement';

  @override
  String get onboardingAnswered => 'Answered';

  @override
  String get onboardingApplicationSubmitted => 'Application submitted';

  @override
  String get onboardingAttached => 'Attached';

  @override
  String get onboardingBankAccount => 'Bank account';

  @override
  String get onboardingBankAccountNeeded => 'Enter your account number and type it again to confirm.';

  @override
  String get onboardingBankAccountTooShort => 'This account number looks too short.';

  @override
  String get onboardingBankBranch => 'Branch';

  @override
  String get onboardingBankCity => 'City';

  @override
  String get onboardingBankIfsc => 'IFSC code';

  @override
  String get onboardingBankIfscFailed => 'Couldn\'t check this IFSC right now. Fill in your bank details below.';

  @override
  String get onboardingBankIfscHelper => '11 characters. You\'ll find it on your passbook or cheque.';

  @override
  String get onboardingBankIfscHint => 'e.g. SBIN0001234';

  @override
  String get onboardingBankIfscNotFound =>
      'No bank found for this IFSC. Check the code, or fill in your bank details below.';

  @override
  String get onboardingBankIfscPending => 'Enter your IFSC and wait for your bank to show.';

  @override
  String get onboardingBankName => 'Bank name';

  @override
  String get onboardingBankProof => 'Bank proof (passbook or cancelled cheque)';

  @override
  String get onboardingBankState => 'State';

  @override
  String get onboardingCheckEverythingBeforeSubmitCan =>
      'Check everything before you submit. You can still edit any step.';

  @override
  String get onboardingCouldNotLoadOnboarding => 'Could not load onboarding';

  @override
  String get onboardingDateBirthNotValid => 'That date of birth is not valid';

  @override
  String get onboardingDocumentApproved => 'Approved';

  @override
  String get onboardingDocumentHasExpiredEnterDate => 'This document has expired. Enter a date later than today.';

  @override
  String get onboardingDocumentInReview => 'Uploaded · under review';

  @override
  String get onboardingDocuments => 'Documents';

  @override
  String get onboardingEdit => 'Edit';

  @override
  String onboardingEnterValidField(String field) {
    return 'Enter a valid $field';
  }

  @override
  String get onboardingEveryStepHaveCompletedSaved =>
      'Every step you have completed is saved. You can pick up exactly where you left off next time you sign in.';

  @override
  String get onboardingExit => 'Exit';

  @override
  String get onboardingExitOnboarding => 'Exit onboarding?';

  @override
  String onboardingFieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get onboardingGoOnboarding => 'Go to onboarding';

  @override
  String get onboardingIntroGetStarted => 'Get started';

  @override
  String get onboardingIntroNext => 'Next';

  @override
  String get onboardingLoadingOnboardingForm => 'Loading your onboarding form…';

  @override
  String get onboardingNoStepsConfigured =>
      'Your fleet operator\'s package has no onboarding steps configured yet. Ask them to set up rider onboarding, then sign in again.';

  @override
  String get onboardingNothingFill => 'Nothing to fill in';

  @override
  String get onboardingNothingFillStep => 'Nothing to fill in on this step.';

  @override
  String get onboardingNothingReviewYet => 'Nothing to review yet';

  @override
  String get onboardingNothingToFillHere => 'Nothing to fill in here';

  @override
  String get onboardingNotProvided => 'Not provided';

  @override
  String get onboardingPackage => 'Package';

  @override
  String get onboardingPleaseFixHighlightedFieldsBefore => 'Please fix the highlighted fields before continuing';

  @override
  String get onboardingReferences => 'References';

  @override
  String get onboardingReferralApplied => 'Applied';

  @override
  String get onboardingReferralApply => 'Apply';

  @override
  String get onboardingReferralCodeApplied => 'Referral code applied';

  @override
  String get onboardingReferralFromInvite => 'Added from your invite link';

  @override
  String get onboardingReferralNotFound => 'We couldn\'t find a referral for that. Check the code or mobile number.';

  @override
  String get onboardingReferralScan => 'Scan referral QR';

  @override
  String get onboardingReferralTapApply => 'Tap Apply to use this code, or clear it';

  @override
  String onboardingRejectedMessage(String documents) {
    return 'Upload again to continue: $documents';
  }

  @override
  String get onboardingRejectedTitle => 'Rejected in review';

  @override
  String get onboardingReview => 'Review';

  @override
  String get onboardingReviewApplication => 'Review application';

  @override
  String get onboardingRiderOnboarding => 'Rider onboarding';

  @override
  String get onboardingSaving => 'Saving…';

  @override
  String get onboardingSignAgreementContinue => 'Sign the agreement to continue';

  @override
  String get onboardingSomeStepsStillIncompleteGo => 'Some steps are still incomplete. Go back and finish them.';

  @override
  String get onboardingStartOnboardingSeeAnswersHere => 'Start onboarding to see your answers here.';

  @override
  String get onboardingStepAgreement => 'Agreement';

  @override
  String get onboardingStepEligibility => 'Eligibility';

  @override
  String get onboardingStepHandledByOperator =>
      'This step is handled by your fleet operator. Continue to the next one.';

  @override
  String get onboardingStepTraining => 'Training';

  @override
  String get onboardingSubmitApplication => 'Submit application';

  @override
  String get onboardingTakePhotoDocumentChooseOne => 'Take a photo of the document, or choose one you already have';

  @override
  String get onboardingUploadRejectedAgain => 'Upload the rejected documents again before you submit.';

  @override
  String get paymentRefundableDeposit => 'Refundable deposit';

  @override
  String get paymentRentAndFees => 'Rent and fees';

  @override
  String get paymentsAllClear => 'You are all paid up';

  @override
  String get paymentsAllClearMessage => 'Nothing is due right now. We will tell you before the next one.';

  @override
  String get paymentsAmountDue => 'Amount due';

  @override
  String get paymentsAutoPay => 'Auto-debit';

  @override
  String get paymentsAutoPayActive => 'On';

  @override
  String get paymentsAutoPayAttention => 'Auto-debit needs attention. Ask your fleet manager to set it up again.';

  @override
  String get paymentsAutoPayAuthPending => 'Waiting for approval';

  @override
  String get paymentsAutoPayExpired => 'Expired';

  @override
  String get paymentsAutoPayFailed => 'Failed';

  @override
  String get paymentsAutoPayNotEnabled => 'Not set up';

  @override
  String get paymentsAutoPayPaused => 'Paused';

  @override
  String get paymentsAutoPayRevoked => 'Cancelled';

  @override
  String get paymentsAutoPaySetupRequired => 'Set-up needed';

  @override
  String get paymentsBreakdown => 'Breakdown';

  @override
  String get paymentsCouldNotLoad => 'Could not load payments';

  @override
  String paymentsDueOnDate(String date) {
    return 'Due on $date';
  }

  @override
  String get paymentsHistory => 'Past payments';

  @override
  String get paymentsMandateExpires => 'Mandate ends';

  @override
  String get paymentsMandateLimit => 'Per-debit limit';

  @override
  String get paymentsMethod => 'Method';

  @override
  String get paymentsNextDebit => 'Next debit';

  @override
  String get paymentsNoPayments => 'No payments yet';

  @override
  String get paymentsNoPaymentsMessage => 'Your payments show up here once they are confirmed.';

  @override
  String get paymentsNothingDue => 'Nothing due';

  @override
  String get paymentsOverdue => 'Overdue';

  @override
  String get paymentsPayAtHub => 'Pay at your hub, or let auto-debit take it on the due date.';

  @override
  String get paymentsPayment => 'Payment';

  @override
  String get paymentsSubtitle => 'Dues, auto-debit and receipts';

  @override
  String get paymentsTitle => 'Payments';

  @override
  String get pdiHintTyreWorn => 'e.g. Front tyre worn below limit';

  @override
  String pdiWorkPartner(String partner) {
    return 'Work partner: $partner';
  }

  @override
  String get planAccept => 'Accept plan';

  @override
  String get planAdvanceRental => 'Advance Rental';

  @override
  String get planBatteryDeposit => 'Battery security deposit';

  @override
  String get planConsent => 'I have read this plan and I agree to it';

  @override
  String get planCustom => 'Custom plan';

  @override
  String get planDaily => 'Daily plan';

  @override
  String planDays(int count) {
    return '$count-day plan';
  }

  @override
  String get planDiscount => 'Discount';

  @override
  String get planErrorAgreementMismatch => 'This rental doesn\'t match the scooter. Contact your fleet manager.';

  @override
  String get planErrorAgreementNotActive => 'Your rental isn\'t active yet, so this can\'t be done now.';

  @override
  String get planErrorAgreementNotReady => 'The accepted plan isn\'t ready for handover. Refresh and try again.';

  @override
  String get planErrorDepositNotConfigured =>
      'No scooter security deposit is set up for this plan. Ask your admin to add one, even if it\'s zero.';

  @override
  String get planErrorExchangePlan => 'This is an exchange scooter, so its plan is already agreed.';

  @override
  String get planErrorFeeNotConfigured =>
      'No onboarding fee is set up for this plan. Ask your admin to add one, even if it\'s zero.';

  @override
  String get planErrorFleetRequestRequired => 'Request the scooter before asking for payment.';

  @override
  String get planErrorOfferNotValid => 'This plan offer is no longer valid. Ask for a new one.';

  @override
  String get planErrorPaymentReferenceRequired => 'The rider hasn\'t sent a payment reference yet.';

  @override
  String get planErrorPaymentStale => 'The amount has changed. Refresh and ask for payment again.';

  @override
  String get planErrorRequired => 'Choose a rental plan and get the rider to accept it first.';

  @override
  String get planErrorSelectionChanged => 'Another plan was just chosen. Refresh and try again.';

  @override
  String get planErrorSelectionClosed => 'The plan can\'t be changed any more.';

  @override
  String get planErrorTermsChanged => 'The plan terms changed. Refresh and accept again.';

  @override
  String get planFortnightly => 'Fortnightly plan';

  @override
  String get planFree => 'Free';

  @override
  String get planIncluded => 'Included';

  @override
  String get planInsurance => 'Insurance';

  @override
  String get planMonthly => 'Monthly plan';

  @override
  String get planOfferNotLive => 'This offer is no longer open. Your fleet manager will send a new one.';

  @override
  String get planOnboardingFee => 'Onboarding fee';

  @override
  String get planPayableToday => 'Pay today';

  @override
  String get planQuarterly => 'Quarterly plan';

  @override
  String planRefundableNote(String amount) {
    return 'Includes $amount refundable deposit';
  }

  @override
  String get planRent => 'Rent';

  @override
  String get planScooterAgeAdjustment => 'Scooter age adjustment';

  @override
  String get planScooterDeposit => 'Scooter security deposit';

  @override
  String planUsageRate(String rate, String unit) {
    return '$rate per $unit';
  }

  @override
  String get planValidUntil => 'Offer valid until';

  @override
  String get planWeekly => 'Weekly plan';

  @override
  String planWeeks(int count) {
    return '$count-week plan';
  }

  @override
  String get profileHub => 'Hub';

  @override
  String get profilePersonalDetails => 'Personal details';

  @override
  String get referActivity => 'Activity';

  @override
  String referCardReward(String amount) {
    return 'Join with my code and get $amount';
  }

  @override
  String get referCodeCopied => 'Referral code copied';

  @override
  String referCompleteBy(String date) {
    return 'Complete these by $date';
  }

  @override
  String get referCopyCode => 'Copy code';

  @override
  String get referCopyMessage => 'Copy invite message';

  @override
  String get referCouldNotLoad => 'Could not load refer & earn';

  @override
  String get referDetailTitle => 'Referral details';

  @override
  String get referDrawerHint => 'Let a friend scan this to join with your code. Tap to enlarge.';

  @override
  String get referDrawerTitle => 'My referral QR';

  @override
  String get referErrorAlreadyLinked => 'Your account is already linked to another referral code.';

  @override
  String get referErrorCampaignInactive => 'Refer & earn isn\'t running right now.';

  @override
  String get referErrorCodeExpired => 'This invite has expired. Ask your friend to send a new one.';

  @override
  String get referErrorLimit => 'This rider has reached their referral limit.';

  @override
  String get referErrorNotEligible => 'Your rider profile isn\'t ready for referrals yet.';

  @override
  String get referErrorNotEnabled => 'Refer & earn isn\'t available for your company.';

  @override
  String get referErrorNotFound => 'Referral not found.';

  @override
  String get referErrorSelf => 'You can\'t use your own referral code.';

  @override
  String get referEventExpired => 'A referral expired';

  @override
  String get referEventOther => 'Referral update';

  @override
  String get referEventProgress => 'A referral made progress';

  @override
  String get referEventQualified => 'A referral qualified for its reward';

  @override
  String get referEventRegistered => 'A rider joined with a referral code';

  @override
  String get referEventRewardPaid => 'A referral reward was paid';

  @override
  String get referFriendGets => 'Your friend gets';

  @override
  String get referHowItWorks => 'How it works';

  @override
  String get referHowItWorksBody =>
      'Share your code. When your friend joins and completes these steps, the referral reward unlocks.';

  @override
  String get referInvited => 'Invited';

  @override
  String referInviteValidTill(String date) {
    return 'This invite is valid till $date';
  }

  @override
  String get referMessageCopied => 'Invite message copied';

  @override
  String get referMilestoneActivated => 'Get activated as a rider';

  @override
  String referMilestoneActiveDays(String count) {
    return 'Stay active for $count days';
  }

  @override
  String referMilestoneAttendance(String count) {
    return 'Mark attendance on $count days';
  }

  @override
  String referMilestoneDeliveries(String count) {
    return 'Complete $count deliveries';
  }

  @override
  String get referMilestoneKyc => 'Complete KYC';

  @override
  String get referMilestoneOther => 'Complete the campaign step';

  @override
  String get referMilestonePayment => 'Make the first payment';

  @override
  String referMilestoneRides(String count) {
    return 'Complete $count rides';
  }

  @override
  String get referMilestoneTraining => 'Finish the training';

  @override
  String get referMilestoneVehicle => 'Get a scooter allotted';

  @override
  String get referNoCampaignBody => 'Check back soon for new rewards.';

  @override
  String get referNoCampaignTitle => 'No referral campaign right now';

  @override
  String get referNoReferralsBody => 'Share your code to invite riders.';

  @override
  String get referNoReferralsTitle => 'No referrals yet';

  @override
  String get referPaid => 'Paid';

  @override
  String get referPending => 'Pending';

  @override
  String get referProgress => 'Progress';

  @override
  String get referQrSemantics => 'Referral QR code';

  @override
  String get referQualified => 'Qualified';

  @override
  String get referRegistered => 'Registered';

  @override
  String get referRewardEarned => 'Earned';

  @override
  String get referRewardPending => 'Pending';

  @override
  String get referRewardProcessing => 'Processing';

  @override
  String get referRewardReversed => 'Reversed';

  @override
  String get referRewards => 'Rewards';

  @override
  String get referScanCameraFailed => 'The camera couldn\'t start. Try again, or pick a photo of the QR code.';

  @override
  String referScanFound(String code) {
    return 'Found code $code';
  }

  @override
  String get referScanFromPhotos => 'Pick from photos';

  @override
  String get referScanHint => 'Point the camera at a referral QR code';

  @override
  String get referScanNoCamera =>
      'There\'s no camera to scan with on this device. Pick a photo of the QR code instead.';

  @override
  String get referScanNoQrInPhoto => 'No QR code found in that photo.';

  @override
  String get referScanNotReferral => 'That QR code isn\'t a referral code.';

  @override
  String get referScanPermissionDenied =>
      'Camera access is off. Allow it in Settings to scan, or pick a photo of the QR code.';

  @override
  String get referScanTitle => 'Scan referral QR';

  @override
  String get referScanToJoin => 'Scan to join with my referral code';

  @override
  String referShareAndroid(String link) {
    return 'Get the app on Android: $link';
  }

  @override
  String referShareCodeLine(String code) {
    return 'Use my referral code $code when you sign up.';
  }

  @override
  String referShareIntro(String app) {
    return 'Join me as a rider on $app!';
  }

  @override
  String get referShareInvite => 'Share invite';

  @override
  String referShareIphone(String link) {
    return 'Get the app on iPhone: $link';
  }

  @override
  String get referShareNow => 'Share';

  @override
  String referShareReward(String amount) {
    return 'You get $amount when you complete the joining steps.';
  }

  @override
  String get referShareSubtitle => 'Your friend can scan the QR or use the link to join.';

  @override
  String get referShareTitle => 'Share your invite';

  @override
  String get referShowQr => 'Show QR';

  @override
  String get referStatusActivated => 'Activated';

  @override
  String get referStatusCancelled => 'Cancelled';

  @override
  String get referStatusDisqualified => 'Disqualified';

  @override
  String get referStatusExpired => 'Expired';

  @override
  String get referStatusInProgress => 'In progress';

  @override
  String get referStatusKycVerified => 'KYC verified';

  @override
  String get referStatusPaid => 'Reward paid';

  @override
  String get referStatusRejected => 'Rejected';

  @override
  String get referStatusRewardApproved => 'Reward approved';

  @override
  String get referStatusRewardPending => 'Reward pending';

  @override
  String get referStatusUnderReview => 'Under review';

  @override
  String referStepsDone(int done, int total) {
    return '$done/$total steps';
  }

  @override
  String get referSubtitle => 'Invite riders and earn rewards';

  @override
  String get referTimeline => 'Timeline';

  @override
  String get referTotalEarned => 'Total earned';

  @override
  String referValidTill(String date) {
    return 'Valid till $date';
  }

  @override
  String get referYouGet => 'You get';

  @override
  String get referYourCode => 'Your referral code';

  @override
  String get referYourQr => 'Your referral QR';

  @override
  String get referYourQrSubtitle => 'Ask your friend to scan it in the app\'s onboarding.';

  @override
  String get referYourReferrals => 'Your referrals';

  @override
  String get rentalsAutoDebit => 'Auto-debit';

  @override
  String get rentalsAutoDebitKeepsEveryCycle => 'Auto-debit keeps every cycle paid on time, no manual transfers';

  @override
  String get rentalsBillingPeriod => 'Billing period';

  @override
  String get rentalsBills => 'Bills';

  @override
  String get rentalsCouldNotLoadBill => 'Could not load this bill';

  @override
  String get rentalsCouldNotLoadLedger => 'Could not load your ledger';

  @override
  String get rentalsCouldNotLoadPayments => 'Could not load your payments';

  @override
  String get rentalsCouldNotLoadRentPlan => 'Could not load your rent plan';

  @override
  String get rentalsCredit => 'Credit available';

  @override
  String get rentalsCreditsApplied => 'Credits applied';

  @override
  String get rentalsCurrentPlan => 'Current plan';

  @override
  String get rentalsDepositHeld => 'Deposit held';

  @override
  String get rentalsDue => 'Due on';

  @override
  String get rentalsDueLater => 'Due later';

  @override
  String get rentalsFromWallet => 'From your wallet';

  @override
  String get rentalsInvoiceHistory => 'Invoice history';

  @override
  String get rentalsLedger => 'Ledger';

  @override
  String get rentalsLedgerAdjustment => 'Adjustment';

  @override
  String get rentalsLedgerCharge => 'Charge';

  @override
  String get rentalsLedgerCredit => 'Credit';

  @override
  String get rentalsLedgerDeposit => 'Deposit';

  @override
  String get rentalsLedgerHint => 'Every charge, payment and credit on your account, newest first.';

  @override
  String get rentalsLedgerPayment => 'Payment';

  @override
  String get rentalsLedgerRefund => 'Refund';

  @override
  String get rentalsLedgerReversal => 'Reversal';

  @override
  String get rentalsNoInvoicesYet => 'No invoices yet';

  @override
  String get rentalsNoLedger => 'Nothing on your ledger yet';

  @override
  String get rentalsNoLedgerBody => 'Charges and payments will show up here as they happen.';

  @override
  String get rentalsNoPayments => 'No payments yet';

  @override
  String get rentalsNoPaymentsBody => 'Payments you make towards your bills will show up here.';

  @override
  String get rentalsOutstanding => 'Outstanding';

  @override
  String rentalsOverdueNotice(String amount) {
    return '$amount is overdue. Please pay it soon to keep riding without interruptions.';
  }

  @override
  String get rentalsPaid => 'Paid';

  @override
  String get rentalsPaid2 => 'Paid on';

  @override
  String get rentalsPaidSoFar => 'Paid so far';

  @override
  String get rentalsPayments => 'Payments';

  @override
  String rentalsReceiptInvoices(int count) {
    return '$count bill(s) settled';
  }

  @override
  String rentalsRefunded(String amount) {
    return '$amount refunded';
  }

  @override
  String get rentalsRentals => 'Rentals';

  @override
  String get rentalsRentHandledAutomatically => 'Rent, handled automatically';

  @override
  String get rentalsRentReceipt => 'Rent receipt';

  @override
  String get rentalsRentReceiptsWillAppearHere => 'Your rent receipts will appear here.';

  @override
  String get rentalsStatusDraft => 'Draft';

  @override
  String get rentalsStatusDue => 'Due';

  @override
  String get rentalsStatusOverdue => 'Overdue';

  @override
  String get rentalsStatusPartlyPaid => 'Part paid';

  @override
  String get rentalsStatusVoid => 'Cancelled';

  @override
  String get rentalsStillDue => 'Still due';

  @override
  String get rentalsSubtitle => 'Your plan, bills and account history';

  @override
  String get rentalsSubtotal => 'Subtotal';

  @override
  String get rentalsTapReceiptSeeFullBreakdown => 'Tap a receipt to see the full breakdown';

  @override
  String get rentalsTax => 'Tax';

  @override
  String get rentalsUnallocated => 'Payments not yet applied';

  @override
  String get rentalsYourAccount => 'Your account';

  @override
  String get reportStatusMechanicallyOk => 'Mechanically Ok';

  @override
  String get reportStatusReadyForAllotment => 'Ready for Allotment';

  @override
  String get reportStatusUnderRepairMajor => 'Under-repair: Major';

  @override
  String get reportStatusUnderRepairMinor => 'Under-repair: Minor';

  @override
  String get returnsApproveCharges => 'Approve charges';

  @override
  String returnsApproveSubtitle(String amount) {
    return 'We sent a 6-digit code to your phone. Entering it approves charges of $amount.';
  }

  @override
  String get returnsApproveTitle => 'Enter the code';

  @override
  String get returnsCancel => 'Cancel return';

  @override
  String get returnsCancelBody => 'You keep the scooter and your rental carries on as before.';

  @override
  String get returnsCancelled => 'Return cancelled';

  @override
  String get returnsCancelTitle => 'Cancel this return?';

  @override
  String get returnsCharges => 'Charges';

  @override
  String get returnsChargesApproved => 'Charges approved';

  @override
  String get returnsChargesPending => 'The hub is still inspecting the scooter. Charges, if any, will appear here.';

  @override
  String get returnsCodeExpired => 'That code has expired. Ask for a new one.';

  @override
  String get returnsCodeInvalid => 'That code didn\'t work. Check it and try again.';

  @override
  String get returnsCouldNotLoad => 'Could not load your returns';

  @override
  String get returnsCouldNotLoadHubs => 'Could not load hubs';

  @override
  String get returnsDate => 'Return date';

  @override
  String get returnsDetails => 'Details';

  @override
  String get returnsDetailTitle => 'Return';

  @override
  String get returnsDisputeCharges => 'Dispute charges';

  @override
  String get returnsDisputeReason => 'What\'s wrong?';

  @override
  String get returnsDisputeReasonRequired => 'Add a reason so the hub team can review it.';

  @override
  String get returnsDisputeSent => 'Dispute sent to the hub team';

  @override
  String get returnsDisputeSubtitle => 'Tell the hub team what is wrong with these charges.';

  @override
  String get returnsEndRentalBody =>
      'Tell us when and where you will hand it back. The hub team checks it in, and any charges come to you for approval first.';

  @override
  String get returnsEndRentalTitle => 'Done with your scooter?';

  @override
  String get returnsErrorAlreadyReceived => 'This scooter has already been received.';

  @override
  String get returnsErrorAlreadyRequested => 'A return is already requested for this rental.';

  @override
  String get returnsErrorApprovalNotPending => 'These penalties aren\'t waiting for your approval.';

  @override
  String get returnsErrorBeforeAgreement => 'The return time is before the rental started.';

  @override
  String get returnsErrorInspectFirst => 'Finish the return inspection before adding penalties.';

  @override
  String get returnsErrorNotCancellable => 'This return can no longer be cancelled.';

  @override
  String get returnsErrorNotDisputable => 'These penalties can\'t be disputed right now.';

  @override
  String get returnsErrorNotReceivable => 'This return was cancelled, so the scooter can\'t be received against it.';

  @override
  String get returnsErrorNotSubmittable => 'These penalties can\'t be submitted right now.';

  @override
  String get returnsErrorNotTerminable => 'This rental can\'t be returned right now.';

  @override
  String get returnsErrorOverrideNotAllowed => 'Rider approval can\'t be overridden at this stage.';

  @override
  String get returnsErrorPenaltiesLocked =>
      'Penalties can\'t be edited while they\'re with the rider or already charged.';

  @override
  String get returnsErrorReceiveFirst => 'Receive the scooter before adding penalties.';

  @override
  String get returnsErrorRevisePenalties => 'The rider disputed these penalties. Revise the list and submit it again.';

  @override
  String get returnsErrorStateChanged => 'These penalties just changed. Refresh and try again.';

  @override
  String get returnsErrorSubmitFirst => 'Submit the penalties before approving them.';

  @override
  String returnsEvidenceCount(int count) {
    return '$count photo(s) as evidence';
  }

  @override
  String get returnsHandedOver => 'Handed over';

  @override
  String get returnsHub => 'Return hub';

  @override
  String get returnsKindDamage => 'Damage';

  @override
  String get returnsKindMissing => 'Missing item';

  @override
  String get returnsLocationForHubs => 'We use your location to list the hubs closest to you.';

  @override
  String get returnsNextCheckIn => 'The hub team photographs the scooter and a mechanic checks it.';

  @override
  String get returnsNextConfirm =>
      'You get a code on your phone to confirm the report and any charges. Your rental ends once it\'s confirmed.';

  @override
  String get returnsNextHandOver => 'Bring the scooter, its battery and charger to the hub on the date you picked.';

  @override
  String get returnsNoCharges => 'No charges for this return.';

  @override
  String get returnsNoHubsNearby => 'No hubs found near you';

  @override
  String get returnsNone => 'No returns yet';

  @override
  String get returnsNoneBody => 'When you hand your scooter back, you can follow the return here.';

  @override
  String get returnsNoteAdminApproved =>
      'An admin approved these charges on your behalf. The hub manager confirms them next. You can still dispute them.';

  @override
  String get returnsNoteCancelled => 'You cancelled this return. Your rental carries on as before.';

  @override
  String get returnsNoteCheckInDone => 'Return closed. The submission report below shows any charges.';

  @override
  String get returnsNoteCheckingIn =>
      'The hub team is checking your scooter. When the mechanic\'s report is ready, you\'ll get a code on your phone to confirm it.';

  @override
  String get returnsNoteDisputed => 'You disputed these charges. The hub team will review them and may revise them.';

  @override
  String get returnsNoteFinalChecks =>
      'Your scooter submission is done and your rental has ended. A mechanic is doing a final check, and if it finds anything more you\'ll be asked to confirm it.';

  @override
  String get returnsNoteInspecting =>
      'The hub has your scooter and is inspecting it. Any charges will show up here for your approval.';

  @override
  String get returnsNoteNeedsYou =>
      'The hub found the charges below. Approve them with a code we send to your phone, or dispute them.';

  @override
  String get returnsNoteNoCharges => 'Return closed. The scooter came back fine, so there are no charges.';

  @override
  String returnsNoteRequested(String date) {
    return 'Take the scooter to the hub you picked on $date. The hub team will start the submission.';
  }

  @override
  String get returnsNotes => 'Anything else?';

  @override
  String returnsNoteSettled(String amount) {
    return 'Return closed. Charges of $amount were added to your bill.';
  }

  @override
  String get returnsNotesHint => 'Optional note for the hub team';

  @override
  String get returnsNoteYouApproved => 'You approved the charges. The hub manager confirms them next.';

  @override
  String get returnsNothingToReturn => 'Nothing to return right now';

  @override
  String get returnsNothingToReturnBody =>
      'You don\'t have an active rental, or a return for it is already in progress.';

  @override
  String get returnsPickDate => 'Pick a return date';

  @override
  String get returnsPickHub => 'Pick a hub';

  @override
  String get returnsPickHubSubtitle => 'Hubs closest to you are at the top';

  @override
  String get returnsPickReason => 'Choose a reason';

  @override
  String returnsPlannedFor(String date) {
    return 'Planned for $date';
  }

  @override
  String get returnsProgress => 'Progress';

  @override
  String get returnsReason => 'Reason';

  @override
  String get returnsReasonBatteryIssues => 'Battery or charging problems';

  @override
  String get returnsReasonChangingJob => 'Changing jobs';

  @override
  String get returnsReasonHealthOrFamily => 'Health or family reasons';

  @override
  String get returnsReasonLowEarnings => 'Not earning enough';

  @override
  String get returnsReasonNoLongerNeeded => 'I don\'t need it anymore';

  @override
  String get returnsReasonOwnVehicle => 'Bought my own vehicle';

  @override
  String get returnsReasonRelocating => 'Moving to another city';

  @override
  String get returnsReasonServiceIssues => 'Unhappy with the service';

  @override
  String get returnsReasonTakingBreak => 'Taking a break from work';

  @override
  String get returnsReasonTooExpensive => 'Rent is too high';

  @override
  String get returnsReasonVehicleIssues => 'Problems with the scooter';

  @override
  String get returnsRequested => 'Return requested. See you at the hub.';

  @override
  String get returnsRequestReturn => 'Request a return';

  @override
  String get returnsRequestSubtitle => 'Pick a date and the hub you will bring it to';

  @override
  String get returnsSendDispute => 'Send dispute';

  @override
  String get returnsStatusAwaitingManager => 'With the hub manager';

  @override
  String get returnsStatusCancelled => 'Cancelled';

  @override
  String get returnsStatusCheckingIn => 'Submission in progress';

  @override
  String get returnsStatusClosed => 'Closed';

  @override
  String get returnsStatusDisputed => 'Disputed';

  @override
  String get returnsStatusFinalChecks => 'Final checks';

  @override
  String get returnsStatusInspecting => 'Being inspected';

  @override
  String get returnsStatusNeedsYou => 'Your approval needed';

  @override
  String get returnsStatusRequested => 'Return requested';

  @override
  String get returnsStepCheckIn => 'Scooter submitted';

  @override
  String get returnsStepClosed => 'Return closed';

  @override
  String get returnsStepFinalChecks => 'Final mechanic check';

  @override
  String get returnsStepHandedOver => 'Scooter handed over';

  @override
  String get returnsStepInspection => 'Inspection and charges';

  @override
  String get returnsStepRequested => 'Return requested';

  @override
  String get returnsSubtitle => 'End your rental and hand the scooter back';

  @override
  String get returnsTitle => 'Return scooter';

  @override
  String get returnsWhenWhere => 'When and where';

  @override
  String get returnsWhy => 'Why are you returning it?';

  @override
  String get returnsYourDispute => 'Your dispute';

  @override
  String get returnsYourReturns => 'Your returns';

  @override
  String get rideParkedLocked => 'Parked and locked.';

  @override
  String get rideRideSafeHelmetLightsChecked => 'Ride safe. Helmet on, lights checked.';

  @override
  String get ridersActive => 'Active';

  @override
  String get ridersCall => 'Call';

  @override
  String get ridersExited => 'Exited';

  @override
  String get ridersOnboarding => 'Onboarding';

  @override
  String get ridersTeam => 'Team';

  @override
  String get rideScooterConnectedUsePowerButton => 'Your scooter is connected. Use the power button to switch it on.';

  @override
  String get rideVehicle => 'Vehicle is ON';

  @override
  String get rideVehicleOff => 'Vehicle is OFF';

  @override
  String routerNoScreenAt(String location) {
    return 'No screen at $location';
  }

  @override
  String get scooterAllowedFromHub => 'Allowed from hub';

  @override
  String get scooterBatteryCharge => 'Battery charge';

  @override
  String get scooterBatterySerial => 'Battery serial';

  @override
  String get scooterBatteryType => 'Battery type';

  @override
  String get scooterCharging => 'Charging';

  @override
  String get scooterClusterManager => 'Cluster manager';

  @override
  String get scooterControllerNumber => 'Controller number';

  @override
  String get scooterCouldNotLoadVehicle => 'Could not load your vehicle';

  @override
  String get scooterDeliveryBox => 'Delivery box';

  @override
  String get scooterHealth => 'Health';

  @override
  String get scooterHelmet => 'Helmet';

  @override
  String get scooterIdentity => 'Identity';

  @override
  String get scooterMotorNumber => 'Motor number';

  @override
  String get scooterNextService => 'Next service';

  @override
  String get scooterNoScooterHasBeenAllocated => 'No scooter has been allocated to you yet.';

  @override
  String get scooterNoScooterMessage => 'When your fleet manager assigns you a scooter, its details show up here.';

  @override
  String get scooterNoScooterTitle => 'No scooter right now';

  @override
  String get scooterOdometerService => 'Odometer and service';

  @override
  String get scooterParked => 'Parked at';

  @override
  String get scooterPowertrain => 'Powertrain';

  @override
  String get scooterRange => 'Range';

  @override
  String get scooterVehicleDetails => 'Vehicle details';

  @override
  String get scooterVehicleNumber => 'Vehicle number';

  @override
  String get scooterViewFullDetails => 'View full details';

  @override
  String get scooterWhereBelongs => 'Where it belongs';

  @override
  String get scooterWhoLooksAfter => 'Who looks after you';

  @override
  String get submissionAddDamagedItem => 'Add damaged item';

  @override
  String get submissionBypass => 'Can\'t use a code?';

  @override
  String get submissionBypassing => 'Skipping code';

  @override
  String get submissionBypassReason => 'Why can\'t they confirm with a code?';

  @override
  String submissionBypassRider(String reason) {
    return 'Rider code skipped: $reason';
  }

  @override
  String submissionBypassTeamLead(String reason) {
    return 'Team lead code skipped: $reason';
  }

  @override
  String submissionCancelledBecause(String reason) {
    return 'Cancelled: $reason';
  }

  @override
  String get submissionCancelReason => 'Reason';

  @override
  String get submissionCancelReasonNeeded => 'Enter a reason to cancel the report.';

  @override
  String get submissionCancelReport => 'Cancel report';

  @override
  String get submissionCancelReportHint => 'Say why. You can record a fresh report afterwards.';

  @override
  String get submissionCancelReportTitle => 'Cancel this report?';

  @override
  String get submissionCharges => 'Charges';

  @override
  String get submissionChassis => 'Chassis';

  @override
  String get submissionChecksComplete => 'All mechanic checks are done';

  @override
  String get submissionChooseSparePart => 'Choose the damaged part';

  @override
  String get submissionChooseSparePartHint => 'Prices come from your spare parts list.';

  @override
  String get submissionCodeNotSent => 'The code couldn\'t be sent. Try again or record why it can\'t be used.';

  @override
  String get submissionCodePending => 'No code yet';

  @override
  String get submissionCodeSent => 'Code sent';

  @override
  String submissionCodeSentTo(String phone) {
    return 'Code sent to $phone';
  }

  @override
  String get submissionCodesSent => 'Codes sent';

  @override
  String get submissionCollect => 'Collect confirmations';

  @override
  String get submissionConfirm => 'Confirm report';

  @override
  String get submissionConfirmed => 'Report confirmed';

  @override
  String get submissionConfirmHint =>
      'The rider and the team lead each get a code by SMS. Enter both codes to confirm. If someone can\'t use a code, record why.';

  @override
  String get submissionConfirmTitle => 'Confirm report';

  @override
  String get submissionCouldNotLoad => 'Couldn\'t load this submission';

  @override
  String get submissionCouldNotLoadParts => 'Couldn\'t load spare parts';

  @override
  String get submissionDamagedItems => 'Damaged items';

  @override
  String get submissionDamagedItemsHint =>
      'Add each damaged part from the spare parts list. Its price is filled in for you.';

  @override
  String get submissionEvidence => 'Proof photos';

  @override
  String get submissionEvidenceHint => 'Pick the photos that back up this report.';

  @override
  String submissionEvidenceLimit(int count) {
    return 'You can pick up to $count photos.';
  }

  @override
  String get submissionEvidenceNeeded => 'Pick at least one proof photo.';

  @override
  String get submissionExchangeStarted => 'Exchange started';

  @override
  String get submissionFindings => 'Findings';

  @override
  String get submissionImpose => 'Impose report';

  @override
  String get submissionImposeBody =>
      'Make sure the rider has seen the findings and charges. After this the report can\'t be changed, only cancelled.';

  @override
  String get submissionImposed => 'Report imposed';

  @override
  String get submissionImposeTitle => 'Impose this report?';

  @override
  String get submissionItemNote => 'Note (optional)';

  @override
  String get submissionItemNoteHint => 'Where is the damage?';

  @override
  String get submissionItemPhotoNeeded => 'Take at least one photo of this part.';

  @override
  String get submissionItemPhotoOptionalHint =>
      'A photo is optional for this part, but it helps if the rider has questions.';

  @override
  String get submissionItemPhotoRequiredHint =>
      'This part needs a photo as proof. Take a clear close-up of the damage.';

  @override
  String get submissionMaintenanceDetails => 'What needs work?';

  @override
  String get submissionMechanicName => 'Submitted by / Mechanic name';

  @override
  String get submissionNameNeeded => 'Enter the mechanic\'s name';

  @override
  String get submissionNextComplete => 'All checks are done. Nothing more to do here.';

  @override
  String get submissionNextLabel => 'Next step';

  @override
  String get submissionNextOtps => 'Collect the rider\'s and team lead\'s codes to confirm the report.';

  @override
  String submissionNextPhotos(int count) {
    return 'Photos still to take: $count. Then record the mechanic\'s report.';
  }

  @override
  String get submissionNextReport => 'All photos are in. Record the mechanic\'s report next.';

  @override
  String get submissionNextReview => 'Go through the report and any charges with the rider, then impose it.';

  @override
  String get submissionNoDamagedItems => 'No damaged items added, so the rider won\'t be charged.';

  @override
  String get submissionNoPrices => 'No penalty prices are set up yet. Ask an admin to add them on the dashboard.';

  @override
  String get submissionNoSparePartMatch => 'No part matches your search';

  @override
  String get submissionNothingToConfirm => 'Nothing to confirm';

  @override
  String get submissionNothingToConfirmBody => 'There\'s no imposed report waiting for codes on this submission.';

  @override
  String get submissionPartyRider => 'Rider';

  @override
  String get submissionPartyTeamLead => 'Team lead';

  @override
  String submissionPhotoBattery(String name) {
    return 'Battery $name';
  }

  @override
  String get submissionPhotoBatteryGeneric => 'Battery';

  @override
  String get submissionPhotoChecklist => 'Return checklist';

  @override
  String submissionPhotoController(String number) {
    return 'Controller $number';
  }

  @override
  String get submissionPhotoControllerGeneric => 'Controller';

  @override
  String get submissionPhotoDamage => 'Damage photo';

  @override
  String get submissionPhotoIot => 'IoT device';

  @override
  String get submissionPhotos => 'Required photos';

  @override
  String get submissionPhotosHint => 'Tap an empty slot to take the photo. Tap a taken photo to view it.';

  @override
  String get submissionPriceChanged =>
      'A part\'s price or photo rule just changed. Remove it and add it again from the list.';

  @override
  String get submissionQuantity => 'Quantity';

  @override
  String get submissionReceivingHub => 'Receiving hub';

  @override
  String get submissionRecordReport => 'Record mechanic report';

  @override
  String get submissionRemovePhoto => 'Remove photo';

  @override
  String submissionReportBy(String name) {
    return 'By $name';
  }

  @override
  String get submissionReportCancelled => 'Report cancelled';

  @override
  String get submissionReports => 'Mechanic reports';

  @override
  String get submissionReportSaved => 'Report saved';

  @override
  String get submissionReportSummary => 'Summary';

  @override
  String get submissionReportSummaryHint =>
      'Check the proof photos and charges before you save. Once you impose the report, the rider is asked to pay these charges.';

  @override
  String get submissionResendAll => 'Resend codes';

  @override
  String get submissionRiderNote => 'Rider\'s note';

  @override
  String get submissionSafeQuestion => 'Current scooter status';

  @override
  String get submissionSafetyNeeded => 'Choose the current scooter status';

  @override
  String get submissionsAll => 'All';

  @override
  String get submissionSaveItem => 'Save item';

  @override
  String get submissionSaveReport => 'Save report';

  @override
  String submissionScooterStatusLine(String status) {
    return 'Scooter status: $status';
  }

  @override
  String get submissionsCouldNotLoad => 'Couldn\'t load returns and exchanges';

  @override
  String get submissionsDrawerSubtitle => 'Start submissions for returned scooters';

  @override
  String submissionsDropOff(String date) {
    return 'Drop-off $date';
  }

  @override
  String get submissionsDropOffDate => 'Drop-off date';

  @override
  String get submissionSearchSpareParts => 'Search by part name or code';

  @override
  String get submissionsEmptyAll => 'Returns and exchanges for your hub show up here.';

  @override
  String get submissionsEmptyChecks => 'No submissions are in progress.';

  @override
  String get submissionsEmptyScheduled => 'No scooters are due at your hub right now.';

  @override
  String get submissionsEmptyTitle => 'Nothing here';

  @override
  String get submissionSendCodes => 'Send codes';

  @override
  String get submissionsExchanges => 'Exchanges';

  @override
  String get submissionsExchangesDue => 'Exchanges due';

  @override
  String get submissionsInChecks => 'In checks';

  @override
  String get submissionSourceExchange => 'Exchange';

  @override
  String get submissionSourceReturn => 'Return';

  @override
  String get submissionsReturns => 'Returns';

  @override
  String get submissionsReturnsDue => 'Returns due';

  @override
  String get submissionsScheduled => 'Scheduled';

  @override
  String get submissionsSubtitle => 'Start submissions for scooters that riders bring back to your hub.';

  @override
  String submissionStaffReturnBody(String rider, String vehicle) {
    return 'This starts the submission for $vehicle now. $rider\'s rental ends once the mechanic\'s report is confirmed.';
  }

  @override
  String get submissionStaffReturnTitle => 'Take this scooter back?';

  @override
  String get submissionStageCheckingIn => 'Submission in progress';

  @override
  String get submissionStageDone => 'Done';

  @override
  String get submissionStageScheduled => 'Scheduled';

  @override
  String get submissionStart => 'Start submission';

  @override
  String get submissionStartBody =>
      'Start once the rider is at the hub with the scooter. The scooter can\'t be allocated again until the submission is finished.';

  @override
  String get submissionStartBodyExchange =>
      'Start once the rider is at the hub with the scooter. The scooter can\'t be allocated again until the exchange is finished.';

  @override
  String get submissionStarted => 'Submission started';

  @override
  String get submissionStartedAt => 'Started';

  @override
  String get submissionStartExchange => 'Start exchange';

  @override
  String get submissionStartTitle => 'Start submission';

  @override
  String get submissionStatusAvailableHint => 'Safe to ride. The scooter goes back into the fleet.';

  @override
  String get submissionStatusAwaitingPartsHint =>
      'Waiting for spare parts. It can\'t be assigned until they\'re fitted.';

  @override
  String get submissionStatusBrokenHint => 'Needs a major repair. It can\'t be assigned until it\'s repaired.';

  @override
  String get submissionStatusCancelled => 'Cancelled';

  @override
  String get submissionStatusMaintenanceHint => 'Needs a repair. It can\'t be assigned until it\'s fixed.';

  @override
  String get submissionsTitle => 'Returns & exchanges';

  @override
  String get submissionSummary => 'What the mechanic found';

  @override
  String get submissionSummaryHint => 'Condition of the body, battery, controller and accessories';

  @override
  String get submissionSummaryNeeded => 'Describe what the mechanic found';

  @override
  String get submissionUseCode => 'Use a code instead';

  @override
  String get submissionVerifiedRider => 'Rider confirmed with a code';

  @override
  String get submissionVerifiedTeamLead => 'Team lead confirmed with a code';

  @override
  String get submissionVerify => 'Verify code';

  @override
  String get submissionViewPhoto => 'View photo';

  @override
  String get submissionWhatNeedsWorkNeeded => 'Describe what needs work';

  @override
  String get supportAccidentTheft => 'Accident or theft';

  @override
  String get supportAddFewMoreDetails10 => 'Add a few more details (10+ characters)';

  @override
  String get supportAll => 'All';

  @override
  String get supportBatteryCharging => 'Battery or charging';

  @override
  String get supportBreakdownRoad => 'Breakdown on the road';

  @override
  String get supportCouldNotLoadSupport => 'Could not load support';

  @override
  String get supportCouldNotLoadTicket => 'Could not load this ticket';

  @override
  String get supportDescription => 'Description';

  @override
  String get supportDeskEmpty => 'No tickets here';

  @override
  String get supportDeskEmptyBody => 'Tickets riders raise at your hubs will show up here.';

  @override
  String get supportDeskSubtitle => 'Rider tickets from your hubs';

  @override
  String get supportDeskTitle => 'Support desk';

  @override
  String get supportDocumentsKyc => 'Documents and KYC';

  @override
  String get supportHub => 'Hub';

  @override
  String get supportInProgress => 'In progress';

  @override
  String get supportMarkResolved => 'Mark resolved';

  @override
  String get supportMoreDetailGiveFasterCan => 'The more detail you give, the faster we can help';

  @override
  String get supportNeedHelpWithSomething => 'Need help with something?';

  @override
  String get supportNothingOpenRightNow => 'Nothing open right now';

  @override
  String get supportNoTicketsYet => 'No tickets yet';

  @override
  String get supportOneLineSumsUpIssue => 'One line that sums up the issue';

  @override
  String supportOpenCount(int count) {
    return '$count open';
  }

  @override
  String get supportOpenTickets => 'Open tickets';

  @override
  String get supportPaymentWallet => 'Payment or wallet';

  @override
  String get supportPdfAttachment => 'PDF document';

  @override
  String supportPhotosHint(int count) {
    return 'Add up to $count photos if they help explain the issue.';
  }

  @override
  String supportPhotosNotAttached(int count) {
    return 'Ticket raised, but $count photo(s) could not be attached. You can add them from the ticket.';
  }

  @override
  String get supportPhotosOptional => 'Photos (optional)';

  @override
  String get supportPickTopic => 'Pick a topic, or write your own subject below.';

  @override
  String supportRaisedOn(String date) {
    return 'Raised on $date';
  }

  @override
  String get supportRaiseOneAboveIfSomething => 'Raise one above if something needs attention.';

  @override
  String get supportRaiseTicket => 'Raise a ticket';

  @override
  String get supportResolveBody => 'The rider can still reply. A reply from them reopens the ticket.';

  @override
  String get supportResolved => 'Resolved';

  @override
  String get supportResolvedReplyToReopen =>
      'This ticket is resolved. Send a message if you still need help and it will reopen.';

  @override
  String get supportResolveTitle => 'Mark this ticket resolved?';

  @override
  String get supportSomethingElse => 'Something else';

  @override
  String get supportStartWorking => 'Start working';

  @override
  String get supportStatusUpdated => 'Ticket status updated';

  @override
  String get supportSubject => 'Subject';

  @override
  String get supportSubmitTicket => 'Submit ticket';

  @override
  String get supportTeam => 'Support team';

  @override
  String get supportTeamLeadSeesStraightAway => 'Your team lead sees it straight away.';

  @override
  String get supportTellUsMore => 'Tell us more';

  @override
  String get supportTellUsWhatAbout => 'Tell us what this is about';

  @override
  String get supportTellUsWhatHappenedAttach => 'Tell us what happened and attach a photo if it helps. ';

  @override
  String get supportTicket => 'Ticket';

  @override
  String get supportTicketRaised => 'Ticket raised. Our team is on it.';

  @override
  String get supportTicketReopened => 'Ticket reopened. Our team will get back to you.';

  @override
  String get supportTickets => 'Your tickets';

  @override
  String supportUpdated(String time) {
    return 'Updated $time';
  }

  @override
  String get supportWhatHappenedSinceWhen => 'What happened, and since when?';

  @override
  String get supportWhatsTheIssue => 'What\'s the issue';

  @override
  String get supportWriteMessage => 'Write a message';

  @override
  String get supportYou => 'You';

  @override
  String get swapCouldNotLoad => 'Could not load swap stations';

  @override
  String get swapNoneBody => 'We could not find any battery swap stations right now.';

  @override
  String get swapNoneTitle => 'No swap stations found';

  @override
  String get swapSubtitle => 'Swap stations closest to you';

  @override
  String get swapTitle => 'Battery swapping';

  @override
  String swapUnits(String count) {
    return 'Units: $count';
  }

  @override
  String get teamAdvisor => 'Advisor';

  @override
  String get teamBatteryExpert => 'Battery Expert';

  @override
  String get teamMotorControllerRepair => 'Motor Controller Repair';

  @override
  String get teamNotIncluded => 'Feature not included';

  @override
  String get teamNotIncludedMessage => 'This feature is not included in your current package.';

  @override
  String get teamTechnician => 'Technician';

  @override
  String get trainingCareClean => 'Keep it clean';

  @override
  String get trainingCareCleanBody => 'Maintain the scooter in clean and good condition.';

  @override
  String get trainingCareReport => 'Report issues';

  @override
  String get trainingCareReportBody =>
      'Immediately report any accident, damage, unusual noise, warning light or vehicle fault to us.';

  @override
  String get trainingCareTamper => 'No tampering';

  @override
  String get trainingCareTamperBody =>
      'Do not open, modify or tamper with the battery, motor, controller, wiring or GPS device.';

  @override
  String get trainingCareWater => 'No deep water';

  @override
  String get trainingCareWaterBody =>
      'Do not take the scooter through flooded/deep-water areas or use high-pressure water on it.';

  @override
  String get trainingChargeEquipment => 'Use approved equipment';

  @override
  String get trainingChargeEquipmentBody => 'Use only the charger/battery/accessories provided or approved by us.';

  @override
  String get trainingChargePark => 'Park responsibly';

  @override
  String get trainingChargeParkBody => 'Park securely at permitted locations and avoid water, fire or theft risks.';

  @override
  String get trainingChargeRide => 'Ride responsibly';

  @override
  String get trainingChargeRideBody => 'No overloading, unsafe riding, jumping, racing or misuse of the scooter.';

  @override
  String get trainingChargeStations => 'Charge/swap only at designated stations';

  @override
  String get trainingChargeStationsBody => 'Use only approved charging/swapping station locations.';

  @override
  String get trainingCharging => 'Charging & usage';

  @override
  String get trainingChargingSummary => 'Follow these simple guidelines for a safe, smooth and hassle-free ride.';

  @override
  String get trainingKeyPoints => 'Key points';

  @override
  String get trainingPayApp => 'Payments on app only';

  @override
  String get trainingPayAppBody =>
      'All rental, deposit and other applicable payments must be made through the official app/payment process.';

  @override
  String get trainingPayBribe => 'No bribe / unofficial payment';

  @override
  String get trainingPayBribeBody =>
      'Never pay or offer a bribe, commission or personal payment to a TL or company representative.';

  @override
  String get trainingPayCash => 'No cash payments';

  @override
  String get trainingPayCashBody => 'Do not make cash payments to any TL, staff member or representative.';

  @override
  String get trainingPayments => 'Payments & conduct';

  @override
  String get trainingPaymentsSummary =>
      'Follow these simple guidelines for safe, transparent and hassle-free transactions.';

  @override
  String get trainingPayReport => 'Report concerns';

  @override
  String get trainingPayReportBody =>
      'Report any demand for cash, bribe, unauthorised charge, misconduct or other issue directly to us.';

  @override
  String get trainingVehicleCare => 'Vehicle care';

  @override
  String get trainingVehicleCareSummary => 'Keep the scooter safe, clean and ready for every ride.';

  @override
  String get trainingViewed => 'Viewed';

  @override
  String get validationEnterDateBeforeToday => 'Enter a date on or before today';

  @override
  String get validationEnterDateLaterThanToday => 'Enter a date later than today';

  @override
  String get validationEnterValid12DigitAadhaar => 'Enter a valid 12-digit Aadhaar number';

  @override
  String get validationEnterValidEmailAddress => 'Enter a valid email address';

  @override
  String get validationEnterValidIfscCode => 'Enter a valid IFSC code';

  @override
  String get validationEnterValidPanAbcde1234f => 'Enter a valid PAN (ABCDE1234F)';

  @override
  String get validationEnterValidUpiId => 'Enter a valid UPI ID';

  @override
  String get validationField => 'This field';

  @override
  String get verifyApprove => 'Approve';

  @override
  String get verifyApproveAllFirst => 'Approve all documents to assign a vehicle.';

  @override
  String get verifyApproved => 'Approved';

  @override
  String get verifyApproveDocument => 'Approve this document?';

  @override
  String verifyApproveMessage(String name) {
    return '$name will be marked as verified. This can\'t be changed later.';
  }

  @override
  String get verifyApproveReference => 'Approve this reference?';

  @override
  String get verifyContinue => 'Continue to assign vehicle';

  @override
  String get verifyCouldNotCall => 'Couldn\'t start the call.';

  @override
  String get verifyCouldNotLoad => 'Couldn\'t load this list.';

  @override
  String get verifyDocumentApproved => 'Document approved';

  @override
  String get verifyDocumentRejected => 'Document rejected';

  @override
  String get verifyDocuments => 'Documents';

  @override
  String get verifyDocumentsHint => 'Open each document the rider uploaded, then approve or reject it.';

  @override
  String get verifyDocumentsLocked =>
      'Fleet managers can\'t review documents yet. Your admin can review them on the dashboard.';

  @override
  String get verifyNoDocuments => 'The rider hasn\'t uploaded any documents yet.';

  @override
  String get verifyNoReferences => 'The rider hasn\'t added any references.';

  @override
  String get verifyReason => 'Reason';

  @override
  String get verifyReasonHint => 'e.g. Photo is blurry';

  @override
  String get verifyReasonRequired => 'Enter a reason';

  @override
  String get verifyReferenceApproved => 'Reference approved';

  @override
  String get verifyReferenceRejected => 'Reference rejected';

  @override
  String get verifyReferences => 'References';

  @override
  String get verifyReferencesHint => 'Call each reference to confirm, then approve or reject.';

  @override
  String get verifyReject => 'Reject';

  @override
  String get verifyRejected => 'Rejected';

  @override
  String get verifyRejectSubtitle => 'Add a short reason for rejecting it.';

  @override
  String verifyRejectTitle(String name) {
    return 'Reject $name';
  }

  @override
  String verifyReviewedBy(String name) {
    return 'Reviewed by $name';
  }

  @override
  String get verifyTitle => 'Verify rider';

  @override
  String verifyUploadedOn(String date) {
    return 'Uploaded $date';
  }

  @override
  String get verifyView => 'View';

  @override
  String get walletAvailable => 'Available';

  @override
  String get walletCash => 'Cash';

  @override
  String get walletClosingBalance => 'Closing balance';

  @override
  String walletCompletedOn(String date) {
    return 'Completed $date';
  }

  @override
  String get walletCouldNotLoadDeposit => 'Could not refresh the deposit details';

  @override
  String get walletCouldNotLoadReceipt => 'Could not load the receipt';

  @override
  String get walletCouldNotLoadStatement => 'Could not load your statement';

  @override
  String get walletCouldNotLoadWallet => 'Could not load your wallet';

  @override
  String get walletCredited => 'Credited';

  @override
  String get walletCredits => 'Credits';

  @override
  String get walletDateTime => 'Date & time';

  @override
  String get walletDebits => 'Debits';

  @override
  String get walletDeducted => 'Deducted';

  @override
  String get walletDeploymentPayment => 'Deployment payment';

  @override
  String get walletDeposit => 'Deposit';

  @override
  String get walletDepositDeducted => 'Deducted';

  @override
  String get walletDepositHeld => 'Held';

  @override
  String get walletDepositLocked => 'Locked for your rental';

  @override
  String walletDepositMoved(String amount) {
    return 'Deposit $amount';
  }

  @override
  String get walletDepositPaidIn => 'Paid in';

  @override
  String get walletDepositRequired => 'Required';

  @override
  String get walletDepositReturnedAmount => 'Returned';

  @override
  String get walletDepositReturnedSeparately => 'Your deposit comes back separately when you leave.';

  @override
  String get walletDepositReturns => 'Returns';

  @override
  String get walletDepositStatusCancelled => 'Cancelled';

  @override
  String get walletDepositStatusForfeited => 'Forfeited';

  @override
  String get walletDepositStatusLocked => 'Held for your rental';

  @override
  String get walletDepositStatusPaid => 'Paid';

  @override
  String get walletDepositStatusPartlyDeducted => 'Partly deducted';

  @override
  String get walletDepositStatusPartlyPaid => 'Part paid';

  @override
  String get walletDepositStatusPending => 'Awaiting payment';

  @override
  String get walletDepositStatusReturnable => 'Ready to return';

  @override
  String get walletDepositStatusReturned => 'Returned';

  @override
  String get walletDepositStatusReturnRequested => 'Return requested';

  @override
  String get walletDepositToPay => 'Still to pay';

  @override
  String get walletDestination => 'Paid to';

  @override
  String get walletDueNow => 'Due now';

  @override
  String get walletErrorDepositNotFound => 'This deposit isn\'t available.';

  @override
  String get walletErrorNotFound => 'Your wallet isn\'t set up yet.';

  @override
  String get walletErrorReceiptNotFound => 'This receipt isn\'t available.';

  @override
  String get walletErrorStatementPeriod => 'A statement isn\'t available for that period.';

  @override
  String get walletErrorTransactionNotFound => 'This transaction isn\'t available.';

  @override
  String get walletExpiringSoon => 'Expiring in 7 days';

  @override
  String walletFundedOf(String funded, String required) {
    return '$funded of $required';
  }

  @override
  String get walletInvoicesSettled => 'Bills settled';

  @override
  String get walletIssued => 'Issued';

  @override
  String get walletKindAdjustment => 'Adjustment';

  @override
  String get walletKindDeposit => 'Security deposit';

  @override
  String get walletKindPayment => 'Payment';

  @override
  String get walletKindPenalty => 'Penalty';

  @override
  String get walletKindRefund => 'Refund';

  @override
  String get walletKindRental => 'Rent';

  @override
  String get walletKindReward => 'Reward';

  @override
  String get walletKindService => 'Service charge';

  @override
  String get walletKindTopUp => 'Money added';

  @override
  String get walletLedgerWillFillUpAs => 'Your ledger will fill up as you ride and earn.';

  @override
  String get walletMethod => 'Method';

  @override
  String get walletMoney => 'Your money';

  @override
  String get walletMoneyIn => 'Money in';

  @override
  String get walletMoneyOut => 'Money out';

  @override
  String get walletNothingMatchesFilterYet => 'Nothing matches this filter yet.';

  @override
  String get walletNoTransactionsHere => 'No transactions here';

  @override
  String get walletOnHold => 'on hold';

  @override
  String get walletOpeningBalance => 'Opening balance';

  @override
  String get walletPayments => 'Payments';

  @override
  String get walletReceipt => 'Receipt';

  @override
  String get walletReceiptNumber => 'Receipt number';

  @override
  String get walletReferenceId => 'Reference ID';

  @override
  String get walletRefundable => 'Refundable';

  @override
  String walletRequestedOn(String date) {
    return 'Requested $date';
  }

  @override
  String get walletReturnApproved => 'Approved';

  @override
  String get walletReturnCancelled => 'Cancelled';

  @override
  String get walletReturnDone => 'Returned';

  @override
  String get walletReturnFailed => 'Failed';

  @override
  String get walletReturnProcessing => 'Processing';

  @override
  String get walletReturnRejected => 'Rejected';

  @override
  String get walletReturnRequested => 'Requested';

  @override
  String get walletReturnReview => 'Under review';

  @override
  String get walletRewardExpired => 'Reward expired';

  @override
  String get walletRewardReversed => 'Reward taken back';

  @override
  String get walletRewardsEarned => 'Earned so far';

  @override
  String get walletSearchTransactions => 'Search transactions';

  @override
  String get walletSecurityDeposit => 'Security deposit';

  @override
  String get walletStateFailed => 'Failed';

  @override
  String get walletStatement => 'Statement';

  @override
  String get walletStatementEmpty => 'Nothing this month';

  @override
  String get walletStatementEmptyBody => 'Money that moves in or out of your wallet this month will show up here.';

  @override
  String walletStatementReference(String reference) {
    return 'Statement ref $reference';
  }

  @override
  String get walletStatementSubtitle => 'Month by month, with exact money in and out';

  @override
  String get walletStatementSummary => 'This month';

  @override
  String get walletStatePending => 'Pending';

  @override
  String get walletStateReversed => 'Reversed';

  @override
  String get walletStateSettled => 'Settled';

  @override
  String get walletToBank => 'To your bank account';

  @override
  String get walletToWallet => 'To your wallet';

  @override
  String get walletTransactions => 'Transactions';

  @override
  String get walletViewReceipt => 'Receipt';

  @override
  String get workPartnerEcommerce => 'E-commerce';

  @override
  String get workPartnerFoodDelivery => 'Food delivery';

  @override
  String get workPartnerOnDemandLogistics => 'On-demand logistics';

  @override
  String get workPartnerParcelLogistics => 'Parcel logistics';

  @override
  String get workPartnerPharmacy => 'Pharmacy and healthcare';

  @override
  String get workPartnerQuickCommerce => 'Quick commerce';

  @override
  String get workPartnerSpecialtyDelivery => 'Specialty delivery';

  @override
  String deploymentPayOnline(String amount) {
    return 'Pay $amount online';
  }

  @override
  String submissionPhotoItemsLimit(int count) {
    return 'Only $count damaged items can have photos. Remove one of them to add this part.';
  }

  @override
  String submissionPhotoItemsLimitHint(int count) {
    return 'Only $count damaged items can have photos, and that limit is reached. You can still save this part without a photo.';
  }

  @override
  String get profileDateOfBirth => 'Date of birth';

  @override
  String get profileAddress => 'Address';

  @override
  String get profileState => 'State';

  @override
  String get profilePinCode => 'PIN code';

  @override
  String get profileEmergencyContact => 'Emergency contact';

  @override
  String get profileCouldNotLoad => 'Could not load your profile';

  @override
  String get profileCurrentAddress => 'Current address';

  @override
  String get profilePermanentAddress => 'Permanent address';

  @override
  String get profileSameAsCurrentAddress => 'Same as current address';

  @override
  String damageChargesPaymentProcessing(String amount) {
    return 'A payment of $amount is being processed. It will show here once it\'s confirmed.';
  }

  @override
  String get damageChargesSectionToPay => 'To pay';

  @override
  String get damageChargesSectionPaid => 'Paid';

  @override
  String get deploymentHowToPay => 'How would you like to pay?';

  @override
  String get deploymentPayMethodOnline => 'Pay online';

  @override
  String get deploymentPayMethodOnlineHint => 'UPI, card or net banking. Confirmed right away.';

  @override
  String get deploymentPayMethodCash => 'Pay via cash';

  @override
  String get deploymentPayMethodCashHint => 'Pay at your hub, then add the receipt number.';

  @override
  String deploymentIHavePaid(String amount) {
    return 'I have paid $amount';
  }

  @override
  String get deploymentOnlineUnavailable => 'Online payment isn\'t available right now. Please pay via cash.';

  @override
  String get onlinePaymentDone => 'Payment done. Thank you!';

  @override
  String get onlinePaymentPending =>
      'Payment received. We\'re waiting for the bank to confirm it. Please don\'t pay again.';

  @override
  String get onlinePaymentReview =>
      'We received your payment, but it needs a quick check. Please don\'t pay again. Contact support if it doesn\'t update soon.';

  @override
  String get onlinePaymentCancelled => 'Payment cancelled';

  @override
  String get onlinePaymentFailed => 'The payment didn\'t go through. Try again.';

  @override
  String get damageChargesOnlineUnavailable => 'Online payment isn\'t available right now. Please pay at your hub.';

  @override
  String get paymentsAutoPaySetUp => 'Set up auto-debit';

  @override
  String paymentsAutoPaySetupMessage(String amount) {
    return 'Your rent is paid automatically from your UPI account on each due date, up to $amount each time. You approve it once in your UPI app and get a notice before every debit.';
  }

  @override
  String get paymentsAutoPayEmail => 'Email';

  @override
  String get paymentsAutoPayEmailHelp => 'Razorpay sends auto-debit updates to this email.';

  @override
  String get paymentsAutoPayEmailInvalid => 'Enter a valid email address.';

  @override
  String get paymentsAutoPayContinue => 'Continue to UPI app';

  @override
  String get paymentsAutoPayFinishSetup => 'Finish setup';

  @override
  String get paymentsAutoPayCheckStatus => 'Check status';

  @override
  String get paymentsAutoPayTurnedOn => 'Auto-debit is on';

  @override
  String get paymentsAutoPayStillWaiting => 'Waiting for your bank to confirm. Check again in a few minutes.';

  @override
  String get paymentsAutoPaySetupFailed => 'Auto-debit setup didn\'t go through. Please try again.';

  @override
  String get paymentsAutoPayUnavailable => 'Auto-debit setup isn\'t available right now. Please try again later.';

  @override
  String get paymentsAutoPayOpenFailed => 'Couldn\'t open the approval page. Please try again.';

  @override
  String get paymentsAutoPayTurnOff => 'Turn off auto-debit';

  @override
  String get paymentsAutoPayTurnOn => 'Turn on auto-debit';

  @override
  String get paymentsAutoPayOffNote => 'Auto-debit is turned off. Rent won\'t be taken automatically.';

  @override
  String get paymentsAutoPayPause => 'Pause auto-debit';

  @override
  String get paymentsAutoPayResume => 'Resume auto-debit';

  @override
  String get paymentsAutoPayManageInUpiApp => 'To pause or resume, use your UPI app.';

  @override
  String get paymentsAutoPayCancel => 'Cancel auto-debit';

  @override
  String get paymentsAutoPayCancelTitle => 'Cancel auto-debit?';

  @override
  String get paymentsAutoPayCancelMessage =>
      'Your rent won\'t be paid automatically any more. You can set it up again later.';

  @override
  String get paymentsAutoPayKeep => 'Keep it';

  @override
  String get paymentsAutoPayCancelled => 'Auto-debit cancelled';

  @override
  String get paymentsAutoPayCancelPending => 'Cancellation requested. Waiting for your bank to confirm.';

  @override
  String get paymentsAutoPayUpdated => 'Auto-debit updated';

  @override
  String get commonContinue => 'Continue';

  @override
  String get exchangeDeskAcceptForRider => 'Accept for the rider';

  @override
  String get exchangeDeskAcceptedForRider => 'Offer accepted for the rider';

  @override
  String get exchangeDeskApprove => 'Approve request';

  @override
  String get exchangeDeskApproved => 'Request approved';

  @override
  String get exchangeDeskAssistedHint =>
      'If the rider can\'t use the app, you can record their answer for them. Do this only with their clear consent.';

  @override
  String get exchangeDeskAssistedReason => 'Reason';

  @override
  String get exchangeDeskAssistedReasonNeeded => 'Add a reason for accepting on their behalf';

  @override
  String get exchangeDeskAssistedReasonSubtitle => 'Why is the rider not accepting in the app themselves?';

  @override
  String get exchangeDeskChangeScooter => 'Change scooter';

  @override
  String get exchangeDeskChooseScooter => 'Choose replacement scooter';

  @override
  String get exchangeDeskComplete => 'Complete exchange';

  @override
  String get exchangeDeskConfirmReturn => 'Confirm scooter returned';

  @override
  String get exchangeDeskConsentNeeded => 'Add how the rider gave consent';

  @override
  String get exchangeDeskConsentReference => 'Consent reference';

  @override
  String get exchangeDeskConsentSubtitle =>
      'How did the rider agree? For example a signed form number or a recorded call.';

  @override
  String get exchangeDeskDeclineForRider => 'Rider declined';

  @override
  String get exchangeDeskDeclineSubtitle => 'Record why the rider turned the offer down.';

  @override
  String get exchangeDeskDeclinedForRider => 'Offer declined for the rider';

  @override
  String exchangeDeskDepositBreakdown(String total, String newDeposit, String shortfall) {
    return '$total is still due: $newDeposit for the new scooter and $shortfall to top up the rider\'s security deposit.';
  }

  @override
  String exchangeDeskDepositDue(String amount) {
    return 'The rider still has to pay $amount more deposit.';
  }

  @override
  String get exchangeDeskDepositsSettled => 'Deposits settled';

  @override
  String get exchangeDeskEmptyBody => 'When a rider asks for a different scooter, the request shows up here.';

  @override
  String get exchangeDeskExchangeCompleted => 'Exchange completed';

  @override
  String get exchangeDeskGuideChoose => 'The old scooter is back. Choose a replacement scooter for the rider.';

  @override
  String get exchangeDeskGuideDeposits => 'The rider accepted. Settle the deposits to move on to the handover.';

  @override
  String get exchangeDeskGuideReview => 'Check the request, then approve or reject it.';

  @override
  String get exchangeDeskGuideSendOffer => 'Check the offer below and send it to the rider.';

  @override
  String get exchangeDeskGuideStartHandover => 'Deposits are settled. Start the handover of the new scooter.';

  @override
  String get exchangeDeskHandoverHint =>
      'Hand over the new scooter in the allocation steps. Once it\'s active with the rider, complete the exchange.';

  @override
  String get exchangeDeskHandoverStarted => 'Handover started';

  @override
  String get exchangeDeskNeedsAction => 'Needs action';

  @override
  String get exchangeDeskNoScooters => 'No scooters are available right now.';

  @override
  String get exchangeDeskOfferPreview => 'Offer preview';

  @override
  String get exchangeDeskOfferSent => 'Offer sent to rider';

  @override
  String get exchangeDeskOpenAllocation => 'Open the new allocation';

  @override
  String get exchangeDeskReject => 'Reject request';

  @override
  String get exchangeDeskRejectSubtitle => 'Tell the rider why this can\'t be approved.';

  @override
  String get exchangeDeskRejectedDone => 'Request rejected';

  @override
  String get exchangeDeskReplacement => 'Replacement scooter';

  @override
  String get exchangeDeskReserveScooter => 'Reserve this scooter';

  @override
  String exchangeDeskReservedUntil(String time) {
    return 'Until $time';
  }

  @override
  String get exchangeDeskReturnConfirmed => 'Return confirmed';

  @override
  String get exchangeDeskReturnHint =>
      'Finish the return in Returns: verify the rider\'s OTP and complete the inspection. Then confirm it here.';

  @override
  String get exchangeDeskRiderNote => 'Rider\'s note';

  @override
  String get exchangeDeskScooterReserved => 'Scooter reserved';

  @override
  String get exchangeDeskSendOffer => 'Send offer to rider';

  @override
  String get exchangeDeskSettleDeposits => 'Settle deposits';

  @override
  String get exchangeDeskStartHandover => 'Start handover';

  @override
  String get exchangeDeskStatusOfferSent => 'Offer sent';

  @override
  String get exchangeDeskStatusReserved => 'Scooter reserved';

  @override
  String get exchangeDeskSubtitle => 'Riders asking for a different scooter';

  @override
  String get exchangeDeskWaitingRider => 'Offer sent. Waiting for the rider to accept it in their app.';

  @override
  String get exchangeDeskWithRider => 'Waiting for rider';

  @override
  String get exchangeReadTerms => 'Read the terms';

  @override
  String get exchangeDeskCheckIn => 'Check in old scooter';

  @override
  String get exchangeDeskOpenCheckIn => 'Open check-in';

  @override
  String get exchangeDeskCheckInStarted => 'Check-in started';

  @override
  String get exchangeDeskGuideCheckIn =>
      'When the rider brings the scooter to the hub, check it in. If the request isn\'t valid, reject it.';

  @override
  String get exchangeDeskCheckInHint =>
      'The old scooter check-in is open. Finish the photos, the report and both OTP confirmations, then choose the replacement here.';

  @override
  String get exchangeDeskCompletedBody => 'The rider has the new scooter and their agreement now shows it.';

  @override
  String get exchangeDeskClosedBody => 'This request is closed. No more steps are needed.';

  @override
  String get exchangeDeskAcceptedPlan => 'Accepted plan';

  @override
  String exchangeDeskForRider(String name) {
    return 'For $name';
  }

  @override
  String exchangeDeskScootersReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scooters ready in your hubs',
      one: '1 scooter ready in your hubs',
    );
    return '$_temp0';
  }
}
