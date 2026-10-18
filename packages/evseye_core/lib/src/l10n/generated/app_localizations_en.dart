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
  String get allocationAssignVehicle => 'Assign a vehicle';

  @override
  String get allocationBack => 'Back';

  @override
  String get allocationBackDesk => 'Back to the desk';

  @override
  String get allocationBatteryChargeCharger => 'Battery charge and charger';

  @override
  String get allocationBodyPaintwork => 'Body and paintwork';

  @override
  String get allocationChangePlan => 'Change plan';

  @override
  String get allocationChecklistRiderWillAcceptItem => 'The checklist the rider will accept item by item';

  @override
  String get allocationChecklistTapToggleMandatory => 'Checklist · tap to toggle mandatory';

  @override
  String get allocationChoosePlan => 'Choose rental plan';

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
  String get allocationConfirmsPhotos => 'Confirms the vehicle\'s photos are on file.';

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
  String get allocationDeAllocateVehicle => 'De-allocate vehicle';

  @override
  String get allocationDeployed => 'Deployed';

  @override
  String get allocationEveryOnboardedRiderHubsHas =>
      'Every onboarded rider in your hubs has a vehicle or a handover under way.';

  @override
  String get allocationFleetCode => 'Fleet code';

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
  String get allocationHelmetHandedOver => 'Helmet handed over';

  @override
  String get allocationHintWorkPartner => 'e.g. Sharma Auto Works';

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
  String get allocationInspectionTraining => 'Inspection and training';

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
  String get allocationNameWorkPartnerWorkshopInspected =>
      'Name the work partner or workshop that inspected the vehicle';

  @override
  String get allocationNoBatteryPlan => 'No battery plan';

  @override
  String get allocationNobodyWaiting => 'Nobody waiting';

  @override
  String get allocationNoHandoversProgress => 'No handovers in progress';

  @override
  String get allocationNothingCurrentlyAllocatedRider => 'Nothing is currently allocated to a rider.';

  @override
  String get allocationNoVehiclesOut => 'No vehicles out';

  @override
  String get allocationNoVehiclesReady => 'No vehicles ready';

  @override
  String get allocationNumber => 'Number';

  @override
  String get allocationPaymentReceived => 'Payment received?';

  @override
  String get allocationPaymentRequested => 'Payment requested';

  @override
  String get allocationPaymentRequestedAmount => 'Payment requested';

  @override
  String get allocationPaymentRequestedRiderSeesNow => 'Payment requested — the rider sees it now';

  @override
  String get allocationPaymentVerified => 'Payment verified';

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
  String get allocationRaiseDepositFeesRiderPays =>
      'You choose the rental plan; the rider accepts it, pays and submits the reference; you verify it.';

  @override
  String get allocationReason => 'Reason';

  @override
  String get allocationRequestVehicle => 'Request the vehicle';

  @override
  String get allocationReserved => 'Reserved';

  @override
  String get allocationReserved2 => 'Reserved on';

  @override
  String get allocationRider => 'Rider';

  @override
  String get allocationRiderCode => 'Rider code';

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
  String get allocationSendPaymentRequest => 'Send payment request';

  @override
  String get allocationSendRider => 'Send to rider';

  @override
  String get allocationStartReturn => 'Start a return';

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
  String get allocationWhatWasAllocated => 'What was allocated';

  @override
  String get allocationWorkPartner => 'Work partner';

  @override
  String get allocationWorkshopTechnicianWhoInspectedVehicle => 'The workshop or technician who inspected the vehicle';

  @override
  String get allocationWritePdiChecklistRiderAccepts =>
      'You write the PDI checklist; the rider accepts it and completes training.';

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
  String get checkInCouldNotLoad => 'Couldn\'t load the check-in.';

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
  String get checkInTitle => 'Scooter check-in';

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
  String get commonInsurance => 'Insurance';

  @override
  String get commonIotUnit => 'IoT unit';

  @override
  String get commonJpgPngPdfUp5 => 'JPG, PNG or PDF · up to 5 MB';

  @override
  String get commonKmLeft => 'km left';

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
  String get commonOffline => 'Offline';

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
  String get commonWeek => 'This week';

  @override
  String get commonWeeklyPlan => 'Weekly plan';

  @override
  String get commonWhatHappensNext => 'What happens next';

  @override
  String get commonWillNeedMobileNumberOtp => 'You will need your mobile number and an OTP to sign back in.';

  @override
  String get commonYesterdayGlance => 'Yesterday at a glance';

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
  String get consentRiderTitle => 'Rider Consent';

  @override
  String get consentSubtitle =>
      'Please read how we collect and use your information, then give your consent to continue.';

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
  String get deploymentBankTransfer => 'Bank transfer';

  @override
  String get deploymentCard => 'Card';

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
  String get deploymentFleetManagerChecksAgainstWhat => 'Your fleet manager checks this against what they received.';

  @override
  String get deploymentFleetManagerHasNotAsked => 'Your fleet manager has not asked for a payment yet.';

  @override
  String get deploymentFleetManagerHasNotSubmitted => 'Your fleet manager has not submitted the inspection yet.';

  @override
  String get deploymentFleetManagerPreparingVehicleIts =>
      'Your fleet manager is preparing the vehicle and its IoT unit. Your payment details appear here as soon as they are ready.';

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
  String get deploymentHowDidPay => 'How did you pay?';

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
  String get deploymentPaymentSubmitted => 'Payment submitted';

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
  String get deploymentReference => 'Reference';

  @override
  String get deploymentReferenceReceiptNumber => 'Reference or receipt number';

  @override
  String get deploymentReferenceSubmitted => 'Reference submitted';

  @override
  String get deploymentReferenceSubmittedWaitingVerification => 'Reference submitted — waiting for verification';

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
  String get deploymentUpiTransactionIdEG => 'UPI transaction ID, e.g. 4284 7192 3456';

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
  String get earningsAchieved => 'Achieved';

  @override
  String get earningsActiveSchemes => 'Active schemes';

  @override
  String get earningsAlreadyClearedCredited => 'Already cleared and credited';

  @override
  String get earningsBonusesCanStillClearWeek => 'Bonuses you can still clear this week';

  @override
  String get earningsCancelledTripsDoNotCount => 'Cancelled trips do not count. Credited by midnight.';

  @override
  String get earningsCheckBackTomorrowNewIncentives => 'Check back tomorrow for new incentives.';

  @override
  String get earningsCleared => 'Cleared';

  @override
  String get earningsClearSchemeWeekLandsWallet => 'Clear a scheme this week and it lands in your wallet instantly';

  @override
  String get earningsComplete20TripsToday => 'Complete 20 trips today';

  @override
  String get earningsCompletedRewardCreditedWallet => 'Completed — reward credited to your wallet.';

  @override
  String get earningsCouldNotLoadIncentives => 'Could not load your incentives';

  @override
  String get earningsCover400KmWeek => 'Cover 400 km this week';

  @override
  String get earningsDaily => 'Daily';

  @override
  String get earningsDailyTripTarget => 'Daily trip target';

  @override
  String get earningsEarnedWeek => 'Earned this week';

  @override
  String get earningsEveningSurge => 'Evening surge';

  @override
  String get earningsMeasuredByVehicleOdometerNot => 'Measured by the vehicle odometer, not the app.';

  @override
  String get earningsMonthly => 'Monthly';

  @override
  String get earningsNoActiveSchemesRightNow => 'No active schemes right now';

  @override
  String get earningsOneClearedSchemeSoAchieved => 'One cleared scheme, so the achieved state is on screen.';

  @override
  String get earningsPerfectWeek => 'Perfect week';

  @override
  String get earningsReferralCompletes20Trips => 'Your referral completes 20 trips';

  @override
  String get earningsReferRider => 'Refer a rider';

  @override
  String get earningsRideBetween6Pm9 => 'Ride between 6 pm and 9 pm in Okhla';

  @override
  String get earningsSixDaysPresentWithNo => 'Six days present with no late returns';

  @override
  String get earningsTerms => 'Terms';

  @override
  String get earningsTermsConditions => 'Terms & conditions';

  @override
  String get earningsTurnExtraTripsIntoExtra => 'Turn extra trips into extra pay';

  @override
  String get earningsWeekly => 'Weekly';

  @override
  String get earningsWeeklyDistance => 'Weekly distance';

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
  String get exchangeConsent => 'I have read and agree to the updated terms';

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
    return 'Bring your current scooter to the hub you picked on $date. The hub team will check it in.';
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
  String get exchangeReadTerms => 'Read the terms';

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
  String get exchangeStatusCheckingIn => 'Checking in';

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
  String get fleetStatusAllocated => 'Allocated';

  @override
  String get fleetStatusAllocating => 'Being allocated';

  @override
  String get fleetStatusAvailable => 'Available';

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
  String get homeBonusUnlocked => 'Bonus unlocked';

  @override
  String get homeBookSlotOkhlaHubBefore => 'Book a slot at the Okhla hub before the odometer hits 8,000 km.';

  @override
  String get homeCategory => 'Category';

  @override
  String get homeCouldNotLoadDashboard => 'Could not load your dashboard';

  @override
  String get homeDailyRental => 'Daily Rental';

  @override
  String get homeDepositsHandoverFees => 'Deposits and handover fees';

  @override
  String get homeExtra15TripOkhlaPhase => 'Extra ₹15 a trip in Okhla Phase II and Jasola this evening.';

  @override
  String get homeHelpSupport => 'Help & support';

  @override
  String get homeHistory => 'History';

  @override
  String get homeIncentiveEarned => 'Incentive earned';

  @override
  String get homeMarkAbsent => 'Mark absent';

  @override
  String get homeMarkAttendanceStartScooter => 'Mark attendance to start the scooter';

  @override
  String get homeMarkedAbsentScooterNowDisabled => 'Marked absent. The scooter is now disabled.';

  @override
  String get homeMarkedPresent => 'Marked present';

  @override
  String get homeMarkYourselfAbsent => 'Mark yourself absent?';

  @override
  String get homeMarkYourselfPresentSwitchVehicle => 'Mark yourself present to switch the vehicle on.';

  @override
  String get homeMonSun => 'Mon – Sun';

  @override
  String get homeNotMarkedPresent => 'Not marked present';

  @override
  String get homeOnline => 'Online';

  @override
  String get homePersonalDetailsKyc => 'Personal details and KYC';

  @override
  String get homeRent => 'Rent';

  @override
  String get homeRentDue => 'Rent due';

  @override
  String get homeScooter => 'Scooter';

  @override
  String get homeServiceDue240Km => 'Service due in 240 km';

  @override
  String get homeShiftWillEndScooterWill =>
      'Your shift will end and the scooter will switch off. Rent still applies on weekly and monthly plans.';

  @override
  String get homeSurgeOkhlaTill9Pm => 'Surge in Okhla till 9 pm';

  @override
  String get homeTodaysEarnings => 'Today\'s earnings';

  @override
  String get homeVehicle => 'Vehicle on';

  @override
  String get homeVehicleOff => 'Vehicle off';

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
  String get hubBaysFree => 'Bays free';

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
  String get hubFleetManager => 'Fleet Manager';

  @override
  String get hubFleetUtilisation => 'Fleet utilisation';

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
  String get hubShift => 'On shift';

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
      'Returns and exchanges due at this hub whose vehicle check-in isn\'t complete yet.';

  @override
  String get hubUnderMaintenanceFleet => 'Under Maintenance Fleet';

  @override
  String get hubUnderMaintenanceFleetInfo => 'Vehicles from this hub that are under maintenance right now.';

  @override
  String get hubUptime => 'Uptime';

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
  String get maintenanceAwaitingReport => 'No report yet';

  @override
  String get maintenanceBandHint => 'Scooters at your hubs that are in for service, with their latest mechanic report.';

  @override
  String get maintenanceBattery => 'Battery';

  @override
  String get maintenanceCategory => 'Category';

  @override
  String get maintenanceChassis => 'Chassis number';

  @override
  String get maintenanceChecksOpen => 'Some mechanic checks are still open';

  @override
  String get maintenanceColour => 'Colour';

  @override
  String maintenanceConfirmedOn(String date) {
    return 'Confirmed $date';
  }

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
  String maintenancePhotoCount(int count) {
    return 'Photos attached: $count';
  }

  @override
  String get maintenanceProgress => 'In progress';

  @override
  String maintenanceReportsLimit(int limit) {
    return 'Showing the latest $limit reports.';
  }

  @override
  String get maintenanceSafeToReuse => 'Safe to reuse';

  @override
  String get maintenanceSearchHint => 'Search vehicle number, fleet code, chassis or model';

  @override
  String get maintenanceSelectVehicle => 'Select a vehicle';

  @override
  String maintenanceShowing(int shown, int total) {
    return 'Showing $shown of $total';
  }

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
  String get paymentsCouldNotLoad => 'Could not load payments';

  @override
  String get paymentsDueOn => 'Due on';

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
  String pdiInspectedBy(String partner) {
    return 'Inspected by $partner';
  }

  @override
  String get planAccept => 'Accept plan';

  @override
  String get planBatteryDeposit => 'Battery security deposit';

  @override
  String get planConsent => 'I have read this plan and its terms, and I agree to them';

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
  String get planTermsTitle => 'Plan terms';

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
  String get profileAddressHub => 'Address & hub';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileHub => 'Hub';

  @override
  String get profileHubCode => 'Hub code';

  @override
  String get profileJoined => 'Joined on';

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
  String get referTerms => 'Terms & conditions';

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
  String get returnsNoteCheckInDone => 'Return closed. The check-in report below shows any charges.';

  @override
  String get returnsNoteCheckingIn =>
      'The hub team is checking your scooter. When the mechanic\'s report is ready, you\'ll get a code on your phone to confirm it.';

  @override
  String get returnsNoteDisputed => 'You disputed these charges. The hub team will review them and may revise them.';

  @override
  String get returnsNoteFinalChecks =>
      'Your scooter is checked in and your rental has ended. A mechanic is doing a final check, and if it finds anything more you\'ll be asked to confirm it.';

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
    return 'Take the scooter to the hub you picked on $date. The hub team will check it in.';
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
  String get returnsStatusCheckingIn => 'Checking in';

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
  String get returnsStepCheckIn => 'Scooter checked in';

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
  String get ridersAllocations => 'Allocations';

  @override
  String get ridersAwaitingAllocation => 'Awaiting allocation';

  @override
  String get ridersCall => 'Call';

  @override
  String get ridersCouldNotLoadTeam => 'Could not load the team';

  @override
  String get ridersExited => 'Exited';

  @override
  String get ridersExitReason => 'Exit reason';

  @override
  String get ridersJoined => 'Joined';

  @override
  String get ridersKycStatus => 'KYC status';

  @override
  String get ridersNobodyMatchesSearchList => 'Nobody matches this search in this list.';

  @override
  String get ridersNoRidersHere => 'No riders here';

  @override
  String get ridersOnboarding => 'Onboarding';

  @override
  String get ridersPlan => 'Plan';

  @override
  String get ridersRidersRoster => 'Riders on the roster';

  @override
  String get ridersSearchNameCodeVehicle => 'Search name, code or vehicle';

  @override
  String get ridersTeam => 'Team';

  @override
  String get ridersVerified => 'Verified';

  @override
  String get ridersWithHubSince => 'With the hub since';

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
  String get scooterCharger => 'Charger';

  @override
  String get scooterCharging => 'Charging';

  @override
  String get scooterClusterManager => 'Cluster manager';

  @override
  String get scooterCommercialPermit => 'Commercial permit';

  @override
  String get scooterControllerNumber => 'Controller number';

  @override
  String get scooterCouldNotLoadVehicle => 'Could not load your vehicle';

  @override
  String get scooterDeliveryBox => 'Delivery box';

  @override
  String get scooterFitnessCertificate => 'Fitness certificate';

  @override
  String get scooterHealth => 'Health';

  @override
  String get scooterHelmet => 'Helmet';

  @override
  String get scooterIdentity => 'Identity';

  @override
  String get scooterIotOffline => 'IoT offline';

  @override
  String get scooterIotOnline => 'IoT online';

  @override
  String get scooterMotorNumber => 'Motor number';

  @override
  String get scooterNextService => 'Next service';

  @override
  String get scooterNoScooterHasBeenAllocated => 'No scooter has been allocated to you yet.';

  @override
  String get scooterOdometerService => 'Odometer and service';

  @override
  String get scooterParked => 'Parked at';

  @override
  String get scooterPhoneMount => 'Phone mount';

  @override
  String get scooterPowertrain => 'Powertrain';

  @override
  String get scooterRange => 'Range';

  @override
  String get scooterRegistrationCertificate => 'Registration certificate';

  @override
  String get scooterToolkit => 'Toolkit';

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
  String get submissionAddCharge => 'Add charge';

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
  String get submissionChargeDetails => 'Details';

  @override
  String get submissionChargeDetailsHint => 'Where is the damage, or what is missing?';

  @override
  String get submissionChargeEvidenceNeeded => 'Pick at least one photo as proof for this charge.';

  @override
  String get submissionCharges => 'Charges';

  @override
  String get submissionChargesHint =>
      'Add a charge for each damaged or missing item. Leave it empty if there\'s nothing to charge.';

  @override
  String get submissionChassis => 'Chassis';

  @override
  String get submissionChecklistNeeded => 'Missing items need the return checklist photo as proof.';

  @override
  String get submissionChecksComplete => 'All mechanic checks are done';

  @override
  String get submissionChecksCompleteConfirm =>
      'This closes the mechanic checks for this scooter. You won\'t be able to add more reports.';

  @override
  String get submissionChecksCompleteHint =>
      'Turn on only when no more checks are needed. No more reports can be added after this.';

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
  String get submissionCouldNotLoad => 'Couldn\'t load this check-in';

  @override
  String get submissionDetailsNeeded => 'Add details for this charge.';

  @override
  String get submissionEditCharge => 'Edit charge';

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
  String get submissionExtraPhotos => 'Damage & extra photos';

  @override
  String get submissionExtraPhotosHint => 'Add close-ups of any damage. You can attach them to charges in the report.';

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
  String get submissionMechanicName => 'Mechanic name';

  @override
  String get submissionNameNeeded => 'Enter the mechanic\'s name';

  @override
  String get submissionNextComplete => 'All checks are done. Nothing more to do here.';

  @override
  String get submissionNextDeep => 'The scooter is checked in. Record the final mechanic check when it\'s done.';

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
  String get submissionNoPhotosYet => 'No photos yet. Take them on the check-in screen first.';

  @override
  String get submissionNoPrices => 'No penalty prices are set up yet. Ask an admin to add them on the dashboard.';

  @override
  String get submissionNothingToConfirm => 'Nothing to confirm';

  @override
  String get submissionNothingToConfirmBody => 'There\'s no imposed report waiting for codes on this check-in.';

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
  String get submissionPickCharge => 'Pick a charge';

  @override
  String get submissionQuantity => 'Quantity';

  @override
  String get submissionReceivingHub => 'Receiving hub';

  @override
  String get submissionRecordFinal => 'Record final check';

  @override
  String get submissionRecordReport => 'Record mechanic report';

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
  String get submissionResendAll => 'Resend codes';

  @override
  String get submissionRiderNote => 'Rider\'s note';

  @override
  String get submissionSafeNo => 'No, it needs work';

  @override
  String get submissionSafeNoHint => 'It stays in maintenance after the checks.';

  @override
  String get submissionSafeQuestion => 'Safe to use again?';

  @override
  String get submissionSafetyNeeded => 'Choose whether it\'s safe to use again';

  @override
  String get submissionSafeYes => 'Yes, it\'s safe';

  @override
  String get submissionSafeYesHint => 'It can go back into the fleet once the checks are done.';

  @override
  String get submissionsAll => 'All';

  @override
  String get submissionSaveCharge => 'Save charge';

  @override
  String get submissionSaveReport => 'Save report';

  @override
  String get submissionsCouldNotLoad => 'Couldn\'t load returns and exchanges';

  @override
  String get submissionsDrawerSubtitle => 'Check in returned scooters';

  @override
  String submissionsDropOff(String date) {
    return 'Drop-off $date';
  }

  @override
  String get submissionsDropOffDate => 'Drop-off date';

  @override
  String get submissionsEmptyAll => 'Returns and exchanges for your hub show up here.';

  @override
  String get submissionsEmptyChecks => 'No check-ins are in progress.';

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
  String get submissionsSubtitle => 'Check in scooters that riders bring back to your hub.';

  @override
  String submissionStaffReturnBody(String rider, String vehicle) {
    return 'This starts the check-in for $vehicle now. $rider\'s rental ends once the mechanic\'s report is confirmed.';
  }

  @override
  String get submissionStaffReturnTitle => 'Take this scooter back?';

  @override
  String get submissionStageCheckingIn => 'Checking in';

  @override
  String get submissionStageDone => 'Done';

  @override
  String get submissionStageFinalChecks => 'Final checks';

  @override
  String get submissionStageScheduled => 'Scheduled';

  @override
  String get submissionStart => 'Start check-in';

  @override
  String get submissionStartBody =>
      'Start once the rider is at the hub with the scooter. The scooter can\'t be allocated again until the check-in is finished.';

  @override
  String get submissionStarted => 'Check-in started';

  @override
  String get submissionStartedAt => 'Started';

  @override
  String get submissionStartTitle => 'Start check-in';

  @override
  String get submissionStatusCancelled => 'Cancelled';

  @override
  String get submissionsTitle => 'Returns & exchanges';

  @override
  String get submissionSummary => 'What the mechanic found';

  @override
  String get submissionSummaryHint => 'Condition of the body, battery, controller and accessories';

  @override
  String get submissionSummaryNeeded => 'Describe what the mechanic found';

  @override
  String get submissionUnsafeReason => 'Why isn\'t it safe?';

  @override
  String get submissionUnsafeReasonNeeded => 'Say why it isn\'t safe';

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
  String get teamHubTeam => 'Hub team';

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
}
