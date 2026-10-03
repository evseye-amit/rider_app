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

  /// Abandon
  ///
  /// In en, this message translates to:
  /// **'Abandon'**
  String get allocationAbandon;

  /// Abandon this de-allocation?
  ///
  /// In en, this message translates to:
  /// **'Abandon this de-allocation?'**
  String get allocationAbandonDeAllocation;

  /// Active allocation
  ///
  /// In en, this message translates to:
  /// **'Active allocation'**
  String get allocationActiveAllocation;

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

  /// Attention required
  ///
  /// In en, this message translates to:
  /// **'Attention required'**
  String get allocationAttentionRequired;

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

  /// Bypass and deploy
  ///
  /// In en, this message translates to:
  /// **'Bypass and deploy'**
  String get allocationBypassDeploy;

  /// Use this when the IoT unit cannot be paired at the hub. The unit's current health is recorded with your reason.
  ///
  /// In en, this message translates to:
  /// **'Use this when the IoT unit cannot be paired at the hub. The unit\'s current health is recorded with your reason.'**
  String get allocationBypassExplainer;

  /// Bypass pairing?
  ///
  /// In en, this message translates to:
  /// **'Bypass pairing?'**
  String get allocationBypassPairing;

  /// Bypass pairing
  ///
  /// In en, this message translates to:
  /// **'Bypass pairing'**
  String get allocationBypassPairing2;

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

  /// This client requires no inspection photos. You can write up the checklist now.
  ///
  /// In en, this message translates to:
  /// **'This client requires no inspection photos. You can write up the checklist now.'**
  String get allocationClientRequiresNoInspectionPhotos;

  /// Codes are sent when this step opens.
  ///
  /// In en, this message translates to:
  /// **'Codes are sent when this step opens.'**
  String get allocationCodesSentWhenStepOpens;

  /// Compare the returned vehicle against this reference set
  ///
  /// In en, this message translates to:
  /// **'Compare the returned vehicle against this reference set'**
  String get allocationCompareReturnedVehicleAgainstReference;

  /// Complete
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get allocationComplete;

  /// Complete.
  ///
  /// In en, this message translates to:
  /// **'Complete.'**
  String get allocationComplete2;

  /// Complete this de-allocation?
  ///
  /// In en, this message translates to:
  /// **'Complete this de-allocation?'**
  String get allocationCompleteDeAllocation;

  /// Completes the handover without the rider pairing the device
  ///
  /// In en, this message translates to:
  /// **'Completes the handover without the rider pairing the device'**
  String get allocationCompletesHandoverWithoutRiderPairing;

  /// Condition
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get allocationCondition;

  /// Confirm you have received the amount the rider submitted a reference for. This cannot be undone.
  ///
  /// In en, this message translates to:
  /// **'Confirm you have received the amount the rider submitted a reference for. This cannot be undone.'**
  String get allocationConfirmHaveReceivedAmountRider;

  /// Confirms the vehicle's photos are on file and its IoT unit is online.
  ///
  /// In en, this message translates to:
  /// **'Confirms the vehicle\'s photos are on file and its IoT unit is online.'**
  String get allocationConfirmsPhotosAndIot;

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

  /// Could not load the de-allocation flow
  ///
  /// In en, this message translates to:
  /// **'Could not load the de-allocation flow'**
  String get allocationCouldNotLoadDeAllocation;

  /// Could not load the de-allocation flow.
  ///
  /// In en, this message translates to:
  /// **'Could not load the de-allocation flow.'**
  String get allocationCouldNotLoadDeAllocation2;

  /// Could not load this handover
  ///
  /// In en, this message translates to:
  /// **'Could not load this handover'**
  String get allocationCouldNotLoadHandover;

  /// Could not load this return
  ///
  /// In en, this message translates to:
  /// **'Could not load this return'**
  String get allocationCouldNotLoadReturn;

  /// Could not load returns
  ///
  /// In en, this message translates to:
  /// **'Could not load returns'**
  String get allocationCouldNotLoadReturns;

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

  /// Device
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get allocationDevice;

  /// Every de-allocation request has been processed.
  ///
  /// In en, this message translates to:
  /// **'Every de-allocation request has been processed.'**
  String get allocationEveryDeAllocationRequestHas;

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

  /// Front
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get allocationFront;

  /// Handover completed without pairing
  ///
  /// In en, this message translates to:
  /// **'Handover completed without pairing'**
  String get allocationHandoverCompletedWithoutPairing;

  /// Healthy
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get allocationHealthy;

  /// Heartbeat
  ///
  /// In en, this message translates to:
  /// **'Heartbeat'**
  String get allocationHeartbeat;

  /// Heartbeat stale
  ///
  /// In en, this message translates to:
  /// **'Heartbeat stale'**
  String get allocationHeartbeatStale;

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

  /// Inspection evidence
  ///
  /// In en, this message translates to:
  /// **'Inspection evidence'**
  String get allocationInspectionEvidence;

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

  /// Inspection, training, pairing
  ///
  /// In en, this message translates to:
  /// **'Inspection, training, pairing'**
  String get allocationInspectionTrainingPairing;

  /// IoT device
  ///
  /// In en, this message translates to:
  /// **'IoT device'**
  String get allocationIotDevice;

  /// Item
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get allocationItem;

  /// Keep going
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get allocationKeepGoing;

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

  /// Map a device first
  ///
  /// In en, this message translates to:
  /// **'Map a device first'**
  String get allocationMapDeviceFirst;

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

  /// Never
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get allocationNever;

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

  /// No IoT device
  ///
  /// In en, this message translates to:
  /// **'No IoT device'**
  String get allocationNoIotDevice;

  /// Nothing is currently allocated to a rider.
  ///
  /// In en, this message translates to:
  /// **'Nothing is currently allocated to a rider.'**
  String get allocationNothingCurrentlyAllocatedRider;

  /// Nothing to take back
  ///
  /// In en, this message translates to:
  /// **'Nothing to take back'**
  String get allocationNothingTakeBack;

  /// Not mapped
  ///
  /// In en, this message translates to:
  /// **'Not mapped'**
  String get allocationNotMapped;

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

  /// Original handover photos
  ///
  /// In en, this message translates to:
  /// **'Original handover photos'**
  String get allocationOriginalHandoverPhotos;

  /// Out on road
  ///
  /// In en, this message translates to:
  /// **'Out on road'**
  String get allocationOutRoad;

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

  /// Photo attached
  ///
  /// In en, this message translates to:
  /// **'Photo attached'**
  String get allocationPhotoAttached;

  /// Process return
  ///
  /// In en, this message translates to:
  /// **'Process return'**
  String get allocationProcessReturn;

  /// In the queue
  ///
  /// In en, this message translates to:
  /// **'In the queue'**
  String get allocationQueue;

  /// Raised on
  ///
  /// In en, this message translates to:
  /// **'Raised on'**
  String get allocationRaised;

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

  /// A reason is required to bypass
  ///
  /// In en, this message translates to:
  /// **'A reason is required to bypass'**
  String get allocationReasonRequiredBypass;

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

  /// The return has already been started on the server. You can finish it later from the Returns tab.
  ///
  /// In en, this message translates to:
  /// **'The return has already been started on the server. You can finish it later from the Returns tab.'**
  String get allocationReturnHasAlreadyBeenStarted;

  /// Return initiated
  ///
  /// In en, this message translates to:
  /// **'Return initiated'**
  String get allocationReturnInitiated;

  /// Return reason
  ///
  /// In en, this message translates to:
  /// **'Return reason'**
  String get allocationReturnReason;

  /// Return request
  ///
  /// In en, this message translates to:
  /// **'Return request'**
  String get allocationReturnRequest;

  /// Return started — codes sent to the rider and to you
  ///
  /// In en, this message translates to:
  /// **'Return started — codes sent to the rider and to you'**
  String get allocationReturnStartedCodesSentRider;

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

  /// The rider is completing the safety training in their app. Pairing opens once every mandatory module is done.
  ///
  /// In en, this message translates to:
  /// **'The rider is completing the safety training in their app. Pairing opens once every mandatory module is done.'**
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

  /// The rider paired the scooter and is on the road. This handover is complete.
  ///
  /// In en, this message translates to:
  /// **'The rider paired the scooter and is on the road. This handover is complete.'**
  String get allocationRiderPairedScooterRoadHandover;

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

  /// SIM
  ///
  /// In en, this message translates to:
  /// **'SIM'**
  String get allocationSim;

  /// Start a return
  ///
  /// In en, this message translates to:
  /// **'Start a return'**
  String get allocationStartReturn;

  /// Take a vehicle back and put it on the shelf
  ///
  /// In en, this message translates to:
  /// **'Take a vehicle back and put it on the shelf'**
  String get allocationTakeVehicleBackPutShelf;

  /// Talking to the server…
  ///
  /// In en, this message translates to:
  /// **'Talking to the server…'**
  String get allocationTalkingServer;

  /// Training done · pairing
  ///
  /// In en, this message translates to:
  /// **'Training done · pairing'**
  String get allocationTrainingDonePairing;

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

  /// View return
  ///
  /// In en, this message translates to:
  /// **'View return'**
  String get allocationViewReturn;

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

  /// Waiting for rider to pair — or bypass
  ///
  /// In en, this message translates to:
  /// **'Waiting for rider to pair — or bypass'**
  String get allocationWaitingRiderPairBypass;

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

  /// You write the PDI checklist; the rider accepts it, completes training and pairs the IoT unit.
  ///
  /// In en, this message translates to:
  /// **'You write the PDI checklist; the rider accepts it, completes training and pairs the IoT unit.'**
  String get allocationWritePdiChecklistRiderAccepts;

  /// Go home
  ///
  /// In en, this message translates to:
  /// **'Go home'**
  String get appGoHome;

  /// Pink Rides Ops
  ///
  /// In en, this message translates to:
  /// **'Pink Rides Ops'**
  String get appPinkRidesOps;

  /// Pink Rides Rental
  ///
  /// In en, this message translates to:
  /// **'Pink Rides Rental'**
  String get appPinkRidesRental;

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

  /// Connector between the two legal links
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get commonAnd;

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

  /// De-allocation
  ///
  /// In en, this message translates to:
  /// **'De-allocation'**
  String get commonDeAllocation;

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

  /// Odometer
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get commonOdometer;

  /// Offline
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get commonOffline;

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

  /// Paired
  ///
  /// In en, this message translates to:
  /// **'Paired'**
  String get commonPaired;

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

  /// Finish training
  ///
  /// In en, this message translates to:
  /// **'Finish training'**
  String get deploymentFinishTraining;

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

  /// Mandatory module
  ///
  /// In en, this message translates to:
  /// **'Mandatory module'**
  String get deploymentMandatoryModule;

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

  /// Optional module
  ///
  /// In en, this message translates to:
  /// **'Optional module'**
  String get deploymentOptionalModule;

  /// Paid via
  ///
  /// In en, this message translates to:
  /// **'Paid via'**
  String get deploymentPaidVia;

  /// Pair the IoT unit
  ///
  /// In en, this message translates to:
  /// **'Pair the IoT unit'**
  String get deploymentPairIotUnit;

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

  /// Read through this module with your team lead before you ride.
  ///
  /// In en, this message translates to:
  /// **'Read through this module with your team lead before you ride.'**
  String get deploymentReadThroughModuleWithTeam;

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

  /// Safety training
  ///
  /// In en, this message translates to:
  /// **'Safety training'**
  String get deploymentSafetyTraining;

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

  /// Training complete
  ///
  /// In en, this message translates to:
  /// **'Training complete'**
  String get deploymentTrainingComplete;

  /// Training unavailable
  ///
  /// In en, this message translates to:
  /// **'Training unavailable'**
  String get deploymentTrainingUnavailable;

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

  /// Pairing the IoT device
  ///
  /// In en, this message translates to:
  /// **'Pairing the IoT device'**
  String get errorPairingIotDevice;

  /// Payment pending
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get errorPaymentPending;

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

  /// Accept offer
  ///
  /// In en, this message translates to:
  /// **'Accept offer'**
  String get exchangeAcceptOffer;

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

  /// Completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get exchangeCompleted;

  /// Could not load exchanges
  ///
  /// In en, this message translates to:
  /// **'Could not load exchanges'**
  String get exchangeCouldNotLoad;

  /// Deposit change
  ///
  /// In en, this message translates to:
  /// **'Deposit change'**
  String get exchangeDepositChange;

  /// Exchange request
  ///
  /// In en, this message translates to:
  /// **'Exchange request'**
  String get exchangeDetailTitle;

  /// Changes from
  ///
  /// In en, this message translates to:
  /// **'Changes from'**
  String get exchangeEffective;

  /// Needs your answer
  ///
  /// In en, this message translates to:
  /// **'Needs your answer'**
  String get exchangeNeedsYou;

  /// No exchange requests
  ///
  /// In en, this message translates to:
  /// **'No exchange requests'**
  String get exchangeNone;

  /// If your scooter has a problem, your hub can start an exchange for you.
  ///
  /// In en, this message translates to:
  /// **'If your scooter has a problem, your hub can start an exchange for you.'**
  String get exchangeNoneMessage;

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

  /// Finished
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get exchangePast;

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

  /// Safety swap
  ///
  /// In en, this message translates to:
  /// **'Safety swap'**
  String get exchangeReasonSafety;

  /// Not safe to ride
  ///
  /// In en, this message translates to:
  /// **'Not safe to ride'**
  String get exchangeReasonUnsafe;

  /// Upgrade
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get exchangeReasonUpgrade;

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

  /// Rent change
  ///
  /// In en, this message translates to:
  /// **'Rent change'**
  String get exchangeRentChange;

  /// Accepted
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get exchangeStageAccepted;

  /// Closed
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get exchangeStageClosed;

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

  /// Being checked
  ///
  /// In en, this message translates to:
  /// **'Being checked'**
  String get exchangeStageInReview;

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

  /// Your hub is working on this. We will tell you when there is an offer.
  ///
  /// In en, this message translates to:
  /// **'Your hub is working on this. We will tell you when there is an offer.'**
  String get exchangeWaitingOnHub;

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

  /// Could not load your dashboard
  ///
  /// In en, this message translates to:
  /// **'Could not load your dashboard'**
  String get homeCouldNotLoadDashboard;

  /// Deposits and handover fees
  ///
  /// In en, this message translates to:
  /// **'Deposits and handover fees'**
  String get homeDepositsHandoverFees;

  /// Distance
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get homeDistance;

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

  /// Trips
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get homeTrips;

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

  /// Allocate
  ///
  /// In en, this message translates to:
  /// **'Allocate'**
  String get hubAllocate;

  /// Bays free
  ///
  /// In en, this message translates to:
  /// **'Bays free'**
  String get hubBaysFree;

  /// Could not load your hub
  ///
  /// In en, this message translates to:
  /// **'Could not load your hub'**
  String get hubCouldNotLoadHub;

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

  /// Your hubs
  ///
  /// In en, this message translates to:
  /// **'Your hubs'**
  String get hubHubs;

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

  /// Open jobs
  ///
  /// In en, this message translates to:
  /// **'Open jobs'**
  String get hubOpenJobs;

  /// Pick one, or several to see their numbers combined
  ///
  /// In en, this message translates to:
  /// **'Pick one, or several to see their numbers combined'**
  String get hubPickOneSeveralSeeTheir;

  /// Return
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get hubReturn;

  /// Returns to clear
  ///
  /// In en, this message translates to:
  /// **'Returns to clear'**
  String get hubReturnsClear;

  /// Riders present
  ///
  /// In en, this message translates to:
  /// **'Riders present'**
  String get hubRidersPresent;

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

  /// Show this hub
  ///
  /// In en, this message translates to:
  /// **'Show this hub'**
  String get hubShowThisHub;

  /// Something went wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get hubSomethingWentWrong;

  /// Uptime
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get hubUptime;

  /// Waiting to allocate
  ///
  /// In en, this message translates to:
  /// **'Waiting to allocate'**
  String get hubWaitingAllocate;

  /// Working late
  ///
  /// In en, this message translates to:
  /// **'Working late'**
  String get hubWorkingLate;

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

  /// New earnings, reminders and alerts will show up here.
  ///
  /// In en, this message translates to:
  /// **'New earnings, reminders and alerts will show up here.'**
  String get notificationsNewEarningsRemindersAlertsWill;

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

  /// This document has expired. Enter a date later than today.
  ///
  /// In en, this message translates to:
  /// **'This document has expired. Enter a date later than today.'**
  String get onboardingDocumentHasExpiredEnterDate;

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

  /// Auto-debit mandate
  ///
  /// In en, this message translates to:
  /// **'Auto-debit mandate'**
  String get rentalsAutoDebitMandate;

  /// Auto-debit is not active — settle upcoming invoices manually until the mandate is restored.
  ///
  /// In en, this message translates to:
  /// **'Auto-debit is not active — settle upcoming invoices manually until the mandate is restored.'**
  String get rentalsAutoDebitNotActiveSettle;

  /// Billing period
  ///
  /// In en, this message translates to:
  /// **'Billing period'**
  String get rentalsBillingPeriod;

  /// Could not load your rent plan
  ///
  /// In en, this message translates to:
  /// **'Could not load your rent plan'**
  String get rentalsCouldNotLoadRentPlan;

  /// Current plan
  ///
  /// In en, this message translates to:
  /// **'Current plan'**
  String get rentalsCurrentPlan;

  /// Debits in
  ///
  /// In en, this message translates to:
  /// **'Debits in'**
  String get rentalsDebits;

  /// Download PDF
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get rentalsDownloadPdf;

  /// Due on
  ///
  /// In en, this message translates to:
  /// **'Due on'**
  String get rentalsDue;

  /// Failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get rentalsFailed;

  /// Invoice history
  ///
  /// In en, this message translates to:
  /// **'Invoice history'**
  String get rentalsInvoiceHistory;

  /// Maintenance cover
  ///
  /// In en, this message translates to:
  /// **'Maintenance cover'**
  String get rentalsMaintenanceCover;

  /// Next debit
  ///
  /// In en, this message translates to:
  /// **'Next debit'**
  String get rentalsNextDebit;

  /// No invoices yet
  ///
  /// In en, this message translates to:
  /// **'No invoices yet'**
  String get rentalsNoInvoicesYet;

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

  /// Your plan, auto-debit and rent receipts
  ///
  /// In en, this message translates to:
  /// **'Your plan, auto-debit and rent receipts'**
  String get rentalsPlanAutoDebitRentReceipts;

  /// Rentals
  ///
  /// In en, this message translates to:
  /// **'Rentals'**
  String get rentalsRentals;

  /// Rent is collected automatically from your linked bank account on the debit date above.
  ///
  /// In en, this message translates to:
  /// **'Rent is collected automatically from your linked bank account on the debit date above.'**
  String get rentalsRentCollectedAutomaticallyFromLinked;

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

  /// Tap a receipt to see the full breakdown
  ///
  /// In en, this message translates to:
  /// **'Tap a receipt to see the full breakdown'**
  String get rentalsTapReceiptSeeFullBreakdown;

  /// Vehicle rent
  ///
  /// In en, this message translates to:
  /// **'Vehicle rent'**
  String get rentalsVehicleRent;

  /// Pairing your scooter
  ///
  /// In en, this message translates to:
  /// **'Pairing your scooter'**
  String get ridePairingScooter;

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

  /// Talking to the IoT unit. Keep your phone close.
  ///
  /// In en, this message translates to:
  /// **'Talking to the IoT unit. Keep your phone close.'**
  String get rideTalkingIotUnitKeepPhone;

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

  /// Device ID
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get scooterDeviceId;

  /// Device number
  ///
  /// In en, this message translates to:
  /// **'Device number'**
  String get scooterDeviceNumber;

  /// Firmware
  ///
  /// In en, this message translates to:
  /// **'Firmware'**
  String get scooterFirmware;

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

  /// Last ping
  ///
  /// In en, this message translates to:
  /// **'Last ping'**
  String get scooterLastPing;

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

  /// Signal strength
  ///
  /// In en, this message translates to:
  /// **'Signal strength'**
  String get scooterSignalStrength;

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

  /// Any settled balance can be withdrawn once a day. Payouts before
  ///
  /// In en, this message translates to:
  /// **'Any settled balance can be withdrawn once a day. Payouts before '**
  String get supportAnySettledBalanceCanWithdrawn;

  /// Battery or charging
  ///
  /// In en, this message translates to:
  /// **'Battery or charging'**
  String get supportBatteryCharging;

  /// Battery drops to 20% within 40 km
  ///
  /// In en, this message translates to:
  /// **'Battery drops to 20% within 40 km'**
  String get supportBatteryDrops20Within40;

  /// Borne by you
  ///
  /// In en, this message translates to:
  /// **'Borne by you'**
  String get supportBorneBy;

  /// Breakdown on the road
  ///
  /// In en, this message translates to:
  /// **'Breakdown on the road'**
  String get supportBreakdownRoad;

  /// Call back within 15 min
  ///
  /// In en, this message translates to:
  /// **'Call back within 15 min'**
  String get supportCallBackWithin15Min;

  /// Can I keep the scooter overnight?
  ///
  /// In en, this message translates to:
  /// **'Can I keep the scooter overnight?'**
  String get supportCanIKeepScooterOvernight;

  /// Choose a category
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get supportChooseCategory;

  /// Could not load support
  ///
  /// In en, this message translates to:
  /// **'Could not load support'**
  String get supportCouldNotLoadSupport;

  /// This decides who picks up your ticket and how fast
  ///
  /// In en, this message translates to:
  /// **'This decides who picks up your ticket and how fast'**
  String get supportDecidesWhoPicksUpTicket;

  /// Description
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get supportDescription;

  /// Documents and KYC
  ///
  /// In en, this message translates to:
  /// **'Documents and KYC'**
  String get supportDocumentsKyc;

  /// Every Monday morning against your NACH mandate. If the wallet
  ///
  /// In en, this message translates to:
  /// **'Every Monday morning against your NACH mandate. If the wallet '**
  String get supportEveryMondayMorningAgainstNach;

  /// General
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get supportGeneral;

  /// How soon can I withdraw my earnings?
  ///
  /// In en, this message translates to:
  /// **'How soon can I withdraw my earnings?'**
  String get supportHowSoonCanIWithdraw;

  /// Licence re-upload after renewal
  ///
  /// In en, this message translates to:
  /// **'Licence re-upload after renewal'**
  String get supportLicenceReUploadAfterRenewal;

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

  /// Photos (optional)
  ///
  /// In en, this message translates to:
  /// **'Photos (optional)'**
  String get supportPhotosOptional;

  /// Raise a Battery or charging ticket and swap at the nearest hub.
  ///
  /// In en, this message translates to:
  /// **'Raise a Battery or charging ticket and swap at the nearest hub. '**
  String get supportRaiseBatteryChargingTicketSwap;

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

  /// Rear tyre puncture near Ashram
  ///
  /// In en, this message translates to:
  /// **'Rear tyre puncture near Ashram'**
  String get supportRearTyrePunctureNearAshram;

  /// Referral bonus for Sunil not credited
  ///
  /// In en, this message translates to:
  /// **'Referral bonus for Sunil not credited'**
  String get supportReferralBonusSunilNotCredited;

  /// Repairs across your tickets
  ///
  /// In en, this message translates to:
  /// **'Repairs across your tickets'**
  String get supportRepairsAcrossTickets;

  /// Resolved
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get supportResolved;

  /// Response within 1 day
  ///
  /// In en, this message translates to:
  /// **'Response within 1 day'**
  String get supportResponseWithin1Day;

  /// Response within 30 min
  ///
  /// In en, this message translates to:
  /// **'Response within 30 min'**
  String get supportResponseWithin30Min;

  /// Response within 4 hours
  ///
  /// In en, this message translates to:
  /// **'Response within 4 hours'**
  String get supportResponseWithin4Hours;

  /// Roadside within 45 min
  ///
  /// In en, this message translates to:
  /// **'Roadside within 45 min'**
  String get supportRoadsideWithin45Min;

  /// Select a category
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get supportSelectCategory;

  /// Something else
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get supportSomethingElse;

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

  /// Your tickets
  ///
  /// In en, this message translates to:
  /// **'Your tickets'**
  String get supportTickets;

  /// Trips lost to a swap do not count against your incentive target.
  ///
  /// In en, this message translates to:
  /// **'Trips lost to a swap do not count against your incentive target.'**
  String get supportTripsLostSwapDoNot;

  /// Turn this on if you cannot ride safely until this is fixed
  ///
  /// In en, this message translates to:
  /// **'Turn this on if you cannot ride safely until this is fixed'**
  String get supportTurnIfCannotRideSafely;

  /// The vehicle is affected
  ///
  /// In en, this message translates to:
  /// **'The vehicle is affected'**
  String get supportVehicleAffected;

  /// Vehicle impact
  ///
  /// In en, this message translates to:
  /// **'Vehicle impact'**
  String get supportVehicleImpact;

  /// What happened, and since when?
  ///
  /// In en, this message translates to:
  /// **'What happened, and since when?'**
  String get supportWhatHappenedSinceWhen;

  /// What happens if the battery dies mid-shift?
  ///
  /// In en, this message translates to:
  /// **'What happens if the battery dies mid-shift?'**
  String get supportWhatHappensIfBatteryDies;

  /// What's the issue
  ///
  /// In en, this message translates to:
  /// **'What\'s the issue'**
  String get supportWhatsTheIssue;

  /// When does my rent get debited?
  ///
  /// In en, this message translates to:
  /// **'When does my rent get debited?'**
  String get supportWhenDoesMyRentGet;

  /// Yes, on weekly and monthly plans. Daily plans return to the hub
  ///
  /// In en, this message translates to:
  /// **'Yes, on weekly and monthly plans. Daily plans return to the hub '**
  String get supportYesWeeklyMonthlyPlansDaily;

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

  /// Your deposit comes back separately when you leave.
  ///
  /// In en, this message translates to:
  /// **'Your deposit comes back separately when you leave.'**
  String get walletDepositReturnedSeparately;

  /// Due now
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get walletDueNow;

  /// Expiring in 7 days
  ///
  /// In en, this message translates to:
  /// **'Expiring in 7 days'**
  String get walletExpiringSoon;

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

  /// Your money
  ///
  /// In en, this message translates to:
  /// **'Your money'**
  String get walletMoney;

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

  /// Payments
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get walletPayments;

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

  /// Transactions
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get walletTransactions;
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
