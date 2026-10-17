import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('hi'), Locale('kn'), Locale('te')];

  /// Add an item
  ///
  /// In en, this message translates to:
  /// **'Add an item'**
  String get allocationAddItem;

  /// Add at least one item
  ///
  /// In en, this message translates to:
  /// **'Add at least one item'**
  String get allocationAddLeastOneItem;

  /// Add at least one line
  ///
  /// In en, this message translates to:
  /// **'Add at least one line'**
  String get allocationAddLeastOneLine;

  /// Add a line
  ///
  /// In en, this message translates to:
  /// **'Add a line'**
  String get allocationAddLine;

  /// All hubs
  ///
  /// In en, this message translates to:
  /// **'All hubs'**
  String get allocationAllHubs;

  /// Allocate vehicle
  ///
  /// In en, this message translates to:
  /// **'Allocate vehicle'**
  String get allocationAllocateVehicle;

  /// Allocate a vehicle to a waiting rider to start one.
  ///
  /// In en, this message translates to:
  /// **'Allocate a vehicle to a waiting rider to start one.'**
  String get allocationAllocateVehicleWaitingRiderStart;

  /// Amount
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get allocationAmount;

  /// Ask for payment
  ///
  /// In en, this message translates to:
  /// **'Ask for payment'**
  String get allocationAskPayment;

  /// Assign
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get allocationAssign;

  /// Assign a vehicle
  ///
  /// In en, this message translates to:
  /// **'Assign a vehicle'**
  String get allocationAssignVehicle;

  /// Back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get allocationBack;

  /// Back to the desk
  ///
  /// In en, this message translates to:
  /// **'Back to the desk'**
  String get allocationBackDesk;

  /// Battery charge and charger
  ///
  /// In en, this message translates to:
  /// **'Battery charge and charger'**
  String get allocationBatteryChargeCharger;

  /// Body and paintwork
  ///
  /// In en, this message translates to:
  /// **'Body and paintwork'**
  String get allocationBodyPaintwork;

  /// The checklist the rider will accept item by item
  ///
  /// In en, this message translates to:
  /// **'The checklist the rider will accept item by item'**
  String get allocationChecklistRiderWillAcceptItem;

  /// Checklist · tap to toggle mandatory
  ///
  /// In en, this message translates to:
  /// **'Checklist · tap to toggle mandatory'**
  String get allocationChecklistTapToggleMandatory;

  /// Complete.
  ///
  /// In en, this message translates to:
  /// **'Complete.'**
  String get allocationComplete2;

  /// Confirm you have received the amount the rider submitted a reference for. This cannot be undone.
  ///
  /// In en, this message translates to:
  /// **'Confirm you have received the amount the rider submitted a reference for. This cannot be undone.'**
  String get allocationConfirmHaveReceivedAmountRider;

  /// Confirms the vehicle's photos are on file.
  ///
  /// In en, this message translates to:
  /// **'Confirms the vehicle\'s photos are on file.'**
  String get allocationConfirmsPhotos;

  /// Continue the handover
  ///
  /// In en, this message translates to:
  /// **'Continue the handover'**
  String get allocationContinueHandover;

  /// Could not allocate the vehicle
  ///
  /// In en, this message translates to:
  /// **'Could not allocate the vehicle'**
  String get allocationCouldNotAllocateVehicle;

  /// Could not load allocations
  ///
  /// In en, this message translates to:
  /// **'Could not load allocations'**
  String get allocationCouldNotLoadAllocations;

  /// Could not load available vehicles
  ///
  /// In en, this message translates to:
  /// **'Could not load available vehicles'**
  String get allocationCouldNotLoadAvailableVehicles;

  /// Could not load this handover
  ///
  /// In en, this message translates to:
  /// **'Could not load this handover'**
  String get allocationCouldNotLoadHandover;

  /// De-allocate vehicle
  ///
  /// In en, this message translates to:
  /// **'De-allocate vehicle'**
  String get allocationDeAllocateVehicle;

  /// Deployed
  ///
  /// In en, this message translates to:
  /// **'Deployed'**
  String get allocationDeployed;

  /// Every line needs a label and an amount above zero
  ///
  /// In en, this message translates to:
  /// **'Every line needs a label and an amount above zero'**
  String get allocationEveryLineNeedsLabelAmount;

  /// Every onboarded rider in your hubs has a vehicle or a handover under way.
  ///
  /// In en, this message translates to:
  /// **'Every onboarded rider in your hubs has a vehicle or a handover under way.'**
  String get allocationEveryOnboardedRiderHubsHas;

  /// Fleet code
  ///
  /// In en, this message translates to:
  /// **'Fleet code'**
  String get allocationFleetCode;

  /// Scooter assignment is done with the hub's fleet manager login.
  ///
  /// In en, this message translates to:
  /// **'Scooter assignment is done with the hub\'s fleet manager login.'**
  String get allocationFleetOnlyBody;

  /// Not available for this login
  ///
  /// In en, this message translates to:
  /// **'Not available for this login'**
  String get allocationFleetOnlyTitle;

  /// Front
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get allocationFront;

  /// Training is done and the scooter is with the rider. This handover is complete.
  ///
  /// In en, this message translates to:
  /// **'Training is done and the scooter is with the rider. This handover is complete.'**
  String get allocationHandoverCompleteMessage;

  /// Helmet handed over
  ///
  /// In en, this message translates to:
  /// **'Helmet handed over'**
  String get allocationHelmetHandedOver;

  /// e.g. Sharma Auto Works
  ///
  /// In en, this message translates to:
  /// **'e.g. Sharma Auto Works'**
  String get allocationHintWorkPartner;

  /// Horn and mirrors
  ///
  /// In en, this message translates to:
  /// **'Horn and mirrors'**
  String get allocationHornMirrors;

  /// Idle
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get allocationIdle;

  /// Inspection accepted · training
  ///
  /// In en, this message translates to:
  /// **'Inspection accepted · training'**
  String get allocationInspectionAcceptedTraining;

  /// Inspection sent to rider
  ///
  /// In en, this message translates to:
  /// **'Inspection sent to rider'**
  String get allocationInspectionSentRider;

  /// Inspection sent to the rider
  ///
  /// In en, this message translates to:
  /// **'Inspection sent to the rider'**
  String get allocationInspectionSentRider2;

  /// Inspection and training
  ///
  /// In en, this message translates to:
  /// **'Inspection and training'**
  String get allocationInspectionTraining;

  /// Item
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get allocationItem;

  /// Left side
  ///
  /// In en, this message translates to:
  /// **'Left side'**
  String get allocationLeftSide;

  /// Lights and indicators
  ///
  /// In en, this message translates to:
  /// **'Lights and indicators'**
  String get allocationLightsIndicators;

  /// Mark as paid
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get allocationMarkAsPaid;

  /// Match a waiting rider with a vehicle, then walk the handover through
  ///
  /// In en, this message translates to:
  /// **'Match a waiting rider with a vehicle, then walk the handover through'**
  String get allocationMatchWaitingRiderWithVehicle;

  /// Your move
  ///
  /// In en, this message translates to:
  /// **'Your move'**
  String get allocationMove;

  /// Name the work partner or workshop that inspected the vehicle
  ///
  /// In en, this message translates to:
  /// **'Name the work partner or workshop that inspected the vehicle'**
  String get allocationNameWorkPartnerWorkshopInspected;

  /// Nobody waiting
  ///
  /// In en, this message translates to:
  /// **'Nobody waiting'**
  String get allocationNobodyWaiting;

  /// No handovers in progress
  ///
  /// In en, this message translates to:
  /// **'No handovers in progress'**
  String get allocationNoHandoversProgress;

  /// Nothing is currently allocated to a rider.
  ///
  /// In en, this message translates to:
  /// **'Nothing is currently allocated to a rider.'**
  String get allocationNothingCurrentlyAllocatedRider;

  /// No vehicles out
  ///
  /// In en, this message translates to:
  /// **'No vehicles out'**
  String get allocationNoVehiclesOut;

  /// No vehicles ready
  ///
  /// In en, this message translates to:
  /// **'No vehicles ready'**
  String get allocationNoVehiclesReady;

  /// Number
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get allocationNumber;

  /// Onboarding fee
  ///
  /// In en, this message translates to:
  /// **'Onboarding fee'**
  String get allocationOnboardingFee;

  /// Payment received?
  ///
  /// In en, this message translates to:
  /// **'Payment received?'**
  String get allocationPaymentReceived;

  /// Payment requested
  ///
  /// In en, this message translates to:
  /// **'Payment requested'**
  String get allocationPaymentRequested;

  /// Payment requested — the rider sees it now
  ///
  /// In en, this message translates to:
  /// **'Payment requested — the rider sees it now'**
  String get allocationPaymentRequestedRiderSeesNow;

  /// Payment verified
  ///
  /// In en, this message translates to:
  /// **'Payment verified'**
  String get allocationPaymentVerified;

  /// Back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get allocationPhotoBack;

  /// This photo can't be opened right now.
  ///
  /// In en, this message translates to:
  /// **'This photo can\'t be opened right now.'**
  String get allocationPhotoCannotOpen;

  /// Assign-flow photo slot: the signed declaration form
  ///
  /// In en, this message translates to:
  /// **'Declaration form'**
  String get allocationPhotoDeclaration;

  /// Front
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get allocationPhotoFront;

  /// Left
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get allocationPhotoLeft;

  /// Assign-flow photo slot: the rider standing with the vehicle
  ///
  /// In en, this message translates to:
  /// **'Rider with vehicle'**
  String get allocationPhotoRider;

  /// Right
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get allocationPhotoRight;

  /// Uploaded
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get allocationPhotoUploaded;

  /// You raise the deposit and fees; the rider pays and submits the reference; you verify it.
  ///
  /// In en, this message translates to:
  /// **'You raise the deposit and fees; the rider pays and submits the reference; you verify it.'**
  String get allocationRaiseDepositFeesRiderPays;

  /// Reason
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get allocationReason;

  /// Rental fee (week)
  ///
  /// In en, this message translates to:
  /// **'Rental fee (week)'**
  String get allocationRentalFeeWeek;

  /// Request the vehicle
  ///
  /// In en, this message translates to:
  /// **'Request the vehicle'**
  String get allocationRequestVehicle;

  /// Reserved
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get allocationReserved;

  /// Reserved on
  ///
  /// In en, this message translates to:
  /// **'Reserved on'**
  String get allocationReserved2;

  /// Rider
  ///
  /// In en, this message translates to:
  /// **'Rider'**
  String get allocationRider;

  /// Rider code
  ///
  /// In en, this message translates to:
  /// **'Rider code'**
  String get allocationRiderCode;

  /// The rider is completing the safety training in their app. The scooter is handed over once every mandatory module is done.
  ///
  /// In en, this message translates to:
  /// **'The rider is completing the safety training in their app. The scooter is handed over once every mandatory module is done.'**
  String get allocationRiderCompletingSafetyTrainingTheir;

  /// The rider is going through your checklist in their app. Items they reject come back with a note.
  ///
  /// In en, this message translates to:
  /// **'The rider is going through your checklist in their app. Items they reject come back with a note.'**
  String get allocationRiderGoingThroughChecklistTheir;

  /// This rider is no longer waiting for a vehicle.
  ///
  /// In en, this message translates to:
  /// **'This rider is no longer waiting for a vehicle.'**
  String get allocationRiderNoLongerWaitingVehicle;

  /// Riding
  ///
  /// In en, this message translates to:
  /// **'Riding'**
  String get allocationRiding;

  /// Right side
  ///
  /// In en, this message translates to:
  /// **'Right side'**
  String get allocationRightSide;

  /// On road
  ///
  /// In en, this message translates to:
  /// **'On road'**
  String get allocationRoad;

  /// Search rider name, code or mobile
  ///
  /// In en, this message translates to:
  /// **'Search rider name, code or mobile'**
  String get allocationSearchRiderNameCodeMobile;

  /// Search rider or vehicle
  ///
  /// In en, this message translates to:
  /// **'Search rider or vehicle'**
  String get allocationSearchRiderVehicle;

  /// Search rider or vehicle number
  ///
  /// In en, this message translates to:
  /// **'Search rider or vehicle number'**
  String get allocationSearchRiderVehicleNumber;

  /// Security deposit
  ///
  /// In en, this message translates to:
  /// **'Security deposit'**
  String get allocationSecurityDeposit;

  /// Send payment request
  ///
  /// In en, this message translates to:
  /// **'Send payment request'**
  String get allocationSendPaymentRequest;

  /// Send to rider
  ///
  /// In en, this message translates to:
  /// **'Send to rider'**
  String get allocationSendRider;

  /// Start a return
  ///
  /// In en, this message translates to:
  /// **'Start a return'**
  String get allocationStartReturn;

  /// Tyres and pressure
  ///
  /// In en, this message translates to:
  /// **'Tyres and pressure'**
  String get allocationTyresPressure;

  /// Upload evidence to continue
  ///
  /// In en, this message translates to:
  /// **'Upload evidence to continue'**
  String get allocationUploadEvidenceContinue;

  /// A vehicle has to be available, onboarded and allocation-enabled in one of your hubs to appear here.
  ///
  /// In en, this message translates to:
  /// **'A vehicle has to be available, onboarded and allocation-enabled in one of your hubs to appear here.'**
  String get allocationVehicleHasAvailableOnboardedAllocation;

  /// Vehicle photos
  ///
  /// In en, this message translates to:
  /// **'Vehicle photos'**
  String get allocationVehiclePhotos;

  /// Hint above the assign-flow photo grid
  ///
  /// In en, this message translates to:
  /// **'Take a photo of each side of the vehicle, one of the rider with the vehicle, and one of the signed declaration form. All are needed before you submit the inspection.'**
  String get allocationVehiclePhotosHint;

  /// Vehicle reserved
  ///
  /// In en, this message translates to:
  /// **'Vehicle reserved'**
  String get allocationVehicleReserved;

  /// Verify payment
  ///
  /// In en, this message translates to:
  /// **'Verify payment'**
  String get allocationVerifyPayment;

  /// Waiting
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get allocationWaiting;

  /// Waiting on the rider
  ///
  /// In en, this message translates to:
  /// **'Waiting on the rider'**
  String get allocationWaitingRider;

  /// Waiting for rider to accept inspection
  ///
  /// In en, this message translates to:
  /// **'Waiting for rider to accept inspection'**
  String get allocationWaitingRiderAcceptInspection;

  /// Waiting for rider to finish training
  ///
  /// In en, this message translates to:
  /// **'Waiting for rider to finish training'**
  String get allocationWaitingRiderFinishTraining;

  /// Waiting for rider: inspection
  ///
  /// In en, this message translates to:
  /// **'Waiting for rider: inspection'**
  String get allocationWaitingRiderInspection;

  /// Waiting on the rider — this page refreshes on its own.
  ///
  /// In en, this message translates to:
  /// **'Waiting on the rider — this page refreshes on its own.'**
  String get allocationWaitingRiderPageRefreshesIts;

  /// Waiting for rider: training
  ///
  /// In en, this message translates to:
  /// **'Waiting for rider: training'**
  String get allocationWaitingRiderTraining;

  /// What the rider pays before the handover
  ///
  /// In en, this message translates to:
  /// **'What the rider pays before the handover'**
  String get allocationWhatRiderPaysBeforeHandover;

  /// What was allocated
  ///
  /// In en, this message translates to:
  /// **'What was allocated'**
  String get allocationWhatWasAllocated;

  /// Work partner
  ///
  /// In en, this message translates to:
  /// **'Work partner'**
  String get allocationWorkPartner;

  /// The workshop or technician who inspected the vehicle
  ///
  /// In en, this message translates to:
  /// **'The workshop or technician who inspected the vehicle'**
  String get allocationWorkshopTechnicianWhoInspectedVehicle;

  /// You write the PDI checklist; the rider accepts it and completes training.
  ///
  /// In en, this message translates to:
  /// **'You write the PDI checklist; the rider accepts it and completes training.'**
  String get allocationWritePdiChecklistRiderAccepts;

  /// Go home
  ///
  /// In en, this message translates to:
  /// **'Go home'**
  String get appGoHome;

  /// Change number
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get authChangeNumber;

  /// That code did not verify. Please try again.
  ///
  /// In en, this message translates to:
  /// **'That code did not verify. Please try again.'**
  String get authCodeDidNotVerifyPlease;

  /// Continue
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get authContinue;

  /// Edit number
  ///
  /// In en, this message translates to:
  /// **'Edit number'**
  String get authEditNumber;

  /// Shown above the Continue button on the login screen. {terms} and {privacy} are tappable links.
  ///
  /// In en, this message translates to:
  /// **'By clicking continue you are accepting our {terms} and {privacy}'**
  String authLegalAgreement(String terms, String privacy);

  /// Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get authLegalPrivacy;

  /// Terms of Service
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get authLegalTerms;

  /// Live fleet visibility
  ///
  /// In en, this message translates to:
  /// **'Live fleet\nvisibility'**
  String get authLiveFleetVisibility;

  /// Number verified
  ///
  /// In en, this message translates to:
  /// **'Number verified'**
  String get authNumberVerified;

  /// Only numbers registered by your admin can sign in
  ///
  /// In en, this message translates to:
  /// **'Only numbers registered by your admin can sign in'**
  String get authOnlyNumbersRegisteredByAdmin;

  /// 24x7 ops support
  ///
  /// In en, this message translates to:
  /// **'24x7 ops\nsupport'**
  String get authOpsSupport;

  /// A 6-digit code was sent to +91 {mobile}
  ///
  /// In en, this message translates to:
  /// **'A 6-digit code was sent to +91 {mobile}'**
  String authOtpSentTo(String mobile);

  /// Resend code
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResendCode;

  /// Countdown before the OTP can be resent
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}'**
  String authResendCodeIn(String seconds);

  /// 24x7 roadside help
  ///
  /// In en, this message translates to:
  /// **'24x7\nroadside help'**
  String get authRoadsideHelp;

  /// Same-day payouts
  ///
  /// In en, this message translates to:
  /// **'Same-day\npayouts'**
  String get authSameDayPayouts;

  /// Your session is encrypted end-to-end
  ///
  /// In en, this message translates to:
  /// **'Your session is encrypted end-to-end'**
  String get authSessionEncryptedEndEnd;

  /// Sign in to run your hub
  ///
  /// In en, this message translates to:
  /// **'Sign in to run your hub'**
  String get authSignRunHub;

  /// Sign in with the mobile number registered to your hub to manage allocations, riders and maintenance.
  ///
  /// In en, this message translates to:
  /// **'Sign in with the mobile number registered to your hub to manage allocations, riders and maintenance.'**
  String get authSignWithMobileNumberRegistered;

  /// Sign in with the mobile number registered with your fleet operator.
  ///
  /// In en, this message translates to:
  /// **'Sign in with the mobile number registered with your fleet operator.'**
  String get authSignWithMobileNumberRegistered2;

  /// Verified hub network
  ///
  /// In en, this message translates to:
  /// **'Verified\nhub network'**
  String get authVerifiedHubNetwork;

  /// Verified operators
  ///
  /// In en, this message translates to:
  /// **'Verified\noperators'**
  String get authVerifiedOperators;

  /// Verifying…
  ///
  /// In en, this message translates to:
  /// **'Verifying…'**
  String get authVerifying;

  /// Verifying your number…
  ///
  /// In en, this message translates to:
  /// **'Verifying your number…'**
  String get authVerifyingNumber;

  /// Verify your number
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get authVerifyNumber;

  /// Welcome back
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authWelcomeBack;

  /// Why choose us
  ///
  /// In en, this message translates to:
  /// **'Why choose us'**
  String get authWhyChooseUs;

  /// Why ride with us
  ///
  /// In en, this message translates to:
  /// **'Why ride with us'**
  String get authWhyRideWithUs;

  /// We will text you a 6-digit code
  ///
  /// In en, this message translates to:
  /// **'We will text you a 6-digit code'**
  String get authWillText6DigitCode;

  /// Wrong number?
  ///
  /// In en, this message translates to:
  /// **'Wrong number?'**
  String get authWrongNumber;

  /// Mechanic report
  ///
  /// In en, this message translates to:
  /// **'Mechanic report'**
  String get checkInBasicReport;

  /// Report confirmed with a recorded bypass reason
  ///
  /// In en, this message translates to:
  /// **'Confirmed by the hub team without your code: {reason}'**
  String checkInConfirmedByManager(String reason);

  /// Confirmed with your code.
  ///
  /// In en, this message translates to:
  /// **'Confirmed with your code.'**
  String get checkInConfirmedByOtp;

  /// Couldn't load the check-in.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the check-in.'**
  String get checkInCouldNotLoad;

  /// Final mechanic check
  ///
  /// In en, this message translates to:
  /// **'Final mechanic check'**
  String get checkInDeepReport;

  /// Hub
  ///
  /// In en, this message translates to:
  /// **'Hub'**
  String get checkInHub;

  /// No charges
  ///
  /// In en, this message translates to:
  /// **'No charges'**
  String get checkInNoCharges;

  /// You'll get a code on your phone. Share it with the hub team to confirm this report and its charges.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get a code on your phone. Share it with the hub team to confirm this report and its charges.'**
  String get checkInOtpHint;

  /// Photos
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get checkInPhotos;

  /// Required check-in photos taken so far
  ///
  /// In en, this message translates to:
  /// **'{taken} of {total} taken'**
  String checkInPhotosCount(int taken, int total);

  /// Safe to use again
  ///
  /// In en, this message translates to:
  /// **'Safe to use again'**
  String get checkInSafe;

  /// Under review
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get checkInStatusDraft;

  /// Confirmed
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get checkInStatusPosted;

  /// Awaiting confirmation
  ///
  /// In en, this message translates to:
  /// **'Awaiting confirmation'**
  String get checkInStatusSubmitted;

  /// Scooter check-in
  ///
  /// In en, this message translates to:
  /// **'Scooter check-in'**
  String get checkInTitle;

  /// Total charges
  ///
  /// In en, this message translates to:
  /// **'Total charges'**
  String get checkInTotal;

  /// Mechanic marked the vehicle unsafe
  ///
  /// In en, this message translates to:
  /// **'Not safe to reuse: {reason}'**
  String checkInUnsafe(String reason);

  /// View
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get checkInViewPhotos;

  /// The hub team is taking photos. The mechanic's report shows up here once it's ready.
  ///
  /// In en, this message translates to:
  /// **'The hub team is taking photos. The mechanic\'s report shows up here once it\'s ready.'**
  String get checkInWaitingReport;

  /// About this app
  ///
  /// In en, this message translates to:
  /// **'About this app'**
  String get commonAboutApp;

  /// Absent
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get commonAbsent;

  /// Your account cannot do that.
  ///
  /// In en, this message translates to:
  /// **'Your account cannot do that.'**
  String get commonAccountCannotDo;

  /// Account numbers do not match
  ///
  /// In en, this message translates to:
  /// **'Account numbers do not match'**
  String get commonAccountNumbersDoNotMatch;

  /// Account numbers match
  ///
  /// In en, this message translates to:
  /// **'Account numbers match'**
  String get commonAccountNumbersMatch;

  /// Add another reference
  ///
  /// In en, this message translates to:
  /// **'Add another reference'**
  String get commonAddAnotherReference;

  /// Add nominee
  ///
  /// In en, this message translates to:
  /// **'Add nominee'**
  String get commonAddNominee;

  /// Add a photo
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get commonAddPhoto;

  /// Allocated on
  ///
  /// In en, this message translates to:
  /// **'Allocated on'**
  String get commonAllocated;

  /// Allocation
  ///
  /// In en, this message translates to:
  /// **'Allocation'**
  String get commonAllocation;

  /// The app will change right away.
  ///
  /// In en, this message translates to:
  /// **'The app will change right away.'**
  String get commonAppWillChangeRightAway;

  /// Attendance
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get commonAttendance;

  /// Bank account number
  ///
  /// In en, this message translates to:
  /// **'Bank account number'**
  String get commonBankAccountNumber;

  /// Brakes
  ///
  /// In en, this message translates to:
  /// **'Brakes'**
  String get commonBrakes;

  /// Brother
  ///
  /// In en, this message translates to:
  /// **'Brother'**
  String get commonBrother;

  /// Camera
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get commonCamera;

  /// Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// You can change it later from the menu.
  ///
  /// In en, this message translates to:
  /// **'You can change it later from the menu.'**
  String get commonCanChangeLaterFromMenu;

  /// Category
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get commonCategory;

  /// Choose your language
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get commonChooseLanguage;

  /// City
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get commonCity;

  /// Colleague
  ///
  /// In en, this message translates to:
  /// **'Colleague'**
  String get commonColleague;

  /// Colour
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get commonColour;

  /// Confirm
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// Confirm account number
  ///
  /// In en, this message translates to:
  /// **'Confirm account number'**
  String get commonConfirmAccountNumber;

  /// Could not open the document. Try again.
  ///
  /// In en, this message translates to:
  /// **'Could not open the document. Try again.'**
  String get commonCouldNotOpenDocumentTry;

  /// Could not read local data.
  ///
  /// In en, this message translates to:
  /// **'Could not read local data.'**
  String get commonCouldNotReadLocalData;

  /// Daughter
  ///
  /// In en, this message translates to:
  /// **'Daughter'**
  String get commonDaughter;

  /// Enter your account number
  ///
  /// In en, this message translates to:
  /// **'Enter your account number'**
  String get commonEnterAccountNumber;

  /// Enter a valid 10-digit mobile number
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get commonEnterValid10DigitMobile;

  /// Father
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get commonFather;

  /// Friend
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get commonFriend;

  /// Full name
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get commonFullName;

  /// Gallery
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get commonGallery;

  /// Good afternoon
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get commonGoodAfternoon;

  /// Good evening
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get commonGoodEvening;

  /// Good morning
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get commonGoodMorning;

  /// Handover
  ///
  /// In en, this message translates to:
  /// **'Handover'**
  String get commonHandover;

  /// You have already used this number for another reference
  ///
  /// In en, this message translates to:
  /// **'You have already used this number for another reference'**
  String get commonHaveAlreadyUsedNumberAnother;

  /// High
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get commonHigh;

  /// High priority
  ///
  /// In en, this message translates to:
  /// **'High priority'**
  String get commonHighPriority;

  /// e.g. Guardian
  ///
  /// In en, this message translates to:
  /// **'e.g. Guardian'**
  String get commonHintGuardian;

  /// How are they related to you?
  ///
  /// In en, this message translates to:
  /// **'How are they related to you?'**
  String get commonHowTheyRelated;

  /// Incentives
  ///
  /// In en, this message translates to:
  /// **'Incentives'**
  String get commonIncentives;

  /// Insurance
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get commonInsurance;

  /// IoT unit
  ///
  /// In en, this message translates to:
  /// **'IoT unit'**
  String get commonIotUnit;

  /// JPG, PNG or PDF · up to 5 MB
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG or PDF · up to 5 MB'**
  String get commonJpgPngPdfUp5;

  /// km left
  ///
  /// In en, this message translates to:
  /// **'km left'**
  String get commonKmLeft;

  /// Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get commonLanguage;

  /// Load more
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get commonLoadMore;

  /// Low priority
  ///
  /// In en, this message translates to:
  /// **'Low priority'**
  String get commonLowPriority;

  /// Make it 100%
  ///
  /// In en, this message translates to:
  /// **'Make it 100%'**
  String get commonMake100;

  /// Manager
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get commonManager;

  /// Mandatory
  ///
  /// In en, this message translates to:
  /// **'Mandatory'**
  String get commonMandatory;

  /// Marked present. Your shift has started.
  ///
  /// In en, this message translates to:
  /// **'Marked present. Your shift has started.'**
  String get commonMarkedPresentShiftHasStarted;

  /// Mobile
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get commonMobile;

  /// Mobile number
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get commonMobileNumber;

  /// Model
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get commonModel;

  /// Mother
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get commonMother;

  /// No internet connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get commonNoInternetConnection;

  /// Your nomination is complete.
  ///
  /// In en, this message translates to:
  /// **'Your nomination is complete.'**
  String get commonNominationComplete;

  /// Normal
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get commonNormal;

  /// Normal priority
  ///
  /// In en, this message translates to:
  /// **'Normal priority'**
  String get commonNormalPriority;

  /// Not found.
  ///
  /// In en, this message translates to:
  /// **'Not found.'**
  String get commonNotFound;

  /// Now
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get commonNow;

  /// Odometer
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get commonOdometer;

  /// Off
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get commonOff;

  /// Offline
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get commonOffline;

  /// On
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get commonOn;

  /// Open
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpen;

  /// Optional
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get commonOptional;

  /// Other
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get commonOther;

  /// Other relationship
  ///
  /// In en, this message translates to:
  /// **'Other relationship'**
  String get commonOtherRelationship;

  /// This is your own number. Use a different one.
  ///
  /// In en, this message translates to:
  /// **'This is your own number. Use a different one.'**
  String get commonOwnNumberUseDifferentOne;

  /// Paid to date
  ///
  /// In en, this message translates to:
  /// **'Paid to date'**
  String get commonPaidDate;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get commonPayment;

  /// Pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get commonPending;

  /// Pre-delivery inspection
  ///
  /// In en, this message translates to:
  /// **'Pre-delivery inspection'**
  String get commonPreDeliveryInspection;

  /// Present
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get commonPresent;

  /// Privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get commonPrivacyPolicy;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get commonProfile;

  /// Raised
  ///
  /// In en, this message translates to:
  /// **'Raised'**
  String get commonRaised;

  /// Refresh
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonRefresh;

  /// Rejected — upload again
  ///
  /// In en, this message translates to:
  /// **'Rejected — upload again'**
  String get commonRejectedUploadAgain;

  /// Why a document was rejected, shown under a rejected upload
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String commonRejectionReason(String reason);

  /// Relationship
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get commonRelationship;

  /// Remove
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// Retake
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get commonRetake;

  /// Retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// Save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// Your scooter
  ///
  /// In en, this message translates to:
  /// **'Your scooter'**
  String get commonScooter;

  /// Search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// Select
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get commonSelect;

  /// Select a date
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get commonSelectDate;

  /// Your session has expired. Please sign in again.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get commonSessionHasExpiredPleaseSign;

  /// Share
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// Shares add up to 100%
  ///
  /// In en, this message translates to:
  /// **'Shares add up to 100%'**
  String get commonSharesAddUp100;

  /// Sign in before reading the client configuration.
  ///
  /// In en, this message translates to:
  /// **'Sign in before reading the client configuration.'**
  String get commonSignBeforeReadingClientConfiguration;

  /// Sign in to continue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue.'**
  String get commonSignContinue;

  /// Sign out
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get commonSignOut;

  /// Sign out?
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get commonSignOut2;

  /// Sister
  ///
  /// In en, this message translates to:
  /// **'Sister'**
  String get commonSister;

  /// Skip
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// Something went wrong. Please try again.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get commonSomethingWentWrongPleaseTry;

  /// Son
  ///
  /// In en, this message translates to:
  /// **'Son'**
  String get commonSon;

  /// Spouse
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get commonSpouse;

  /// Status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// Submit inspection
  ///
  /// In en, this message translates to:
  /// **'Submit inspection'**
  String get commonSubmitInspection;

  /// Support
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get commonSupport;

  /// Take one now, or choose from your gallery
  ///
  /// In en, this message translates to:
  /// **'Take one now, or choose from your gallery'**
  String get commonTakeOneNowChooseFrom;

  /// Team lead
  ///
  /// In en, this message translates to:
  /// **'Team lead'**
  String get commonTeamLead;

  /// Tell us how they are related to you
  ///
  /// In en, this message translates to:
  /// **'Tell us how they are related to you'**
  String get commonTellUsHowTheyRelated;

  /// Terms of service
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get commonTermsService;

  /// Their name
  ///
  /// In en, this message translates to:
  /// **'Their name'**
  String get commonTheirName;

  /// Too many attempts. Wait a moment.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a moment.'**
  String get commonTooManyAttemptsWaitMoment;

  /// Total
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get commonTotal;

  /// Try again
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// Type it again
  ///
  /// In en, this message translates to:
  /// **'Type it again'**
  String get commonTypeAgain;

  /// Upload
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get commonUpload;

  /// Uploaded
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get commonUploaded;

  /// Vehicle
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get commonVehicle;

  /// Version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get commonVersion;

  /// Wallet
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get commonWallet;

  /// This week
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get commonWeek;

  /// Weekly plan
  ///
  /// In en, this message translates to:
  /// **'Weekly plan'**
  String get commonWeeklyPlan;

  /// What happens next
  ///
  /// In en, this message translates to:
  /// **'What happens next'**
  String get commonWhatHappensNext;

  /// You will need your mobile number and an OTP to sign back in.
  ///
  /// In en, this message translates to:
  /// **'You will need your mobile number and an OTP to sign back in.'**
  String get commonWillNeedMobileNumberOtp;

  /// Yesterday at a glance
  ///
  /// In en, this message translates to:
  /// **'Yesterday at a glance'**
  String get commonYesterdayGlance;

  /// e.g. yogmaya
  ///
  /// In en, this message translates to:
  /// **'e.g. yogmaya'**
  String get companyCodeHint;

  /// Company code
  ///
  /// In en, this message translates to:
  /// **'Company code'**
  String get companyCodeLabel;

  /// Enter your company code
  ///
  /// In en, this message translates to:
  /// **'Enter your company code'**
  String get companyCodeRequired;

  /// You'll find the code in your welcome message. If you don't have it, ask your hub team.
  ///
  /// In en, this message translates to:
  /// **'You\'ll find the code in your welcome message. If you don\'t have it, ask your hub team.'**
  String get companyHelp;

  /// We couldn't find a company with that code. Check it and try again.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find a company with that code. Check it and try again.'**
  String get companyNotFound;

  /// This company isn't set up for the app yet. Please contact your fleet operator.
  ///
  /// In en, this message translates to:
  /// **'This company isn\'t set up for the app yet. Please contact your fleet operator.'**
  String get companyNotReady;

  /// Enter the company code your fleet operator gave you. You only need to do this once.
  ///
  /// In en, this message translates to:
  /// **'Enter the company code your fleet operator gave you. You only need to do this once.'**
  String get companySubtitle;

  /// Find your company
  ///
  /// In en, this message translates to:
  /// **'Find your company'**
  String get companyTitle;

  /// Shown after the company code is resolved
  ///
  /// In en, this message translates to:
  /// **'Welcome to {name}'**
  String companyWelcome(String name);

  /// Consent screen checkbox: the data principal declaration, matching the rider privacy notice
  ///
  /// In en, this message translates to:
  /// **'I declare that I have understood the points of this consent form and agree in my capacity as the data principal.'**
  String get consentAgree;

  /// Rider Consent
  ///
  /// In en, this message translates to:
  /// **'Rider Consent'**
  String get consentRiderTitle;

  /// Please read how we collect and use your information, then give your consent to continue.
  ///
  /// In en, this message translates to:
  /// **'Please read how we collect and use your information, then give your consent to continue.'**
  String get consentSubtitle;

  /// Accessories returned
  ///
  /// In en, this message translates to:
  /// **'Accessories returned'**
  String get deallocAccessoriesReturned;

  /// Any new damage you record here is assessed against the rider's security deposit, so capture it clearly.
  ///
  /// In en, this message translates to:
  /// **'Any new damage you record here is assessed against the rider\'s security deposit, so capture it clearly.'**
  String get deallocAnyNewDamageRecordHere;

  /// Assessment
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get deallocAssessment;

  /// Available
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get deallocAvailable;

  /// Battery returned to the hub
  ///
  /// In en, this message translates to:
  /// **'Battery returned to the hub'**
  String get deallocBatteryReturnedHub;

  /// Both the rider and the team lead must confirm
  ///
  /// In en, this message translates to:
  /// **'Both the rider and the team lead must confirm'**
  String get deallocBothRiderTeamLeadMust;

  /// Charger & cable
  ///
  /// In en, this message translates to:
  /// **'Charger & cable'**
  String get deallocChargerCable;

  /// Charge at return
  ///
  /// In en, this message translates to:
  /// **'Charge at return'**
  String get deallocChargeReturn;

  /// Close the ride
  ///
  /// In en, this message translates to:
  /// **'Close the ride'**
  String get deallocCloseRide;

  /// Codes are valid for 10 minutes. Ask each person to read theirs out — do not take their phone.
  ///
  /// In en, this message translates to:
  /// **'Codes are valid for 10 minutes. Ask each person to read theirs out — do not take their phone.'**
  String get deallocCodesValid10MinutesAsk;

  /// Compare against the handover set
  ///
  /// In en, this message translates to:
  /// **'Compare against the handover set'**
  String get deallocCompareAgainstHandoverSet;

  /// Complete de-allocation
  ///
  /// In en, this message translates to:
  /// **'Complete de-allocation'**
  String get deallocCompleteDeAllocation;

  /// Components
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get deallocComponents;

  /// Condition assessment
  ///
  /// In en, this message translates to:
  /// **'Condition assessment'**
  String get deallocConditionAssessment;

  /// Confirm the battery is back
  ///
  /// In en, this message translates to:
  /// **'Confirm the battery is back'**
  String get deallocConfirmBatteryBack;

  /// Continue to assessment
  ///
  /// In en, this message translates to:
  /// **'Continue to assessment'**
  String get deallocContinueAssessment;

  /// Continue to verification
  ///
  /// In en, this message translates to:
  /// **'Continue to verification'**
  String get deallocContinueVerification;

  /// Damaged
  ///
  /// In en, this message translates to:
  /// **'Damaged'**
  String get deallocDamaged;

  /// Damage description
  ///
  /// In en, this message translates to:
  /// **'Damage description'**
  String get deallocDamageDescription;

  /// Deducted from the rider's security deposit after review.
  ///
  /// In en, this message translates to:
  /// **'Deducted from the rider\'s security deposit after review.'**
  String get deallocDeductedFromRidersSecurityDeposit;

  /// Describe the damage
  ///
  /// In en, this message translates to:
  /// **'Describe the damage'**
  String get deallocDescribeDamage;

  /// End the ride to continue
  ///
  /// In en, this message translates to:
  /// **'End the ride to continue'**
  String get deallocEndRideContinue;

  /// End the rider's active ride
  ///
  /// In en, this message translates to:
  /// **'End the rider\'s active ride'**
  String get deallocEndRidersActiveRide;

  /// Enter all 6 digits
  ///
  /// In en, this message translates to:
  /// **'Enter all 6 digits'**
  String get deallocEnterAll6Digits;

  /// Enter the closing odometer
  ///
  /// In en, this message translates to:
  /// **'Enter the closing odometer'**
  String get deallocEnterClosingOdometer;

  /// Enter the rider's code
  ///
  /// In en, this message translates to:
  /// **'Enter the rider\'s code'**
  String get deallocEnterRidersCode;

  /// Enter the team lead's code
  ///
  /// In en, this message translates to:
  /// **'Enter the team lead\'s code'**
  String get deallocEnterTeamLeadsCode;

  /// Estimated recovery
  ///
  /// In en, this message translates to:
  /// **'Estimated recovery'**
  String get deallocEstimatedRecovery;

  /// Excellent
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get deallocExcellent;

  /// Good
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get deallocGood;

  /// Logged back into the charging bay inventory.
  ///
  /// In en, this message translates to:
  /// **'Logged back into the charging bay inventory.'**
  String get deallocLoggedBackIntoChargingBay;

  /// Minor scuffs, nothing to recover
  ///
  /// In en, this message translates to:
  /// **'Minor scuffs, nothing to recover'**
  String get deallocMinorScuffsNothingRecover;

  /// No damage beyond normal wear
  ///
  /// In en, this message translates to:
  /// **'No damage beyond normal wear'**
  String get deallocNoDamageBeyondNormalWear;

  /// Not usable until further notice
  ///
  /// In en, this message translates to:
  /// **'Not usable until further notice'**
  String get deallocNotUsableUntilFurtherNotice;

  /// Odometer at return
  ///
  /// In en, this message translates to:
  /// **'Odometer at return'**
  String get deallocOdometerReturn;

  /// Off road
  ///
  /// In en, this message translates to:
  /// **'Off road'**
  String get deallocOffRoad;

  /// Photograph the vehicle exactly as it came back
  ///
  /// In en, this message translates to:
  /// **'Photograph the vehicle exactly as it came back'**
  String get deallocPhotographVehicleExactlyAsCame;

  /// RC, insurance and PUC
  ///
  /// In en, this message translates to:
  /// **'RC, insurance and PUC'**
  String get deallocRcInsurancePuc;

  /// Ready to allocate to another rider
  ///
  /// In en, this message translates to:
  /// **'Ready to allocate to another rider'**
  String get deallocReadyAllocateAnotherRider;

  /// Record the vehicle condition
  ///
  /// In en, this message translates to:
  /// **'Record the vehicle condition'**
  String get deallocRecordVehicleCondition;

  /// Record what comes back and what is missing
  ///
  /// In en, this message translates to:
  /// **'Record what comes back and what is missing'**
  String get deallocRecordWhatComesBackWhat;

  /// Recoverable damage — raise a maintenance job
  ///
  /// In en, this message translates to:
  /// **'Recoverable damage — raise a maintenance job'**
  String get deallocRecoverableDamageRaiseMaintenanceJob;

  /// Return condition
  ///
  /// In en, this message translates to:
  /// **'Return condition'**
  String get deallocReturnCondition;

  /// Return photos
  ///
  /// In en, this message translates to:
  /// **'Return photos'**
  String get deallocReturnPhotos;

  /// Rider confirmation
  ///
  /// In en, this message translates to:
  /// **'Rider confirmation'**
  String get deallocRiderConfirmation;

  /// Send to the workshop first
  ///
  /// In en, this message translates to:
  /// **'Send to the workshop first'**
  String get deallocSendWorkshopFirst;

  /// In service
  ///
  /// In en, this message translates to:
  /// **'In service'**
  String get deallocService;

  /// Set fleet status
  ///
  /// In en, this message translates to:
  /// **'Set fleet status'**
  String get deallocSetFleetStatus;

  /// Set the fleet status
  ///
  /// In en, this message translates to:
  /// **'Set the fleet status'**
  String get deallocSetFleetStatus2;

  /// Stops telemetry, closes the shift and settles the final trip.
  ///
  /// In en, this message translates to:
  /// **'Stops telemetry, closes the shift and settles the final trip.'**
  String get deallocStopsTelemetryClosesShiftSettles;

  /// Team lead confirmation
  ///
  /// In en, this message translates to:
  /// **'Team lead confirmation'**
  String get deallocTeamLeadConfirmation;

  /// Two-party verification
  ///
  /// In en, this message translates to:
  /// **'Two-party verification'**
  String get deallocTwoPartyVerification;

  /// Vehicle angles
  ///
  /// In en, this message translates to:
  /// **'Vehicle angles'**
  String get deallocVehicleAngles;

  /// Vehicle condition
  ///
  /// In en, this message translates to:
  /// **'Vehicle condition'**
  String get deallocVehicleCondition;

  /// Verification
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get deallocVerification;

  /// What is damaged, and how badly
  ///
  /// In en, this message translates to:
  /// **'What is damaged, and how badly'**
  String get deallocWhatDamagedHowBadly;

  /// Accept scooter
  ///
  /// In en, this message translates to:
  /// **'Accept scooter'**
  String get deploymentAcceptScooter;

  /// Accept this scooter?
  ///
  /// In en, this message translates to:
  /// **'Accept this scooter?'**
  String get deploymentAcceptScooter2;

  /// You're all set up
  ///
  /// In en, this message translates to:
  /// **'You\'re all set up'**
  String get deploymentAllSetUp;

  /// Almost there
  ///
  /// In en, this message translates to:
  /// **'Almost there'**
  String get deploymentAlmostThere;

  /// Amount due
  ///
  /// In en, this message translates to:
  /// **'Amount due'**
  String get deploymentAmountDue;

  /// Awaiting verification
  ///
  /// In en, this message translates to:
  /// **'Awaiting verification'**
  String get deploymentAwaitingVerification;

  /// Bank transfer
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get deploymentBankTransfer;

  /// Card
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get deploymentCard;

  /// Cash at hub
  ///
  /// In en, this message translates to:
  /// **'Cash at hub'**
  String get deploymentCashHub;

  /// Check each item
  ///
  /// In en, this message translates to:
  /// **'Check each item'**
  String get deploymentCheckEachItem;

  /// Checking with your fleet manager every few seconds…
  ///
  /// In en, this message translates to:
  /// **'Checking with your fleet manager every few seconds…'**
  String get deploymentCheckingWithFleetManagerEvery;

  /// You confirm every item has been checked with your team lead and the scooter is fit to ride.
  ///
  /// In en, this message translates to:
  /// **'You confirm every item has been checked with your team lead and the scooter is fit to ride.'**
  String get deploymentConfirmEveryItemHasBeen;

  /// Could not load the checklist
  ///
  /// In en, this message translates to:
  /// **'Could not load the checklist'**
  String get deploymentCouldNotLoadChecklist;

  /// Could not load training
  ///
  /// In en, this message translates to:
  /// **'Could not load training'**
  String get deploymentCouldNotLoadTraining;

  /// Could not reach the server
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server'**
  String get deploymentCouldNotReachServer;

  /// Could not submit the inspection
  ///
  /// In en, this message translates to:
  /// **'Could not submit the inspection'**
  String get deploymentCouldNotSubmitInspection;

  /// Done
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get deploymentDone;

  /// Enter the transaction reference you paid with
  ///
  /// In en, this message translates to:
  /// **'Enter the transaction reference you paid with'**
  String get deploymentEnterTransactionReferencePaidWith;

  /// Bottom button on the rider hygiene screen
  ///
  /// In en, this message translates to:
  /// **'Finish hygiene check'**
  String get deploymentFinishHygieneCheck;

  /// Flag as a problem
  ///
  /// In en, this message translates to:
  /// **'Flag as a problem'**
  String get deploymentFlagAsProblem;

  /// Flagged by rider
  ///
  /// In en, this message translates to:
  /// **'Flagged by rider'**
  String get deploymentFlaggedByRider;

  /// Your fleet manager checks this against what they received.
  ///
  /// In en, this message translates to:
  /// **'Your fleet manager checks this against what they received.'**
  String get deploymentFleetManagerChecksAgainstWhat;

  /// Your fleet manager has not asked for a payment yet.
  ///
  /// In en, this message translates to:
  /// **'Your fleet manager has not asked for a payment yet.'**
  String get deploymentFleetManagerHasNotAsked;

  /// Your fleet manager has not submitted the inspection yet.
  ///
  /// In en, this message translates to:
  /// **'Your fleet manager has not submitted the inspection yet.'**
  String get deploymentFleetManagerHasNotSubmitted;

  /// Your fleet manager is preparing the vehicle and its IoT unit. Your payment details appear here as soon as they are ready.
  ///
  /// In en, this message translates to:
  /// **'Your fleet manager is preparing the vehicle and its IoT unit. Your payment details appear here as soon as they are ready.'**
  String get deploymentFleetManagerPreparingVehicleIts;

  /// Your fleet manager is putting together your payment details. You will be asked to pay in a moment.
  ///
  /// In en, this message translates to:
  /// **'Your fleet manager is putting together your payment details. You will be asked to pay in a moment.'**
  String get deploymentFleetManagerPuttingTogetherPayment;

  /// Your fleet manager will allocate a scooter to you. We will bring you straight here when they do.
  ///
  /// In en, this message translates to:
  /// **'Your fleet manager will allocate a scooter to you. We will bring you straight here when they do.'**
  String get deploymentFleetManagerWillAllocateScooter;

  /// Go through each item with your team lead. Flag anything that is not right — it goes to the workshop with your note.
  ///
  /// In en, this message translates to:
  /// **'Go through each item with your team lead. Flag anything that is not right — it goes to the workshop with your note.'**
  String get deploymentGoThroughEachItemWith;

  /// How did you pay?
  ///
  /// In en, this message translates to:
  /// **'How did you pay?'**
  String get deploymentHowDidPay;

  /// Snack after the rider finishes the hygiene check
  ///
  /// In en, this message translates to:
  /// **'Hygiene check complete'**
  String get deploymentHygieneComplete;

  /// Inspection
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get deploymentInspection;

  /// Inspection accepted
  ///
  /// In en, this message translates to:
  /// **'Inspection accepted'**
  String get deploymentInspectionAccepted;

  /// Items marked as a problem go to your fleet manager with your notes. The handover continues on the rest.
  ///
  /// In en, this message translates to:
  /// **'Items marked as a problem go to your fleet manager with your notes. The handover continues on the rest.'**
  String get deploymentItemsMarkedAsProblemGo;

  /// Your fleet manager is on the next step for {vehicle}.
  ///
  /// In en, this message translates to:
  /// **'Your fleet manager is on the next step for {vehicle}.'**
  String deploymentManagerNextStep(String vehicle);

  /// No payment to show
  ///
  /// In en, this message translates to:
  /// **'No payment to show'**
  String get deploymentNoPaymentShow;

  /// Note for the workshop team
  ///
  /// In en, this message translates to:
  /// **'Note for the workshop team'**
  String get deploymentNoteWorkshopTeam;

  /// Open each module and read it through. Mandatory ones must be completed before you can finish.
  ///
  /// In en, this message translates to:
  /// **'Open each module and read it through. Mandatory ones must be completed before you can finish.'**
  String get deploymentOpenEachModuleReadThrough;

  /// Paid via
  ///
  /// In en, this message translates to:
  /// **'Paid via'**
  String get deploymentPaidVia;

  /// Payment received
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get deploymentPaymentReceived;

  /// Payment submitted
  ///
  /// In en, this message translates to:
  /// **'Payment submitted'**
  String get deploymentPaymentSubmitted;

  /// Pay for your scooter
  ///
  /// In en, this message translates to:
  /// **'Pay for your scooter'**
  String get deploymentPayScooter;

  /// Preparing your scooter
  ///
  /// In en, this message translates to:
  /// **'Preparing your scooter'**
  String get deploymentPreparingScooter;

  /// Your progress is saved. Sign in again any time to pick up where you left off.
  ///
  /// In en, this message translates to:
  /// **'Your progress is saved. Sign in again any time to pick up where you left off.'**
  String get deploymentProgressSavedSignAgainAny;

  /// Reference
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get deploymentReference;

  /// Reference or receipt number
  ///
  /// In en, this message translates to:
  /// **'Reference or receipt number'**
  String get deploymentReferenceReceiptNumber;

  /// Reference submitted
  ///
  /// In en, this message translates to:
  /// **'Reference submitted'**
  String get deploymentReferenceSubmitted;

  /// Reference submitted — waiting for verification
  ///
  /// In en, this message translates to:
  /// **'Reference submitted — waiting for verification'**
  String get deploymentReferenceSubmittedWaitingVerification;

  /// Required
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get deploymentRequired;

  /// Ride
  ///
  /// In en, this message translates to:
  /// **'Ride'**
  String get deploymentRide;

  /// Title of the rider hygiene screen during deployment
  ///
  /// In en, this message translates to:
  /// **'Rider Hygiene'**
  String get deploymentRiderHygiene;

  /// Scooter reserved
  ///
  /// In en, this message translates to:
  /// **'Scooter reserved'**
  String get deploymentScooterReserved;

  /// Submitted
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get deploymentSubmitted;

  /// Submit with problems flagged?
  ///
  /// In en, this message translates to:
  /// **'Submit with problems flagged?'**
  String get deploymentSubmitWithProblemsFlagged;

  /// Transaction reference
  ///
  /// In en, this message translates to:
  /// **'Transaction reference'**
  String get deploymentTransactionReference;

  /// UPI transaction ID, e.g. 4284 7192 3456
  ///
  /// In en, this message translates to:
  /// **'UPI transaction ID, e.g. 4284 7192 3456'**
  String get deploymentUpiTransactionIdEG;

  /// Waiting for an allocation
  ///
  /// In en, this message translates to:
  /// **'Waiting for an allocation'**
  String get deploymentWaitingAllocation;

  /// What is wrong?
  ///
  /// In en, this message translates to:
  /// **'What is wrong?'**
  String get deploymentWhatWrong;

  /// Your fleet manager is writing up the pre-delivery inspection for {vehicle}. You will check it over next.
  ///
  /// In en, this message translates to:
  /// **'Your fleet manager is writing up the pre-delivery inspection for {vehicle}. You will check it over next.'**
  String deploymentWritingPdi(String vehicle);

  /// Achieved
  ///
  /// In en, this message translates to:
  /// **'Achieved'**
  String get earningsAchieved;

  /// Active schemes
  ///
  /// In en, this message translates to:
  /// **'Active schemes'**
  String get earningsActiveSchemes;

  /// Already cleared and credited
  ///
  /// In en, this message translates to:
  /// **'Already cleared and credited'**
  String get earningsAlreadyClearedCredited;

  /// Bonuses you can still clear this week
  ///
  /// In en, this message translates to:
  /// **'Bonuses you can still clear this week'**
  String get earningsBonusesCanStillClearWeek;

  /// Cancelled trips do not count. Credited by midnight.
  ///
  /// In en, this message translates to:
  /// **'Cancelled trips do not count. Credited by midnight.'**
  String get earningsCancelledTripsDoNotCount;

  /// Check back tomorrow for new incentives.
  ///
  /// In en, this message translates to:
  /// **'Check back tomorrow for new incentives.'**
  String get earningsCheckBackTomorrowNewIncentives;

  /// Cleared
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get earningsCleared;

  /// Clear a scheme this week and it lands in your wallet instantly
  ///
  /// In en, this message translates to:
  /// **'Clear a scheme this week and it lands in your wallet instantly'**
  String get earningsClearSchemeWeekLandsWallet;

  /// Complete 20 trips today
  ///
  /// In en, this message translates to:
  /// **'Complete 20 trips today'**
  String get earningsComplete20TripsToday;

  /// Completed — reward credited to your wallet.
  ///
  /// In en, this message translates to:
  /// **'Completed — reward credited to your wallet.'**
  String get earningsCompletedRewardCreditedWallet;

  /// Could not load your incentives
  ///
  /// In en, this message translates to:
  /// **'Could not load your incentives'**
  String get earningsCouldNotLoadIncentives;

  /// Cover 400 km this week
  ///
  /// In en, this message translates to:
  /// **'Cover 400 km this week'**
  String get earningsCover400KmWeek;

  /// Daily
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get earningsDaily;

  /// Daily trip target
  ///
  /// In en, this message translates to:
  /// **'Daily trip target'**
  String get earningsDailyTripTarget;

  /// Earned this week
  ///
  /// In en, this message translates to:
  /// **'Earned this week'**
  String get earningsEarnedWeek;

  /// Evening surge
  ///
  /// In en, this message translates to:
  /// **'Evening surge'**
  String get earningsEveningSurge;

  /// Measured by the vehicle odometer, not the app.
  ///
  /// In en, this message translates to:
  /// **'Measured by the vehicle odometer, not the app.'**
  String get earningsMeasuredByVehicleOdometerNot;

  /// Monthly
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get earningsMonthly;

  /// No active schemes right now
  ///
  /// In en, this message translates to:
  /// **'No active schemes right now'**
  String get earningsNoActiveSchemesRightNow;

  /// One cleared scheme, so the achieved state is on screen.
  ///
  /// In en, this message translates to:
  /// **'One cleared scheme, so the achieved state is on screen.'**
  String get earningsOneClearedSchemeSoAchieved;

  /// Perfect week
  ///
  /// In en, this message translates to:
  /// **'Perfect week'**
  String get earningsPerfectWeek;

  /// Your referral completes 20 trips
  ///
  /// In en, this message translates to:
  /// **'Your referral completes 20 trips'**
  String get earningsReferralCompletes20Trips;

  /// Refer a rider
  ///
  /// In en, this message translates to:
  /// **'Refer a rider'**
  String get earningsReferRider;

  /// Ride between 6 pm and 9 pm in Okhla
  ///
  /// In en, this message translates to:
  /// **'Ride between 6 pm and 9 pm in Okhla'**
  String get earningsRideBetween6Pm9;

  /// Six days present with no late returns
  ///
  /// In en, this message translates to:
  /// **'Six days present with no late returns'**
  String get earningsSixDaysPresentWithNo;

  /// Terms
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get earningsTerms;

  /// Terms & conditions
  ///
  /// In en, this message translates to:
  /// **'Terms & conditions'**
  String get earningsTermsConditions;

  /// Turn extra trips into extra pay
  ///
  /// In en, this message translates to:
  /// **'Turn extra trips into extra pay'**
  String get earningsTurnExtraTripsIntoExtra;

  /// Weekly
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get earningsWeekly;

  /// Weekly distance
  ///
  /// In en, this message translates to:
  /// **'Weekly distance'**
  String get earningsWeeklyDistance;

  /// You need a scooter assigned to you for this.
  ///
  /// In en, this message translates to:
  /// **'You need a scooter assigned to you for this.'**
  String get errorActiveScooterRequired;

  /// Could not reach the server. Check your connection.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check your connection.'**
  String get errorCouldNotReachServerCheck;

  /// That did not look right.
  ///
  /// In en, this message translates to:
  /// **'That did not look right.'**
  String get errorDidNotLookRight;

  /// Inspection with rider
  ///
  /// In en, this message translates to:
  /// **'Inspection with rider'**
  String get errorInspectionWithRider;

  /// Payment pending
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get errorPaymentPending;

  /// We couldn't find the rider profile.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find the rider profile.'**
  String get errorRiderProfileMissing;

  /// The server took too long to answer.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to answer.'**
  String get errorServerTookTooLongAnswer;

  /// Your session has expired. Sign in again.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Sign in again.'**
  String get errorSessionHasExpiredSignAgain;

  /// Training in progress
  ///
  /// In en, this message translates to:
  /// **'Training in progress'**
  String get errorTrainingProgress;

  /// Unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get errorUnknown;

  /// Add your full name in the profile step first
  ///
  /// In en, this message translates to:
  /// **'Add your full name in the profile step first'**
  String get esignAddNameFirst;

  /// Signed
  ///
  /// In en, this message translates to:
  /// **'Signed'**
  String get esignSigned;

  /// Tap to sign
  ///
  /// In en, this message translates to:
  /// **'Tap to sign'**
  String get esignTapToSign;

  /// Your e-signature
  ///
  /// In en, this message translates to:
  /// **'Your e-signature'**
  String get esignTitle;

  /// Your name
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get esignYourName;

  /// Accepting means you agree to the new terms for this scooter.
  ///
  /// In en, this message translates to:
  /// **'Accepting means you agree to the new terms for this scooter.'**
  String get exchangeAcceptConfirm;

  /// Offer accepted
  ///
  /// In en, this message translates to:
  /// **'Offer accepted'**
  String get exchangeAccepted;

  /// Your new plan
  ///
  /// In en, this message translates to:
  /// **'Your new plan'**
  String get exchangeAcceptedOfferTitle;

  /// Accept offer
  ///
  /// In en, this message translates to:
  /// **'Accept offer'**
  String get exchangeAcceptOffer;

  /// Agreement history
  ///
  /// In en, this message translates to:
  /// **'Agreement history'**
  String get exchangeAgreementHistory;

  /// This exchange request will be closed.
  ///
  /// In en, this message translates to:
  /// **'This exchange request will be closed.'**
  String get exchangeCancelConfirm;

  /// Request cancelled
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get exchangeCancelled;

  /// Cancel request
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get exchangeCancelRequest;

  /// Why do you need an exchange?
  ///
  /// In en, this message translates to:
  /// **'Why do you need an exchange?'**
  String get exchangeChooseReason;

  /// Completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get exchangeCompleted;

  /// I have read and agree to the updated terms
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the updated terms'**
  String get exchangeConsent;

  /// Could not load exchanges
  ///
  /// In en, this message translates to:
  /// **'Could not load exchanges'**
  String get exchangeCouldNotLoad;

  /// Current scooter
  ///
  /// In en, this message translates to:
  /// **'Current scooter'**
  String get exchangeCurrentScooter;

  /// Pay {amount} more deposit before you collect your new scooter.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount} more deposit before you collect your new scooter.'**
  String exchangeDepositDue(String amount);

  /// Extra deposit kept by hub
  ///
  /// In en, this message translates to:
  /// **'Extra deposit kept by hub'**
  String get exchangeDepositHeld;

  /// Deposit moved over
  ///
  /// In en, this message translates to:
  /// **'Deposit moved over'**
  String get exchangeDepositMoved;

  /// Deposit refund
  ///
  /// In en, this message translates to:
  /// **'Deposit refund'**
  String get exchangeDepositRefund;

  /// Extra deposit to pay
  ///
  /// In en, this message translates to:
  /// **'Extra deposit to pay'**
  String get exchangeDepositToPay;

  /// Request details
  ///
  /// In en, this message translates to:
  /// **'Request details'**
  String get exchangeDetails;

  /// Exchange request
  ///
  /// In en, this message translates to:
  /// **'Exchange request'**
  String get exchangeDetailTitle;

  /// The old scooter has already been returned.
  ///
  /// In en, this message translates to:
  /// **'The old scooter has already been returned.'**
  String get exchangeErrorAlreadyReturned;

  /// The rider's battery plan isn't available for this scooter.
  ///
  /// In en, this message translates to:
  /// **'The rider\'s battery plan isn\'t available for this scooter.'**
  String get exchangeErrorBatteryPlan;

  /// Billing changed after the offer was accepted. Please contact support.
  ///
  /// In en, this message translates to:
  /// **'Billing changed after the offer was accepted. Please contact support.'**
  String get exchangeErrorBillingChanged;

  /// Your scooter has already been returned, so this request can't be cancelled here. Please contact your hub.
  ///
  /// In en, this message translates to:
  /// **'Your scooter has already been returned, so this request can\'t be cancelled here. Please contact your hub.'**
  String get exchangeErrorCannotCancel;

  /// This request was just updated. Pull down to refresh and try again.
  ///
  /// In en, this message translates to:
  /// **'This request was just updated. Pull down to refresh and try again.'**
  String get exchangeErrorChanged;

  /// Deposits aren't settled yet. Settle the deposits first.
  ///
  /// In en, this message translates to:
  /// **'Deposits aren\'t settled yet. Settle the deposits first.'**
  String get exchangeErrorDepositsUnsettled;

  /// Vehicle exchange isn't open right now. Please contact your hub.
  ///
  /// In en, this message translates to:
  /// **'Vehicle exchange isn\'t open right now. Please contact your hub.'**
  String get exchangeErrorDisabled;

  /// Clear your pending dues first. Breakdown and safety exchanges are still allowed.
  ///
  /// In en, this message translates to:
  /// **'Clear your pending dues first. Breakdown and safety exchanges are still allowed.'**
  String get exchangeErrorDuesPending;

  /// The new scooter hasn't been handed over yet. Finish the handover steps first.
  ///
  /// In en, this message translates to:
  /// **'The new scooter hasn\'t been handed over yet. Finish the handover steps first.'**
  String get exchangeErrorHandoverUnfinished;

  /// The scooter hold expired. Choose the replacement again.
  ///
  /// In en, this message translates to:
  /// **'The scooter hold expired. Choose the replacement again.'**
  String get exchangeErrorHoldExpired;

  /// Complete the return inspection first.
  ///
  /// In en, this message translates to:
  /// **'Complete the return inspection first.'**
  String get exchangeErrorInspectionUnfinished;

  /// We couldn't find an active rental for you.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find an active rental for you.'**
  String get exchangeErrorNoRental;

  /// The rider isn't eligible for this scooter.
  ///
  /// In en, this message translates to:
  /// **'The rider isn\'t eligible for this scooter.'**
  String get exchangeErrorNotEligible;

  /// Rider terms aren't set up. Ask an admin to publish one active set of terms.
  ///
  /// In en, this message translates to:
  /// **'Rider terms aren\'t set up. Ask an admin to publish one active set of terms.'**
  String get exchangeErrorNoTerms;

  /// This exchange request no longer exists.
  ///
  /// In en, this message translates to:
  /// **'This exchange request no longer exists.'**
  String get exchangeErrorNotFound;

  /// This offer is no longer open.
  ///
  /// In en, this message translates to:
  /// **'This offer is no longer open.'**
  String get exchangeErrorOfferClosed;

  /// We couldn't verify this offer. Ask your hub to send it again.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t verify this offer. Ask your hub to send it again.'**
  String get exchangeErrorOfferInvalid;

  /// Pricing isn't set up for this scooter yet. Ask your operator to check the rate card.
  ///
  /// In en, this message translates to:
  /// **'Pricing isn\'t set up for this scooter yet. Ask your operator to check the rate card.'**
  String get exchangeErrorPricingSetup;

  /// Some records for this exchange are missing. Please contact support.
  ///
  /// In en, this message translates to:
  /// **'Some records for this exchange are missing. Please contact support.'**
  String get exchangeErrorRecordsMissing;

  /// Your rental isn't active, so an exchange can't be requested.
  ///
  /// In en, this message translates to:
  /// **'Your rental isn\'t active, so an exchange can\'t be requested.'**
  String get exchangeErrorRentalInactive;

  /// Finish the old scooter's return before choosing a replacement.
  ///
  /// In en, this message translates to:
  /// **'Finish the old scooter\'s return before choosing a replacement.'**
  String get exchangeErrorReturnFirst;

  /// The return isn't finished yet. Verify the rider's OTP and complete the return first.
  ///
  /// In en, this message translates to:
  /// **'The return isn\'t finished yet. Verify the rider\'s OTP and complete the return first.'**
  String get exchangeErrorReturnUnfinished;

  /// Pick a different scooter from the rider's current one.
  ///
  /// In en, this message translates to:
  /// **'Pick a different scooter from the rider\'s current one.'**
  String get exchangeErrorSameScooter;

  /// That scooter is reserved for another exchange.
  ///
  /// In en, this message translates to:
  /// **'That scooter is reserved for another exchange.'**
  String get exchangeErrorScooterReserved;

  /// That scooter is no longer available. Pick another one.
  ///
  /// In en, this message translates to:
  /// **'That scooter is no longer available. Pick another one.'**
  String get exchangeErrorScooterUnavailable;

  /// This scooter needs a different security deposit. Change the deposit separately first.
  ///
  /// In en, this message translates to:
  /// **'This scooter needs a different security deposit. Change the deposit separately first.'**
  String get exchangeErrorSecurityChange;

  /// The rider's security deposit needs a top-up before completing.
  ///
  /// In en, this message translates to:
  /// **'The rider\'s security deposit needs a top-up before completing.'**
  String get exchangeErrorSecurityTopUp;

  /// Your rental changed after this offer was made. Ask your hub for a new offer.
  ///
  /// In en, this message translates to:
  /// **'Your rental changed after this offer was made. Ask your hub for a new offer.'**
  String get exchangeErrorStale;

  /// You've had this scooter for too short a time. Please try again in a few days.
  ///
  /// In en, this message translates to:
  /// **'You\'ve had this scooter for too short a time. Please try again in a few days.'**
  String get exchangeErrorTooSoon;

  /// Extra rent now
  ///
  /// In en, this message translates to:
  /// **'Extra rent now'**
  String get exchangeExtraRentNow;

  /// Exchange fee
  ///
  /// In en, this message translates to:
  /// **'Exchange fee'**
  String get exchangeFee;

  /// Waived
  ///
  /// In en, this message translates to:
  /// **'Waived'**
  String get exchangeFeeWaived;

  /// Reason from hub
  ///
  /// In en, this message translates to:
  /// **'Reason from hub'**
  String get exchangeHubReason;

  /// Needs your answer
  ///
  /// In en, this message translates to:
  /// **'Needs your answer'**
  String get exchangeNeedsYou;

  /// New rent
  ///
  /// In en, this message translates to:
  /// **'New rent'**
  String get exchangeNewRent;

  /// New rent starts
  ///
  /// In en, this message translates to:
  /// **'New rent starts'**
  String get exchangeNewRentFrom;

  /// New scooter
  ///
  /// In en, this message translates to:
  /// **'New scooter'**
  String get exchangeNewScooter;

  /// Approved. Your hub will ask you to bring your current scooter in for a check.
  ///
  /// In en, this message translates to:
  /// **'Approved. Your hub will ask you to bring your current scooter in for a check.'**
  String get exchangeNextApproved;

  /// Exchange requested, waiting for drop-off
  ///
  /// In en, this message translates to:
  /// **'Bring your current scooter to the hub you picked on {date}. The hub team will check it in.'**
  String exchangeNextBringIn(String date);

  /// This request was cancelled.
  ///
  /// In en, this message translates to:
  /// **'This request was cancelled.'**
  String get exchangeNextCancelled;

  /// The hub team is checking your current scooter. You'll get a code on your phone to confirm the mechanic's report.
  ///
  /// In en, this message translates to:
  /// **'The hub team is checking your current scooter. You\'ll get a code on your phone to confirm the mechanic\'s report.'**
  String get exchangeNextCheckingIn;

  /// Your old scooter is returned. Your hub is picking a replacement for you.
  ///
  /// In en, this message translates to:
  /// **'Your old scooter is returned. Your hub is picking a replacement for you.'**
  String get exchangeNextChoosing;

  /// Exchange complete. Enjoy your new scooter!
  ///
  /// In en, this message translates to:
  /// **'Exchange complete. Enjoy your new scooter!'**
  String get exchangeNextCompleted;

  /// Offer accepted. Your hub is settling the deposit for your new scooter.
  ///
  /// In en, this message translates to:
  /// **'Offer accepted. Your hub is settling the deposit for your new scooter.'**
  String get exchangeNextDeposit;

  /// This request expired before it was completed.
  ///
  /// In en, this message translates to:
  /// **'This request expired before it was completed.'**
  String get exchangeNextExpired;

  /// Your new scooter is ready. Collect it from the hub.
  ///
  /// In en, this message translates to:
  /// **'Your new scooter is ready. Collect it from the hub.'**
  String get exchangeNextHandover;

  /// Your offer is ready. Check the details and accept or reject it.
  ///
  /// In en, this message translates to:
  /// **'Your offer is ready. Check the details and accept or reject it.'**
  String get exchangeNextOffer;

  /// Your hub couldn't approve this request.
  ///
  /// In en, this message translates to:
  /// **'Your hub couldn\'t approve this request.'**
  String get exchangeNextRejected;

  /// Your hub will review your request soon.
  ///
  /// In en, this message translates to:
  /// **'Your hub will review your request soon.'**
  String get exchangeNextRequested;

  /// A replacement scooter is reserved for you. Your offer will be ready soon.
  ///
  /// In en, this message translates to:
  /// **'A replacement scooter is reserved for you. Your offer will be ready soon.'**
  String get exchangeNextReserved;

  /// Return your current scooter at the hub so they can inspect it.
  ///
  /// In en, this message translates to:
  /// **'Return your current scooter at the hub so they can inspect it.'**
  String get exchangeNextReturn;

  /// No exchange requests
  ///
  /// In en, this message translates to:
  /// **'No exchange requests'**
  String get exchangeNone;

  /// If your scooter has a problem, request an exchange and your hub will help.
  ///
  /// In en, this message translates to:
  /// **'If your scooter has a problem, request an exchange and your hub will help.'**
  String get exchangeNoneMessage;

  /// You can request an exchange once a scooter is rented to you.
  ///
  /// In en, this message translates to:
  /// **'You can request an exchange once a scooter is rented to you.'**
  String get exchangeNoRentalBody;

  /// No active rental
  ///
  /// In en, this message translates to:
  /// **'No active rental'**
  String get exchangeNoRentalTitle;

  /// Describe the problem (optional)
  ///
  /// In en, this message translates to:
  /// **'Describe the problem (optional)'**
  String get exchangeNoteHint;

  /// Note for your hub
  ///
  /// In en, this message translates to:
  /// **'Note for your hub'**
  String get exchangeNoteLabel;

  /// Your note
  ///
  /// In en, this message translates to:
  /// **'Your note'**
  String get exchangeNotes;

  /// This offer has expired. Your hub can send a new one.
  ///
  /// In en, this message translates to:
  /// **'This offer has expired. Your hub can send a new one.'**
  String get exchangeOfferExpiredMessage;

  /// Offer valid till
  ///
  /// In en, this message translates to:
  /// **'Offer valid till'**
  String get exchangeOfferExpires;

  /// Your offer
  ///
  /// In en, this message translates to:
  /// **'Your offer'**
  String get exchangeOfferTitle;

  /// In progress
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get exchangeOpen;

  /// You already have an exchange in progress.
  ///
  /// In en, this message translates to:
  /// **'You already have an exchange in progress.'**
  String get exchangeOpenExists;

  /// Finished
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get exchangePast;

  /// / day
  ///
  /// In en, this message translates to:
  /// **'/ day'**
  String get exchangePerDay;

  /// / 2 weeks
  ///
  /// In en, this message translates to:
  /// **'/ 2 weeks'**
  String get exchangePerFortnight;

  /// / month
  ///
  /// In en, this message translates to:
  /// **'/ month'**
  String get exchangePerMonth;

  /// / 3 months
  ///
  /// In en, this message translates to:
  /// **'/ 3 months'**
  String get exchangePerQuarter;

  /// / week
  ///
  /// In en, this message translates to:
  /// **'/ week'**
  String get exchangePerWeek;

  /// Progress
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get exchangeProgress;

  /// Raised
  ///
  /// In en, this message translates to:
  /// **'Raised'**
  String get exchangeRaised;

  /// Read the terms
  ///
  /// In en, this message translates to:
  /// **'Read the terms'**
  String get exchangeReadTerms;

  /// Reason
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get exchangeReason;

  /// Breakdown
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get exchangeReasonBreakdown;

  /// It stopped working or keeps breaking down
  ///
  /// In en, this message translates to:
  /// **'It stopped working or keeps breaking down'**
  String get exchangeReasonBreakdownHint;

  /// Something else
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get exchangeReasonOtherHint;

  /// Safety swap
  ///
  /// In en, this message translates to:
  /// **'Safety swap'**
  String get exchangeReasonSafety;

  /// A safety check needs a different scooter
  ///
  /// In en, this message translates to:
  /// **'A safety check needs a different scooter'**
  String get exchangeReasonSafetyHint;

  /// Not safe to ride
  ///
  /// In en, this message translates to:
  /// **'Not safe to ride'**
  String get exchangeReasonUnsafe;

  /// Brakes, lights or tyres don't feel safe
  ///
  /// In en, this message translates to:
  /// **'Brakes, lights or tyres don\'t feel safe'**
  String get exchangeReasonUnsafeHint;

  /// Upgrade
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get exchangeReasonUpgrade;

  /// You'd like a different model
  ///
  /// In en, this message translates to:
  /// **'You\'d like a different model'**
  String get exchangeReasonUpgradeHint;

  /// Offer rejected
  ///
  /// In en, this message translates to:
  /// **'Offer rejected'**
  String get exchangeRejected;

  /// Reject offer
  ///
  /// In en, this message translates to:
  /// **'Reject offer'**
  String get exchangeRejectOffer;

  /// Reason
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get exchangeRejectReason;

  /// Please write a reason
  ///
  /// In en, this message translates to:
  /// **'Please write a reason'**
  String get exchangeRejectReasonRequired;

  /// Tell your hub why, so they can send a better one.
  ///
  /// In en, this message translates to:
  /// **'Tell your hub why, so they can send a better one.'**
  String get exchangeRejectSubtitle;

  /// Could not load your rental
  ///
  /// In en, this message translates to:
  /// **'Could not load your rental'**
  String get exchangeRentalCouldNotLoad;

  /// Rent credit
  ///
  /// In en, this message translates to:
  /// **'Rent credit'**
  String get exchangeRentCredit;

  /// Request an exchange
  ///
  /// In en, this message translates to:
  /// **'Request an exchange'**
  String get exchangeRequestAction;

  /// Exchange request sent
  ///
  /// In en, this message translates to:
  /// **'Exchange request sent'**
  String get exchangeRequestSent;

  /// Tell your hub why you need a different scooter.
  ///
  /// In en, this message translates to:
  /// **'Tell your hub why you need a different scooter.'**
  String get exchangeRequestSubtitle;

  /// Drop-off date
  ///
  /// In en, this message translates to:
  /// **'Drop-off date'**
  String get exchangeReturnDate;

  /// Send request
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get exchangeSendRequest;

  /// Accepted
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get exchangeStageAccepted;

  /// Completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get exchangeStageCompleted;

  /// Handover
  ///
  /// In en, this message translates to:
  /// **'Handover'**
  String get exchangeStageHandover;

  /// Offer ready
  ///
  /// In en, this message translates to:
  /// **'Offer ready'**
  String get exchangeStageOfferReady;

  /// Requested
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get exchangeStageRequested;

  /// Approved
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get exchangeStatusApproved;

  /// Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get exchangeStatusCancelled;

  /// Checking in
  ///
  /// In en, this message translates to:
  /// **'Checking in'**
  String get exchangeStatusCheckingIn;

  /// Choosing scooter
  ///
  /// In en, this message translates to:
  /// **'Choosing scooter'**
  String get exchangeStatusChoosing;

  /// Expired
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get exchangeStatusExpired;

  /// Rejected
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get exchangeStatusRejected;

  /// Return scooter
  ///
  /// In en, this message translates to:
  /// **'Return scooter'**
  String get exchangeStatusReturn;

  /// Hub approval
  ///
  /// In en, this message translates to:
  /// **'Hub approval'**
  String get exchangeStepApproval;

  /// Deposit
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get exchangeStepDeposit;

  /// Get new scooter
  ///
  /// In en, this message translates to:
  /// **'Get new scooter'**
  String get exchangeStepHandover;

  /// Replacement offer
  ///
  /// In en, this message translates to:
  /// **'Replacement offer'**
  String get exchangeStepOffer;

  /// Request sent
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get exchangeStepRequested;

  /// Return old scooter
  ///
  /// In en, this message translates to:
  /// **'Return old scooter'**
  String get exchangeStepReturn;

  /// Ask for a different scooter
  ///
  /// In en, this message translates to:
  /// **'Ask for a different scooter'**
  String get exchangeSubtitle;

  /// Vehicle exchange
  ///
  /// In en, this message translates to:
  /// **'Vehicle exchange'**
  String get exchangeTitle;

  /// Current
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get exchangeVersionCurrent;

  /// From {date}
  ///
  /// In en, this message translates to:
  /// **'From {date}'**
  String exchangeVersionFrom(String date);

  /// Version {number}
  ///
  /// In en, this message translates to:
  /// **'Version {number}'**
  String exchangeVersionNumber(String number);

  /// Previous
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get exchangeVersionPrevious;

  /// When and where
  ///
  /// In en, this message translates to:
  /// **'When and where'**
  String get exchangeWhenWhere;

  /// Pick when and where you'll bring your current scooter in.
  ///
  /// In en, this message translates to:
  /// **'Pick when and where you\'ll bring your current scooter in.'**
  String get exchangeWhenWhereHint;

  /// Bonus unlocked
  ///
  /// In en, this message translates to:
  /// **'Bonus unlocked'**
  String get homeBonusUnlocked;

  /// Book a slot at the Okhla hub before the odometer hits 8,000 km.
  ///
  /// In en, this message translates to:
  /// **'Book a slot at the Okhla hub before the odometer hits 8,000 km.'**
  String get homeBookSlotOkhlaHubBefore;

  /// Category
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get homeCategory;

  /// Could not load your dashboard
  ///
  /// In en, this message translates to:
  /// **'Could not load your dashboard'**
  String get homeCouldNotLoadDashboard;

  /// Daily Rental
  ///
  /// In en, this message translates to:
  /// **'Daily Rental'**
  String get homeDailyRental;

  /// Deposits and handover fees
  ///
  /// In en, this message translates to:
  /// **'Deposits and handover fees'**
  String get homeDepositsHandoverFees;

  /// Extra ₹15 a trip in Okhla Phase II and Jasola this evening.
  ///
  /// In en, this message translates to:
  /// **'Extra ₹15 a trip in Okhla Phase II and Jasola this evening.'**
  String get homeExtra15TripOkhlaPhase;

  /// Help & support
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get homeHelpSupport;

  /// History
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get homeHistory;

  /// Incentive earned
  ///
  /// In en, this message translates to:
  /// **'Incentive earned'**
  String get homeIncentiveEarned;

  /// Mark absent
  ///
  /// In en, this message translates to:
  /// **'Mark absent'**
  String get homeMarkAbsent;

  /// Mark attendance to start the scooter
  ///
  /// In en, this message translates to:
  /// **'Mark attendance to start the scooter'**
  String get homeMarkAttendanceStartScooter;

  /// Marked absent. The scooter is now disabled.
  ///
  /// In en, this message translates to:
  /// **'Marked absent. The scooter is now disabled.'**
  String get homeMarkedAbsentScooterNowDisabled;

  /// Marked present
  ///
  /// In en, this message translates to:
  /// **'Marked present'**
  String get homeMarkedPresent;

  /// Mark yourself absent?
  ///
  /// In en, this message translates to:
  /// **'Mark yourself absent?'**
  String get homeMarkYourselfAbsent;

  /// Mark yourself present to switch the vehicle on.
  ///
  /// In en, this message translates to:
  /// **'Mark yourself present to switch the vehicle on.'**
  String get homeMarkYourselfPresentSwitchVehicle;

  /// Mon – Sun
  ///
  /// In en, this message translates to:
  /// **'Mon – Sun'**
  String get homeMonSun;

  /// Not marked present
  ///
  /// In en, this message translates to:
  /// **'Not marked present'**
  String get homeNotMarkedPresent;

  /// Online
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get homeOnline;

  /// Personal details and KYC
  ///
  /// In en, this message translates to:
  /// **'Personal details and KYC'**
  String get homePersonalDetailsKyc;

  /// Rent
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get homeRent;

  /// Rent due
  ///
  /// In en, this message translates to:
  /// **'Rent due'**
  String get homeRentDue;

  /// Riding late
  ///
  /// In en, this message translates to:
  /// **'Riding late'**
  String get homeRidingLate;

  /// Scooter
  ///
  /// In en, this message translates to:
  /// **'Scooter'**
  String get homeScooter;

  /// Service due in 240 km
  ///
  /// In en, this message translates to:
  /// **'Service due in 240 km'**
  String get homeServiceDue240Km;

  /// Your shift will end and the scooter will switch off. Rent still applies on weekly and monthly plans.
  ///
  /// In en, this message translates to:
  /// **'Your shift will end and the scooter will switch off. Rent still applies on weekly and monthly plans.'**
  String get homeShiftWillEndScooterWill;

  /// Surge in Okhla till 9 pm
  ///
  /// In en, this message translates to:
  /// **'Surge in Okhla till 9 pm'**
  String get homeSurgeOkhlaTill9Pm;

  /// Today's earnings
  ///
  /// In en, this message translates to:
  /// **'Today\'s earnings'**
  String get homeTodaysEarnings;

  /// Vehicle on
  ///
  /// In en, this message translates to:
  /// **'Vehicle on'**
  String get homeVehicle;

  /// Vehicle off
  ///
  /// In en, this message translates to:
  /// **'Vehicle off'**
  String get homeVehicleOff;

  /// Withdraw
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get homeWithdraw;

  /// Working Days
  ///
  /// In en, this message translates to:
  /// **'Working Days'**
  String get homeWorkingDays;

  /// All hubs
  ///
  /// In en, this message translates to:
  /// **'All hubs'**
  String get hubAllHubs;

  /// Allocate
  ///
  /// In en, this message translates to:
  /// **'Allocate'**
  String get hubAllocate;

  /// Allotments in Queue
  ///
  /// In en, this message translates to:
  /// **'Allotments in Queue'**
  String get hubAllotmentsInQueue;

  /// Active riders at this hub who are waiting for a vehicle.
  ///
  /// In en, this message translates to:
  /// **'Active riders at this hub who are waiting for a vehicle.'**
  String get hubAllotmentsInQueueInfo;

  /// Bays free
  ///
  /// In en, this message translates to:
  /// **'Bays free'**
  String get hubBaysFree;

  /// Choose a hub
  ///
  /// In en, this message translates to:
  /// **'Choose a hub'**
  String get hubChooseHub;

  /// See one hub, or all your hubs together.
  ///
  /// In en, this message translates to:
  /// **'See one hub, or all your hubs together.'**
  String get hubChooseHubSubtitle;

  /// Could not load your hub
  ///
  /// In en, this message translates to:
  /// **'Could not load your hub'**
  String get hubCouldNotLoadHub;

  /// Number of hubs assigned to the manager
  ///
  /// In en, this message translates to:
  /// **'{count} hubs'**
  String hubCount(int count);

  /// Fleet Manager
  ///
  /// In en, this message translates to:
  /// **'Fleet Manager'**
  String get hubFleetManager;

  /// Fleet utilisation
  ///
  /// In en, this message translates to:
  /// **'Fleet utilisation'**
  String get hubFleetUtilisation;

  /// Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get hubHome;

  /// Your hub at a glance
  ///
  /// In en, this message translates to:
  /// **'Your hub at a glance'**
  String get hubHubGlance;

  /// Maintenance
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get hubMaintenance;

  /// Marked absent. Your shift is closed.
  ///
  /// In en, this message translates to:
  /// **'Marked absent. Your shift is closed.'**
  String get hubMarkedAbsentShiftClosed;

  /// No hub is assigned to you.
  ///
  /// In en, this message translates to:
  /// **'No hub is assigned to you.'**
  String get hubNoHubAssigned;

  /// Quick Hub View
  ///
  /// In en, this message translates to:
  /// **'Quick Hub View'**
  String get hubQuickView;

  /// Live counts for your selected hub.
  ///
  /// In en, this message translates to:
  /// **'Live counts for your selected hub.'**
  String get hubQuickViewInfo;

  /// Return
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get hubReturn;

  /// RFDs available
  ///
  /// In en, this message translates to:
  /// **'RFDs available'**
  String get hubRfdsAvailable;

  /// Ready for deployment: vehicles at this hub that are free to allot.
  ///
  /// In en, this message translates to:
  /// **'Ready for deployment: vehicles at this hub that are free to allot.'**
  String get hubRfdsAvailableInfo;

  /// Could not load nearby hubs
  ///
  /// In en, this message translates to:
  /// **'Could not load nearby hubs'**
  String get hubsCouldNotLoad;

  /// Service
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get hubService;

  /// On shift
  ///
  /// In en, this message translates to:
  /// **'On shift'**
  String get hubShift;

  /// Show data for
  ///
  /// In en, this message translates to:
  /// **'Show data for'**
  String get hubShowDataFor;

  /// There are no active hubs within reach of your location.
  ///
  /// In en, this message translates to:
  /// **'There are no active hubs within reach of your location.'**
  String get hubsNoneBody;

  /// No hubs near you
  ///
  /// In en, this message translates to:
  /// **'No hubs near you'**
  String get hubsNoneTitle;

  /// Something went wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get hubSomethingWentWrong;

  /// Closest hubs to you
  ///
  /// In en, this message translates to:
  /// **'Closest hubs to you'**
  String get hubsSubtitle;

  /// Submissions in Queue
  ///
  /// In en, this message translates to:
  /// **'Submissions in Queue'**
  String get hubSubmissionsInQueue;

  /// Returns and exchanges due at this hub whose vehicle check-in isn't complete yet.
  ///
  /// In en, this message translates to:
  /// **'Returns and exchanges due at this hub whose vehicle check-in isn\'t complete yet.'**
  String get hubSubmissionsInQueueInfo;

  /// Under Maintenance Fleet
  ///
  /// In en, this message translates to:
  /// **'Under Maintenance Fleet'**
  String get hubUnderMaintenanceFleet;

  /// Vehicles from this hub that are under maintenance right now.
  ///
  /// In en, this message translates to:
  /// **'Vehicles from this hub that are under maintenance right now.'**
  String get hubUnderMaintenanceFleetInfo;

  /// Uptime
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get hubUptime;

  /// Working late
  ///
  /// In en, this message translates to:
  /// **'Working late'**
  String get hubWorkingLate;

  /// Say whether the scooter is safe to give out again.
  ///
  /// In en, this message translates to:
  /// **'Say whether the scooter is safe to give out again.'**
  String get inspectionErrorSafeForReuse;

  /// Add why the scooter isn't safe to give out again.
  ///
  /// In en, this message translates to:
  /// **'Add why the scooter isn\'t safe to give out again.'**
  String get inspectionErrorUnsafeReason;

  /// Could not load the intro slides.
  ///
  /// In en, this message translates to:
  /// **'Could not load the intro slides.'**
  String get introCouldNotLoad;

  /// Daily payouts, transparent incentives and a rental plan that fits how much you actually ride.
  ///
  /// In en, this message translates to:
  /// **'Daily payouts, transparent incentives and a rental plan that fits how much you actually ride.'**
  String get introEarnBody;

  /// Same-day settlement
  ///
  /// In en, this message translates to:
  /// **'Same-day settlement'**
  String get introEarnHighlight1;

  /// No hidden deductions
  ///
  /// In en, this message translates to:
  /// **'No hidden deductions'**
  String get introEarnHighlight2;

  /// Earn more, ride cleaner
  ///
  /// In en, this message translates to:
  /// **'Earn more,\nride cleaner'**
  String get introEarnTitle;

  /// Roadside assistance, service booking and a team lead who can see exactly what you see.
  ///
  /// In en, this message translates to:
  /// **'Roadside assistance, service booking and a team lead who can see exactly what you see.'**
  String get introSupportBody;

  /// 24x7 roadside help
  ///
  /// In en, this message translates to:
  /// **'24x7 roadside help'**
  String get introSupportHighlight1;

  /// Service at your hub
  ///
  /// In en, this message translates to:
  /// **'Service at your hub'**
  String get introSupportHighlight2;

  /// Help that shows up
  ///
  /// In en, this message translates to:
  /// **'Help that\nshows up'**
  String get introSupportTitle;

  /// Live battery, range and health from the onboard IoT unit. Unlock and start your shift from the app.
  ///
  /// In en, this message translates to:
  /// **'Live battery, range and health from the onboard IoT unit. Unlock and start your shift from the app.'**
  String get introVehicleBody;

  /// Live telemetry
  ///
  /// In en, this message translates to:
  /// **'Live telemetry'**
  String get introVehicleHighlight1;

  /// One-tap start
  ///
  /// In en, this message translates to:
  /// **'One-tap start'**
  String get introVehicleHighlight2;

  /// Your scooter, fully connected
  ///
  /// In en, this message translates to:
  /// **'Your scooter,\nfully connected'**
  String get introVehicleTitle;

  /// App
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get legalAppName;

  /// Could not load this document
  ///
  /// In en, this message translates to:
  /// **'Could not load this document'**
  String get legalDocumentCouldNotLoad;

  /// Add a note
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get maintenanceAddNote;

  /// Add note
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get maintenanceAddNote2;

  /// Assign to
  ///
  /// In en, this message translates to:
  /// **'Assign to'**
  String get maintenanceAssign;

  /// Assigned vendor
  ///
  /// In en, this message translates to:
  /// **'Assigned vendor'**
  String get maintenanceAssignedVendor;

  /// Assign a vendor
  ///
  /// In en, this message translates to:
  /// **'Assign a vendor'**
  String get maintenanceAssignVendor;

  /// Assign a vendor to start work
  ///
  /// In en, this message translates to:
  /// **'Assign a vendor to start work'**
  String get maintenanceAssignVendorStartWork;

  /// Awaiting vendor assignment
  ///
  /// In en, this message translates to:
  /// **'Awaiting vendor assignment'**
  String get maintenanceAwaitingVendorAssignment;

  /// Battery
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get maintenanceBattery;

  /// Battery specialist
  ///
  /// In en, this message translates to:
  /// **'Battery specialist'**
  String get maintenanceBatterySpecialist;

  /// Bay
  ///
  /// In en, this message translates to:
  /// **'Bay'**
  String get maintenanceBay;

  /// Body
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get maintenanceBody;

  /// Body and paint
  ///
  /// In en, this message translates to:
  /// **'Body and paint'**
  String get maintenanceBodyPaint;

  /// You can also assign this later
  ///
  /// In en, this message translates to:
  /// **'You can also assign this later'**
  String get maintenanceCanAlsoAssignLater;

  /// Cell balance test booked for this afternoon
  ///
  /// In en, this message translates to:
  /// **'Cell balance test booked for this afternoon'**
  String get maintenanceCellBalanceTestBookedAfternoon;

  /// Charge holds to 62% then drops to 40% within a kilometre.
  ///
  /// In en, this message translates to:
  /// **'Charge holds to 62% then drops to 40% within a kilometre.'**
  String get maintenanceChargeHolds62ThenDrops;

  /// Choose later
  ///
  /// In en, this message translates to:
  /// **'Choose later'**
  String get maintenanceChooseLater;

  /// Closed
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get maintenanceClosed;

  /// Close job
  ///
  /// In en, this message translates to:
  /// **'Close job'**
  String get maintenanceCloseJob;

  /// Close this job?
  ///
  /// In en, this message translates to:
  /// **'Close this job?'**
  String get maintenanceCloseJob2;

  /// Completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get maintenanceCompleted;

  /// Cost breakdown
  ///
  /// In en, this message translates to:
  /// **'Cost breakdown'**
  String get maintenanceCostBreakdown;

  /// Could not load the form
  ///
  /// In en, this message translates to:
  /// **'Could not load the form'**
  String get maintenanceCouldNotLoadForm;

  /// Could not load this job
  ///
  /// In en, this message translates to:
  /// **'Could not load this job'**
  String get maintenanceCouldNotLoadJob;

  /// Could not load the maintenance board
  ///
  /// In en, this message translates to:
  /// **'Could not load the maintenance board'**
  String get maintenanceCouldNotLoadMaintenanceBoard;

  /// Describe the issue
  ///
  /// In en, this message translates to:
  /// **'Describe the issue'**
  String get maintenanceDescribeIssue;

  /// Front tyre worn past the wear bar.
  ///
  /// In en, this message translates to:
  /// **'Front tyre worn past the wear bar.'**
  String get maintenanceFrontTyreWornPastWear;

  /// e.g. 9420
  ///
  /// In en, this message translates to:
  /// **'e.g. 9420'**
  String get maintenanceHintOdometer;

  /// e.g. Unit not powering on; workshop ticket raised
  ///
  /// In en, this message translates to:
  /// **'e.g. Unit not powering on; workshop ticket raised'**
  String get maintenanceHintUnitNotPowering;

  /// Issue
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get maintenanceIssue;

  /// Issue close-up
  ///
  /// In en, this message translates to:
  /// **'Issue close-up'**
  String get maintenanceIssueCloseUp;

  /// Issue description
  ///
  /// In en, this message translates to:
  /// **'Issue description'**
  String get maintenanceIssueDescription;

  /// Job
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get maintenanceJob;

  /// Job details
  ///
  /// In en, this message translates to:
  /// **'Job details'**
  String get maintenanceJobDetails;

  /// That job is no longer on the board.
  ///
  /// In en, this message translates to:
  /// **'That job is no longer on the board.'**
  String get maintenanceJobNoLongerBoard;

  /// Job timeline
  ///
  /// In en, this message translates to:
  /// **'Job timeline'**
  String get maintenanceJobTimeline;

  /// Job type
  ///
  /// In en, this message translates to:
  /// **'Job type'**
  String get maintenanceJobType;

  /// In kilometres, as shown on the cluster.
  ///
  /// In en, this message translates to:
  /// **'In kilometres, as shown on the cluster.'**
  String get maintenanceKilometresAsShownCluster;

  /// Labour
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get maintenanceLabour;

  /// Maintenance board
  ///
  /// In en, this message translates to:
  /// **'Maintenance board'**
  String get maintenanceMaintenanceBoard;

  /// No jobs here
  ///
  /// In en, this message translates to:
  /// **'No jobs here'**
  String get maintenanceNoJobsHere;

  /// No notes yet
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get maintenanceNoNotesYet;

  /// Note
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get maintenanceNote;

  /// Note added.
  ///
  /// In en, this message translates to:
  /// **'Note added.'**
  String get maintenanceNoteAdded;

  /// Notes
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get maintenanceNotes;

  /// Nothing matches this queue and filter right now.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches this queue and filter right now.'**
  String get maintenanceNothingMatchesQueueFilterRight;

  /// No vendors available to reassign right now.
  ///
  /// In en, this message translates to:
  /// **'No vendors available to reassign right now.'**
  String get maintenanceNoVendorsAvailableReassignRight;

  /// Odometer reading
  ///
  /// In en, this message translates to:
  /// **'Odometer reading'**
  String get maintenanceOdometerReading;

  /// Overdue
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get maintenanceOverdue;

  /// Pads measured at 1.2 mm
  ///
  /// In en, this message translates to:
  /// **'Pads measured at 1.2 mm'**
  String get maintenancePadsMeasured12Mm;

  /// Panel resprayed and refitted
  ///
  /// In en, this message translates to:
  /// **'Panel resprayed and refitted'**
  String get maintenancePanelResprayedRefitted;

  /// Parts
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get maintenanceParts;

  /// Photo evidence
  ///
  /// In en, this message translates to:
  /// **'Photo evidence'**
  String get maintenancePhotoEvidence;

  /// Pre-delivery
  ///
  /// In en, this message translates to:
  /// **'Pre-delivery'**
  String get maintenancePreDelivery;

  /// Priority
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get maintenancePriority;

  /// In progress
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get maintenanceProgress;

  /// Raise a job
  ///
  /// In en, this message translates to:
  /// **'Raise a job'**
  String get maintenanceRaiseJob;

  /// Raise job
  ///
  /// In en, this message translates to:
  /// **'Raise job'**
  String get maintenanceRaiseJob2;

  /// Raising a maintenance job needs an API that does not exist yet.
  ///
  /// In en, this message translates to:
  /// **'Raising a maintenance job needs an API that does not exist yet.'**
  String get maintenanceRaisingMaintenanceJobNeedsApi;

  /// Rear brake bites late and squeals under load.
  ///
  /// In en, this message translates to:
  /// **'Rear brake bites late and squeals under load.'**
  String get maintenanceRearBrakeBitesLateSqueals;

  /// Reassign
  ///
  /// In en, this message translates to:
  /// **'Reassign'**
  String get maintenanceReassign;

  /// Reassign vendor
  ///
  /// In en, this message translates to:
  /// **'Reassign vendor'**
  String get maintenanceReassignVendor;

  /// Replacement set ordered
  ///
  /// In en, this message translates to:
  /// **'Replacement set ordered'**
  String get maintenanceReplacementSetOrdered;

  /// Rider on file
  ///
  /// In en, this message translates to:
  /// **'Rider on file'**
  String get maintenanceRiderFile;

  /// Save note
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get maintenanceSaveNote;

  /// Scheduled service
  ///
  /// In en, this message translates to:
  /// **'Scheduled service'**
  String get maintenanceScheduledService;

  /// Scuffed side panel after a parking knock.
  ///
  /// In en, this message translates to:
  /// **'Scuffed side panel after a parking knock.'**
  String get maintenanceScuffedSidePanelAfterParking;

  /// Search vehicle, job ID or issue
  ///
  /// In en, this message translates to:
  /// **'Search vehicle, job ID or issue'**
  String get maintenanceSearchVehicleJobIdIssue;

  /// Select a job type
  ///
  /// In en, this message translates to:
  /// **'Select a job type'**
  String get maintenanceSelectJobType;

  /// Select a vehicle
  ///
  /// In en, this message translates to:
  /// **'Select a vehicle'**
  String get maintenanceSelectVehicle;

  /// Select the vehicle this job is for
  ///
  /// In en, this message translates to:
  /// **'Select the vehicle this job is for'**
  String get maintenanceSelectVehicleJob;

  /// Send a vehicle to the workshop
  ///
  /// In en, this message translates to:
  /// **'Send a vehicle to the workshop'**
  String get maintenanceSendVehicleWorkshop;

  /// Send it to the workshop
  ///
  /// In en, this message translates to:
  /// **'Send it to the workshop'**
  String get maintenanceSendWorkshop;

  /// Service bay
  ///
  /// In en, this message translates to:
  /// **'Service bay'**
  String get maintenanceServiceBay;

  /// Service partner
  ///
  /// In en, this message translates to:
  /// **'Service partner'**
  String get maintenanceServicePartner;

  /// A technician picks this up as soon as it is raised.
  ///
  /// In en, this message translates to:
  /// **'A technician picks this up as soon as it is raised.'**
  String get maintenanceTechnicianPicksUpAsSoon;

  /// Tracker drops off between Okhla and Jasola.
  ///
  /// In en, this message translates to:
  /// **'Tracker drops off between Okhla and Jasola.'**
  String get maintenanceTrackerDropsOffBetweenOkhla;

  /// Track every job from raised to closed
  ///
  /// In en, this message translates to:
  /// **'Track every job from raised to closed'**
  String get maintenanceTrackEveryJobFromRaised;

  /// Two-wheeler workshop
  ///
  /// In en, this message translates to:
  /// **'Two-wheeler workshop'**
  String get maintenanceTwoWheelerWorkshop;

  /// Tyres
  ///
  /// In en, this message translates to:
  /// **'Tyres'**
  String get maintenanceTyres;

  /// Unassigned
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get maintenanceUnassigned;

  /// Updates from the workshop will show up here.
  ///
  /// In en, this message translates to:
  /// **'Updates from the workshop will show up here.'**
  String get maintenanceUpdatesFromWorkshopWillShow;

  /// Update status
  ///
  /// In en, this message translates to:
  /// **'Update status'**
  String get maintenanceUpdateStatus;

  /// Vendor
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get maintenanceVendor;

  /// What happened, or what is needed next
  ///
  /// In en, this message translates to:
  /// **'What happened, or what is needed next'**
  String get maintenanceWhatHappenedWhatNeededNext;

  /// What kind of job is this
  ///
  /// In en, this message translates to:
  /// **'What kind of job is this'**
  String get maintenanceWhatKindJob;

  /// What is wrong with the vehicle
  ///
  /// In en, this message translates to:
  /// **'What is wrong with the vehicle'**
  String get maintenanceWhatWrongWithVehicle;

  /// Wide shot
  ///
  /// In en, this message translates to:
  /// **'Wide shot'**
  String get maintenanceWideShot;

  /// Allow location
  ///
  /// In en, this message translates to:
  /// **'Allow location'**
  String get mapsAllowLocation;

  /// {distance} away
  ///
  /// In en, this message translates to:
  /// **'{distance} away'**
  String mapsAway(String distance);

  /// Could not open Google Maps
  ///
  /// In en, this message translates to:
  /// **'Could not open Google Maps'**
  String get mapsCouldNotOpenMaps;

  /// Finding your location…
  ///
  /// In en, this message translates to:
  /// **'Finding your location…'**
  String get mapsLocating;

  /// We use your location to show hubs and swap stations near you.
  ///
  /// In en, this message translates to:
  /// **'We use your location to show hubs and swap stations near you.'**
  String get mapsLocationDeniedBody;

  /// Allow location access
  ///
  /// In en, this message translates to:
  /// **'Allow location access'**
  String get mapsLocationDeniedTitle;

  /// Turn on location services to see places near you.
  ///
  /// In en, this message translates to:
  /// **'Turn on location services to see places near you.'**
  String get mapsLocationOffBody;

  /// Location is turned off
  ///
  /// In en, this message translates to:
  /// **'Location is turned off'**
  String get mapsLocationOffTitle;

  /// Could not find your location
  ///
  /// In en, this message translates to:
  /// **'Could not find your location'**
  String get mapsLocationUnavailable;

  /// {minutes} min
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String mapsMinutes(String minutes);

  /// Navigate
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get mapsNavigate;

  /// Open settings
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get mapsOpenSettings;

  /// Battery swap
  ///
  /// In en, this message translates to:
  /// **'Battery swap'**
  String get navBatterySwap;

  /// Nearby hubs
  ///
  /// In en, this message translates to:
  /// **'Nearby hubs'**
  String get navNearbyHubs;

  /// Refer & earn
  ///
  /// In en, this message translates to:
  /// **'Refer & earn'**
  String get navReferEarn;

  /// Scooter details
  ///
  /// In en, this message translates to:
  /// **'Scooter details'**
  String get navScooterDetails;

  /// All
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notificationsAll;

  /// You are all caught up
  ///
  /// In en, this message translates to:
  /// **'You are all caught up'**
  String get notificationsAllCaughtUp;

  /// All clear
  ///
  /// In en, this message translates to:
  /// **'All clear'**
  String get notificationsAllClear;

  /// Could not load notifications
  ///
  /// In en, this message translates to:
  /// **'Could not load notifications'**
  String get notificationsCouldNotLoadNotifications;

  /// Earlier
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notificationsEarlier;

  /// New updates and alerts will show up here.
  ///
  /// In en, this message translates to:
  /// **'New updates and alerts will show up here.'**
  String get notificationsEmptyMessage;

  /// Got it
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get notificationsGotIt;

  /// Total notifications loaded
  ///
  /// In en, this message translates to:
  /// **'{count} notifications in your inbox'**
  String notificationsInboxCount(int count);

  /// No matching notifications
  ///
  /// In en, this message translates to:
  /// **'No matching notifications'**
  String get notificationsNoMatchingNotifications;

  /// Nothing new needs your attention
  ///
  /// In en, this message translates to:
  /// **'Nothing new needs your attention'**
  String get notificationsNothingNewNeedsAttention;

  /// Notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsNotifications;

  /// Search notifications
  ///
  /// In en, this message translates to:
  /// **'Search notifications'**
  String get notificationsSearchNotifications;

  /// Today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notificationsToday;

  /// Unread
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationsUnread;

  /// Unread notifications headline
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String notificationsUnreadCount(int count);

  /// Accept the agreement to continue
  ///
  /// In en, this message translates to:
  /// **'Accept the agreement to continue'**
  String get onboardingAcceptAgreementContinue;

  /// Add your date of birth on the first step before continuing
  ///
  /// In en, this message translates to:
  /// **'Add your date of birth on the first step before continuing'**
  String get onboardingAddDateBirthFirstStep;

  /// Add at least one reference
  ///
  /// In en, this message translates to:
  /// **'Add at least one reference'**
  String get onboardingAddLeastOneReference;

  /// Add your {field}
  ///
  /// In en, this message translates to:
  /// **'Add your {field}'**
  String onboardingAddYourField(String field);

  /// This agreement is between you and your fleet operator. It covers the vehicle you are handed, how it may be used, your responsibility for its care, the deposits and fees on your plan, and how the arrangement ends. Read it fully before you accept. By ticking the box below you confirm that you have read and agree to be bound by the rider agreement and the operator's rider policies.
  ///
  /// In en, this message translates to:
  /// **'This agreement is between you and your fleet operator. It covers the vehicle you are handed, how it may be used, your responsibility for its care, the deposits and fees on your plan, and how the arrangement ends. Read it fully before you accept. By ticking the box below you confirm that you have read and agree to be bound by the rider agreement and the operator\'s rider policies.'**
  String get onboardingAgreementBody;

  /// I have read and agree to the rider agreement
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the rider agreement'**
  String get onboardingAgreeToRiderAgreement;

  /// Answered
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get onboardingAnswered;

  /// Application submitted
  ///
  /// In en, this message translates to:
  /// **'Application submitted'**
  String get onboardingApplicationSubmitted;

  /// Attached
  ///
  /// In en, this message translates to:
  /// **'Attached'**
  String get onboardingAttached;

  /// Check everything before you submit. You can still edit any step.
  ///
  /// In en, this message translates to:
  /// **'Check everything before you submit. You can still edit any step.'**
  String get onboardingCheckEverythingBeforeSubmitCan;

  /// Could not load onboarding
  ///
  /// In en, this message translates to:
  /// **'Could not load onboarding'**
  String get onboardingCouldNotLoadOnboarding;

  /// That date of birth is not valid
  ///
  /// In en, this message translates to:
  /// **'That date of birth is not valid'**
  String get onboardingDateBirthNotValid;

  /// Upload tile text for a document the reviewer approved
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get onboardingDocumentApproved;

  /// This document has expired. Enter a date later than today.
  ///
  /// In en, this message translates to:
  /// **'This document has expired. Enter a date later than today.'**
  String get onboardingDocumentHasExpiredEnterDate;

  /// Upload tile text for a document waiting for review
  ///
  /// In en, this message translates to:
  /// **'Uploaded · under review'**
  String get onboardingDocumentInReview;

  /// Documents
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get onboardingDocuments;

  /// Edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get onboardingEdit;

  /// Enter a valid {field}
  ///
  /// In en, this message translates to:
  /// **'Enter a valid {field}'**
  String onboardingEnterValidField(String field);

  /// Every step you have completed is saved. You can pick up exactly where you left off next time you sign in.
  ///
  /// In en, this message translates to:
  /// **'Every step you have completed is saved. You can pick up exactly where you left off next time you sign in.'**
  String get onboardingEveryStepHaveCompletedSaved;

  /// Exit
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get onboardingExit;

  /// Exit onboarding?
  ///
  /// In en, this message translates to:
  /// **'Exit onboarding?'**
  String get onboardingExitOnboarding;

  /// Go to onboarding
  ///
  /// In en, this message translates to:
  /// **'Go to onboarding'**
  String get onboardingGoOnboarding;

  /// Get started
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingIntroGetStarted;

  /// Next
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingIntroNext;

  /// Loading your onboarding form…
  ///
  /// In en, this message translates to:
  /// **'Loading your onboarding form…'**
  String get onboardingLoadingOnboardingForm;

  /// Your fleet operator's package has no onboarding steps configured yet. Ask them to set up rider onboarding, then sign in again.
  ///
  /// In en, this message translates to:
  /// **'Your fleet operator\'s package has no onboarding steps configured yet. Ask them to set up rider onboarding, then sign in again.'**
  String get onboardingNoStepsConfigured;

  /// Nothing to fill in
  ///
  /// In en, this message translates to:
  /// **'Nothing to fill in'**
  String get onboardingNothingFill;

  /// Nothing to fill in on this step.
  ///
  /// In en, this message translates to:
  /// **'Nothing to fill in on this step.'**
  String get onboardingNothingFillStep;

  /// Nothing to review yet
  ///
  /// In en, this message translates to:
  /// **'Nothing to review yet'**
  String get onboardingNothingReviewYet;

  /// Nothing to fill in here
  ///
  /// In en, this message translates to:
  /// **'Nothing to fill in here'**
  String get onboardingNothingToFillHere;

  /// Not provided
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get onboardingNotProvided;

  /// Package
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get onboardingPackage;

  /// Please fix the highlighted fields before continuing
  ///
  /// In en, this message translates to:
  /// **'Please fix the highlighted fields before continuing'**
  String get onboardingPleaseFixHighlightedFieldsBefore;

  /// References
  ///
  /// In en, this message translates to:
  /// **'References'**
  String get onboardingReferences;

  /// Applied
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get onboardingReferralApplied;

  /// Apply
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get onboardingReferralApply;

  /// Referral code applied
  ///
  /// In en, this message translates to:
  /// **'Referral code applied'**
  String get onboardingReferralCodeApplied;

  /// Added from your invite link
  ///
  /// In en, this message translates to:
  /// **'Added from your invite link'**
  String get onboardingReferralFromInvite;

  /// We couldn't find a referral for that. Check the code or mobile number.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find a referral for that. Check the code or mobile number.'**
  String get onboardingReferralNotFound;

  /// Scan referral QR
  ///
  /// In en, this message translates to:
  /// **'Scan referral QR'**
  String get onboardingReferralScan;

  /// Tap Apply to use this code, or clear it
  ///
  /// In en, this message translates to:
  /// **'Tap Apply to use this code, or clear it'**
  String get onboardingReferralTapApply;

  /// Red banner message listing the rejected documents
  ///
  /// In en, this message translates to:
  /// **'Upload again to continue: {documents}'**
  String onboardingRejectedMessage(String documents);

  /// Red banner title on an onboarding step with rejected documents
  ///
  /// In en, this message translates to:
  /// **'Rejected in review'**
  String get onboardingRejectedTitle;

  /// Review
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get onboardingReview;

  /// Review application
  ///
  /// In en, this message translates to:
  /// **'Review application'**
  String get onboardingReviewApplication;

  /// Rider onboarding
  ///
  /// In en, this message translates to:
  /// **'Rider onboarding'**
  String get onboardingRiderOnboarding;

  /// Saving…
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get onboardingSaving;

  /// Sign the agreement to continue
  ///
  /// In en, this message translates to:
  /// **'Sign the agreement to continue'**
  String get onboardingSignAgreementContinue;

  /// Some steps are still incomplete. Go back and finish them.
  ///
  /// In en, this message translates to:
  /// **'Some steps are still incomplete. Go back and finish them.'**
  String get onboardingSomeStepsStillIncompleteGo;

  /// Start onboarding to see your answers here.
  ///
  /// In en, this message translates to:
  /// **'Start onboarding to see your answers here.'**
  String get onboardingStartOnboardingSeeAnswersHere;

  /// Agreement
  ///
  /// In en, this message translates to:
  /// **'Agreement'**
  String get onboardingStepAgreement;

  /// Eligibility
  ///
  /// In en, this message translates to:
  /// **'Eligibility'**
  String get onboardingStepEligibility;

  /// This step is handled by your fleet operator. Continue to the next one.
  ///
  /// In en, this message translates to:
  /// **'This step is handled by your fleet operator. Continue to the next one.'**
  String get onboardingStepHandledByOperator;

  /// Training
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get onboardingStepTraining;

  /// Submit application
  ///
  /// In en, this message translates to:
  /// **'Submit application'**
  String get onboardingSubmitApplication;

  /// Take a photo of the document, or choose one you already have
  ///
  /// In en, this message translates to:
  /// **'Take a photo of the document, or choose one you already have'**
  String get onboardingTakePhotoDocumentChooseOne;

  /// Snack when the rider submits while a rejected document is still not re-uploaded
  ///
  /// In en, this message translates to:
  /// **'Upload the rejected documents again before you submit.'**
  String get onboardingUploadRejectedAgain;

  /// You are all paid up
  ///
  /// In en, this message translates to:
  /// **'You are all paid up'**
  String get paymentsAllClear;

  /// Nothing is due right now. We will tell you before the next one.
  ///
  /// In en, this message translates to:
  /// **'Nothing is due right now. We will tell you before the next one.'**
  String get paymentsAllClearMessage;

  /// Amount due
  ///
  /// In en, this message translates to:
  /// **'Amount due'**
  String get paymentsAmountDue;

  /// Auto-debit
  ///
  /// In en, this message translates to:
  /// **'Auto-debit'**
  String get paymentsAutoPay;

  /// On
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get paymentsAutoPayActive;

  /// Auto-debit needs attention. Ask your fleet manager to set it up again.
  ///
  /// In en, this message translates to:
  /// **'Auto-debit needs attention. Ask your fleet manager to set it up again.'**
  String get paymentsAutoPayAttention;

  /// Waiting for approval
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval'**
  String get paymentsAutoPayAuthPending;

  /// Expired
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get paymentsAutoPayExpired;

  /// Failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get paymentsAutoPayFailed;

  /// Not set up
  ///
  /// In en, this message translates to:
  /// **'Not set up'**
  String get paymentsAutoPayNotEnabled;

  /// Paused
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paymentsAutoPayPaused;

  /// Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get paymentsAutoPayRevoked;

  /// Set-up needed
  ///
  /// In en, this message translates to:
  /// **'Set-up needed'**
  String get paymentsAutoPaySetupRequired;

  /// Could not load payments
  ///
  /// In en, this message translates to:
  /// **'Could not load payments'**
  String get paymentsCouldNotLoad;

  /// Due on
  ///
  /// In en, this message translates to:
  /// **'Due on'**
  String get paymentsDueOn;

  /// Past payments
  ///
  /// In en, this message translates to:
  /// **'Past payments'**
  String get paymentsHistory;

  /// Mandate ends
  ///
  /// In en, this message translates to:
  /// **'Mandate ends'**
  String get paymentsMandateExpires;

  /// Per-debit limit
  ///
  /// In en, this message translates to:
  /// **'Per-debit limit'**
  String get paymentsMandateLimit;

  /// Method
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get paymentsMethod;

  /// Next debit
  ///
  /// In en, this message translates to:
  /// **'Next debit'**
  String get paymentsNextDebit;

  /// No payments yet
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get paymentsNoPayments;

  /// Your payments show up here once they are confirmed.
  ///
  /// In en, this message translates to:
  /// **'Your payments show up here once they are confirmed.'**
  String get paymentsNoPaymentsMessage;

  /// Nothing due
  ///
  /// In en, this message translates to:
  /// **'Nothing due'**
  String get paymentsNothingDue;

  /// Overdue
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get paymentsOverdue;

  /// Pay at your hub, or let auto-debit take it on the due date.
  ///
  /// In en, this message translates to:
  /// **'Pay at your hub, or let auto-debit take it on the due date.'**
  String get paymentsPayAtHub;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentsPayment;

  /// Dues, auto-debit and receipts
  ///
  /// In en, this message translates to:
  /// **'Dues, auto-debit and receipts'**
  String get paymentsSubtitle;

  /// Payments
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentsTitle;

  /// e.g. Front tyre worn below limit
  ///
  /// In en, this message translates to:
  /// **'e.g. Front tyre worn below limit'**
  String get pdiHintTyreWorn;

  /// Inspected by {partner}
  ///
  /// In en, this message translates to:
  /// **'Inspected by {partner}'**
  String pdiInspectedBy(String partner);

  /// Address & hub
  ///
  /// In en, this message translates to:
  /// **'Address & hub'**
  String get profileAddressHub;

  /// Email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// Hub
  ///
  /// In en, this message translates to:
  /// **'Hub'**
  String get profileHub;

  /// Hub code
  ///
  /// In en, this message translates to:
  /// **'Hub code'**
  String get profileHubCode;

  /// Joined on
  ///
  /// In en, this message translates to:
  /// **'Joined on'**
  String get profileJoined;

  /// Personal details
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get profilePersonalDetails;

  /// Activity
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get referActivity;

  /// Caption on the shared QR card
  ///
  /// In en, this message translates to:
  /// **'Join with my code and get {amount}'**
  String referCardReward(String amount);

  /// Referral code copied
  ///
  /// In en, this message translates to:
  /// **'Referral code copied'**
  String get referCodeCopied;

  /// Qualification deadline
  ///
  /// In en, this message translates to:
  /// **'Complete these by {date}'**
  String referCompleteBy(String date);

  /// Copy code
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get referCopyCode;

  /// Copy invite message
  ///
  /// In en, this message translates to:
  /// **'Copy invite message'**
  String get referCopyMessage;

  /// Could not load refer & earn
  ///
  /// In en, this message translates to:
  /// **'Could not load refer & earn'**
  String get referCouldNotLoad;

  /// Referral details
  ///
  /// In en, this message translates to:
  /// **'Referral details'**
  String get referDetailTitle;

  /// Let a friend scan this to join with your code. Tap to enlarge.
  ///
  /// In en, this message translates to:
  /// **'Let a friend scan this to join with your code. Tap to enlarge.'**
  String get referDrawerHint;

  /// My referral QR
  ///
  /// In en, this message translates to:
  /// **'My referral QR'**
  String get referDrawerTitle;

  /// Your account is already linked to another referral code.
  ///
  /// In en, this message translates to:
  /// **'Your account is already linked to another referral code.'**
  String get referErrorAlreadyLinked;

  /// Refer & earn isn't running right now.
  ///
  /// In en, this message translates to:
  /// **'Refer & earn isn\'t running right now.'**
  String get referErrorCampaignInactive;

  /// This invite has expired. Ask your friend to send a new one.
  ///
  /// In en, this message translates to:
  /// **'This invite has expired. Ask your friend to send a new one.'**
  String get referErrorCodeExpired;

  /// This rider has reached their referral limit.
  ///
  /// In en, this message translates to:
  /// **'This rider has reached their referral limit.'**
  String get referErrorLimit;

  /// Your rider profile isn't ready for referrals yet.
  ///
  /// In en, this message translates to:
  /// **'Your rider profile isn\'t ready for referrals yet.'**
  String get referErrorNotEligible;

  /// Refer & earn isn't available for your company.
  ///
  /// In en, this message translates to:
  /// **'Refer & earn isn\'t available for your company.'**
  String get referErrorNotEnabled;

  /// Referral not found.
  ///
  /// In en, this message translates to:
  /// **'Referral not found.'**
  String get referErrorNotFound;

  /// You can't use your own referral code.
  ///
  /// In en, this message translates to:
  /// **'You can\'t use your own referral code.'**
  String get referErrorSelf;

  /// A referral expired
  ///
  /// In en, this message translates to:
  /// **'A referral expired'**
  String get referEventExpired;

  /// Referral update
  ///
  /// In en, this message translates to:
  /// **'Referral update'**
  String get referEventOther;

  /// A referral made progress
  ///
  /// In en, this message translates to:
  /// **'A referral made progress'**
  String get referEventProgress;

  /// A referral qualified for its reward
  ///
  /// In en, this message translates to:
  /// **'A referral qualified for its reward'**
  String get referEventQualified;

  /// A rider joined with a referral code
  ///
  /// In en, this message translates to:
  /// **'A rider joined with a referral code'**
  String get referEventRegistered;

  /// A referral reward was paid
  ///
  /// In en, this message translates to:
  /// **'A referral reward was paid'**
  String get referEventRewardPaid;

  /// Your friend gets
  ///
  /// In en, this message translates to:
  /// **'Your friend gets'**
  String get referFriendGets;

  /// How it works
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get referHowItWorks;

  /// Share your code. When your friend joins and completes these steps, the referral reward unlocks.
  ///
  /// In en, this message translates to:
  /// **'Share your code. When your friend joins and completes these steps, the referral reward unlocks.'**
  String get referHowItWorksBody;

  /// Invited
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get referInvited;

  /// Invite expiry
  ///
  /// In en, this message translates to:
  /// **'This invite is valid till {date}'**
  String referInviteValidTill(String date);

  /// Invite message copied
  ///
  /// In en, this message translates to:
  /// **'Invite message copied'**
  String get referMessageCopied;

  /// Get activated as a rider
  ///
  /// In en, this message translates to:
  /// **'Get activated as a rider'**
  String get referMilestoneActivated;

  /// Milestone: active days
  ///
  /// In en, this message translates to:
  /// **'Stay active for {count} days'**
  String referMilestoneActiveDays(String count);

  /// Milestone: attendance days
  ///
  /// In en, this message translates to:
  /// **'Mark attendance on {count} days'**
  String referMilestoneAttendance(String count);

  /// Milestone: deliveries
  ///
  /// In en, this message translates to:
  /// **'Complete {count} deliveries'**
  String referMilestoneDeliveries(String count);

  /// Complete KYC
  ///
  /// In en, this message translates to:
  /// **'Complete KYC'**
  String get referMilestoneKyc;

  /// Complete the campaign step
  ///
  /// In en, this message translates to:
  /// **'Complete the campaign step'**
  String get referMilestoneOther;

  /// Make the first payment
  ///
  /// In en, this message translates to:
  /// **'Make the first payment'**
  String get referMilestonePayment;

  /// Milestone: rides
  ///
  /// In en, this message translates to:
  /// **'Complete {count} rides'**
  String referMilestoneRides(String count);

  /// Finish the training
  ///
  /// In en, this message translates to:
  /// **'Finish the training'**
  String get referMilestoneTraining;

  /// Get a scooter allotted
  ///
  /// In en, this message translates to:
  /// **'Get a scooter allotted'**
  String get referMilestoneVehicle;

  /// Check back soon for new rewards.
  ///
  /// In en, this message translates to:
  /// **'Check back soon for new rewards.'**
  String get referNoCampaignBody;

  /// No referral campaign right now
  ///
  /// In en, this message translates to:
  /// **'No referral campaign right now'**
  String get referNoCampaignTitle;

  /// Share your code to invite riders.
  ///
  /// In en, this message translates to:
  /// **'Share your code to invite riders.'**
  String get referNoReferralsBody;

  /// No referrals yet
  ///
  /// In en, this message translates to:
  /// **'No referrals yet'**
  String get referNoReferralsTitle;

  /// Paid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get referPaid;

  /// Pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get referPending;

  /// Progress
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get referProgress;

  /// Referral QR code
  ///
  /// In en, this message translates to:
  /// **'Referral QR code'**
  String get referQrSemantics;

  /// Qualified
  ///
  /// In en, this message translates to:
  /// **'Qualified'**
  String get referQualified;

  /// Registered
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get referRegistered;

  /// Earned
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get referRewardEarned;

  /// Pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get referRewardPending;

  /// Processing
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get referRewardProcessing;

  /// Reversed
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get referRewardReversed;

  /// Rewards
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get referRewards;

  /// The camera couldn't start. Try again, or pick a photo of the QR code.
  ///
  /// In en, this message translates to:
  /// **'The camera couldn\'t start. Try again, or pick a photo of the QR code.'**
  String get referScanCameraFailed;

  /// Code read from a QR
  ///
  /// In en, this message translates to:
  /// **'Found code {code}'**
  String referScanFound(String code);

  /// Pick from photos
  ///
  /// In en, this message translates to:
  /// **'Pick from photos'**
  String get referScanFromPhotos;

  /// Point the camera at a referral QR code
  ///
  /// In en, this message translates to:
  /// **'Point the camera at a referral QR code'**
  String get referScanHint;

  /// There's no camera to scan with on this device. Pick a photo of the QR code instead.
  ///
  /// In en, this message translates to:
  /// **'There\'s no camera to scan with on this device. Pick a photo of the QR code instead.'**
  String get referScanNoCamera;

  /// No QR code found in that photo.
  ///
  /// In en, this message translates to:
  /// **'No QR code found in that photo.'**
  String get referScanNoQrInPhoto;

  /// That QR code isn't a referral code.
  ///
  /// In en, this message translates to:
  /// **'That QR code isn\'t a referral code.'**
  String get referScanNotReferral;

  /// Camera access is off. Allow it in Settings to scan, or pick a photo of the QR code.
  ///
  /// In en, this message translates to:
  /// **'Camera access is off. Allow it in Settings to scan, or pick a photo of the QR code.'**
  String get referScanPermissionDenied;

  /// Scan referral QR
  ///
  /// In en, this message translates to:
  /// **'Scan referral QR'**
  String get referScanTitle;

  /// Scan to join with my referral code
  ///
  /// In en, this message translates to:
  /// **'Scan to join with my referral code'**
  String get referScanToJoin;

  /// Play Store link line in the invite message
  ///
  /// In en, this message translates to:
  /// **'Get the app on Android: {link}'**
  String referShareAndroid(String link);

  /// Referral code line in the invite message
  ///
  /// In en, this message translates to:
  /// **'Use my referral code {code} when you sign up.'**
  String referShareCodeLine(String code);

  /// Invite message opening line
  ///
  /// In en, this message translates to:
  /// **'Join me as a rider on {app}!'**
  String referShareIntro(String app);

  /// Share invite
  ///
  /// In en, this message translates to:
  /// **'Share invite'**
  String get referShareInvite;

  /// App Store link line in the invite message
  ///
  /// In en, this message translates to:
  /// **'Get the app on iPhone: {link}'**
  String referShareIphone(String link);

  /// Share
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get referShareNow;

  /// Friend reward line in the invite message
  ///
  /// In en, this message translates to:
  /// **'You get {amount} when you complete the joining steps.'**
  String referShareReward(String amount);

  /// Your friend can scan the QR or use the link to join.
  ///
  /// In en, this message translates to:
  /// **'Your friend can scan the QR or use the link to join.'**
  String get referShareSubtitle;

  /// Share your invite
  ///
  /// In en, this message translates to:
  /// **'Share your invite'**
  String get referShareTitle;

  /// Show QR
  ///
  /// In en, this message translates to:
  /// **'Show QR'**
  String get referShowQr;

  /// Activated
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get referStatusActivated;

  /// Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get referStatusCancelled;

  /// Disqualified
  ///
  /// In en, this message translates to:
  /// **'Disqualified'**
  String get referStatusDisqualified;

  /// Expired
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get referStatusExpired;

  /// In progress
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get referStatusInProgress;

  /// KYC verified
  ///
  /// In en, this message translates to:
  /// **'KYC verified'**
  String get referStatusKycVerified;

  /// Reward paid
  ///
  /// In en, this message translates to:
  /// **'Reward paid'**
  String get referStatusPaid;

  /// Rejected
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get referStatusRejected;

  /// Reward approved
  ///
  /// In en, this message translates to:
  /// **'Reward approved'**
  String get referStatusRewardApproved;

  /// Reward pending
  ///
  /// In en, this message translates to:
  /// **'Reward pending'**
  String get referStatusRewardPending;

  /// Under review
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get referStatusUnderReview;

  /// Milestones completed out of total
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} steps'**
  String referStepsDone(int done, int total);

  /// Invite riders and earn rewards
  ///
  /// In en, this message translates to:
  /// **'Invite riders and earn rewards'**
  String get referSubtitle;

  /// Terms & conditions
  ///
  /// In en, this message translates to:
  /// **'Terms & conditions'**
  String get referTerms;

  /// Timeline
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get referTimeline;

  /// Total earned
  ///
  /// In en, this message translates to:
  /// **'Total earned'**
  String get referTotalEarned;

  /// Valid till {date}
  ///
  /// In en, this message translates to:
  /// **'Valid till {date}'**
  String referValidTill(String date);

  /// You get
  ///
  /// In en, this message translates to:
  /// **'You get'**
  String get referYouGet;

  /// Your referral code
  ///
  /// In en, this message translates to:
  /// **'Your referral code'**
  String get referYourCode;

  /// Your referral QR
  ///
  /// In en, this message translates to:
  /// **'Your referral QR'**
  String get referYourQr;

  /// Ask your friend to scan it in the app's onboarding.
  ///
  /// In en, this message translates to:
  /// **'Ask your friend to scan it in the app\'s onboarding.'**
  String get referYourQrSubtitle;

  /// Your referrals
  ///
  /// In en, this message translates to:
  /// **'Your referrals'**
  String get referYourReferrals;

  /// Auto-debit
  ///
  /// In en, this message translates to:
  /// **'Auto-debit'**
  String get rentalsAutoDebit;

  /// Auto-debit keeps every cycle paid on time, no manual transfers
  ///
  /// In en, this message translates to:
  /// **'Auto-debit keeps every cycle paid on time, no manual transfers'**
  String get rentalsAutoDebitKeepsEveryCycle;

  /// Billing period
  ///
  /// In en, this message translates to:
  /// **'Billing period'**
  String get rentalsBillingPeriod;

  /// Bills
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get rentalsBills;

  /// Could not load this bill
  ///
  /// In en, this message translates to:
  /// **'Could not load this bill'**
  String get rentalsCouldNotLoadBill;

  /// Could not load your ledger
  ///
  /// In en, this message translates to:
  /// **'Could not load your ledger'**
  String get rentalsCouldNotLoadLedger;

  /// Could not load your payments
  ///
  /// In en, this message translates to:
  /// **'Could not load your payments'**
  String get rentalsCouldNotLoadPayments;

  /// Could not load your rent plan
  ///
  /// In en, this message translates to:
  /// **'Could not load your rent plan'**
  String get rentalsCouldNotLoadRentPlan;

  /// Credit available
  ///
  /// In en, this message translates to:
  /// **'Credit available'**
  String get rentalsCredit;

  /// Credits applied
  ///
  /// In en, this message translates to:
  /// **'Credits applied'**
  String get rentalsCreditsApplied;

  /// Current plan
  ///
  /// In en, this message translates to:
  /// **'Current plan'**
  String get rentalsCurrentPlan;

  /// Deposit held
  ///
  /// In en, this message translates to:
  /// **'Deposit held'**
  String get rentalsDepositHeld;

  /// Due on
  ///
  /// In en, this message translates to:
  /// **'Due on'**
  String get rentalsDue;

  /// Due later
  ///
  /// In en, this message translates to:
  /// **'Due later'**
  String get rentalsDueLater;

  /// From your wallet
  ///
  /// In en, this message translates to:
  /// **'From your wallet'**
  String get rentalsFromWallet;

  /// Invoice history
  ///
  /// In en, this message translates to:
  /// **'Invoice history'**
  String get rentalsInvoiceHistory;

  /// Ledger
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get rentalsLedger;

  /// Adjustment
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get rentalsLedgerAdjustment;

  /// Charge
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get rentalsLedgerCharge;

  /// Credit
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get rentalsLedgerCredit;

  /// Deposit
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get rentalsLedgerDeposit;

  /// Every charge, payment and credit on your account, newest first.
  ///
  /// In en, this message translates to:
  /// **'Every charge, payment and credit on your account, newest first.'**
  String get rentalsLedgerHint;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get rentalsLedgerPayment;

  /// Refund
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get rentalsLedgerRefund;

  /// Reversal
  ///
  /// In en, this message translates to:
  /// **'Reversal'**
  String get rentalsLedgerReversal;

  /// No invoices yet
  ///
  /// In en, this message translates to:
  /// **'No invoices yet'**
  String get rentalsNoInvoicesYet;

  /// Nothing on your ledger yet
  ///
  /// In en, this message translates to:
  /// **'Nothing on your ledger yet'**
  String get rentalsNoLedger;

  /// Charges and payments will show up here as they happen.
  ///
  /// In en, this message translates to:
  /// **'Charges and payments will show up here as they happen.'**
  String get rentalsNoLedgerBody;

  /// No payments yet
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get rentalsNoPayments;

  /// Payments you make towards your bills will show up here.
  ///
  /// In en, this message translates to:
  /// **'Payments you make towards your bills will show up here.'**
  String get rentalsNoPaymentsBody;

  /// Outstanding
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get rentalsOutstanding;

  /// Banner when the rider has overdue bills
  ///
  /// In en, this message translates to:
  /// **'{amount} is overdue. Please pay it soon to keep riding without interruptions.'**
  String rentalsOverdueNotice(String amount);

  /// Paid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get rentalsPaid;

  /// Paid on
  ///
  /// In en, this message translates to:
  /// **'Paid on'**
  String get rentalsPaid2;

  /// Paid so far
  ///
  /// In en, this message translates to:
  /// **'Paid so far'**
  String get rentalsPaidSoFar;

  /// Payments
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get rentalsPayments;

  /// Number of bills a payment settled
  ///
  /// In en, this message translates to:
  /// **'{count} bill(s) settled'**
  String rentalsReceiptInvoices(int count);

  /// Amount refunded from a payment
  ///
  /// In en, this message translates to:
  /// **'{amount} refunded'**
  String rentalsRefunded(String amount);

  /// Rentals
  ///
  /// In en, this message translates to:
  /// **'Rentals'**
  String get rentalsRentals;

  /// Rent, handled automatically
  ///
  /// In en, this message translates to:
  /// **'Rent, handled automatically'**
  String get rentalsRentHandledAutomatically;

  /// Rent receipt
  ///
  /// In en, this message translates to:
  /// **'Rent receipt'**
  String get rentalsRentReceipt;

  /// Your rent receipts will appear here.
  ///
  /// In en, this message translates to:
  /// **'Your rent receipts will appear here.'**
  String get rentalsRentReceiptsWillAppearHere;

  /// Draft
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get rentalsStatusDraft;

  /// Due
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get rentalsStatusDue;

  /// Overdue
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get rentalsStatusOverdue;

  /// Part paid
  ///
  /// In en, this message translates to:
  /// **'Part paid'**
  String get rentalsStatusPartlyPaid;

  /// Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get rentalsStatusVoid;

  /// Still due
  ///
  /// In en, this message translates to:
  /// **'Still due'**
  String get rentalsStillDue;

  /// Your plan, bills and account history
  ///
  /// In en, this message translates to:
  /// **'Your plan, bills and account history'**
  String get rentalsSubtitle;

  /// Subtotal
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get rentalsSubtotal;

  /// Tap a receipt to see the full breakdown
  ///
  /// In en, this message translates to:
  /// **'Tap a receipt to see the full breakdown'**
  String get rentalsTapReceiptSeeFullBreakdown;

  /// Tax
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get rentalsTax;

  /// Payments not yet applied
  ///
  /// In en, this message translates to:
  /// **'Payments not yet applied'**
  String get rentalsUnallocated;

  /// Your account
  ///
  /// In en, this message translates to:
  /// **'Your account'**
  String get rentalsYourAccount;

  /// Approve charges
  ///
  /// In en, this message translates to:
  /// **'Approve charges'**
  String get returnsApproveCharges;

  /// Subtitle of the charges approval code sheet
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to your phone. Entering it approves charges of {amount}.'**
  String returnsApproveSubtitle(String amount);

  /// Enter the code
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get returnsApproveTitle;

  /// Cancel return
  ///
  /// In en, this message translates to:
  /// **'Cancel return'**
  String get returnsCancel;

  /// You keep the scooter and your rental carries on as before.
  ///
  /// In en, this message translates to:
  /// **'You keep the scooter and your rental carries on as before.'**
  String get returnsCancelBody;

  /// Return cancelled
  ///
  /// In en, this message translates to:
  /// **'Return cancelled'**
  String get returnsCancelled;

  /// Cancel this return?
  ///
  /// In en, this message translates to:
  /// **'Cancel this return?'**
  String get returnsCancelTitle;

  /// Charges
  ///
  /// In en, this message translates to:
  /// **'Charges'**
  String get returnsCharges;

  /// Charges approved
  ///
  /// In en, this message translates to:
  /// **'Charges approved'**
  String get returnsChargesApproved;

  /// The hub is still inspecting the scooter. Charges, if any, will appear here.
  ///
  /// In en, this message translates to:
  /// **'The hub is still inspecting the scooter. Charges, if any, will appear here.'**
  String get returnsChargesPending;

  /// That code has expired. Ask for a new one.
  ///
  /// In en, this message translates to:
  /// **'That code has expired. Ask for a new one.'**
  String get returnsCodeExpired;

  /// That code didn't work. Check it and try again.
  ///
  /// In en, this message translates to:
  /// **'That code didn\'t work. Check it and try again.'**
  String get returnsCodeInvalid;

  /// Could not load your returns
  ///
  /// In en, this message translates to:
  /// **'Could not load your returns'**
  String get returnsCouldNotLoad;

  /// Could not load hubs
  ///
  /// In en, this message translates to:
  /// **'Could not load hubs'**
  String get returnsCouldNotLoadHubs;

  /// Return date
  ///
  /// In en, this message translates to:
  /// **'Return date'**
  String get returnsDate;

  /// Details
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get returnsDetails;

  /// Return
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnsDetailTitle;

  /// Dispute charges
  ///
  /// In en, this message translates to:
  /// **'Dispute charges'**
  String get returnsDisputeCharges;

  /// What's wrong?
  ///
  /// In en, this message translates to:
  /// **'What\'s wrong?'**
  String get returnsDisputeReason;

  /// Add a reason so the hub team can review it.
  ///
  /// In en, this message translates to:
  /// **'Add a reason so the hub team can review it.'**
  String get returnsDisputeReasonRequired;

  /// Dispute sent to the hub team
  ///
  /// In en, this message translates to:
  /// **'Dispute sent to the hub team'**
  String get returnsDisputeSent;

  /// Tell the hub team what is wrong with these charges.
  ///
  /// In en, this message translates to:
  /// **'Tell the hub team what is wrong with these charges.'**
  String get returnsDisputeSubtitle;

  /// Tell us when and where you will hand it back. The hub team checks it in, and any charges come to you for approval first.
  ///
  /// In en, this message translates to:
  /// **'Tell us when and where you will hand it back. The hub team checks it in, and any charges come to you for approval first.'**
  String get returnsEndRentalBody;

  /// Done with your scooter?
  ///
  /// In en, this message translates to:
  /// **'Done with your scooter?'**
  String get returnsEndRentalTitle;

  /// This scooter has already been received.
  ///
  /// In en, this message translates to:
  /// **'This scooter has already been received.'**
  String get returnsErrorAlreadyReceived;

  /// A return is already requested for this rental.
  ///
  /// In en, this message translates to:
  /// **'A return is already requested for this rental.'**
  String get returnsErrorAlreadyRequested;

  /// These penalties aren't waiting for your approval.
  ///
  /// In en, this message translates to:
  /// **'These penalties aren\'t waiting for your approval.'**
  String get returnsErrorApprovalNotPending;

  /// The return time is before the rental started.
  ///
  /// In en, this message translates to:
  /// **'The return time is before the rental started.'**
  String get returnsErrorBeforeAgreement;

  /// Finish the return inspection before adding penalties.
  ///
  /// In en, this message translates to:
  /// **'Finish the return inspection before adding penalties.'**
  String get returnsErrorInspectFirst;

  /// This return can no longer be cancelled.
  ///
  /// In en, this message translates to:
  /// **'This return can no longer be cancelled.'**
  String get returnsErrorNotCancellable;

  /// These penalties can't be disputed right now.
  ///
  /// In en, this message translates to:
  /// **'These penalties can\'t be disputed right now.'**
  String get returnsErrorNotDisputable;

  /// This return was cancelled, so the scooter can't be received against it.
  ///
  /// In en, this message translates to:
  /// **'This return was cancelled, so the scooter can\'t be received against it.'**
  String get returnsErrorNotReceivable;

  /// These penalties can't be submitted right now.
  ///
  /// In en, this message translates to:
  /// **'These penalties can\'t be submitted right now.'**
  String get returnsErrorNotSubmittable;

  /// This rental can't be returned right now.
  ///
  /// In en, this message translates to:
  /// **'This rental can\'t be returned right now.'**
  String get returnsErrorNotTerminable;

  /// Rider approval can't be overridden at this stage.
  ///
  /// In en, this message translates to:
  /// **'Rider approval can\'t be overridden at this stage.'**
  String get returnsErrorOverrideNotAllowed;

  /// Penalties can't be edited while they're with the rider or already charged.
  ///
  /// In en, this message translates to:
  /// **'Penalties can\'t be edited while they\'re with the rider or already charged.'**
  String get returnsErrorPenaltiesLocked;

  /// Receive the scooter before adding penalties.
  ///
  /// In en, this message translates to:
  /// **'Receive the scooter before adding penalties.'**
  String get returnsErrorReceiveFirst;

  /// The rider disputed these penalties. Revise the list and submit it again.
  ///
  /// In en, this message translates to:
  /// **'The rider disputed these penalties. Revise the list and submit it again.'**
  String get returnsErrorRevisePenalties;

  /// These penalties just changed. Refresh and try again.
  ///
  /// In en, this message translates to:
  /// **'These penalties just changed. Refresh and try again.'**
  String get returnsErrorStateChanged;

  /// Submit the penalties before approving them.
  ///
  /// In en, this message translates to:
  /// **'Submit the penalties before approving them.'**
  String get returnsErrorSubmitFirst;

  /// Number of evidence photos for a charge
  ///
  /// In en, this message translates to:
  /// **'{count} photo(s) as evidence'**
  String returnsEvidenceCount(int count);

  /// Handed over
  ///
  /// In en, this message translates to:
  /// **'Handed over'**
  String get returnsHandedOver;

  /// Return hub
  ///
  /// In en, this message translates to:
  /// **'Return hub'**
  String get returnsHub;

  /// Damage
  ///
  /// In en, this message translates to:
  /// **'Damage'**
  String get returnsKindDamage;

  /// Missing item
  ///
  /// In en, this message translates to:
  /// **'Missing item'**
  String get returnsKindMissing;

  /// We use your location to list the hubs closest to you.
  ///
  /// In en, this message translates to:
  /// **'We use your location to list the hubs closest to you.'**
  String get returnsLocationForHubs;

  /// The hub team photographs the scooter and a mechanic checks it.
  ///
  /// In en, this message translates to:
  /// **'The hub team photographs the scooter and a mechanic checks it.'**
  String get returnsNextCheckIn;

  /// You get a code on your phone to confirm the report and any charges. Your rental ends once it's confirmed.
  ///
  /// In en, this message translates to:
  /// **'You get a code on your phone to confirm the report and any charges. Your rental ends once it\'s confirmed.'**
  String get returnsNextConfirm;

  /// Bring the scooter, its battery and charger to the hub on the date you picked.
  ///
  /// In en, this message translates to:
  /// **'Bring the scooter, its battery and charger to the hub on the date you picked.'**
  String get returnsNextHandOver;

  /// No charges for this return.
  ///
  /// In en, this message translates to:
  /// **'No charges for this return.'**
  String get returnsNoCharges;

  /// No hubs found near you
  ///
  /// In en, this message translates to:
  /// **'No hubs found near you'**
  String get returnsNoHubsNearby;

  /// No returns yet
  ///
  /// In en, this message translates to:
  /// **'No returns yet'**
  String get returnsNone;

  /// When you hand your scooter back, you can follow the return here.
  ///
  /// In en, this message translates to:
  /// **'When you hand your scooter back, you can follow the return here.'**
  String get returnsNoneBody;

  /// An admin approved these charges on your behalf. The hub manager confirms them next. You can still dispute them.
  ///
  /// In en, this message translates to:
  /// **'An admin approved these charges on your behalf. The hub manager confirms them next. You can still dispute them.'**
  String get returnsNoteAdminApproved;

  /// You cancelled this return. Your rental carries on as before.
  ///
  /// In en, this message translates to:
  /// **'You cancelled this return. Your rental carries on as before.'**
  String get returnsNoteCancelled;

  /// Return closed. The check-in report below shows any charges.
  ///
  /// In en, this message translates to:
  /// **'Return closed. The check-in report below shows any charges.'**
  String get returnsNoteCheckInDone;

  /// The hub team is checking your scooter. When the mechanic's report is ready, you'll get a code on your phone to confirm it.
  ///
  /// In en, this message translates to:
  /// **'The hub team is checking your scooter. When the mechanic\'s report is ready, you\'ll get a code on your phone to confirm it.'**
  String get returnsNoteCheckingIn;

  /// You disputed these charges. The hub team will review them and may revise them.
  ///
  /// In en, this message translates to:
  /// **'You disputed these charges. The hub team will review them and may revise them.'**
  String get returnsNoteDisputed;

  /// Your scooter is checked in and your rental has ended. A mechanic is doing a final check, and if it finds anything more you'll be asked to confirm it.
  ///
  /// In en, this message translates to:
  /// **'Your scooter is checked in and your rental has ended. A mechanic is doing a final check, and if it finds anything more you\'ll be asked to confirm it.'**
  String get returnsNoteFinalChecks;

  /// The hub has your scooter and is inspecting it. Any charges will show up here for your approval.
  ///
  /// In en, this message translates to:
  /// **'The hub has your scooter and is inspecting it. Any charges will show up here for your approval.'**
  String get returnsNoteInspecting;

  /// The hub found the charges below. Approve them with a code we send to your phone, or dispute them.
  ///
  /// In en, this message translates to:
  /// **'The hub found the charges below. Approve them with a code we send to your phone, or dispute them.'**
  String get returnsNoteNeedsYou;

  /// Return closed. The scooter came back fine, so there are no charges.
  ///
  /// In en, this message translates to:
  /// **'Return closed. The scooter came back fine, so there are no charges.'**
  String get returnsNoteNoCharges;

  /// Status note while a return is requested
  ///
  /// In en, this message translates to:
  /// **'Take the scooter to the hub you picked on {date}. The hub team will check it in.'**
  String returnsNoteRequested(String date);

  /// Anything else?
  ///
  /// In en, this message translates to:
  /// **'Anything else?'**
  String get returnsNotes;

  /// Status note when charges were posted
  ///
  /// In en, this message translates to:
  /// **'Return closed. Charges of {amount} were added to your bill.'**
  String returnsNoteSettled(String amount);

  /// Optional note for the hub team
  ///
  /// In en, this message translates to:
  /// **'Optional note for the hub team'**
  String get returnsNotesHint;

  /// You approved the charges. The hub manager confirms them next.
  ///
  /// In en, this message translates to:
  /// **'You approved the charges. The hub manager confirms them next.'**
  String get returnsNoteYouApproved;

  /// Nothing to return right now
  ///
  /// In en, this message translates to:
  /// **'Nothing to return right now'**
  String get returnsNothingToReturn;

  /// You don't have an active rental, or a return for it is already in progress.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have an active rental, or a return for it is already in progress.'**
  String get returnsNothingToReturnBody;

  /// Pick a return date
  ///
  /// In en, this message translates to:
  /// **'Pick a return date'**
  String get returnsPickDate;

  /// Pick a hub
  ///
  /// In en, this message translates to:
  /// **'Pick a hub'**
  String get returnsPickHub;

  /// Hubs closest to you are at the top
  ///
  /// In en, this message translates to:
  /// **'Hubs closest to you are at the top'**
  String get returnsPickHubSubtitle;

  /// Choose a reason
  ///
  /// In en, this message translates to:
  /// **'Choose a reason'**
  String get returnsPickReason;

  /// Planned return date
  ///
  /// In en, this message translates to:
  /// **'Planned for {date}'**
  String returnsPlannedFor(String date);

  /// Progress
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get returnsProgress;

  /// Reason
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get returnsReason;

  /// Battery or charging problems
  ///
  /// In en, this message translates to:
  /// **'Battery or charging problems'**
  String get returnsReasonBatteryIssues;

  /// Changing jobs
  ///
  /// In en, this message translates to:
  /// **'Changing jobs'**
  String get returnsReasonChangingJob;

  /// Health or family reasons
  ///
  /// In en, this message translates to:
  /// **'Health or family reasons'**
  String get returnsReasonHealthOrFamily;

  /// Not earning enough
  ///
  /// In en, this message translates to:
  /// **'Not earning enough'**
  String get returnsReasonLowEarnings;

  /// I don't need it anymore
  ///
  /// In en, this message translates to:
  /// **'I don\'t need it anymore'**
  String get returnsReasonNoLongerNeeded;

  /// Bought my own vehicle
  ///
  /// In en, this message translates to:
  /// **'Bought my own vehicle'**
  String get returnsReasonOwnVehicle;

  /// Moving to another city
  ///
  /// In en, this message translates to:
  /// **'Moving to another city'**
  String get returnsReasonRelocating;

  /// Unhappy with the service
  ///
  /// In en, this message translates to:
  /// **'Unhappy with the service'**
  String get returnsReasonServiceIssues;

  /// Taking a break from work
  ///
  /// In en, this message translates to:
  /// **'Taking a break from work'**
  String get returnsReasonTakingBreak;

  /// Rent is too high
  ///
  /// In en, this message translates to:
  /// **'Rent is too high'**
  String get returnsReasonTooExpensive;

  /// Problems with the scooter
  ///
  /// In en, this message translates to:
  /// **'Problems with the scooter'**
  String get returnsReasonVehicleIssues;

  /// Return requested. See you at the hub.
  ///
  /// In en, this message translates to:
  /// **'Return requested. See you at the hub.'**
  String get returnsRequested;

  /// Request a return
  ///
  /// In en, this message translates to:
  /// **'Request a return'**
  String get returnsRequestReturn;

  /// Pick a date and the hub you will bring it to
  ///
  /// In en, this message translates to:
  /// **'Pick a date and the hub you will bring it to'**
  String get returnsRequestSubtitle;

  /// Send dispute
  ///
  /// In en, this message translates to:
  /// **'Send dispute'**
  String get returnsSendDispute;

  /// With the hub manager
  ///
  /// In en, this message translates to:
  /// **'With the hub manager'**
  String get returnsStatusAwaitingManager;

  /// Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get returnsStatusCancelled;

  /// Checking in
  ///
  /// In en, this message translates to:
  /// **'Checking in'**
  String get returnsStatusCheckingIn;

  /// Closed
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get returnsStatusClosed;

  /// Disputed
  ///
  /// In en, this message translates to:
  /// **'Disputed'**
  String get returnsStatusDisputed;

  /// Final checks
  ///
  /// In en, this message translates to:
  /// **'Final checks'**
  String get returnsStatusFinalChecks;

  /// Being inspected
  ///
  /// In en, this message translates to:
  /// **'Being inspected'**
  String get returnsStatusInspecting;

  /// Your approval needed
  ///
  /// In en, this message translates to:
  /// **'Your approval needed'**
  String get returnsStatusNeedsYou;

  /// Return requested
  ///
  /// In en, this message translates to:
  /// **'Return requested'**
  String get returnsStatusRequested;

  /// Scooter checked in
  ///
  /// In en, this message translates to:
  /// **'Scooter checked in'**
  String get returnsStepCheckIn;

  /// Return closed
  ///
  /// In en, this message translates to:
  /// **'Return closed'**
  String get returnsStepClosed;

  /// Final mechanic check
  ///
  /// In en, this message translates to:
  /// **'Final mechanic check'**
  String get returnsStepFinalChecks;

  /// Scooter handed over
  ///
  /// In en, this message translates to:
  /// **'Scooter handed over'**
  String get returnsStepHandedOver;

  /// Inspection and charges
  ///
  /// In en, this message translates to:
  /// **'Inspection and charges'**
  String get returnsStepInspection;

  /// Return requested
  ///
  /// In en, this message translates to:
  /// **'Return requested'**
  String get returnsStepRequested;

  /// End your rental and hand the scooter back
  ///
  /// In en, this message translates to:
  /// **'End your rental and hand the scooter back'**
  String get returnsSubtitle;

  /// Return scooter
  ///
  /// In en, this message translates to:
  /// **'Return scooter'**
  String get returnsTitle;

  /// When and where
  ///
  /// In en, this message translates to:
  /// **'When and where'**
  String get returnsWhenWhere;

  /// Why are you returning it?
  ///
  /// In en, this message translates to:
  /// **'Why are you returning it?'**
  String get returnsWhy;

  /// Your dispute
  ///
  /// In en, this message translates to:
  /// **'Your dispute'**
  String get returnsYourDispute;

  /// Your returns
  ///
  /// In en, this message translates to:
  /// **'Your returns'**
  String get returnsYourReturns;

  /// Parked and locked.
  ///
  /// In en, this message translates to:
  /// **'Parked and locked.'**
  String get rideParkedLocked;

  /// Ride safe. Helmet on, lights checked.
  ///
  /// In en, this message translates to:
  /// **'Ride safe. Helmet on, lights checked.'**
  String get rideRideSafeHelmetLightsChecked;

  /// Active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get ridersActive;

  /// Allocations
  ///
  /// In en, this message translates to:
  /// **'Allocations'**
  String get ridersAllocations;

  /// Awaiting allocation
  ///
  /// In en, this message translates to:
  /// **'Awaiting allocation'**
  String get ridersAwaitingAllocation;

  /// Call
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get ridersCall;

  /// Could not load the team
  ///
  /// In en, this message translates to:
  /// **'Could not load the team'**
  String get ridersCouldNotLoadTeam;

  /// Exited
  ///
  /// In en, this message translates to:
  /// **'Exited'**
  String get ridersExited;

  /// Exit reason
  ///
  /// In en, this message translates to:
  /// **'Exit reason'**
  String get ridersExitReason;

  /// Joined
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get ridersJoined;

  /// KYC status
  ///
  /// In en, this message translates to:
  /// **'KYC status'**
  String get ridersKycStatus;

  /// Nobody matches this search in this list.
  ///
  /// In en, this message translates to:
  /// **'Nobody matches this search in this list.'**
  String get ridersNobodyMatchesSearchList;

  /// No riders here
  ///
  /// In en, this message translates to:
  /// **'No riders here'**
  String get ridersNoRidersHere;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get ridersOnboarding;

  /// Plan
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get ridersPlan;

  /// Riders on the roster
  ///
  /// In en, this message translates to:
  /// **'Riders on the roster'**
  String get ridersRidersRoster;

  /// Search name, code or vehicle
  ///
  /// In en, this message translates to:
  /// **'Search name, code or vehicle'**
  String get ridersSearchNameCodeVehicle;

  /// Team
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get ridersTeam;

  /// Verified
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get ridersVerified;

  /// With the hub since
  ///
  /// In en, this message translates to:
  /// **'With the hub since'**
  String get ridersWithHubSince;

  /// Your scooter is connected. Use the power button to switch it on.
  ///
  /// In en, this message translates to:
  /// **'Your scooter is connected. Use the power button to switch it on.'**
  String get rideScooterConnectedUsePowerButton;

  /// Vehicle is ON
  ///
  /// In en, this message translates to:
  /// **'Vehicle is ON'**
  String get rideVehicle;

  /// Vehicle is OFF
  ///
  /// In en, this message translates to:
  /// **'Vehicle is OFF'**
  String get rideVehicleOff;

  /// No screen at {location}
  ///
  /// In en, this message translates to:
  /// **'No screen at {location}'**
  String routerNoScreenAt(String location);

  /// Allowed from hub
  ///
  /// In en, this message translates to:
  /// **'Allowed from hub'**
  String get scooterAllowedFromHub;

  /// Battery charge
  ///
  /// In en, this message translates to:
  /// **'Battery charge'**
  String get scooterBatteryCharge;

  /// Battery serial
  ///
  /// In en, this message translates to:
  /// **'Battery serial'**
  String get scooterBatterySerial;

  /// Battery type
  ///
  /// In en, this message translates to:
  /// **'Battery type'**
  String get scooterBatteryType;

  /// Charger
  ///
  /// In en, this message translates to:
  /// **'Charger'**
  String get scooterCharger;

  /// Charging
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get scooterCharging;

  /// Cluster manager
  ///
  /// In en, this message translates to:
  /// **'Cluster manager'**
  String get scooterClusterManager;

  /// Commercial permit
  ///
  /// In en, this message translates to:
  /// **'Commercial permit'**
  String get scooterCommercialPermit;

  /// Controller number
  ///
  /// In en, this message translates to:
  /// **'Controller number'**
  String get scooterControllerNumber;

  /// Could not load your vehicle
  ///
  /// In en, this message translates to:
  /// **'Could not load your vehicle'**
  String get scooterCouldNotLoadVehicle;

  /// Delivery box
  ///
  /// In en, this message translates to:
  /// **'Delivery box'**
  String get scooterDeliveryBox;

  /// Fitness certificate
  ///
  /// In en, this message translates to:
  /// **'Fitness certificate'**
  String get scooterFitnessCertificate;

  /// Health
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get scooterHealth;

  /// Helmet
  ///
  /// In en, this message translates to:
  /// **'Helmet'**
  String get scooterHelmet;

  /// Identity
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get scooterIdentity;

  /// IoT offline
  ///
  /// In en, this message translates to:
  /// **'IoT offline'**
  String get scooterIotOffline;

  /// IoT online
  ///
  /// In en, this message translates to:
  /// **'IoT online'**
  String get scooterIotOnline;

  /// Motor number
  ///
  /// In en, this message translates to:
  /// **'Motor number'**
  String get scooterMotorNumber;

  /// Next service
  ///
  /// In en, this message translates to:
  /// **'Next service'**
  String get scooterNextService;

  /// No scooter has been allocated to you yet.
  ///
  /// In en, this message translates to:
  /// **'No scooter has been allocated to you yet.'**
  String get scooterNoScooterHasBeenAllocated;

  /// Odometer and service
  ///
  /// In en, this message translates to:
  /// **'Odometer and service'**
  String get scooterOdometerService;

  /// Parked at
  ///
  /// In en, this message translates to:
  /// **'Parked at'**
  String get scooterParked;

  /// Phone mount
  ///
  /// In en, this message translates to:
  /// **'Phone mount'**
  String get scooterPhoneMount;

  /// Powertrain
  ///
  /// In en, this message translates to:
  /// **'Powertrain'**
  String get scooterPowertrain;

  /// Range
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get scooterRange;

  /// Registration certificate
  ///
  /// In en, this message translates to:
  /// **'Registration certificate'**
  String get scooterRegistrationCertificate;

  /// Toolkit
  ///
  /// In en, this message translates to:
  /// **'Toolkit'**
  String get scooterToolkit;

  /// Vehicle details
  ///
  /// In en, this message translates to:
  /// **'Vehicle details'**
  String get scooterVehicleDetails;

  /// Vehicle number
  ///
  /// In en, this message translates to:
  /// **'Vehicle number'**
  String get scooterVehicleNumber;

  /// View full details
  ///
  /// In en, this message translates to:
  /// **'View full details'**
  String get scooterViewFullDetails;

  /// Where it belongs
  ///
  /// In en, this message translates to:
  /// **'Where it belongs'**
  String get scooterWhereBelongs;

  /// Who looks after you
  ///
  /// In en, this message translates to:
  /// **'Who looks after you'**
  String get scooterWhoLooksAfter;

  /// Add charge
  ///
  /// In en, this message translates to:
  /// **'Add charge'**
  String get submissionAddCharge;

  /// Can't use a code?
  ///
  /// In en, this message translates to:
  /// **'Can\'t use a code?'**
  String get submissionBypass;

  /// Skipping code
  ///
  /// In en, this message translates to:
  /// **'Skipping code'**
  String get submissionBypassing;

  /// Why can't they confirm with a code?
  ///
  /// In en, this message translates to:
  /// **'Why can\'t they confirm with a code?'**
  String get submissionBypassReason;

  /// Recorded rider bypass reason
  ///
  /// In en, this message translates to:
  /// **'Rider code skipped: {reason}'**
  String submissionBypassRider(String reason);

  /// Recorded team lead bypass reason
  ///
  /// In en, this message translates to:
  /// **'Team lead code skipped: {reason}'**
  String submissionBypassTeamLead(String reason);

  /// Why a report was cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled: {reason}'**
  String submissionCancelledBecause(String reason);

  /// Reason
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get submissionCancelReason;

  /// Enter a reason to cancel the report.
  ///
  /// In en, this message translates to:
  /// **'Enter a reason to cancel the report.'**
  String get submissionCancelReasonNeeded;

  /// Cancel report
  ///
  /// In en, this message translates to:
  /// **'Cancel report'**
  String get submissionCancelReport;

  /// Say why. You can record a fresh report afterwards.
  ///
  /// In en, this message translates to:
  /// **'Say why. You can record a fresh report afterwards.'**
  String get submissionCancelReportHint;

  /// Cancel this report?
  ///
  /// In en, this message translates to:
  /// **'Cancel this report?'**
  String get submissionCancelReportTitle;

  /// Details
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get submissionChargeDetails;

  /// Where is the damage, or what is missing?
  ///
  /// In en, this message translates to:
  /// **'Where is the damage, or what is missing?'**
  String get submissionChargeDetailsHint;

  /// Pick at least one photo as proof for this charge.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one photo as proof for this charge.'**
  String get submissionChargeEvidenceNeeded;

  /// Charges
  ///
  /// In en, this message translates to:
  /// **'Charges'**
  String get submissionCharges;

  /// Add a charge for each damaged or missing item. Leave it empty if there's nothing to charge.
  ///
  /// In en, this message translates to:
  /// **'Add a charge for each damaged or missing item. Leave it empty if there\'s nothing to charge.'**
  String get submissionChargesHint;

  /// Chassis
  ///
  /// In en, this message translates to:
  /// **'Chassis'**
  String get submissionChassis;

  /// Missing items need the return checklist photo as proof.
  ///
  /// In en, this message translates to:
  /// **'Missing items need the return checklist photo as proof.'**
  String get submissionChecklistNeeded;

  /// All mechanic checks are done
  ///
  /// In en, this message translates to:
  /// **'All mechanic checks are done'**
  String get submissionChecksComplete;

  /// This closes the mechanic checks for this scooter. You won't be able to add more reports.
  ///
  /// In en, this message translates to:
  /// **'This closes the mechanic checks for this scooter. You won\'t be able to add more reports.'**
  String get submissionChecksCompleteConfirm;

  /// Turn on only when no more checks are needed. No more reports can be added after this.
  ///
  /// In en, this message translates to:
  /// **'Turn on only when no more checks are needed. No more reports can be added after this.'**
  String get submissionChecksCompleteHint;

  /// The code couldn't be sent. Try again or record why it can't be used.
  ///
  /// In en, this message translates to:
  /// **'The code couldn\'t be sent. Try again or record why it can\'t be used.'**
  String get submissionCodeNotSent;

  /// No code yet
  ///
  /// In en, this message translates to:
  /// **'No code yet'**
  String get submissionCodePending;

  /// Code sent
  ///
  /// In en, this message translates to:
  /// **'Code sent'**
  String get submissionCodeSent;

  /// Masked phone number that received the code
  ///
  /// In en, this message translates to:
  /// **'Code sent to {phone}'**
  String submissionCodeSentTo(String phone);

  /// Codes sent
  ///
  /// In en, this message translates to:
  /// **'Codes sent'**
  String get submissionCodesSent;

  /// Collect confirmations
  ///
  /// In en, this message translates to:
  /// **'Collect confirmations'**
  String get submissionCollect;

  /// Confirm report
  ///
  /// In en, this message translates to:
  /// **'Confirm report'**
  String get submissionConfirm;

  /// Report confirmed
  ///
  /// In en, this message translates to:
  /// **'Report confirmed'**
  String get submissionConfirmed;

  /// The rider and the team lead each get a code by SMS. Enter both codes to confirm. If someone can't use a code, record why.
  ///
  /// In en, this message translates to:
  /// **'The rider and the team lead each get a code by SMS. Enter both codes to confirm. If someone can\'t use a code, record why.'**
  String get submissionConfirmHint;

  /// Confirm report
  ///
  /// In en, this message translates to:
  /// **'Confirm report'**
  String get submissionConfirmTitle;

  /// Couldn't load this check-in
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this check-in'**
  String get submissionCouldNotLoad;

  /// Add details for this charge.
  ///
  /// In en, this message translates to:
  /// **'Add details for this charge.'**
  String get submissionDetailsNeeded;

  /// Edit charge
  ///
  /// In en, this message translates to:
  /// **'Edit charge'**
  String get submissionEditCharge;

  /// Proof photos
  ///
  /// In en, this message translates to:
  /// **'Proof photos'**
  String get submissionEvidence;

  /// Pick the photos that back up this report.
  ///
  /// In en, this message translates to:
  /// **'Pick the photos that back up this report.'**
  String get submissionEvidenceHint;

  /// Maximum proof photos
  ///
  /// In en, this message translates to:
  /// **'You can pick up to {count} photos.'**
  String submissionEvidenceLimit(int count);

  /// Pick at least one proof photo.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one proof photo.'**
  String get submissionEvidenceNeeded;

  /// Damage & extra photos
  ///
  /// In en, this message translates to:
  /// **'Damage & extra photos'**
  String get submissionExtraPhotos;

  /// Add close-ups of any damage. You can attach them to charges in the report.
  ///
  /// In en, this message translates to:
  /// **'Add close-ups of any damage. You can attach them to charges in the report.'**
  String get submissionExtraPhotosHint;

  /// Findings
  ///
  /// In en, this message translates to:
  /// **'Findings'**
  String get submissionFindings;

  /// Impose report
  ///
  /// In en, this message translates to:
  /// **'Impose report'**
  String get submissionImpose;

  /// Make sure the rider has seen the findings and charges. After this the report can't be changed, only cancelled.
  ///
  /// In en, this message translates to:
  /// **'Make sure the rider has seen the findings and charges. After this the report can\'t be changed, only cancelled.'**
  String get submissionImposeBody;

  /// Report imposed
  ///
  /// In en, this message translates to:
  /// **'Report imposed'**
  String get submissionImposed;

  /// Impose this report?
  ///
  /// In en, this message translates to:
  /// **'Impose this report?'**
  String get submissionImposeTitle;

  /// Mechanic name
  ///
  /// In en, this message translates to:
  /// **'Mechanic name'**
  String get submissionMechanicName;

  /// Enter the mechanic's name
  ///
  /// In en, this message translates to:
  /// **'Enter the mechanic\'s name'**
  String get submissionNameNeeded;

  /// All checks are done. Nothing more to do here.
  ///
  /// In en, this message translates to:
  /// **'All checks are done. Nothing more to do here.'**
  String get submissionNextComplete;

  /// The scooter is checked in. Record the final mechanic check when it's done.
  ///
  /// In en, this message translates to:
  /// **'The scooter is checked in. Record the final mechanic check when it\'s done.'**
  String get submissionNextDeep;

  /// Next step
  ///
  /// In en, this message translates to:
  /// **'Next step'**
  String get submissionNextLabel;

  /// Collect the rider's and team lead's codes to confirm the report.
  ///
  /// In en, this message translates to:
  /// **'Collect the rider\'s and team lead\'s codes to confirm the report.'**
  String get submissionNextOtps;

  /// Required check-in photos still missing
  ///
  /// In en, this message translates to:
  /// **'Photos still to take: {count}. Then record the mechanic\'s report.'**
  String submissionNextPhotos(int count);

  /// All photos are in. Record the mechanic's report next.
  ///
  /// In en, this message translates to:
  /// **'All photos are in. Record the mechanic\'s report next.'**
  String get submissionNextReport;

  /// Go through the report and any charges with the rider, then impose it.
  ///
  /// In en, this message translates to:
  /// **'Go through the report and any charges with the rider, then impose it.'**
  String get submissionNextReview;

  /// No photos yet. Take them on the check-in screen first.
  ///
  /// In en, this message translates to:
  /// **'No photos yet. Take them on the check-in screen first.'**
  String get submissionNoPhotosYet;

  /// No penalty prices are set up yet. Ask an admin to add them on the dashboard.
  ///
  /// In en, this message translates to:
  /// **'No penalty prices are set up yet. Ask an admin to add them on the dashboard.'**
  String get submissionNoPrices;

  /// Nothing to confirm
  ///
  /// In en, this message translates to:
  /// **'Nothing to confirm'**
  String get submissionNothingToConfirm;

  /// There's no imposed report waiting for codes on this check-in.
  ///
  /// In en, this message translates to:
  /// **'There\'s no imposed report waiting for codes on this check-in.'**
  String get submissionNothingToConfirmBody;

  /// Rider
  ///
  /// In en, this message translates to:
  /// **'Rider'**
  String get submissionPartyRider;

  /// Team lead
  ///
  /// In en, this message translates to:
  /// **'Team lead'**
  String get submissionPartyTeamLead;

  /// Photo of a specific battery
  ///
  /// In en, this message translates to:
  /// **'Battery {name}'**
  String submissionPhotoBattery(String name);

  /// Battery
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get submissionPhotoBatteryGeneric;

  /// Return checklist
  ///
  /// In en, this message translates to:
  /// **'Return checklist'**
  String get submissionPhotoChecklist;

  /// Photo of a specific controller
  ///
  /// In en, this message translates to:
  /// **'Controller {number}'**
  String submissionPhotoController(String number);

  /// Controller
  ///
  /// In en, this message translates to:
  /// **'Controller'**
  String get submissionPhotoControllerGeneric;

  /// Damage photo
  ///
  /// In en, this message translates to:
  /// **'Damage photo'**
  String get submissionPhotoDamage;

  /// IoT device
  ///
  /// In en, this message translates to:
  /// **'IoT device'**
  String get submissionPhotoIot;

  /// Required photos
  ///
  /// In en, this message translates to:
  /// **'Required photos'**
  String get submissionPhotos;

  /// Tap an empty slot to take the photo. Tap a taken photo to view it.
  ///
  /// In en, this message translates to:
  /// **'Tap an empty slot to take the photo. Tap a taken photo to view it.'**
  String get submissionPhotosHint;

  /// Pick a charge
  ///
  /// In en, this message translates to:
  /// **'Pick a charge'**
  String get submissionPickCharge;

  /// Quantity
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get submissionQuantity;

  /// Receiving hub
  ///
  /// In en, this message translates to:
  /// **'Receiving hub'**
  String get submissionReceivingHub;

  /// Record final check
  ///
  /// In en, this message translates to:
  /// **'Record final check'**
  String get submissionRecordFinal;

  /// Record mechanic report
  ///
  /// In en, this message translates to:
  /// **'Record mechanic report'**
  String get submissionRecordReport;

  /// Mechanic who wrote the report
  ///
  /// In en, this message translates to:
  /// **'By {name}'**
  String submissionReportBy(String name);

  /// Report cancelled
  ///
  /// In en, this message translates to:
  /// **'Report cancelled'**
  String get submissionReportCancelled;

  /// Mechanic reports
  ///
  /// In en, this message translates to:
  /// **'Mechanic reports'**
  String get submissionReports;

  /// Report saved
  ///
  /// In en, this message translates to:
  /// **'Report saved'**
  String get submissionReportSaved;

  /// Resend codes
  ///
  /// In en, this message translates to:
  /// **'Resend codes'**
  String get submissionResendAll;

  /// Rider's note
  ///
  /// In en, this message translates to:
  /// **'Rider\'s note'**
  String get submissionRiderNote;

  /// No, it needs work
  ///
  /// In en, this message translates to:
  /// **'No, it needs work'**
  String get submissionSafeNo;

  /// It stays in maintenance after the checks.
  ///
  /// In en, this message translates to:
  /// **'It stays in maintenance after the checks.'**
  String get submissionSafeNoHint;

  /// Safe to use again?
  ///
  /// In en, this message translates to:
  /// **'Safe to use again?'**
  String get submissionSafeQuestion;

  /// Choose whether it's safe to use again
  ///
  /// In en, this message translates to:
  /// **'Choose whether it\'s safe to use again'**
  String get submissionSafetyNeeded;

  /// Yes, it's safe
  ///
  /// In en, this message translates to:
  /// **'Yes, it\'s safe'**
  String get submissionSafeYes;

  /// It can go back into the fleet once the checks are done.
  ///
  /// In en, this message translates to:
  /// **'It can go back into the fleet once the checks are done.'**
  String get submissionSafeYesHint;

  /// All
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get submissionsAll;

  /// Save charge
  ///
  /// In en, this message translates to:
  /// **'Save charge'**
  String get submissionSaveCharge;

  /// Save report
  ///
  /// In en, this message translates to:
  /// **'Save report'**
  String get submissionSaveReport;

  /// Couldn't load returns and exchanges
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load returns and exchanges'**
  String get submissionsCouldNotLoad;

  /// Check in returned scooters
  ///
  /// In en, this message translates to:
  /// **'Check in returned scooters'**
  String get submissionsDrawerSubtitle;

  /// Planned drop-off date on a queue row
  ///
  /// In en, this message translates to:
  /// **'Drop-off {date}'**
  String submissionsDropOff(String date);

  /// Drop-off date
  ///
  /// In en, this message translates to:
  /// **'Drop-off date'**
  String get submissionsDropOffDate;

  /// Returns and exchanges for your hub show up here.
  ///
  /// In en, this message translates to:
  /// **'Returns and exchanges for your hub show up here.'**
  String get submissionsEmptyAll;

  /// No check-ins are in progress.
  ///
  /// In en, this message translates to:
  /// **'No check-ins are in progress.'**
  String get submissionsEmptyChecks;

  /// No scooters are due at your hub right now.
  ///
  /// In en, this message translates to:
  /// **'No scooters are due at your hub right now.'**
  String get submissionsEmptyScheduled;

  /// Nothing here
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get submissionsEmptyTitle;

  /// Send codes
  ///
  /// In en, this message translates to:
  /// **'Send codes'**
  String get submissionSendCodes;

  /// Exchanges
  ///
  /// In en, this message translates to:
  /// **'Exchanges'**
  String get submissionsExchanges;

  /// Exchanges due
  ///
  /// In en, this message translates to:
  /// **'Exchanges due'**
  String get submissionsExchangesDue;

  /// In checks
  ///
  /// In en, this message translates to:
  /// **'In checks'**
  String get submissionsInChecks;

  /// Exchange
  ///
  /// In en, this message translates to:
  /// **'Exchange'**
  String get submissionSourceExchange;

  /// Return
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get submissionSourceReturn;

  /// Returns
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get submissionsReturns;

  /// Returns due
  ///
  /// In en, this message translates to:
  /// **'Returns due'**
  String get submissionsReturnsDue;

  /// Scheduled
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get submissionsScheduled;

  /// Check in scooters that riders bring back to your hub.
  ///
  /// In en, this message translates to:
  /// **'Check in scooters that riders bring back to your hub.'**
  String get submissionsSubtitle;

  /// Confirm a staff-started return
  ///
  /// In en, this message translates to:
  /// **'This starts the check-in for {vehicle} now. {rider}\'s rental ends once the mechanic\'s report is confirmed.'**
  String submissionStaffReturnBody(String rider, String vehicle);

  /// Take this scooter back?
  ///
  /// In en, this message translates to:
  /// **'Take this scooter back?'**
  String get submissionStaffReturnTitle;

  /// Checking in
  ///
  /// In en, this message translates to:
  /// **'Checking in'**
  String get submissionStageCheckingIn;

  /// Done
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get submissionStageDone;

  /// Final checks
  ///
  /// In en, this message translates to:
  /// **'Final checks'**
  String get submissionStageFinalChecks;

  /// Scheduled
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get submissionStageScheduled;

  /// Start check-in
  ///
  /// In en, this message translates to:
  /// **'Start check-in'**
  String get submissionStart;

  /// Start once the rider is at the hub with the scooter. The scooter can't be allocated again until the check-in is finished.
  ///
  /// In en, this message translates to:
  /// **'Start once the rider is at the hub with the scooter. The scooter can\'t be allocated again until the check-in is finished.'**
  String get submissionStartBody;

  /// Check-in started
  ///
  /// In en, this message translates to:
  /// **'Check-in started'**
  String get submissionStarted;

  /// Started
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get submissionStartedAt;

  /// Start check-in
  ///
  /// In en, this message translates to:
  /// **'Start check-in'**
  String get submissionStartTitle;

  /// Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get submissionStatusCancelled;

  /// Returns & exchanges
  ///
  /// In en, this message translates to:
  /// **'Returns & exchanges'**
  String get submissionsTitle;

  /// What the mechanic found
  ///
  /// In en, this message translates to:
  /// **'What the mechanic found'**
  String get submissionSummary;

  /// Condition of the body, battery, controller and accessories
  ///
  /// In en, this message translates to:
  /// **'Condition of the body, battery, controller and accessories'**
  String get submissionSummaryHint;

  /// Describe what the mechanic found
  ///
  /// In en, this message translates to:
  /// **'Describe what the mechanic found'**
  String get submissionSummaryNeeded;

  /// Why isn't it safe?
  ///
  /// In en, this message translates to:
  /// **'Why isn\'t it safe?'**
  String get submissionUnsafeReason;

  /// Say why it isn't safe
  ///
  /// In en, this message translates to:
  /// **'Say why it isn\'t safe'**
  String get submissionUnsafeReasonNeeded;

  /// Use a code instead
  ///
  /// In en, this message translates to:
  /// **'Use a code instead'**
  String get submissionUseCode;

  /// Rider confirmed with a code
  ///
  /// In en, this message translates to:
  /// **'Rider confirmed with a code'**
  String get submissionVerifiedRider;

  /// Team lead confirmed with a code
  ///
  /// In en, this message translates to:
  /// **'Team lead confirmed with a code'**
  String get submissionVerifiedTeamLead;

  /// Verify code
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get submissionVerify;

  /// View photo
  ///
  /// In en, this message translates to:
  /// **'View photo'**
  String get submissionViewPhoto;

  /// Accident or theft
  ///
  /// In en, this message translates to:
  /// **'Accident or theft'**
  String get supportAccidentTheft;

  /// Add a few more details (10+ characters)
  ///
  /// In en, this message translates to:
  /// **'Add a few more details (10+ characters)'**
  String get supportAddFewMoreDetails10;

  /// All
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get supportAll;

  /// Battery or charging
  ///
  /// In en, this message translates to:
  /// **'Battery or charging'**
  String get supportBatteryCharging;

  /// Breakdown on the road
  ///
  /// In en, this message translates to:
  /// **'Breakdown on the road'**
  String get supportBreakdownRoad;

  /// Could not load support
  ///
  /// In en, this message translates to:
  /// **'Could not load support'**
  String get supportCouldNotLoadSupport;

  /// Could not load this ticket
  ///
  /// In en, this message translates to:
  /// **'Could not load this ticket'**
  String get supportCouldNotLoadTicket;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get supportDescription;

  /// No tickets here
  ///
  /// In en, this message translates to:
  /// **'No tickets here'**
  String get supportDeskEmpty;

  /// Tickets riders raise at your hubs will show up here.
  ///
  /// In en, this message translates to:
  /// **'Tickets riders raise at your hubs will show up here.'**
  String get supportDeskEmptyBody;

  /// Rider tickets from your hubs
  ///
  /// In en, this message translates to:
  /// **'Rider tickets from your hubs'**
  String get supportDeskSubtitle;

  /// Support desk
  ///
  /// In en, this message translates to:
  /// **'Support desk'**
  String get supportDeskTitle;

  /// Documents and KYC
  ///
  /// In en, this message translates to:
  /// **'Documents and KYC'**
  String get supportDocumentsKyc;

  /// Hub
  ///
  /// In en, this message translates to:
  /// **'Hub'**
  String get supportHub;

  /// In progress
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get supportInProgress;

  /// Mark resolved
  ///
  /// In en, this message translates to:
  /// **'Mark resolved'**
  String get supportMarkResolved;

  /// The more detail you give, the faster we can help
  ///
  /// In en, this message translates to:
  /// **'The more detail you give, the faster we can help'**
  String get supportMoreDetailGiveFasterCan;

  /// Need help with something?
  ///
  /// In en, this message translates to:
  /// **'Need help with something?'**
  String get supportNeedHelpWithSomething;

  /// Nothing open right now
  ///
  /// In en, this message translates to:
  /// **'Nothing open right now'**
  String get supportNothingOpenRightNow;

  /// No tickets yet
  ///
  /// In en, this message translates to:
  /// **'No tickets yet'**
  String get supportNoTicketsYet;

  /// One line that sums up the issue
  ///
  /// In en, this message translates to:
  /// **'One line that sums up the issue'**
  String get supportOneLineSumsUpIssue;

  /// Number of tickets that are not resolved yet
  ///
  /// In en, this message translates to:
  /// **'{count} open'**
  String supportOpenCount(int count);

  /// Open tickets
  ///
  /// In en, this message translates to:
  /// **'Open tickets'**
  String get supportOpenTickets;

  /// Payment or wallet
  ///
  /// In en, this message translates to:
  /// **'Payment or wallet'**
  String get supportPaymentWallet;

  /// PDF document
  ///
  /// In en, this message translates to:
  /// **'PDF document'**
  String get supportPdfAttachment;

  /// Hint above the photo picker on the raise ticket screen
  ///
  /// In en, this message translates to:
  /// **'Add up to {count} photos if they help explain the issue.'**
  String supportPhotosHint(int count);

  /// Shown when the ticket was created but some photos failed to upload
  ///
  /// In en, this message translates to:
  /// **'Ticket raised, but {count} photo(s) could not be attached. You can add them from the ticket.'**
  String supportPhotosNotAttached(int count);

  /// Photos (optional)
  ///
  /// In en, this message translates to:
  /// **'Photos (optional)'**
  String get supportPhotosOptional;

  /// Pick a topic, or write your own subject below.
  ///
  /// In en, this message translates to:
  /// **'Pick a topic, or write your own subject below.'**
  String get supportPickTopic;

  /// When the ticket was raised
  ///
  /// In en, this message translates to:
  /// **'Raised on {date}'**
  String supportRaisedOn(String date);

  /// Raise one above if something needs attention.
  ///
  /// In en, this message translates to:
  /// **'Raise one above if something needs attention.'**
  String get supportRaiseOneAboveIfSomething;

  /// Raise a ticket
  ///
  /// In en, this message translates to:
  /// **'Raise a ticket'**
  String get supportRaiseTicket;

  /// The rider can still reply. A reply from them reopens the ticket.
  ///
  /// In en, this message translates to:
  /// **'The rider can still reply. A reply from them reopens the ticket.'**
  String get supportResolveBody;

  /// Resolved
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get supportResolved;

  /// This ticket is resolved. Send a message if you still need help and it will reopen.
  ///
  /// In en, this message translates to:
  /// **'This ticket is resolved. Send a message if you still need help and it will reopen.'**
  String get supportResolvedReplyToReopen;

  /// Mark this ticket resolved?
  ///
  /// In en, this message translates to:
  /// **'Mark this ticket resolved?'**
  String get supportResolveTitle;

  /// Something else
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get supportSomethingElse;

  /// Start working
  ///
  /// In en, this message translates to:
  /// **'Start working'**
  String get supportStartWorking;

  /// Ticket status updated
  ///
  /// In en, this message translates to:
  /// **'Ticket status updated'**
  String get supportStatusUpdated;

  /// Subject
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get supportSubject;

  /// Submit ticket
  ///
  /// In en, this message translates to:
  /// **'Submit ticket'**
  String get supportSubmitTicket;

  /// Support team
  ///
  /// In en, this message translates to:
  /// **'Support team'**
  String get supportTeam;

  /// Your team lead sees it straight away.
  ///
  /// In en, this message translates to:
  /// **'Your team lead sees it straight away.'**
  String get supportTeamLeadSeesStraightAway;

  /// Tell us more
  ///
  /// In en, this message translates to:
  /// **'Tell us more'**
  String get supportTellUsMore;

  /// Tell us what this is about
  ///
  /// In en, this message translates to:
  /// **'Tell us what this is about'**
  String get supportTellUsWhatAbout;

  /// Tell us what happened and attach a photo if it helps.
  ///
  /// In en, this message translates to:
  /// **'Tell us what happened and attach a photo if it helps. '**
  String get supportTellUsWhatHappenedAttach;

  /// Ticket
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get supportTicket;

  /// Ticket raised. Our team is on it.
  ///
  /// In en, this message translates to:
  /// **'Ticket raised. Our team is on it.'**
  String get supportTicketRaised;

  /// Ticket reopened. Our team will get back to you.
  ///
  /// In en, this message translates to:
  /// **'Ticket reopened. Our team will get back to you.'**
  String get supportTicketReopened;

  /// Your tickets
  ///
  /// In en, this message translates to:
  /// **'Your tickets'**
  String get supportTickets;

  /// When the ticket last changed, for example Updated 2h ago
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String supportUpdated(String time);

  /// What happened, and since when?
  ///
  /// In en, this message translates to:
  /// **'What happened, and since when?'**
  String get supportWhatHappenedSinceWhen;

  /// What's the issue
  ///
  /// In en, this message translates to:
  /// **'What\'s the issue'**
  String get supportWhatsTheIssue;

  /// Write a message
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get supportWriteMessage;

  /// You
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get supportYou;

  /// Could not load swap stations
  ///
  /// In en, this message translates to:
  /// **'Could not load swap stations'**
  String get swapCouldNotLoad;

  /// We could not find any battery swap stations right now.
  ///
  /// In en, this message translates to:
  /// **'We could not find any battery swap stations right now.'**
  String get swapNoneBody;

  /// No swap stations found
  ///
  /// In en, this message translates to:
  /// **'No swap stations found'**
  String get swapNoneTitle;

  /// Swap stations closest to you
  ///
  /// In en, this message translates to:
  /// **'Swap stations closest to you'**
  String get swapSubtitle;

  /// Battery swapping
  ///
  /// In en, this message translates to:
  /// **'Battery swapping'**
  String get swapTitle;

  /// Units: {count}
  ///
  /// In en, this message translates to:
  /// **'Units: {count}'**
  String swapUnits(String count);

  /// Advisor
  ///
  /// In en, this message translates to:
  /// **'Advisor'**
  String get teamAdvisor;

  /// Battery Expert
  ///
  /// In en, this message translates to:
  /// **'Battery Expert'**
  String get teamBatteryExpert;

  /// Hub team
  ///
  /// In en, this message translates to:
  /// **'Hub team'**
  String get teamHubTeam;

  /// Motor Controller Repair
  ///
  /// In en, this message translates to:
  /// **'Motor Controller Repair'**
  String get teamMotorControllerRepair;

  /// Feature not included
  ///
  /// In en, this message translates to:
  /// **'Feature not included'**
  String get teamNotIncluded;

  /// This feature is not included in your current package.
  ///
  /// In en, this message translates to:
  /// **'This feature is not included in your current package.'**
  String get teamNotIncludedMessage;

  /// Technician
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get teamTechnician;

  /// Keep it clean
  ///
  /// In en, this message translates to:
  /// **'Keep it clean'**
  String get trainingCareClean;

  /// Maintain the scooter in clean and good condition.
  ///
  /// In en, this message translates to:
  /// **'Maintain the scooter in clean and good condition.'**
  String get trainingCareCleanBody;

  /// Report issues
  ///
  /// In en, this message translates to:
  /// **'Report issues'**
  String get trainingCareReport;

  /// Immediately report any accident, damage, unusual noise, warning light or vehicle fault to us.
  ///
  /// In en, this message translates to:
  /// **'Immediately report any accident, damage, unusual noise, warning light or vehicle fault to us.'**
  String get trainingCareReportBody;

  /// No tampering
  ///
  /// In en, this message translates to:
  /// **'No tampering'**
  String get trainingCareTamper;

  /// Do not open, modify or tamper with the battery, motor, controller, wiring or GPS device.
  ///
  /// In en, this message translates to:
  /// **'Do not open, modify or tamper with the battery, motor, controller, wiring or GPS device.'**
  String get trainingCareTamperBody;

  /// No deep water
  ///
  /// In en, this message translates to:
  /// **'No deep water'**
  String get trainingCareWater;

  /// Do not take the scooter through flooded/deep-water areas or use high-pressure water on it.
  ///
  /// In en, this message translates to:
  /// **'Do not take the scooter through flooded/deep-water areas or use high-pressure water on it.'**
  String get trainingCareWaterBody;

  /// Use approved equipment
  ///
  /// In en, this message translates to:
  /// **'Use approved equipment'**
  String get trainingChargeEquipment;

  /// Use only the charger/battery/accessories provided or approved by us.
  ///
  /// In en, this message translates to:
  /// **'Use only the charger/battery/accessories provided or approved by us.'**
  String get trainingChargeEquipmentBody;

  /// Park responsibly
  ///
  /// In en, this message translates to:
  /// **'Park responsibly'**
  String get trainingChargePark;

  /// Park securely at permitted locations and avoid water, fire or theft risks.
  ///
  /// In en, this message translates to:
  /// **'Park securely at permitted locations and avoid water, fire or theft risks.'**
  String get trainingChargeParkBody;

  /// Ride responsibly
  ///
  /// In en, this message translates to:
  /// **'Ride responsibly'**
  String get trainingChargeRide;

  /// No overloading, unsafe riding, jumping, racing or misuse of the scooter.
  ///
  /// In en, this message translates to:
  /// **'No overloading, unsafe riding, jumping, racing or misuse of the scooter.'**
  String get trainingChargeRideBody;

  /// Charge/swap only at designated stations
  ///
  /// In en, this message translates to:
  /// **'Charge/swap only at designated stations'**
  String get trainingChargeStations;

  /// Use only approved charging/swapping station locations.
  ///
  /// In en, this message translates to:
  /// **'Use only approved charging/swapping station locations.'**
  String get trainingChargeStationsBody;

  /// Charging & usage
  ///
  /// In en, this message translates to:
  /// **'Charging & usage'**
  String get trainingCharging;

  /// Follow these simple guidelines for a safe, smooth and hassle-free ride.
  ///
  /// In en, this message translates to:
  /// **'Follow these simple guidelines for a safe, smooth and hassle-free ride.'**
  String get trainingChargingSummary;

  /// Key points
  ///
  /// In en, this message translates to:
  /// **'Key points'**
  String get trainingKeyPoints;

  /// Payments on app only
  ///
  /// In en, this message translates to:
  /// **'Payments on app only'**
  String get trainingPayApp;

  /// All rental, deposit and other applicable payments must be made through the official app/payment process.
  ///
  /// In en, this message translates to:
  /// **'All rental, deposit and other applicable payments must be made through the official app/payment process.'**
  String get trainingPayAppBody;

  /// No bribe / unofficial payment
  ///
  /// In en, this message translates to:
  /// **'No bribe / unofficial payment'**
  String get trainingPayBribe;

  /// Never pay or offer a bribe, commission or personal payment to a TL or company representative.
  ///
  /// In en, this message translates to:
  /// **'Never pay or offer a bribe, commission or personal payment to a TL or company representative.'**
  String get trainingPayBribeBody;

  /// No cash payments
  ///
  /// In en, this message translates to:
  /// **'No cash payments'**
  String get trainingPayCash;

  /// Do not make cash payments to any TL, staff member or representative.
  ///
  /// In en, this message translates to:
  /// **'Do not make cash payments to any TL, staff member or representative.'**
  String get trainingPayCashBody;

  /// Payments & conduct
  ///
  /// In en, this message translates to:
  /// **'Payments & conduct'**
  String get trainingPayments;

  /// Follow these simple guidelines for safe, transparent and hassle-free transactions.
  ///
  /// In en, this message translates to:
  /// **'Follow these simple guidelines for safe, transparent and hassle-free transactions.'**
  String get trainingPaymentsSummary;

  /// Report concerns
  ///
  /// In en, this message translates to:
  /// **'Report concerns'**
  String get trainingPayReport;

  /// Report any demand for cash, bribe, unauthorised charge, misconduct or other issue directly to us.
  ///
  /// In en, this message translates to:
  /// **'Report any demand for cash, bribe, unauthorised charge, misconduct or other issue directly to us.'**
  String get trainingPayReportBody;

  /// Vehicle care
  ///
  /// In en, this message translates to:
  /// **'Vehicle care'**
  String get trainingVehicleCare;

  /// Keep the scooter safe, clean and ready for every ride.
  ///
  /// In en, this message translates to:
  /// **'Keep the scooter safe, clean and ready for every ride.'**
  String get trainingVehicleCareSummary;

  /// Viewed
  ///
  /// In en, this message translates to:
  /// **'Viewed'**
  String get trainingViewed;

  /// Enter a date on or before today
  ///
  /// In en, this message translates to:
  /// **'Enter a date on or before today'**
  String get validationEnterDateBeforeToday;

  /// Enter a date later than today
  ///
  /// In en, this message translates to:
  /// **'Enter a date later than today'**
  String get validationEnterDateLaterThanToday;

  /// Enter a valid 12-digit Aadhaar number
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 12-digit Aadhaar number'**
  String get validationEnterValid12DigitAadhaar;

  /// Enter a valid email address
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validationEnterValidEmailAddress;

  /// Enter a valid IFSC code
  ///
  /// In en, this message translates to:
  /// **'Enter a valid IFSC code'**
  String get validationEnterValidIfscCode;

  /// Enter a valid PAN (ABCDE1234F)
  ///
  /// In en, this message translates to:
  /// **'Enter a valid PAN (ABCDE1234F)'**
  String get validationEnterValidPanAbcde1234f;

  /// Enter a valid UPI ID
  ///
  /// In en, this message translates to:
  /// **'Enter a valid UPI ID'**
  String get validationEnterValidUpiId;

  /// This field
  ///
  /// In en, this message translates to:
  /// **'This field'**
  String get validationField;

  /// Approve
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get verifyApprove;

  /// Approve all documents to assign a vehicle.
  ///
  /// In en, this message translates to:
  /// **'Approve all documents to assign a vehicle.'**
  String get verifyApproveAllFirst;

  /// Approved
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get verifyApproved;

  /// Approve this document?
  ///
  /// In en, this message translates to:
  /// **'Approve this document?'**
  String get verifyApproveDocument;

  /// Confirm message before approving a rider document or reference
  ///
  /// In en, this message translates to:
  /// **'{name} will be marked as verified. This can\'t be changed later.'**
  String verifyApproveMessage(String name);

  /// Approve this reference?
  ///
  /// In en, this message translates to:
  /// **'Approve this reference?'**
  String get verifyApproveReference;

  /// Continue to assign vehicle
  ///
  /// In en, this message translates to:
  /// **'Continue to assign vehicle'**
  String get verifyContinue;

  /// Couldn't start the call.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start the call.'**
  String get verifyCouldNotCall;

  /// Couldn't load this list.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this list.'**
  String get verifyCouldNotLoad;

  /// Document approved
  ///
  /// In en, this message translates to:
  /// **'Document approved'**
  String get verifyDocumentApproved;

  /// Document rejected
  ///
  /// In en, this message translates to:
  /// **'Document rejected'**
  String get verifyDocumentRejected;

  /// Documents
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get verifyDocuments;

  /// Open each document the rider uploaded, then approve or reject it.
  ///
  /// In en, this message translates to:
  /// **'Open each document the rider uploaded, then approve or reject it.'**
  String get verifyDocumentsHint;

  /// Fleet managers can't review documents yet. Your admin can review them on the dashboard.
  ///
  /// In en, this message translates to:
  /// **'Fleet managers can\'t review documents yet. Your admin can review them on the dashboard.'**
  String get verifyDocumentsLocked;

  /// The rider hasn't uploaded any documents yet.
  ///
  /// In en, this message translates to:
  /// **'The rider hasn\'t uploaded any documents yet.'**
  String get verifyNoDocuments;

  /// The rider hasn't added any references.
  ///
  /// In en, this message translates to:
  /// **'The rider hasn\'t added any references.'**
  String get verifyNoReferences;

  /// Reason
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get verifyReason;

  /// e.g. Photo is blurry
  ///
  /// In en, this message translates to:
  /// **'e.g. Photo is blurry'**
  String get verifyReasonHint;

  /// Enter a reason
  ///
  /// In en, this message translates to:
  /// **'Enter a reason'**
  String get verifyReasonRequired;

  /// Reference approved
  ///
  /// In en, this message translates to:
  /// **'Reference approved'**
  String get verifyReferenceApproved;

  /// Reference rejected
  ///
  /// In en, this message translates to:
  /// **'Reference rejected'**
  String get verifyReferenceRejected;

  /// References
  ///
  /// In en, this message translates to:
  /// **'References'**
  String get verifyReferences;

  /// Call each reference to confirm, then approve or reject.
  ///
  /// In en, this message translates to:
  /// **'Call each reference to confirm, then approve or reject.'**
  String get verifyReferencesHint;

  /// Reject
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get verifyReject;

  /// Rejected
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get verifyRejected;

  /// Add a short reason for rejecting it.
  ///
  /// In en, this message translates to:
  /// **'Add a short reason for rejecting it.'**
  String get verifyRejectSubtitle;

  /// Title of the reject reason sheet
  ///
  /// In en, this message translates to:
  /// **'Reject {name}'**
  String verifyRejectTitle(String name);

  /// Who reviewed a rider reference
  ///
  /// In en, this message translates to:
  /// **'Reviewed by {name}'**
  String verifyReviewedBy(String name);

  /// Verify rider
  ///
  /// In en, this message translates to:
  /// **'Verify rider'**
  String get verifyTitle;

  /// When a rider document was uploaded
  ///
  /// In en, this message translates to:
  /// **'Uploaded {date}'**
  String verifyUploadedOn(String date);

  /// View
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get verifyView;

  /// Available
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get walletAvailable;

  /// Cash
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get walletCash;

  /// Closing balance
  ///
  /// In en, this message translates to:
  /// **'Closing balance'**
  String get walletClosingBalance;

  /// When a deposit return completed
  ///
  /// In en, this message translates to:
  /// **'Completed {date}'**
  String walletCompletedOn(String date);

  /// Could not refresh the deposit details
  ///
  /// In en, this message translates to:
  /// **'Could not refresh the deposit details'**
  String get walletCouldNotLoadDeposit;

  /// Could not load the receipt
  ///
  /// In en, this message translates to:
  /// **'Could not load the receipt'**
  String get walletCouldNotLoadReceipt;

  /// Could not load your statement
  ///
  /// In en, this message translates to:
  /// **'Could not load your statement'**
  String get walletCouldNotLoadStatement;

  /// Could not load your wallet
  ///
  /// In en, this message translates to:
  /// **'Could not load your wallet'**
  String get walletCouldNotLoadWallet;

  /// Credited
  ///
  /// In en, this message translates to:
  /// **'Credited'**
  String get walletCredited;

  /// Credits
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get walletCredits;

  /// Date & time
  ///
  /// In en, this message translates to:
  /// **'Date & time'**
  String get walletDateTime;

  /// Debits
  ///
  /// In en, this message translates to:
  /// **'Debits'**
  String get walletDebits;

  /// Deducted
  ///
  /// In en, this message translates to:
  /// **'Deducted'**
  String get walletDeducted;

  /// Deployment payment
  ///
  /// In en, this message translates to:
  /// **'Deployment payment'**
  String get walletDeploymentPayment;

  /// Deposit
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get walletDeposit;

  /// Deducted
  ///
  /// In en, this message translates to:
  /// **'Deducted'**
  String get walletDepositDeducted;

  /// Held
  ///
  /// In en, this message translates to:
  /// **'Held'**
  String get walletDepositHeld;

  /// Locked for your rental
  ///
  /// In en, this message translates to:
  /// **'Locked for your rental'**
  String get walletDepositLocked;

  /// Deposit part of a wallet movement
  ///
  /// In en, this message translates to:
  /// **'Deposit {amount}'**
  String walletDepositMoved(String amount);

  /// Paid in
  ///
  /// In en, this message translates to:
  /// **'Paid in'**
  String get walletDepositPaidIn;

  /// Required
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get walletDepositRequired;

  /// Returned
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get walletDepositReturnedAmount;

  /// Your deposit comes back separately when you leave.
  ///
  /// In en, this message translates to:
  /// **'Your deposit comes back separately when you leave.'**
  String get walletDepositReturnedSeparately;

  /// Returns
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get walletDepositReturns;

  /// Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get walletDepositStatusCancelled;

  /// Forfeited
  ///
  /// In en, this message translates to:
  /// **'Forfeited'**
  String get walletDepositStatusForfeited;

  /// Held for your rental
  ///
  /// In en, this message translates to:
  /// **'Held for your rental'**
  String get walletDepositStatusLocked;

  /// Paid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get walletDepositStatusPaid;

  /// Partly deducted
  ///
  /// In en, this message translates to:
  /// **'Partly deducted'**
  String get walletDepositStatusPartlyDeducted;

  /// Part paid
  ///
  /// In en, this message translates to:
  /// **'Part paid'**
  String get walletDepositStatusPartlyPaid;

  /// Awaiting payment
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get walletDepositStatusPending;

  /// Ready to return
  ///
  /// In en, this message translates to:
  /// **'Ready to return'**
  String get walletDepositStatusReturnable;

  /// Returned
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get walletDepositStatusReturned;

  /// Return requested
  ///
  /// In en, this message translates to:
  /// **'Return requested'**
  String get walletDepositStatusReturnRequested;

  /// Still to pay
  ///
  /// In en, this message translates to:
  /// **'Still to pay'**
  String get walletDepositToPay;

  /// Paid to
  ///
  /// In en, this message translates to:
  /// **'Paid to'**
  String get walletDestination;

  /// Due now
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get walletDueNow;

  /// This deposit isn't available.
  ///
  /// In en, this message translates to:
  /// **'This deposit isn\'t available.'**
  String get walletErrorDepositNotFound;

  /// Your wallet isn't set up yet.
  ///
  /// In en, this message translates to:
  /// **'Your wallet isn\'t set up yet.'**
  String get walletErrorNotFound;

  /// This receipt isn't available.
  ///
  /// In en, this message translates to:
  /// **'This receipt isn\'t available.'**
  String get walletErrorReceiptNotFound;

  /// A statement isn't available for that period.
  ///
  /// In en, this message translates to:
  /// **'A statement isn\'t available for that period.'**
  String get walletErrorStatementPeriod;

  /// This transaction isn't available.
  ///
  /// In en, this message translates to:
  /// **'This transaction isn\'t available.'**
  String get walletErrorTransactionNotFound;

  /// Expiring in 7 days
  ///
  /// In en, this message translates to:
  /// **'Expiring in 7 days'**
  String get walletExpiringSoon;

  /// Deposit paid out of the required amount
  ///
  /// In en, this message translates to:
  /// **'{funded} of {required}'**
  String walletFundedOf(String funded, String required);

  /// Bills settled
  ///
  /// In en, this message translates to:
  /// **'Bills settled'**
  String get walletInvoicesSettled;

  /// Issued
  ///
  /// In en, this message translates to:
  /// **'Issued'**
  String get walletIssued;

  /// Adjustment
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get walletKindAdjustment;

  /// Security deposit
  ///
  /// In en, this message translates to:
  /// **'Security deposit'**
  String get walletKindDeposit;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get walletKindPayment;

  /// Penalty
  ///
  /// In en, this message translates to:
  /// **'Penalty'**
  String get walletKindPenalty;

  /// Refund
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get walletKindRefund;

  /// Rent
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get walletKindRental;

  /// Reward
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get walletKindReward;

  /// Service charge
  ///
  /// In en, this message translates to:
  /// **'Service charge'**
  String get walletKindService;

  /// Money added
  ///
  /// In en, this message translates to:
  /// **'Money added'**
  String get walletKindTopUp;

  /// Your ledger will fill up as you ride and earn.
  ///
  /// In en, this message translates to:
  /// **'Your ledger will fill up as you ride and earn.'**
  String get walletLedgerWillFillUpAs;

  /// Method
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get walletMethod;

  /// Your money
  ///
  /// In en, this message translates to:
  /// **'Your money'**
  String get walletMoney;

  /// Money in
  ///
  /// In en, this message translates to:
  /// **'Money in'**
  String get walletMoneyIn;

  /// Money out
  ///
  /// In en, this message translates to:
  /// **'Money out'**
  String get walletMoneyOut;

  /// Nothing matches this filter yet.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches this filter yet.'**
  String get walletNothingMatchesFilterYet;

  /// No transactions here
  ///
  /// In en, this message translates to:
  /// **'No transactions here'**
  String get walletNoTransactionsHere;

  /// on hold
  ///
  /// In en, this message translates to:
  /// **'on hold'**
  String get walletOnHold;

  /// Opening balance
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get walletOpeningBalance;

  /// Payments
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get walletPayments;

  /// Receipt
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get walletReceipt;

  /// Receipt number
  ///
  /// In en, this message translates to:
  /// **'Receipt number'**
  String get walletReceiptNumber;

  /// Reference ID
  ///
  /// In en, this message translates to:
  /// **'Reference ID'**
  String get walletReferenceId;

  /// Refundable
  ///
  /// In en, this message translates to:
  /// **'Refundable'**
  String get walletRefundable;

  /// When a deposit return was requested
  ///
  /// In en, this message translates to:
  /// **'Requested {date}'**
  String walletRequestedOn(String date);

  /// Approved
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get walletReturnApproved;

  /// Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get walletReturnCancelled;

  /// Returned
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get walletReturnDone;

  /// Failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get walletReturnFailed;

  /// Processing
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get walletReturnProcessing;

  /// Rejected
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get walletReturnRejected;

  /// Requested
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get walletReturnRequested;

  /// Under review
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get walletReturnReview;

  /// Reward expired
  ///
  /// In en, this message translates to:
  /// **'Reward expired'**
  String get walletRewardExpired;

  /// Reward taken back
  ///
  /// In en, this message translates to:
  /// **'Reward taken back'**
  String get walletRewardReversed;

  /// Earned so far
  ///
  /// In en, this message translates to:
  /// **'Earned so far'**
  String get walletRewardsEarned;

  /// Search transactions
  ///
  /// In en, this message translates to:
  /// **'Search transactions'**
  String get walletSearchTransactions;

  /// Security deposit
  ///
  /// In en, this message translates to:
  /// **'Security deposit'**
  String get walletSecurityDeposit;

  /// Failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get walletStateFailed;

  /// Statement
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get walletStatement;

  /// Nothing this month
  ///
  /// In en, this message translates to:
  /// **'Nothing this month'**
  String get walletStatementEmpty;

  /// Money that moves in or out of your wallet this month will show up here.
  ///
  /// In en, this message translates to:
  /// **'Money that moves in or out of your wallet this month will show up here.'**
  String get walletStatementEmptyBody;

  /// Reference code of a wallet statement
  ///
  /// In en, this message translates to:
  /// **'Statement ref {reference}'**
  String walletStatementReference(String reference);

  /// Month by month, with exact money in and out
  ///
  /// In en, this message translates to:
  /// **'Month by month, with exact money in and out'**
  String get walletStatementSubtitle;

  /// This month
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get walletStatementSummary;

  /// Pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get walletStatePending;

  /// Reversed
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get walletStateReversed;

  /// Settled
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get walletStateSettled;

  /// To your bank account
  ///
  /// In en, this message translates to:
  /// **'To your bank account'**
  String get walletToBank;

  /// To your wallet
  ///
  /// In en, this message translates to:
  /// **'To your wallet'**
  String get walletToWallet;

  /// Transactions
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get walletTransactions;

  /// Receipt
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get walletViewReceipt;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'kn', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
    case 'hi':
      return AppL10nHi();
    case 'kn':
      return AppL10nKn();
    case 'te':
      return AppL10nTe();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
