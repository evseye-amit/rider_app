// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppL10nTe extends AppL10n {
  AppL10nTe([String locale = 'te']) : super(locale);

  @override
  String get allocationAddItem => 'అంశం జోడించండి';

  @override
  String get allocationAddLeastOneItem => 'కనీసం ఒక అంశం జోడించండి';

  @override
  String get allocationAllHubs => 'అన్ని హబ్‌లు';

  @override
  String get allocationAllocateVehicle => 'వాహనం ఇవ్వండి';

  @override
  String get allocationAllocateVehicleWaitingRiderStart => 'మొదలుపెట్టడానికి ఎదురుచూస్తున్న రైడర్‌కు వాహనం ఇవ్వండి.';

  @override
  String get allocationAskPayment => 'చెల్లింపు అడగండి';

  @override
  String get allocationAskPaymentConfirm =>
      'మొత్తాన్ని రైడర్ అంగీకరించిన ప్లాన్ ఆధారంగా లెక్కిస్తారు. రైడర్‌కు చెల్లింపు అభ్యర్థన పంపాలా?';

  @override
  String get allocationAskPaymentExchange =>
      'ఇది ఎక్స్ఛేంజ్ స్కూటర్. దీని ప్లాన్ ఇప్పటికే అంగీకరించబడింది, కాబట్టి ఈ హ్యాండోవర్‌కు ఏమీ వసూలు చేయరు. కొనసాగాలా?';

  @override
  String get allocationAssign => 'అప్పగించండి';

  @override
  String get allocationAssignTeamLead => 'టీమ్ లీడ్‌ను కేటాయించండి';

  @override
  String get allocationAssignVehicle => 'వాహనం అప్పగించండి';

  @override
  String get allocationBack => 'వెనక్కి';

  @override
  String get allocationBackDesk => 'తిరిగి డెస్క్‌కు';

  @override
  String get allocationBackToAllocations => 'కేటాయింపులకు తిరిగి వెళ్లండి';

  @override
  String get allocationBatteryChargeCharger => 'బ్యాటరీ చార్జ్ మరియు చార్జర్';

  @override
  String get allocationBodyPaintwork => 'బాడీ మరియు పెయింట్ పని';

  @override
  String get allocationCallRider => 'కాల్ చేయండి';

  @override
  String get allocationChangePlan => 'ప్లాన్ మార్చండి';

  @override
  String get allocationChangeTeamLead => 'టీమ్ లీడ్‌ను మార్చండి';

  @override
  String get allocationChecklistRiderWillAcceptItem => 'రైడర్ ఒక్కొక్కటిగా అంగీకరించే జాబితా';

  @override
  String get allocationChecklistTapToggleMandatory => 'జాబితా · తప్పనిసరి మార్చడానికి నొక్కండి';

  @override
  String get allocationChoosePlan => 'అద్దె ప్లాన్ ఎంచుకోండి';

  @override
  String get allocationChooseTeamLead => 'టీమ్ లీడ్‌ను ఎంచుకోండి';

  @override
  String get allocationChooseWorkPartner => 'పని భాగస్వామిని ఎంచుకోండి';

  @override
  String get allocationComplete2 => 'పూర్తయింది.';

  @override
  String get allocationConfirmHaveReceivedAmountRider =>
      'రైడర్ రిఫరెన్స్ ఇచ్చిన మొత్తం మీకు అందిందని ఖరారు చేయండి. దీన్ని వెనక్కి తీసుకోలేరు.';

  @override
  String allocationConfirmReceivedAmount(String amount) {
    return 'రైడర్ నుండి $amount అందిందని నిర్ధారించండి.';
  }

  @override
  String get allocationContinueHandover => 'అప్పగింత కొనసాగించండి';

  @override
  String get allocationCouldNotAllocateVehicle => 'వాహనం కేటాయించలేకపోయాం';

  @override
  String get allocationCouldNotLoadAllocations => 'కేటాయింపులు తెరవలేకపోయాం';

  @override
  String get allocationCouldNotLoadAvailableVehicles => 'అందుబాటులోని వాహనాలు తెరవలేకపోయాం';

  @override
  String get allocationCouldNotLoadHandover => 'ఈ అప్పగింత తెరవలేకపోయాం';

  @override
  String get allocationCouldNotLoadTeamLeads => 'టీమ్ లీడ్‌లు లోడ్ కాలేదు';

  @override
  String get allocationCouldNotLoadWorkPartners => 'పని భాగస్వాములు లోడ్ కాలేదు';

  @override
  String get allocationDeAllocateVehicle => 'వాహనం వాపసు తీసుకోండి';

  @override
  String get allocationDeployed => 'మోహరించబడింది';

  @override
  String allocationDeployedMessage(String vehicle, String rider) {
    return '$vehicle ఇప్పుడు $riderతో రోడ్డుపై ఉంది.';
  }

  @override
  String get allocationDeployedTitle => 'స్కూటర్ మోహరించబడింది!';

  @override
  String get allocationEveryOnboardedRiderHubsHas =>
      'మీ హబ్‌లలోని ప్రతి నమోదైన రైడర్‌కు వాహనం ఉంది లేదా అప్పగింత జరుగుతోంది.';

  @override
  String get allocationFleetOnlyBody => 'స్కూటర్ కేటాయింపు హబ్ ఫ్లీట్ మేనేజర్ లాగిన్‌తో జరుగుతుంది.';

  @override
  String get allocationFleetOnlyTitle => 'ఈ లాగిన్‌కు అందుబాటులో లేదు';

  @override
  String get allocationFront => 'ముందు';

  @override
  String get allocationHandoverCompleteMessage => 'శిక్షణ పూర్తయింది, స్కూటర్ రైడర్ వద్ద ఉంది. ఈ అప్పగింత పూర్తయింది.';

  @override
  String get allocationHandoverHistory => 'అప్పగింత చరిత్ర';

  @override
  String get allocationHelmetHandedOver => 'హెల్మెట్ అప్పగించారు';

  @override
  String get allocationHornMirrors => 'హారన్ మరియు అద్దాలు';

  @override
  String get allocationIdle => 'ఖాళీ';

  @override
  String get allocationInspectionAcceptedTraining => 'తనిఖీ ఆమోదం · శిక్షణ';

  @override
  String get allocationInspectionSentRider => 'తనిఖీ రైడర్‌కు పంపబడింది';

  @override
  String get allocationInspectionSentRider2 => 'తనిఖీ రైడర్‌కు పంపబడింది';

  @override
  String get allocationLeftSide => 'ఎడమ వైపు';

  @override
  String get allocationLightsIndicators => 'లైట్లు మరియు ఇండికేటర్లు';

  @override
  String get allocationMarkAsPaid => 'చెల్లించినట్టు గుర్తించండి';

  @override
  String get allocationMatchWaitingRiderWithVehicle =>
      'ఎదురుచూస్తున్న రైడర్‌కు వాహనం సరిపోల్చి, ఆపై అప్పగింత పూర్తి చేయండి';

  @override
  String get allocationMove => 'ఇప్పుడు మీ వంతు';

  @override
  String get allocationNoBatteryPlan => 'బ్యాటరీ ప్లాన్ లేదు';

  @override
  String get allocationNobodyWaiting => 'ఎవరూ ఎదురుచూడటం లేదు';

  @override
  String get allocationNoHandoversProgress => 'ఏ అప్పగింతా జరగడం లేదు';

  @override
  String get allocationNoTeamLeads => 'టీమ్ లీడ్‌లు ఎవరూ కనిపించలేదు';

  @override
  String get allocationNoTeamLeadsMessage => 'యాక్టివ్ టీమ్ లీడ్‌ను జోడించమని మీ అడ్మిన్‌ను అడగండి.';

  @override
  String get allocationNothingCurrentlyAllocatedRider => 'ప్రస్తుతం ఏ రైడర్‌కూ ఏదీ కేటాయించలేదు.';

  @override
  String get allocationNoVehiclesOut => 'ఏ వాహనమూ బయట లేదు';

  @override
  String get allocationNoVehiclesReady => 'ఏ వాహనమూ సిద్ధంగా లేదు';

  @override
  String get allocationNoWorkPartners => 'పని భాగస్వాములు ఎవరూ కనిపించలేదు';

  @override
  String get allocationNoWorkPartnersMessage => 'పని భాగస్వాములను జోడించమని మీ అడ్మిన్‌ను అడగండి.';

  @override
  String get allocationPaymentCouldNotLoad => 'చెల్లింపు లోడ్ కాలేదు';

  @override
  String get allocationPaymentNoScreenshot => 'రైడర్ స్క్రీన్‌షాట్ జోడించలేదు.';

  @override
  String get allocationPaymentReceived => 'చెల్లింపు అందిందా?';

  @override
  String get allocationPaymentRejected => 'చెల్లింపు తిరస్కరించబడింది. రైడర్ సరిచేసి మళ్లీ పంపవచ్చు.';

  @override
  String allocationPaymentRejectedNote(String reason) {
    return 'మీరు ఈ చెల్లింపును తిరస్కరించారు: $reason. రైడర్ మళ్లీ పంపే వరకు వేచి ఉంది.';
  }

  @override
  String get allocationPaymentRequested => 'చెల్లింపు అడిగారు';

  @override
  String get allocationPaymentRequestedAmount => 'అడిగిన చెల్లింపు';

  @override
  String get allocationPaymentRequestedRiderSeesNow => 'చెల్లింపు అడిగారు, రైడర్‌కు ఇప్పుడు కనిపిస్తోంది';

  @override
  String get allocationPaymentScreenshots => 'చెల్లింపు స్క్రీన్‌షాట్‌లు';

  @override
  String get allocationPaymentVerified => 'చెల్లింపు ధృవీకరించబడింది';

  @override
  String get allocationPaymentWaitingRider => 'రైడర్ ఇంకా చెల్లింపు వివరాలు పంపలేదు.';

  @override
  String get allocationPhotoBack => 'వెనుక';

  @override
  String get allocationPhotoCannotOpen => 'ఈ ఫోటోను ఇప్పుడు తెరవలేము.';

  @override
  String get allocationPhotoDeclaration => 'ప్రకటన పత్రం';

  @override
  String get allocationPhotoFront => 'ముందు';

  @override
  String get allocationPhotoLeft => 'ఎడమ వైపు';

  @override
  String get allocationPhotoRider => 'వాహనంతో రైడర్';

  @override
  String get allocationPhotoRight => 'కుడి వైపు';

  @override
  String get allocationPhotoUploaded => 'అప్‌లోడ్ అయింది';

  @override
  String get allocationPlanAcceptedChip => 'రైడర్ అంగీకరించారు';

  @override
  String get allocationPlanAwaitingBody =>
      'రైడర్ తమ యాప్‌లో ఈ ప్లాన్‌ను అంగీకరించడానికి వేచి ఉన్నాం. వారు అంగీకరించే వరకు మీరు దీన్ని మార్చవచ్చు.';

  @override
  String get allocationPlanAwaitingChip => 'రైడర్ కోసం వేచి ఉంది';

  @override
  String get allocationPlanCouldNotLoad => 'అద్దె ప్లాన్‌లను లోడ్ చేయలేకపోయాం';

  @override
  String get allocationPlanExchangeBody =>
      'ఈ స్కూటర్ ఎక్స్ఛేంజ్‌లో బదులుగా ఇస్తున్నది. రైడర్ ఎక్స్ఛేంజ్ ప్లాన్ కొనసాగుతుంది, కాబట్టి కొత్త ప్లాన్ లేదా డిపాజిట్ వసూలు చేయాల్సిన అవసరం లేదు.';

  @override
  String get allocationPlanExchangeChip => 'ఎక్స్ఛేంజ్ ప్లాన్';

  @override
  String get allocationPlanExpiredBody =>
      'ప్లాన్ ఆఫర్ గడువు ముగిసింది లేదా మార్చబడింది. మళ్లీ ప్లాన్ ఎంచుకుని రైడర్‌కు పంపండి.';

  @override
  String get allocationPlanNoneBody =>
      'ఈ స్కూటర్ మరియు హబ్‌కు సరిపోయే ప్రచురించిన అద్దె ప్లాన్ లేదు. రేట్ కార్డ్ ప్రచురించమని మీ అడ్మిన్‌ను అడగండి.';

  @override
  String get allocationPlanNoneTitle => 'ప్లాన్‌లు అందుబాటులో లేవు';

  @override
  String get allocationPlanNotChosenBody =>
      'ఈ రైడర్ కోసం అద్దె ప్లాన్ ఎంచుకోండి. రైడర్ దాన్ని తమ యాప్‌లో చూసి అంగీకరిస్తారు, చెల్లింపు దాని ఆధారంగా లెక్కిస్తారు.';

  @override
  String get allocationPlanNotChosenChip => 'ఎంచుకోలేదు';

  @override
  String get allocationPlanPickSubtitle => 'ధరలు ఈ రైడర్, స్కూటర్ మరియు హబ్ కోసం లెక్కిస్తారు.';

  @override
  String get allocationPlanPickTitle => 'అద్దె ప్లాన్ ఎంచుకోండి';

  @override
  String get allocationPlanSend => 'రైడర్‌కు పంపండి';

  @override
  String get allocationPlanSentSnack => 'ప్లాన్ పంపబడింది. రైడర్ తమ యాప్‌లో దాన్ని అంగీకరించవచ్చు.';

  @override
  String get allocationPlanTitle => 'అద్దె ప్లాన్';

  @override
  String get allocationPlanWaitingButton => 'రైడర్ అంగీకారం కోసం వేచి ఉంది';

  @override
  String get allocationReason => 'కారణం';

  @override
  String get allocationRejectConfirm => 'చెల్లింపును తిరస్కరించండి';

  @override
  String get allocationRejectPayment => 'తిరస్కరించండి';

  @override
  String get allocationRejectReason => 'మీరు దీన్ని ఎందుకు తిరస్కరిస్తున్నారు?';

  @override
  String get allocationRejectReasonHint => 'ఉదా: రిఫరెన్స్ వచ్చిన డబ్బుతో సరిపోలడం లేదు';

  @override
  String get allocationRejectReasonNeeded => 'కనీసం 3 అక్షరాలు నమోదు చేయండి';

  @override
  String get allocationReserved2 => 'రిజర్వ్ చేసిన తేదీ';

  @override
  String get allocationReviewPayment => 'చెల్లింపును పరిశీలించండి';

  @override
  String get allocationRider => 'రైడర్';

  @override
  String get allocationRiderCompletingSafetyTrainingTheir =>
      'రైడర్ తమ యాప్‌లో భద్రతా శిక్షణ పూర్తి చేస్తున్నారు. ప్రతి తప్పనిసరి పాఠం పూర్తయ్యాక స్కూటర్ అప్పగిస్తారు.';

  @override
  String get allocationRiderGoingThroughChecklistTheir =>
      'రైడర్ తమ యాప్‌లో మీ జాబితాను చూస్తున్నారు. వారు తిరస్కరించినవి గమనికతో తిరిగి వస్తాయి.';

  @override
  String get allocationRiderNoLongerWaitingVehicle => 'ఈ రైడర్ ఇప్పుడు వాహనం కోసం ఎదురుచూడటం లేదు.';

  @override
  String get allocationRiding => 'ప్రయాణంలో';

  @override
  String get allocationRightSide => 'కుడి వైపు';

  @override
  String get allocationRoad => 'రోడ్డుపై';

  @override
  String allocationScooterAge(int months) {
    return 'స్కూటర్ వయస్సు (నెలలు): $months';
  }

  @override
  String get allocationSearchRiderNameCodeMobile => 'రైడర్ పేరు, కోడ్ లేదా మొబైల్ వెతకండి';

  @override
  String get allocationSearchRiderVehicle => 'రైడర్ లేదా వాహనం వెతకండి';

  @override
  String get allocationSearchRiderVehicleNumber => 'రైడర్ లేదా వాహన నంబర్ వెతకండి';

  @override
  String get allocationSearchTeamLead => 'పేరు, మొబైల్ లేదా ఉద్యోగి కోడ్‌తో వెతకండి';

  @override
  String get allocationSearchWorkPartner => 'పని భాగస్వాములను వెతకండి';

  @override
  String get allocationSendPaymentRequest => 'చెల్లింపు అభ్యర్థన పంపండి';

  @override
  String get allocationSendRider => 'రైడర్‌కు పంపండి';

  @override
  String get allocationStartReturn => 'వాపసు మొదలుపెట్టండి';

  @override
  String get allocationStepPhotos => 'ఫోటోలు & తనిఖీ';

  @override
  String get allocationStepRider => 'రైడర్ తనిఖీ & శిక్షణ';

  @override
  String get allocationTeamLead => 'టీమ్ లీడ్';

  @override
  String get allocationTeamLeadMissing =>
      'ఇంకా టీమ్ లీడ్ లేరు. అది లేకుండా హ్యాండోవర్ పూర్తి కాదు, కాబట్టి ఒకరిని ఎంచుకోండి.';

  @override
  String get allocationTeamLeadNotSaved =>
      'స్కూటర్ రిజర్వ్ అయింది, కానీ టీమ్ లీడ్ సేవ్ కాలేదు. కేటాయింపు పేజీలో దాన్ని కేటాయించండి.';

  @override
  String get allocationTeamLeadPickerSubtitle => 'టీమ్ లీడ్ ఈ రైడర్‌ను చూసుకుంటారు.';

  @override
  String get allocationTeamLeadRequired =>
      'ఈ హ్యాండోవర్‌కు ముందుగా టీమ్ లీడ్ కావాలి. ఫ్లీట్ మేనేజర్ కేటాయింపు పేజీలో వారిని కేటాయించవచ్చు.';

  @override
  String allocationTeamLeadRiderCount(int count) {
    return 'రైడర్లు: $count';
  }

  @override
  String get allocationTeamLeadSaved => 'టీమ్ లీడ్ సేవ్ అయింది';

  @override
  String get allocationTyresPressure => 'టైర్లు మరియు గాలి';

  @override
  String get allocationUploadEvidenceContinue => 'కొనసాగడానికి ఆధారం అప్‌లోడ్ చేయండి';

  @override
  String get allocationVehicleHasAvailableOnboardedAllocation =>
      'ఇక్కడ కనిపించాలంటే వాహనం మీ హబ్‌లలో ఒకదానిలో అందుబాటులో, నమోదై, కేటాయింపుకు సిద్ధంగా ఉండాలి.';

  @override
  String get allocationVehiclePhotos => 'వాహన ఫోటోలు';

  @override
  String get allocationVehiclePhotosHint =>
      'వాహనం ప్రతి వైపు ఫోటో, వాహనంతో రైడర్ ఒక ఫోటో మరియు సంతకం చేసిన ప్రకటన పత్రం ఒక ఫోటో తీయండి. తనిఖీ సమర్పించే ముందు అన్ని ఫోటోలు అవసరం.';

  @override
  String get allocationVehicleReserved => 'వాహనం రిజర్వ్ చేయబడింది';

  @override
  String get allocationVerifyPayment => 'చెల్లింపు ధృవీకరించండి';

  @override
  String get allocationWaiting => 'ఎదురుచూస్తోంది';

  @override
  String get allocationWaitingRider => 'రైడర్ కోసం వేచి ఉంది';

  @override
  String get allocationWaitingRiderAcceptInspection => 'రైడర్ తనిఖీ ఆమోదించడం కోసం ఎదురుచూస్తోంది';

  @override
  String get allocationWaitingRiderFinishTraining => 'రైడర్ శిక్షణ పూర్తి చేయడం కోసం ఎదురుచూస్తోంది';

  @override
  String get allocationWaitingRiderInspection => 'రైడర్ కోసం వేచి ఉంది: తనిఖీ';

  @override
  String get allocationWaitingRiderPageRefreshesIts => 'రైడర్ కోసం వేచి ఉంది, ఈ పేజీ దానంతట అదే రిఫ్రెష్ అవుతుంది.';

  @override
  String get allocationWaitingRiderTraining => 'రైడర్ కోసం వేచి ఉంది: శిక్షణ';

  @override
  String get allocationWorkPartner => 'పని భాగస్వామి';

  @override
  String get allocationWorkPartnerHelper => 'ఈ రైడర్ పని చేసే కంపెనీ.';

  @override
  String get allocationWorkPartnerNeeded => 'రైడర్ పని భాగస్వామిని ఎంచుకోండి';

  @override
  String get appGoHome => 'హోమ్‌కు వెళ్ళండి';

  @override
  String get authChangeNumber => 'నంబర్ మార్చండి';

  @override
  String get authCodeDidNotVerifyPlease => 'ఈ కోడ్ ధృవీకరణలో సరిపోలేదు. మళ్ళీ ప్రయత్నించండి.';

  @override
  String get authContinue => 'కొనసాగించండి';

  @override
  String get authEditNumber => 'నంబర్ మార్చండి';

  @override
  String authLegalAgreement(String terms, String privacy) {
    return 'కొనసాగించండి పై క్లిక్ చేయడం ద్వారా మీరు మా $terms మరియు $privacy అంగీకరిస్తున్నారు';
  }

  @override
  String get authLegalPrivacy => 'గోప్యతా విధానం';

  @override
  String get authLegalTerms => 'సేవా నిబంధనలు';

  @override
  String get authLiveFleetVisibility => 'ఫ్లీట్ యొక్క\nప్రత్యక్ష సమాచారం';

  @override
  String get authNumberVerified => 'నంబర్ ధృవీకరించబడింది';

  @override
  String get authOnlyNumbersRegisteredByAdmin => 'మీ అడ్మిన్ నమోదు చేసిన నంబర్లు మాత్రమే సైన్ ఇన్ చేయగలవు';

  @override
  String get authOpsSupport => '24x7 ఆపరేషన్స్\nమద్దతు';

  @override
  String authOtpSentTo(String mobile) {
    return '+91 $mobile కు 6 అంకెల కోడ్ పంపబడింది';
  }

  @override
  String get authResendCode => 'కోడ్ మళ్ళీ పంపండి';

  @override
  String authResendCodeIn(String seconds) {
    return '$seconds లో కోడ్ మళ్ళీ పంపండి';
  }

  @override
  String get authRoadsideHelp => '24x7\nరోడ్డుపై సహాయం';

  @override
  String get authSameDayPayouts => 'అదే రోజు\nచెల్లింపులు';

  @override
  String get authSessionEncryptedEndEnd => 'మీ సెషన్ పూర్తిగా సురక్షితంగా ఉంది';

  @override
  String get authSignRunHub => 'మీ హబ్ నడపడానికి సైన్ ఇన్ చేయండి';

  @override
  String get authSignWithMobileNumberRegistered =>
      'కేటాయింపులు, రైడర్లు మరియు నిర్వహణ చూసుకోవడానికి మీ హబ్‌కు నమోదైన మొబైల్ నంబర్‌తో సైన్ ఇన్ చేయండి.';

  @override
  String get authSignWithMobileNumberRegistered2 => 'మీ ఫ్లీట్ ఆపరేటర్ వద్ద నమోదైన మొబైల్ నంబర్‌తో సైన్ ఇన్ చేయండి.';

  @override
  String get authVerifiedHubNetwork => 'ధృవీకరించిన\nహబ్ నెట్‌వర్క్';

  @override
  String get authVerifiedOperators => 'ధృవీకరించిన\nఆపరేటర్లు';

  @override
  String get authVerifying => 'ధృవీకరిస్తోంది…';

  @override
  String get authVerifyingNumber => 'మీ నంబర్ ధృవీకరించబడుతోంది…';

  @override
  String get authVerifyNumber => 'మీ నంబర్ ధృవీకరించండి';

  @override
  String get authWelcomeBack => 'తిరిగి స్వాగతం';

  @override
  String get authWhyChooseUs => 'మమ్మల్నే ఎందుకు ఎంచుకోవాలి';

  @override
  String get authWhyRideWithUs => 'మాతో ఎందుకు ప్రయాణించాలి';

  @override
  String get authWillText6DigitCode => 'మేము మీకు 6 అంకెల కోడ్ పంపుతాం';

  @override
  String get authWrongNumber => 'తప్పు నంబరా?';

  @override
  String get checkInBasicReport => 'మెకానిక్ రిపోర్ట్';

  @override
  String checkInConfirmedByManager(String reason) {
    return 'మీ కోడ్ లేకుండా హబ్ బృందం నిర్ధారించింది: $reason';
  }

  @override
  String get checkInConfirmedByOtp => 'మీ కోడ్‌తో నిర్ధారించబడింది.';

  @override
  String get checkInCouldNotLoad => 'సబ్మిషన్ లోడ్ కాలేదు.';

  @override
  String get checkInDeepReport => 'చివరి మెకానిక్ తనిఖీ';

  @override
  String get checkInHub => 'హబ్';

  @override
  String get checkInNoCharges => 'ఛార్జీలు లేవు';

  @override
  String get checkInOtpHint =>
      'మీ ఫోన్‌కు ఒక కోడ్ వస్తుంది. ఈ రిపోర్ట్‌ను, దాని ఛార్జీలను నిర్ధారించడానికి దాన్ని హబ్ బృందానికి చెప్పండి.';

  @override
  String get checkInPhotos => 'ఫోటోలు';

  @override
  String checkInPhotosCount(int taken, int total) {
    return '$totalలో $taken తీశారు';
  }

  @override
  String get checkInSafe => 'మళ్లీ వాడటానికి సురక్షితం';

  @override
  String get checkInStatusDraft => 'సమీక్షలో ఉంది';

  @override
  String get checkInStatusPosted => 'నిర్ధారించబడింది';

  @override
  String get checkInStatusSubmitted => 'నిర్ధారణ పెండింగ్';

  @override
  String get checkInTitle => 'స్కూటర్ సబ్మిషన్';

  @override
  String get checkInTotal => 'మొత్తం ఛార్జీలు';

  @override
  String checkInUnsafe(String reason) {
    return 'మళ్లీ వాడటానికి సురక్షితం కాదు: $reason';
  }

  @override
  String get checkInViewPhotos => 'చూడండి';

  @override
  String get checkInWaitingReport =>
      'హబ్ బృందం ఫోటోలు తీస్తోంది. మెకానిక్ రిపోర్ట్ సిద్ధమైన వెంటనే ఇక్కడ కనిపిస్తుంది.';

  @override
  String get commonAboutApp => 'ఈ యాప్ గురించి';

  @override
  String get commonAbsent => 'గైర్హాజరు';

  @override
  String get commonAccountCannotDo => 'మీ ఖాతాకు ఇది సాధ్యం కాదు.';

  @override
  String get commonAccountNumbersDoNotMatch => 'ఖాతా నంబర్లు సరిపోలేదు';

  @override
  String get commonAccountNumbersMatch => 'ఖాతా నంబర్లు సరిపోయాయి';

  @override
  String get commonAddAnotherReference => 'మరో రిఫరెన్స్ జోడించండి';

  @override
  String get commonAddNominee => 'నామినీని జోడించండి';

  @override
  String get commonAddPhoto => 'ఫోటో జోడించండి';

  @override
  String get commonAllocated => 'ఇచ్చిన తేదీ';

  @override
  String get commonAllocation => 'కేటాయింపు';

  @override
  String get commonAppWillChangeRightAway => 'యాప్ వెంటనే మారుతుంది.';

  @override
  String get commonAttendance => 'హాజరు';

  @override
  String get commonBankAccountNumber => 'బ్యాంక్ ఖాతా నంబర్';

  @override
  String get commonBrakes => 'బ్రేకులు';

  @override
  String get commonBrother => 'సోదరుడు';

  @override
  String get commonCamera => 'కెమెరా';

  @override
  String get commonCameraAccessNeeded => 'ఫోటోలు తీయడానికి Settings లో కెమెరా అనుమతి ఇవ్వండి.';

  @override
  String get commonCancel => 'రద్దు చేయండి';

  @override
  String get commonCanChangeLaterFromMenu => 'దీన్ని తర్వాత మెనూ నుంచి మార్చుకోవచ్చు.';

  @override
  String get commonCategory => 'విభాగం';

  @override
  String get commonChooseLanguage => 'మీ భాషను ఎంచుకోండి';

  @override
  String get commonCity => 'నగరం';

  @override
  String get commonColleague => 'సహోద్యోగి';

  @override
  String get commonColour => 'రంగు';

  @override
  String get commonConfirm => 'ఖరారు చేయండి';

  @override
  String get commonConfirmAccountNumber => 'ఖాతా నంబర్ మళ్ళీ రాయండి';

  @override
  String get commonCouldNotOpenDocumentTry => 'పత్రం తెరవలేదు. మళ్ళీ ప్రయత్నించండి.';

  @override
  String get commonCouldNotReadLocalData => 'ఫోన్‌లోని డేటా చదవలేకపోయాం.';

  @override
  String get commonDaughter => 'కుమార్తె';

  @override
  String get commonEnterAccountNumber => 'మీ ఖాతా నంబర్ రాయండి';

  @override
  String get commonEnterValid10DigitMobile => 'సరైన 10 అంకెల మొబైల్ నంబర్ రాయండి';

  @override
  String get commonFather => 'తండ్రి';

  @override
  String get commonFriend => 'స్నేహితుడు';

  @override
  String get commonFullName => 'పూర్తి పేరు';

  @override
  String get commonGallery => 'గ్యాలరీ';

  @override
  String get commonHandover => 'అప్పగింత';

  @override
  String get commonHaveAlreadyUsedNumberAnother => 'ఈ నంబర్‌ను మరో రిఫరెన్స్‌కు ఇప్పటికే వాడారు';

  @override
  String get commonHintGuardian => 'ఉదా. సంరక్షకుడు';

  @override
  String get commonHowTheyRelated => 'వారు మీకు ఏమవుతారు?';

  @override
  String get commonIncentives => 'ప్రోత్సాహకాలు';

  @override
  String get commonIotUnit => 'పరికరం';

  @override
  String get commonJpgPngPdfUp5 => 'JPG, PNG లేదా PDF · 5 MB వరకు';

  @override
  String get commonLanguage => 'భాష';

  @override
  String get commonLoadMore => 'మరిన్ని చూపించు';

  @override
  String get commonMake100 => 'దీన్ని 100% చేయండి';

  @override
  String get commonManager => 'మేనేజర్';

  @override
  String get commonMandatory => 'తప్పనిసరి';

  @override
  String get commonMarkedPresentShiftHasStarted => 'హాజరు వేయబడింది. మీ షిఫ్ట్ మొదలైంది.';

  @override
  String get commonMobile => 'మొబైల్';

  @override
  String get commonMobileNumber => 'మొబైల్ నంబర్';

  @override
  String get commonModel => 'మోడల్';

  @override
  String get commonMother => 'తల్లి';

  @override
  String get commonNoInternetConnection => 'ఇంటర్నెట్ కనెక్షన్ లేదు.';

  @override
  String get commonNominationComplete => 'మీ నామినేషన్ పూర్తయింది.';

  @override
  String get commonNotFound => 'దొరకలేదు.';

  @override
  String get commonNow => 'ఇప్పుడు';

  @override
  String get commonOdometer => 'ఓడోమీటర్';

  @override
  String get commonOff => 'ఆఫ్';

  @override
  String get commonOn => 'ఆన్';

  @override
  String get commonOpen => 'తెరవండి';

  @override
  String get commonOptional => 'ఐచ్ఛికం';

  @override
  String get commonOther => 'ఇతర';

  @override
  String get commonOtherRelationship => 'ఇతర సంబంధం';

  @override
  String get commonOwnNumberUseDifferentOne => 'ఇది మీ సొంత నంబరే. వేరొకటి వాడండి.';

  @override
  String get commonPaidDate => 'ఇప్పటివరకు చెల్లింపు';

  @override
  String get commonPayment => 'చెల్లింపు';

  @override
  String get commonPending => 'పెండింగ్';

  @override
  String get commonPreDeliveryInspection => 'అప్పగింతకు ముందు తనిఖీ';

  @override
  String get commonPresent => 'హాజరు';

  @override
  String get commonPrivacyPolicy => 'గోప్యతా విధానం';

  @override
  String get commonProfile => 'ప్రొఫైల్';

  @override
  String get commonRaised => 'నమోదైంది';

  @override
  String get commonRefresh => 'రిఫ్రెష్ చేయండి';

  @override
  String get commonRejectedUploadAgain => 'తిరస్కరించారు, మళ్ళీ అప్‌లోడ్ చేయండి';

  @override
  String commonRejectionReason(String reason) {
    return 'కారణం: $reason';
  }

  @override
  String get commonRelationship => 'సంబంధం';

  @override
  String get commonRemove => 'తీసివేయండి';

  @override
  String get commonRetake => 'మళ్ళీ తీయండి';

  @override
  String get commonRetry => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get commonSave => 'సేవ్ చేయండి';

  @override
  String get commonScooter => 'మీ స్కూటర్';

  @override
  String get commonSearch => 'వెతకండి';

  @override
  String get commonSelect => 'ఎంచుకోండి';

  @override
  String get commonSelectDate => 'తేదీని ఎంచుకోండి';

  @override
  String get commonSessionHasExpiredPleaseSign => 'మీ సెషన్ ముగిసింది. మళ్ళీ సైన్ ఇన్ చేయండి.';

  @override
  String get commonShare => 'వాటా';

  @override
  String get commonSharesAddUp100 => 'వాటాల మొత్తం 100% అయింది';

  @override
  String get commonSignBeforeReadingClientConfiguration => 'క్లయింట్ కాన్ఫిగరేషన్ చదవడానికి ముందు సైన్ ఇన్ చేయండి.';

  @override
  String get commonSignContinue => 'కొనసాగడానికి సైన్ ఇన్ చేయండి.';

  @override
  String get commonSignOut => 'సైన్ అవుట్';

  @override
  String get commonSignOut2 => 'సైన్ అవుట్ చేయాలా?';

  @override
  String get commonSister => 'సోదరి';

  @override
  String get commonSkip => 'వదిలేయండి';

  @override
  String get commonSomethingWentWrongPleaseTry => 'ఏదో తప్పు జరిగింది. మళ్ళీ ప్రయత్నించండి.';

  @override
  String get commonSon => 'కుమారుడు';

  @override
  String get commonSpouse => 'జీవిత భాగస్వామి';

  @override
  String get commonStatus => 'స్థితి';

  @override
  String get commonSubmitInspection => 'తనిఖీ సమర్పించండి';

  @override
  String get commonSupport => 'సహాయం';

  @override
  String get commonTakeOneNowChooseFrom => 'ఇప్పుడు ఒకటి తీయండి, లేదా గ్యాలరీ నుంచి ఎంచుకోండి';

  @override
  String get commonTeamLead => 'టీమ్ లీడ్';

  @override
  String get commonTellUsHowTheyRelated => 'వారు మీకు ఏమవుతారో చెప్పండి';

  @override
  String get commonTermsService => 'సేవా నిబంధనలు';

  @override
  String get commonTheirName => 'వారి పేరు';

  @override
  String get commonTooManyAttemptsWaitMoment => 'చాలాసార్లు ప్రయత్నించారు. కాసేపు ఆగండి.';

  @override
  String get commonTotal => 'మొత్తం';

  @override
  String get commonTryAgain => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get commonTypeAgain => 'దీన్ని మళ్ళీ రాయండి';

  @override
  String get commonUpload => 'అప్‌లోడ్ చేయండి';

  @override
  String get commonUploaded => 'అప్‌లోడ్ అయింది';

  @override
  String get commonVehicle => 'వాహనం';

  @override
  String get commonVersion => 'వెర్షన్';

  @override
  String get commonWallet => 'వాలెట్';

  @override
  String get commonWhatHappensNext => 'తర్వాత ఏమి జరుగుతుంది';

  @override
  String get commonWillNeedMobileNumberOtp => 'మళ్ళీ సైన్ ఇన్ చేయడానికి మీకు మొబైల్ నంబర్ మరియు ఓటీపీ అవసరం.';

  @override
  String get companyCodeHint => 'ఉదా. yogmaya';

  @override
  String get companyCodeLabel => 'కంపెనీ కోడ్';

  @override
  String get companyCodeRequired => 'మీ కంపెనీ కోడ్‌ను నమోదు చేయండి';

  @override
  String get companyHelp => 'ఈ కోడ్ మీ వెల్‌కమ్ సందేశంలో ఉంటుంది. మీ దగ్గర లేకపోతే, మీ హబ్ బృందాన్ని అడగండి.';

  @override
  String get companyNotFound => 'ఈ కోడ్‌తో ఏ కంపెనీ దొరకలేదు. తనిఖీ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get companyNotReady => 'ఈ కంపెనీ ఇంకా యాప్ కోసం సెటప్ కాలేదు. దయచేసి మీ ఫ్లీట్ ఆపరేటర్‌ను సంప్రదించండి.';

  @override
  String get companySubtitle => 'మీ ఫ్లీట్ ఆపరేటర్ ఇచ్చిన కంపెనీ కోడ్‌ను నమోదు చేయండి. ఇది ఒక్కసారి మాత్రమే చేయాలి.';

  @override
  String get companyTitle => 'మీ కంపెనీని కనుగొనండి';

  @override
  String companyWelcome(String name) {
    return '$nameకు స్వాగతం';
  }

  @override
  String get consentAgree =>
      'ఈ సమ్మతి పత్రంలోని అంశాలను నేను అర్థం చేసుకున్నానని మరియు డేటా ప్రిన్సిపాల్ హోదాలో అంగీకరిస్తున్నానని ప్రకటిస్తున్నాను.';

  @override
  String get consentReviewLatest =>
      'యాప్‌ను ఉపయోగించడం కొనసాగించడానికి దయచేసి ఈ సమ్మతి యొక్క తాజా వెర్షన్‌ను చదివి అంగీకరించండి.';

  @override
  String get consentRiderTitle => 'రైడర్ సమ్మతి';

  @override
  String get consentSubtitle =>
      'మీ సమాచారాన్ని మేము ఎలా సేకరిస్తామో, ఎలా ఉపయోగిస్తామో చదవండి, తర్వాత కొనసాగడానికి మీ సమ్మతి ఇవ్వండి.';

  @override
  String get damageChargeAmountToPay => 'చెల్లించాల్సిన మొత్తం';

  @override
  String get damageChargeCancelledBody => 'ఈ ఛార్జీ రద్దు చేశారు. మీరు దీన్ని చెల్లించాల్సిన అవసరం లేదు.';

  @override
  String get damageChargeCouldNotLoad => 'ఈ ఛార్జీ లోడ్ కాలేదు';

  @override
  String get damageChargeCreditUsed => 'వాడిన క్రెడిట్';

  @override
  String damageChargeEach(String amount) {
    return 'ఒక్కోటి $amount';
  }

  @override
  String get damageChargeLeftToPay => 'మిగిలిన మొత్తం';

  @override
  String get damageChargePaidBody => 'మీరు ఈ ఛార్జీని పూర్తిగా చెల్లించారు.';

  @override
  String get damageChargePaidSoFar => 'ఇప్పటివరకు చెల్లించింది';

  @override
  String get damageChargePaidTitle => 'పూర్తిగా చెల్లించారు';

  @override
  String damageChargePay(String amount) {
    return '$amount చెల్లించండి';
  }

  @override
  String damageChargeRaisedOn(String date) {
    return '$dateన విధించారు';
  }

  @override
  String get damageChargesCouldNotLoad => 'నష్టం ఛార్జీలు లోడ్ కాలేదు';

  @override
  String get damageChargesNoneMessage =>
      'స్కూటర్ తిరిగి ఇచ్చేటప్పుడు లేదా మార్చేటప్పుడు హబ్‌కు నష్టం కనిపిస్తే, ఆ ఛార్జీ ఇక్కడ కనిపిస్తుంది.';

  @override
  String get damageChargesNoneTitle => 'నష్టం ఛార్జీలు లేవు';

  @override
  String get damageChargesNothingToPay => 'చెల్లించాల్సింది ఏమీ లేదు';

  @override
  String get damageChargesNoUnpaid => 'బకాయి నష్టం ఛార్జీలు లేవు';

  @override
  String get damageChargeStatusCancelled => 'రద్దు చేశారు';

  @override
  String get damageChargeStatusPaid => 'చెల్లించారు';

  @override
  String get damageChargeStatusPartlyPaid => 'కొంత చెల్లించారు';

  @override
  String get damageChargesTitle => 'నష్టం ఛార్జీలు';

  @override
  String damageChargesToPay(int count) {
    return '$count చెల్లించాలి';
  }

  @override
  String get damageChargesUnpaid => 'బకాయి';

  @override
  String get damageChargesViewAndPay => 'చూసి చెల్లించండి';

  @override
  String get damageChargeTitle => 'నష్టం ఛార్జీ';

  @override
  String get damageChargeTotal => 'మొత్తం ఛార్జీలు';

  @override
  String get damageChargeWhatWasCharged => 'దేనికి ఛార్జీ';

  @override
  String get deallocAccessoriesReturned => 'తిరిగి ఇచ్చిన సామగ్రి';

  @override
  String get deallocAnyNewDamageRecordHere =>
      'ఇక్కడ నమోదు చేసిన ఏ కొత్త నష్టాన్నైనా రైడర్ భద్రతా డిపాజిట్ నుంచి అంచనా వేస్తారు, కాబట్టి దాన్ని స్పష్టంగా నమోదు చేయండి.';

  @override
  String get deallocAssessment => 'అంచనా';

  @override
  String get deallocAvailable => 'అందుబాటులో';

  @override
  String get deallocBatteryReturnedHub => 'బ్యాటరీ హబ్‌కు తిరిగి ఇచ్చారు';

  @override
  String get deallocBothRiderTeamLeadMust => 'రైడర్ మరియు టీమ్ లీడ్ ఇద్దరూ ఖరారు చేయాలి';

  @override
  String get deallocChargerCable => 'చార్జర్ మరియు కేబుల్';

  @override
  String get deallocChargeReturn => 'వాపసు సమయంలో చార్జ్';

  @override
  String get deallocCloseRide => 'ప్రయాణాన్ని ముగించండి';

  @override
  String get deallocCodesValid10MinutesAsk =>
      'కోడ్‌లు 10 నిమిషాలు చెల్లుతాయి. ప్రతి ఒక్కరినీ వారి కోడ్ చదవమని అడగండి, వారి ఫోన్ తీసుకోవద్దు.';

  @override
  String get deallocCompareAgainstHandoverSet => 'అప్పగింత ఫోటోలతో పోల్చండి';

  @override
  String get deallocCompleteDeAllocation => 'వాపసు పూర్తి చేయండి';

  @override
  String get deallocComponents => 'భాగాలు';

  @override
  String get deallocConditionAssessment => 'స్థితి అంచనా';

  @override
  String get deallocConfirmBatteryBack => 'బ్యాటరీ తిరిగి వచ్చిందని ఖరారు చేయండి';

  @override
  String get deallocContinueAssessment => 'అంచనాకు కొనసాగండి';

  @override
  String get deallocContinueVerification => 'ధృవీకరణకు కొనసాగండి';

  @override
  String get deallocDamaged => 'దెబ్బతింది';

  @override
  String get deallocDamageDescription => 'నష్టం వివరణ';

  @override
  String get deallocDeductedFromRidersSecurityDeposit => 'సమీక్ష తర్వాత రైడర్ భద్రతా డిపాజిట్ నుంచి తీసివేస్తారు.';

  @override
  String get deallocDescribeDamage => 'నష్టాన్ని వివరించండి';

  @override
  String get deallocEndRideContinue => 'కొనసాగడానికి ప్రయాణాన్ని ముగించండి';

  @override
  String get deallocEndRidersActiveRide => 'రైడర్ ప్రస్తుత ప్రయాణాన్ని ముగించండి';

  @override
  String get deallocEnterAll6Digits => 'మొత్తం 6 అంకెలు రాయండి';

  @override
  String get deallocEnterClosingOdometer => 'ముగింపు ఓడోమీటర్ రాయండి';

  @override
  String get deallocEnterRidersCode => 'రైడర్ కోడ్ రాయండి';

  @override
  String get deallocEnterTeamLeadsCode => 'టీమ్ లీడ్ కోడ్ రాయండి';

  @override
  String get deallocEstimatedRecovery => 'అంచనా రికవరీ';

  @override
  String get deallocExcellent => 'చాలా బాగుంది';

  @override
  String get deallocGood => 'బాగుంది';

  @override
  String get deallocLoggedBackIntoChargingBay => 'చార్జింగ్ బే జాబితాలో మళ్ళీ నమోదైంది.';

  @override
  String get deallocMinorScuffsNothingRecover => 'చిన్న గీతలు, రికవరీ చేయవలసినది ఏమీ లేదు';

  @override
  String get deallocNoDamageBeyondNormalWear => 'సాధారణ అరుగుదల తప్ప ఏ నష్టమూ లేదు';

  @override
  String get deallocNotUsableUntilFurtherNotice => 'తదుపరి సూచన వరకు వాడటానికి పనికిరాదు';

  @override
  String get deallocOdometerReturn => 'వాపసు సమయంలో ఓడోమీటర్';

  @override
  String get deallocOffRoad => 'రోడ్డు నుంచి బయట';

  @override
  String get deallocPhotographVehicleExactlyAsCame => 'వాహనం తిరిగి వచ్చిన స్థితిలోనే దాని ఫోటో తీయండి';

  @override
  String get deallocRcInsurancePuc => 'ఆర్‌సీ, బీమా మరియు పీయూసీ';

  @override
  String get deallocReadyAllocateAnotherRider => 'మరో రైడర్‌కు ఇవ్వడానికి సిద్ధం';

  @override
  String get deallocRecordVehicleCondition => 'వాహన స్థితిని నమోదు చేయండి';

  @override
  String get deallocRecordWhatComesBackWhat => 'ఏమి తిరిగి వచ్చింది, ఏమి లేదు నమోదు చేయండి';

  @override
  String get deallocRecoverableDamageRaiseMaintenanceJob => 'రికవరీ చేయదగిన నష్టం, నిర్వహణ పని నమోదు చేయండి';

  @override
  String get deallocReturnCondition => 'వాపసు స్థితి';

  @override
  String get deallocReturnPhotos => 'వాపసు ఫోటోలు';

  @override
  String get deallocRiderConfirmation => 'రైడర్ ధృవీకరణ';

  @override
  String get deallocSendWorkshopFirst => 'ముందు వర్క్‌షాప్‌కు పంపండి';

  @override
  String get deallocService => 'సర్వీస్‌లో';

  @override
  String get deallocSetFleetStatus => 'వాహన స్థితిని సెట్ చేయండి';

  @override
  String get deallocSetFleetStatus2 => 'వాహన స్థితిని సెట్ చేయండి';

  @override
  String get deallocStopsTelemetryClosesShiftSettles =>
      'సమాచారం ఆగిపోతుంది, షిఫ్ట్ ముగుస్తుంది మరియు చివరి ట్రిప్ పరిష్కారమవుతుంది.';

  @override
  String get deallocTeamLeadConfirmation => 'టీమ్ లీడ్ ధృవీకరణ';

  @override
  String get deallocTwoPartyVerification => 'రెండు వైపుల ధృవీకరణ';

  @override
  String get deallocVehicleAngles => 'వాహన కోణాలు';

  @override
  String get deallocVehicleCondition => 'వాహన స్థితి';

  @override
  String get deallocVerification => 'ధృవీకరణ';

  @override
  String get deallocWhatDamagedHowBadly => 'ఏమి దెబ్బతింది, ఎంత తీవ్రంగా';

  @override
  String get deploymentAcceptScooter => 'స్కూటర్‌ను స్వీకరించండి';

  @override
  String get deploymentAcceptScooter2 => 'ఈ స్కూటర్‌ను స్వీకరించాలా?';

  @override
  String get deploymentAllSetUp => 'మీరు పూర్తిగా సిద్ధంగా ఉన్నారు';

  @override
  String get deploymentAlmostThere => 'దాదాపు పూర్తయింది';

  @override
  String get deploymentAmountDue => 'బకాయి మొత్తం';

  @override
  String get deploymentAwaitingVerification => 'ధృవీకరణ కోసం వేచి ఉంది';

  @override
  String get deploymentAwaitingVerificationHint => 'మీ ఫ్లీట్ మేనేజర్ త్వరలో దీన్ని నిర్ధారిస్తారు.';

  @override
  String get deploymentBankTransfer => 'బ్యాంక్ బదిలీ';

  @override
  String get deploymentCard => 'కార్డు';

  @override
  String get deploymentCashHub => 'హబ్‌లో నగదు';

  @override
  String get deploymentCheckEachItem => 'ప్రతి అంశాన్ని చూడండి';

  @override
  String get deploymentCheckingWithFleetManagerEvery => 'ప్రతి కొన్ని క్షణాలకు మీ ఫ్లీట్ మేనేజర్‌ను అడుగుతున్నాం…';

  @override
  String get deploymentConfirmEveryItemHasBeen =>
      'ప్రతి అంశాన్నీ టీమ్ లీడ్‌తో పరిశీలించారని, స్కూటర్ నడపడానికి యోగ్యమని మీరు ఖరారు చేస్తున్నారు.';

  @override
  String get deploymentCouldNotLoadChecklist => 'జాబితా తెరవలేకపోయాం';

  @override
  String get deploymentCouldNotLoadTraining => 'శిక్షణ తెరవలేకపోయాం';

  @override
  String get deploymentCouldNotReachServer => 'సర్వర్‌ను చేరలేకపోయాం';

  @override
  String get deploymentCouldNotSubmitInspection => 'తనిఖీ సమర్పించలేకపోయాం';

  @override
  String get deploymentDone => 'పూర్తయింది';

  @override
  String get deploymentEnterTransactionReferencePaidWith => 'చెల్లించిన లావాదేవీ రిఫరెన్స్ రాయండి';

  @override
  String get deploymentFinishHygieneCheck => 'పరిశుభ్రత తనిఖీ పూర్తి చేయండి';

  @override
  String get deploymentFlagAsProblem => 'సమస్యగా గుర్తించండి';

  @override
  String get deploymentFlaggedByRider => 'రైడర్ గుర్తించారు';

  @override
  String get deploymentFleetManagerHasNotAsked => 'మీ ఫ్లీట్ మేనేజర్ ఇంకా చెల్లింపు అడగలేదు.';

  @override
  String get deploymentFleetManagerHasNotSubmitted => 'మీ ఫ్లీట్ మేనేజర్ ఇంకా తనిఖీ సమర్పించలేదు.';

  @override
  String get deploymentFleetManagerPreparingVehicleIts =>
      'మీ ఫ్లీట్ మేనేజర్ వాహనాన్ని సిద్ధం చేస్తున్నారు. సిద్ధం కాగానే చెల్లింపు వివరాలు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get deploymentFleetManagerPuttingTogetherPayment =>
      'మీ ఫ్లీట్ మేనేజర్ చెల్లింపు వివరాలు సిద్ధం చేస్తున్నారు. కొద్దిసేపట్లో మిమ్మల్ని చెల్లించమని అడుగుతారు.';

  @override
  String get deploymentFleetManagerWillAllocateScooter =>
      'మీ ఫ్లీట్ మేనేజర్ మీకు స్కూటర్ ఇస్తారు. అలా జరిగిన వెంటనే మిమ్మల్ని నేరుగా ఇక్కడికి తీసుకువస్తాం.';

  @override
  String get deploymentGoThroughEachItemWith =>
      'ప్రతి అంశాన్ని మీ టీమ్ లీడ్‌తో కలిసి చూడండి. సరిగా లేనిదాన్ని గుర్తించండి, అది మీ గమనికతో వర్క్‌షాప్‌కు వెళ్తుంది.';

  @override
  String get deploymentHowDidPay => 'మీరు ఎలా చెల్లించారు?';

  @override
  String get deploymentHygieneComplete => 'పరిశుభ్రత తనిఖీ పూర్తయింది';

  @override
  String get deploymentInspection => 'తనిఖీ';

  @override
  String get deploymentInspectionAccepted => 'తనిఖీ ఆమోదించబడింది';

  @override
  String get deploymentItemsMarkedAsProblemGo =>
      'సమస్యగా గుర్తించిన అంశాలు మీ గమనికతో ఫ్లీట్ మేనేజర్‌కు వెళ్తాయి. మిగిలినవాటిపై అప్పగింత కొనసాగుతుంది.';

  @override
  String deploymentManagerNextStep(String vehicle) {
    return 'మీ ఫ్లీట్ మేనేజర్ $vehicle తదుపరి దశలో ఉన్నారు.';
  }

  @override
  String get deploymentNoPaymentShow => 'చూపడానికి చెల్లింపు లేదు';

  @override
  String get deploymentNoteWorkshopTeam => 'వర్క్‌షాప్ బృందానికి సూచన';

  @override
  String get deploymentOpenEachModuleReadThrough =>
      'ప్రతి పాఠాన్ని తెరిచి పూర్తిగా చదవండి. తప్పనిసరి పాఠాలు పూర్తి చేయకుండా మీరు ముగించలేరు.';

  @override
  String get deploymentPaidVia => 'దీని ద్వారా చెల్లింపు';

  @override
  String get deploymentPaymentReceived => 'చెల్లింపు అందింది';

  @override
  String deploymentPaymentRejectedBody(String reason) {
    return 'మీ ఫ్లీట్ మేనేజర్ ఈ చెల్లింపును నిర్ధారించలేకపోయారు: $reason. వివరాలు చూసి మళ్లీ పంపండి.';
  }

  @override
  String get deploymentPaymentRejectedTitle => 'చెల్లింపు నిర్ధారించబడలేదు';

  @override
  String get deploymentPaymentSubmitted => 'చెల్లింపు సమర్పించబడింది';

  @override
  String get deploymentPaymentSupport =>
      'ఈ చెల్లింపును ఇప్పుడు యాప్ నుంచి పంపలేరు. దయచేసి మీ హబ్ లేదా సపోర్ట్‌ను సంప్రదించండి.';

  @override
  String get deploymentPayScooter => 'మీ స్కూటర్‌కు చెల్లించండి';

  @override
  String get deploymentPlanAcceptedSnack => 'ప్లాన్ అంగీకరించబడింది. తర్వాత మీ ఫ్లీట్ మేనేజర్ చెల్లింపు అడుగుతారు.';

  @override
  String get deploymentPlanCouldNotLoad => 'మీ ప్లాన్‌ను లోడ్ చేయలేకపోయాం';

  @override
  String get deploymentPlanIntro =>
      'మీ ఫ్లీట్ మేనేజర్ మీ కోసం ఈ ప్లాన్ ఎంచుకున్నారు. అద్దె మరియు ఈరోజు చెల్లించాల్సిన మొత్తం చూడండి, నిబంధనలు చదవండి, తర్వాత కొనసాగడానికి అంగీకరించండి.';

  @override
  String get deploymentPlanNextPayment =>
      'మీరు ఈ ప్లాన్‌ను అంగీకరించారు. తర్వాత మీ ఫ్లీట్ మేనేజర్ చెల్లింపు అడుగుతారు.';

  @override
  String get deploymentPlanTitle => 'మీ అద్దె ప్లాన్';

  @override
  String get deploymentPreparingScooter => 'మీ స్కూటర్ సిద్ధమవుతోంది';

  @override
  String get deploymentProgressSavedSignAgainAny =>
      'మీ పురోగతి సేవ్ అయింది. ఎప్పుడైనా మళ్ళీ సైన్ ఇన్ చేసి అక్కడి నుంచే కొనసాగించండి.';

  @override
  String get deploymentReceiptAdd => 'స్క్రీన్‌షాట్ జోడించండి';

  @override
  String get deploymentReceiptAdded => 'స్క్రీన్‌షాట్ జోడించబడింది';

  @override
  String get deploymentReceiptsSent => 'పంపిన స్క్రీన్‌షాట్‌లు';

  @override
  String get deploymentReceiptTitle => 'చెల్లింపు స్క్రీన్‌షాట్ (ఐచ్ఛికం)';

  @override
  String get deploymentReceiptTooLarge => 'ఈ చిత్రం 5 MB కంటే పెద్దది. చిన్నది ఎంచుకోండి.';

  @override
  String get deploymentReference => 'రిఫరెన్స్';

  @override
  String get deploymentReferenceReceiptNumber => 'రిఫరెన్స్ లేదా రసీదు నంబర్';

  @override
  String get deploymentRequired => 'అవసరం';

  @override
  String get deploymentRide => 'ప్రయాణం';

  @override
  String get deploymentRiderHygiene => 'రైడర్ పరిశుభ్రత';

  @override
  String get deploymentScooterReserved => 'స్కూటర్ రిజర్వ్ చేయబడింది';

  @override
  String get deploymentSubmitted => 'సమర్పించబడింది';

  @override
  String get deploymentSubmitWithProblemsFlagged => 'సమస్యలు గుర్తించి సమర్పించాలా?';

  @override
  String get deploymentTransactionReference => 'లావాదేవీ రిఫరెన్స్';

  @override
  String get deploymentUpiTransactionIdEG => 'యూపీఐ లావాదేవీ ఐడీ, ఉదా. 4284 7192 3456';

  @override
  String get deploymentWaitingAllocation => 'కేటాయింపు కోసం ఎదురుచూస్తోంది';

  @override
  String get deploymentWhatWrong => 'ఏమి సమస్య?';

  @override
  String deploymentWritingPdi(String vehicle) {
    return 'మీ ఫ్లీట్ మేనేజర్ $vehicle అప్పగింతకు ముందు తనిఖీ రాస్తున్నారు. తర్వాత మీరు దాన్ని చూస్తారు.';
  }

  @override
  String get deploymentYourPlan => 'మీ ప్లాన్';

  @override
  String get errorActiveScooterRequired => 'దీనికి మీకు స్కూటర్ కేటాయించి ఉండాలి.';

  @override
  String get errorCouldNotReachServerCheck => 'సర్వర్‌ను చేరలేకపోయాం. మీ కనెక్షన్ చూసుకోండి.';

  @override
  String get errorDidNotLookRight => 'ఇది సరిగా అనిపించలేదు.';

  @override
  String get errorInspectionWithRider => 'తనిఖీ రైడర్ వద్ద';

  @override
  String get errorPaymentPending => 'చెల్లింపు పెండింగ్';

  @override
  String get errorRiderProfileMissing => 'రైడర్ ప్రొఫైల్ దొరకలేదు.';

  @override
  String get errorServerTookTooLongAnswer => 'సర్వర్ సమాధానం ఇవ్వడానికి చాలా సమయం తీసుకుంది.';

  @override
  String get errorSessionHasExpiredSignAgain => 'మీ సెషన్ ముగిసింది. మళ్ళీ సైన్ ఇన్ చేయండి.';

  @override
  String get errorTrainingProgress => 'శిక్షణ జరుగుతోంది';

  @override
  String get errorUnknown => 'తెలియదు';

  @override
  String get esignAddNameFirst => 'ముందుగా ప్రొఫైల్ దశలో మీ పూర్తి పేరును జోడించండి';

  @override
  String get esignSigned => 'సంతకం చేశారు';

  @override
  String get esignTapToSign => 'సంతకం చేయడానికి ట్యాప్ చేయండి';

  @override
  String get esignTitle => 'మీ ఈ-సంతకం';

  @override
  String get esignYourName => 'మీ పేరు';

  @override
  String get exchangeAcceptConfirm => 'ఆమోదిస్తే ఈ స్కూటర్ కొత్త నిబంధనలకు మీరు ఒప్పుకున్నట్టే.';

  @override
  String get exchangeAccepted => 'ఆఫర్ ఆమోదించారు';

  @override
  String get exchangeAcceptedOfferTitle => 'మీ కొత్త ప్లాన్';

  @override
  String get exchangeAcceptOffer => 'ఆఫర్ ఆమోదించండి';

  @override
  String get exchangeAgreementHistory => 'ఒప్పందం చరిత్ర';

  @override
  String get exchangeCancelConfirm => 'ఈ అభ్యర్థన మూసివేయబడుతుంది.';

  @override
  String get exchangeCancelled => 'అభ్యర్థన రద్దయింది';

  @override
  String get exchangeCancelRequest => 'అభ్యర్థన రద్దు చేయండి';

  @override
  String get exchangeChooseReason => 'మీకు మార్పు ఎందుకు కావాలి?';

  @override
  String get exchangeCompleted => 'పూర్తయింది';

  @override
  String get exchangeConsent => 'నేను ఈ ఆఫర్ చదివాను, దీనికి అంగీకరిస్తున్నాను';

  @override
  String get exchangeCouldNotLoad => 'మార్పు సమాచారం రాలేదు';

  @override
  String get exchangeCurrentScooter => 'ప్రస్తుత స్కూటర్';

  @override
  String exchangeDepositDue(String amount) {
    return 'కొత్త స్కూటర్ తీసుకునే ముందు ఇంకా $amount డిపాజిట్ చెల్లించండి.';
  }

  @override
  String get exchangeDepositHeld => 'హబ్ వద్ద ఉంచిన అదనపు డిపాజిట్';

  @override
  String get exchangeDepositMoved => 'బదిలీ అయిన డిపాజిట్';

  @override
  String get exchangeDepositRefund => 'డిపాజిట్ వాపసు';

  @override
  String get exchangeDepositToPay => 'చెల్లించాల్సిన అదనపు డిపాజిట్';

  @override
  String get exchangeDetails => 'అభ్యర్థన వివరాలు';

  @override
  String get exchangeDetailTitle => 'మార్పు అభ్యర్థన';

  @override
  String get exchangeErrorAlreadyReturned => 'పాత స్కూటర్ ఇప్పటికే తిరిగి ఇచ్చారు.';

  @override
  String get exchangeErrorBatteryPlan => 'ఈ స్కూటర్‌కు రైడర్ బ్యాటరీ ప్లాన్ అందుబాటులో లేదు.';

  @override
  String get exchangeErrorBillingChanged => 'ఆఫర్ ఆమోదించిన తర్వాత బిల్లింగ్ మారింది. దయచేసి సపోర్ట్‌ను సంప్రదించండి.';

  @override
  String get exchangeErrorCannotCancel =>
      'మీ స్కూటర్ ఇప్పటికే తిరిగి ఇచ్చారు, కాబట్టి ఇక్కడ అభ్యర్థన రద్దు చేయలేరు. దయచేసి మీ హబ్‌ను సంప్రదించండి.';

  @override
  String get exchangeErrorChanged => 'ఈ అభ్యర్థన ఇప్పుడే మారింది. కిందికి లాగి రిఫ్రెష్ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get exchangeErrorDepositsUnsettled => 'డిపాజిట్లు ఇంకా సర్దుబాటు కాలేదు. ముందు డిపాజిట్లు సర్దుబాటు చేయండి.';

  @override
  String get exchangeErrorDisabled => 'ప్రస్తుతం వాహనం మార్పు అందుబాటులో లేదు. దయచేసి మీ హబ్‌ను సంప్రదించండి.';

  @override
  String get exchangeErrorDuesPending =>
      'ముందు మీ బకాయిలు చెల్లించండి. వాహనం పాడైనా లేదా భద్రత కోసం మార్పు ఇప్పటికీ చేయవచ్చు.';

  @override
  String get exchangeErrorHandoverUnfinished => 'కొత్త స్కూటర్ ఇంకా అప్పగించలేదు. ముందు అప్పగింత దశలు పూర్తి చేయండి.';

  @override
  String get exchangeErrorHoldExpired => 'స్కూటర్ రిజర్వేషన్ గడువు ముగిసింది. బదులు స్కూటర్ మళ్లీ ఎంచుకోండి.';

  @override
  String get exchangeErrorInspectionUnfinished => 'ముందు వాపసు తనిఖీ పూర్తి చేయండి.';

  @override
  String get exchangeErrorNoRental => 'మీకు యాక్టివ్ అద్దె కనిపించలేదు.';

  @override
  String get exchangeErrorNotEligible => 'రైడర్ ఈ స్కూటర్‌కు అర్హులు కాదు.';

  @override
  String get exchangeErrorNoTerms =>
      'రైడర్ నిబంధనలు సెట్ కాలేదు. ఒక యాక్టివ్ నిబంధనల సెట్ ప్రచురించమని అడ్మిన్‌ను అడగండి.';

  @override
  String get exchangeErrorNotFound => 'ఈ మార్పు అభ్యర్థన ఇప్పుడు లేదు.';

  @override
  String get exchangeErrorOfferClosed => 'ఈ ఆఫర్ ఇప్పుడు అందుబాటులో లేదు.';

  @override
  String get exchangeErrorOfferInvalid => 'ఈ ఆఫర్‌ను ధృవీకరించలేకపోయాం. మళ్లీ పంపమని మీ హబ్‌ను అడగండి.';

  @override
  String get exchangeErrorPricingSetup =>
      'ఈ స్కూటర్‌కు ధర ఇంకా సెట్ చేయలేదు. రేట్ కార్డ్ తనిఖీ చేయమని ఆపరేటర్‌ను అడగండి.';

  @override
  String get exchangeErrorRecordsMissing =>
      'ఈ మార్పుకు సంబంధించిన కొన్ని రికార్డులు లేవు. దయచేసి సపోర్ట్‌ను సంప్రదించండి.';

  @override
  String get exchangeErrorRentalInactive => 'మీ అద్దె యాక్టివ్‌గా లేదు, కాబట్టి మార్పు అభ్యర్థన పంపలేరు.';

  @override
  String get exchangeErrorReturnFirst => 'బదులు ఎంచుకునే ముందు పాత స్కూటర్ వాపసు పూర్తి చేయండి.';

  @override
  String get exchangeErrorReturnUnfinished =>
      'వాపసు ఇంకా పూర్తి కాలేదు. ముందు రైడర్ OTP ధృవీకరించి వాపసు పూర్తి చేయండి.';

  @override
  String get exchangeErrorSameScooter => 'రైడర్ ప్రస్తుత స్కూటర్ కాకుండా వేరేది ఎంచుకోండి.';

  @override
  String get exchangeErrorScooterReserved => 'ఆ స్కూటర్ వేరే మార్పు కోసం రిజర్వ్ అయింది.';

  @override
  String get exchangeErrorScooterUnavailable => 'ఆ స్కూటర్ ఇప్పుడు అందుబాటులో లేదు. వేరేది ఎంచుకోండి.';

  @override
  String get exchangeErrorSecurityChange =>
      'ఈ స్కూటర్‌కు వేరే సెక్యూరిటీ డిపాజిట్ కావాలి. ముందు డిపాజిట్‌ను విడిగా మార్చండి.';

  @override
  String get exchangeErrorSecurityTopUp => 'పూర్తి చేసే ముందు రైడర్ సెక్యూరిటీ డిపాజిట్ నింపాలి.';

  @override
  String get exchangeErrorStale => 'ఈ ఆఫర్ తర్వాత మీ అద్దె మారింది. మీ హబ్‌ను కొత్త ఆఫర్ అడగండి.';

  @override
  String get exchangeErrorTooSoon =>
      'ఈ స్కూటర్ మీకు వచ్చి కొద్ది రోజులే అయింది. కొన్ని రోజుల తర్వాత మళ్లీ ప్రయత్నించండి.';

  @override
  String get exchangeExtraRentNow => 'ఇప్పుడు అదనపు అద్దె';

  @override
  String get exchangeFee => 'మార్పు రుసుము';

  @override
  String get exchangeFeeWaived => 'మాఫీ';

  @override
  String get exchangeHubReason => 'హబ్ చెప్పిన కారణం';

  @override
  String get exchangeNeedsYou => 'మీ సమాధానం కావాలి';

  @override
  String get exchangeNewRent => 'కొత్త అద్దె';

  @override
  String get exchangeNewRentFrom => 'కొత్త అద్దె మొదలు';

  @override
  String get exchangeNewScooter => 'కొత్త స్కూటర్';

  @override
  String get exchangeNextApproved => 'ఆమోదించారు. తనిఖీ కోసం ప్రస్తుత స్కూటర్ తీసుకురమ్మని మీ హబ్ చెబుతుంది.';

  @override
  String exchangeNextBringIn(String date) {
    return '$dateన మీ ప్రస్తుత స్కూటర్‌ను మీరు ఎంచుకున్న హబ్‌కు తీసుకురండి. హబ్ బృందం ఎక్స్‌ఛేంజ్ ప్రారంభిస్తుంది.';
  }

  @override
  String get exchangeNextCancelled => 'ఈ అభ్యర్థన రద్దైంది.';

  @override
  String get exchangeNextCheckingIn =>
      'హబ్ బృందం మీ ప్రస్తుత స్కూటర్‌ను తనిఖీ చేస్తోంది. మెకానిక్ రిపోర్ట్‌ను నిర్ధారించడానికి మీ ఫోన్‌కు కోడ్ వస్తుంది.';

  @override
  String get exchangeNextChoosing => 'పాత స్కూటర్ తిరిగి ఇచ్చారు. మీ హబ్ మీ కోసం కొత్త స్కూటర్ ఎంచుకుంటోంది.';

  @override
  String get exchangeNextCompleted => 'మార్పు పూర్తయింది. మీ కొత్త స్కూటర్‌ను ఆనందించండి!';

  @override
  String get exchangeNextDeposit => 'ఆఫర్ ఆమోదించారు. మీ హబ్ కొత్త స్కూటర్ డిపాజిట్ సర్దుబాటు చేస్తోంది.';

  @override
  String get exchangeNextExpired => 'ఈ అభ్యర్థన పూర్తి కాకముందే గడువు ముగిసింది.';

  @override
  String get exchangeNextHandover => 'మీ కొత్త స్కూటర్ సిద్ధంగా ఉంది. హబ్ నుండి తీసుకోండి.';

  @override
  String get exchangeNextOffer => 'మీ ఆఫర్ సిద్ధంగా ఉంది. వివరాలు చూసి ఆమోదించండి లేదా తిరస్కరించండి.';

  @override
  String get exchangeNextRejected => 'మీ హబ్ ఈ అభ్యర్థనను ఆమోదించలేకపోయింది.';

  @override
  String get exchangeNextRequested => 'మీ హబ్ త్వరలో మీ అభ్యర్థనను పరిశీలిస్తుంది.';

  @override
  String get exchangeNextReserved => 'మీ కోసం కొత్త స్కూటర్ రిజర్వ్ చేశారు. మీ ఆఫర్ త్వరలో సిద్ధమవుతుంది.';

  @override
  String get exchangeNextReturn => 'తనిఖీ కోసం ప్రస్తుత స్కూటర్‌ను హబ్‌లో తిరిగి ఇవ్వండి.';

  @override
  String get exchangeNone => 'అభ్యర్థనలు లేవు';

  @override
  String get exchangeNoneMessage => 'మీ స్కూటర్‌లో సమస్య ఉంటే, మార్పు కోసం అభ్యర్థించండి, మీ హబ్ సహాయం చేస్తుంది.';

  @override
  String get exchangeNoRentalBody => 'స్కూటర్ అద్దెకు వచ్చిన తర్వాత మీరు మార్పు కోసం అభ్యర్థించవచ్చు.';

  @override
  String get exchangeNoRentalTitle => 'యాక్టివ్ అద్దె లేదు';

  @override
  String get exchangeNoteHint => 'సమస్యను వివరించండి (ఐచ్ఛికం)';

  @override
  String get exchangeNoteLabel => 'హబ్ కోసం నోట్';

  @override
  String get exchangeNotes => 'మీ నోట్';

  @override
  String get exchangeOfferExpiredMessage => 'ఈ ఆఫర్ గడువు ముగిసింది. మీ హబ్ కొత్తది పంపగలదు.';

  @override
  String get exchangeOfferExpires => 'ఆఫర్ చెల్లుబాటు';

  @override
  String get exchangeOfferTitle => 'మీ ఆఫర్';

  @override
  String get exchangeOpen => 'జరుగుతోంది';

  @override
  String get exchangeOpenExists => 'మీ మార్పు ఒకటి ఇప్పటికే జరుగుతోంది.';

  @override
  String get exchangePast => 'పూర్తయ్యాయి';

  @override
  String get exchangePerDay => '/ రోజు';

  @override
  String get exchangePerFortnight => '/ 2 వారాలు';

  @override
  String get exchangePerMonth => '/ నెల';

  @override
  String get exchangePerQuarter => '/ 3 నెలలు';

  @override
  String get exchangePerWeek => '/ వారం';

  @override
  String get exchangeProgress => 'పురోగతి';

  @override
  String get exchangeRaised => 'అభ్యర్థించినది';

  @override
  String get exchangeReason => 'కారణం';

  @override
  String get exchangeReasonBreakdown => 'వాహనం పాడైంది';

  @override
  String get exchangeReasonBreakdownHint => 'స్కూటర్ ఆగిపోయింది లేదా తరచూ పాడవుతోంది';

  @override
  String get exchangeReasonOtherHint => 'ఇంకేదైనా కారణం';

  @override
  String get exchangeReasonSafety => 'భద్రత మార్పు';

  @override
  String get exchangeReasonSafetyHint => 'భద్రతా తనిఖీ వల్ల వేరే స్కూటర్ కావాలి';

  @override
  String get exchangeReasonUnsafe => 'నడపడం సురక్షితం కాదు';

  @override
  String get exchangeReasonUnsafeHint => 'బ్రేకులు, లైట్లు లేదా టైర్లు సురక్షితంగా లేవు';

  @override
  String get exchangeReasonUpgrade => 'అప్‌గ్రేడ్';

  @override
  String get exchangeReasonUpgradeHint => 'మీకు వేరే మోడల్ కావాలి';

  @override
  String get exchangeRejected => 'ఆఫర్ తిరస్కరించారు';

  @override
  String get exchangeRejectOffer => 'ఆఫర్ తిరస్కరించండి';

  @override
  String get exchangeRejectReason => 'కారణం';

  @override
  String get exchangeRejectReasonRequired => 'దయచేసి కారణం రాయండి';

  @override
  String get exchangeRejectSubtitle => 'కారణం మీ హబ్‌కు చెప్పండి, వారు మంచిది పంపగలరు.';

  @override
  String get exchangeRentalCouldNotLoad => 'మీ అద్దె లోడ్ కాలేదు';

  @override
  String get exchangeRentCredit => 'అద్దె క్రెడిట్';

  @override
  String get exchangeRequestAction => 'మార్పు కోసం అభ్యర్థించండి';

  @override
  String get exchangeRequestSent => 'మార్పు అభ్యర్థన పంపబడింది';

  @override
  String get exchangeRequestSubtitle => 'మీకు వేరే స్కూటర్ ఎందుకు కావాలో మీ హబ్‌కు చెప్పండి.';

  @override
  String get exchangeReturnDate => 'అప్పగించే తేదీ';

  @override
  String get exchangeSendRequest => 'అభ్యర్థన పంపండి';

  @override
  String get exchangeStageAccepted => 'ఆమోదించారు';

  @override
  String get exchangeStageCompleted => 'పూర్తయింది';

  @override
  String get exchangeStageHandover => 'అప్పగింత';

  @override
  String get exchangeStageOfferReady => 'ఆఫర్ సిద్ధం';

  @override
  String get exchangeStageRequested => 'అభ్యర్థించారు';

  @override
  String get exchangeStatusApproved => 'ఆమోదించారు';

  @override
  String get exchangeStatusCancelled => 'రద్దైంది';

  @override
  String get exchangeStatusCheckingIn => 'ఎక్స్‌ఛేంజ్ జరుగుతోంది';

  @override
  String get exchangeStatusChoosing => 'స్కూటర్ ఎంపిక జరుగుతోంది';

  @override
  String get exchangeStatusExpired => 'గడువు ముగిసింది';

  @override
  String get exchangeStatusRejected => 'తిరస్కరించారు';

  @override
  String get exchangeStatusReturn => 'స్కూటర్ తిరిగి ఇవ్వండి';

  @override
  String get exchangeStepApproval => 'హబ్ ఆమోదం';

  @override
  String get exchangeStepDeposit => 'డిపాజిట్';

  @override
  String get exchangeStepHandover => 'కొత్త స్కూటర్ తీసుకోవడం';

  @override
  String get exchangeStepOffer => 'కొత్త స్కూటర్ ఆఫర్';

  @override
  String get exchangeStepRequested => 'అభ్యర్థన పంపారు';

  @override
  String get exchangeStepReturn => 'పాత స్కూటర్ తిరిగి ఇవ్వడం';

  @override
  String get exchangeSubtitle => 'వేరే స్కూటర్ కోసం అడగండి';

  @override
  String get exchangeTitle => 'వాహనం మార్పు';

  @override
  String get exchangeVersionCurrent => 'ప్రస్తుతం';

  @override
  String exchangeVersionFrom(String date) {
    return '$date నుండి';
  }

  @override
  String exchangeVersionNumber(String number) {
    return 'వెర్షన్ $number';
  }

  @override
  String get exchangeVersionPrevious => 'మునుపటి';

  @override
  String get exchangeWhenWhere => 'ఎప్పుడు, ఎక్కడ';

  @override
  String get exchangeWhenWhereHint => 'మీ ప్రస్తుత స్కూటర్‌ను ఎప్పుడు, ఎక్కడికి తీసుకొస్తారో ఎంచుకోండి.';

  @override
  String get fleetOnboardingActive => 'యాక్టివ్';

  @override
  String get fleetOnboardingArchived => 'ఆర్కైవ్ చేయబడింది';

  @override
  String get fleetOnboardingDraft => 'డ్రాఫ్ట్';

  @override
  String get fleetOnboardingInProgress => 'జరుగుతోంది';

  @override
  String get fleetOnboardingPendingReview => 'సమీక్ష కోసం వేచి ఉంది';

  @override
  String get fleetOnboardingRejected => 'తిరస్కరించబడింది';

  @override
  String get fleetSearchAllocationActive => 'రైడర్ దగ్గర';

  @override
  String get fleetSearchAllocationCancelled => 'రద్దయింది';

  @override
  String get fleetSearchAllocationHandover => 'అప్పగింత జరుగుతోంది';

  @override
  String get fleetSearchAllocationReturned => 'తిరిగి ఇచ్చారు';

  @override
  String get fleetSearchAllocationReturning => 'రిటర్న్ జరుగుతోంది';

  @override
  String get fleetSearchCouldNotLoad => 'స్కూటర్లను వెతకలేకపోయాం';

  @override
  String get fleetSearchCouldNotLoadRiderHistory => 'రైడర్ చరిత్ర లోడ్ కాలేదు';

  @override
  String get fleetSearchCouldNotLoadScooter => 'ఈ స్కూటర్ లోడ్ కాలేదు';

  @override
  String get fleetSearchCurrentRider => 'ప్రస్తుత రైడర్';

  @override
  String get fleetSearchEmptyMessage => 'వాహన నంబర్, ఫ్లీట్ కోడ్ లేదా చాసిస్ నంబర్ చూసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get fleetSearchEmptyTitle => 'స్కూటర్ కనిపించలేదు';

  @override
  String get fleetSearchHint => 'నంబర్, కోడ్ లేదా చాసిస్‌తో స్కూటర్లను వెతకండి';

  @override
  String get fleetSearchLatestSubmission => 'తాజా రిటర్న్ లేదా ఎక్స్ఛేంజ్';

  @override
  String get fleetSearchNoRider => 'ప్రస్తుతం ఈ స్కూటర్ ఏ రైడర్ దగ్గరా లేదు.';

  @override
  String get fleetSearchNoRiderHistory => 'ఇప్పటివరకు ఈ స్కూటర్ ఏ రైడర్‌కూ ఇవ్వలేదు.';

  @override
  String get fleetSearchNoSubmission => 'ఇంకా ఏ రిటర్న్ లేదా ఎక్స్ఛేంజ్ జరగలేదు.';

  @override
  String get fleetSearchOtherHub => 'వేరే హబ్';

  @override
  String get fleetSearchRiderHistory => 'రైడర్ చరిత్ర';

  @override
  String get fleetSearchRiderHistoryOtherHub => 'రైడర్ చరిత్ర మీ హబ్‌లలోని స్కూటర్లకు మాత్రమే కనిపిస్తుంది.';

  @override
  String fleetSearchSince(String date) {
    return '$date నుండి';
  }

  @override
  String get fleetSearchStartMessage => 'వాహన నంబర్, ఫ్లీట్ కోడ్ లేదా చాసిస్ నంబర్‌లో కనీసం 2 అక్షరాలు టైప్ చేయండి.';

  @override
  String get fleetSearchStartTitle => 'అన్ని హబ్‌లలో వెతకండి';

  @override
  String get fleetSearchSubmissionDone => 'పూర్తయింది';

  @override
  String get fleetSearchSubmissionOpen => 'జరుగుతోంది';

  @override
  String get fleetSearchTitle => 'స్కూటర్ వెతకండి';

  @override
  String get fleetStatusAllocated => 'కేటాయించబడింది';

  @override
  String get fleetStatusAllocating => 'కేటాయింపు జరుగుతోంది';

  @override
  String get fleetStatusAvailable => 'అందుబాటులో ఉంది';

  @override
  String get fleetStatusAwaitingParts => 'విడిభాగాల కోసం వేచి ఉంది';

  @override
  String get fleetStatusBroken => 'చెడిపోయింది';

  @override
  String get fleetStatusInspectionPending => 'తనిఖీ కోసం వేచి ఉంది';

  @override
  String get fleetStatusInTransit => 'రవాణాలో ఉంది';

  @override
  String get fleetStatusInUse => 'వాడుకలో ఉంది';

  @override
  String get fleetStatusMaintenance => 'నిర్వహణలో ఉంది';

  @override
  String get fleetStatusOutOfService => 'సేవలో లేదు';

  @override
  String get fleetStatusReserved => 'రిజర్వ్ చేయబడింది';

  @override
  String get fleetStatusReturning => 'తిరిగి ఇవ్వబడుతోంది';

  @override
  String get homeCouldNotLoadDashboard => 'మీ డాష్‌బోర్డ్ తెరవలేకపోయాం';

  @override
  String get homeDailyRental => 'రోజువారీ అద్దె';

  @override
  String get homeDepositsHandoverFees => 'డిపాజిట్లు మరియు అప్పగింత రుసుము';

  @override
  String get homeHelpSupport => 'సహాయం మరియు మద్దతు';

  @override
  String get homeHistory => 'చరిత్ర';

  @override
  String get homeLastPayment => 'చివరి చెల్లింపు';

  @override
  String get homeMarkAbsent => 'గైర్హాజరుగా గుర్తించండి';

  @override
  String get homeMarkedAbsentScooterNowDisabled => 'గైర్హాజరుగా గుర్తించారు. స్కూటర్ ఇప్పుడు ఆగిపోయింది.';

  @override
  String get homeMarkYourselfAbsent => 'మిమ్మల్ని గైర్హాజరుగా గుర్తించాలా?';

  @override
  String get homeMarkYourselfPresentSwitchVehicle => 'వాహనం ఆన్ చేయడానికి ముందు హాజరు వేయండి.';

  @override
  String homeNextDebitOn(String date) {
    return 'తదుపరి కోత $date';
  }

  @override
  String get homeRent => 'అద్దె';

  @override
  String get homeRentDue => 'బకాయి అద్దె';

  @override
  String homeRentDueOn(String date) {
    return 'గడువు తేదీ $date';
  }

  @override
  String homeRentOverdue(String amount) {
    return '$amount గడువు దాటింది';
  }

  @override
  String get homeScooter => 'స్కూటర్';

  @override
  String get homeShiftWillEndScooterWill =>
      'మీ షిఫ్ట్ ముగుస్తుంది మరియు స్కూటర్ ఆగిపోతుంది. వారం మరియు నెల ప్లాన్లలో అద్దె వర్తిస్తుంది.';

  @override
  String get homeWithdraw => 'తీసుకోండి';

  @override
  String get homeWorkingDays => 'పని దినాలు';

  @override
  String get hubAllHubs => 'అన్ని హబ్‌లు';

  @override
  String get hubAllocate => 'కేటాయించండి';

  @override
  String get hubAllotmentsInQueue => 'క్యూలో ఉన్న కేటాయింపులు';

  @override
  String get hubAllotmentsInQueueInfo => 'వాహనం కోసం ఎదురుచూస్తున్న ఈ హబ్ యాక్టివ్ రైడర్లు.';

  @override
  String get hubChooseHub => 'హబ్ ఎంచుకోండి';

  @override
  String get hubChooseHubSubtitle => 'ఒక హబ్ చూడండి, లేదా మీ అన్ని హబ్‌లను కలిపి.';

  @override
  String get hubCouldNotLoadHub => 'మీ హబ్ తెరవలేకపోయాం';

  @override
  String hubCount(int count) {
    return '$count హబ్‌లు';
  }

  @override
  String get hubFleetAtHub => 'హబ్‌లో';

  @override
  String get hubFleetManager => 'ఫ్లీట్ మేనేజర్';

  @override
  String get hubFleetMapped => 'మొత్తం ఫ్లీట్';

  @override
  String get hubFleetOnField => 'ఫీల్డ్‌లో';

  @override
  String get hubFleetUtilisation => 'ఫ్లీట్ వినియోగం';

  @override
  String hubGstinLine(String gstin) {
    return 'GSTIN: $gstin';
  }

  @override
  String get hubHome => 'హోమ్';

  @override
  String get hubHubGlance => 'మీ హబ్ ఒక్క చూపులో';

  @override
  String get hubMaintenance => 'నిర్వహణ';

  @override
  String get hubMarkedAbsentShiftClosed => 'గైర్హాజరుగా గుర్తించారు. మీ షిఫ్ట్ ముగిసింది.';

  @override
  String get hubNoHubAssigned => 'మీకు ఏ హబ్ కేటాయించలేదు.';

  @override
  String hubQuickSupportLine(String number) {
    return 'త్వరిత సహాయం: $number';
  }

  @override
  String get hubQuickView => 'హబ్ త్వరిత వీక్షణ';

  @override
  String get hubQuickViewInfo => 'మీరు ఎంచుకున్న హబ్ లైవ్ లెక్కలు.';

  @override
  String get hubReturn => 'వాపసు';

  @override
  String get hubRfdsAvailable => 'అందుబాటులో ఉన్న RFDలు';

  @override
  String get hubRfdsAvailableInfo => 'డిప్లాయ్‌మెంట్‌కు సిద్ధం: కేటాయింపుకు అందుబాటులో ఉన్న ఈ హబ్ వాహనాలు.';

  @override
  String get hubsCouldNotLoad => 'సమీప హబ్‌లు తెరవలేకపోయాం';

  @override
  String get hubService => 'సర్వీస్';

  @override
  String get hubShowDataFor => 'దీని డేటా చూపించు';

  @override
  String get hubsNoneBody => 'మీ లొకేషన్ దగ్గరలో యాక్టివ్ హబ్‌లు లేవు.';

  @override
  String get hubsNoneTitle => 'మీ దగ్గర హబ్‌లు లేవు';

  @override
  String get hubSomethingWentWrong => 'ఏదో తప్పు జరిగింది.';

  @override
  String get hubsSubtitle => 'మీకు దగ్గరలోని హబ్‌లు';

  @override
  String get hubSubmissionsInQueue => 'క్యూలో ఉన్న సబ్మిషన్లు';

  @override
  String get hubSubmissionsInQueueInfo =>
      'ఈ హబ్‌లో పెండింగ్ రిటర్న్‌లు, ఎక్స్‌ఛేంజ్‌లు; వీటి వాహన సబ్మిషన్ ఇంకా పూర్తి కాలేదు.';

  @override
  String get hubUnderMaintenanceFleet => 'మెయింటెనెన్స్‌లో ఉన్న ఫ్లీట్';

  @override
  String get hubUnderMaintenanceFleetInfo => 'ప్రస్తుతం మెయింటెనెన్స్‌లో ఉన్న ఈ హబ్ వాహనాలు.';

  @override
  String get inspectionErrorSafeForReuse => 'స్కూటర్‌ను మళ్లీ ఇవ్వడానికి సురక్షితమో కాదో చెప్పండి.';

  @override
  String get inspectionErrorUnsafeReason => 'స్కూటర్‌ను మళ్లీ ఇవ్వడానికి ఎందుకు సురక్షితం కాదో జోడించండి.';

  @override
  String get introCouldNotLoad => 'పరిచయ స్లైడ్‌లు తెరవలేకపోయాం.';

  @override
  String get introEarnBody =>
      'రోజువారీ చెల్లింపులు, స్పష్టమైన ప్రోత్సాహకాలు మరియు మీరు నిజంగా ఎంత ప్రయాణిస్తారో దానికి సరిపోయే అద్దె ప్లాన్.';

  @override
  String get introEarnHighlight1 => 'అదే రోజు పరిష్కారం';

  @override
  String get introEarnHighlight2 => 'దాచిన కోతలు లేవు';

  @override
  String get introEarnTitle => 'ఎక్కువ సంపాదించండి,\nస్వచ్ఛంగా ప్రయాణించండి';

  @override
  String get introSupportBody => 'రోడ్డుపై సహాయం, సర్వీస్ బుకింగ్ మరియు మీరు చూసేదే చూడగల టీమ్ లీడ్.';

  @override
  String get introSupportHighlight1 => '24x7 రోడ్డుపై సహాయం';

  @override
  String get introSupportHighlight2 => 'మీ హబ్‌లో సర్వీస్';

  @override
  String get introSupportTitle => 'నిజంగా వచ్చే\nసహాయం';

  @override
  String get introVehicleBody =>
      'వాహన పరికరం నుంచి బ్యాటరీ, పరిధి మరియు స్థితి ప్రత్యక్ష సమాచారం. యాప్ నుంచే అన్‌లాక్ చేసి షిఫ్ట్ మొదలుపెట్టండి.';

  @override
  String get introVehicleHighlight1 => 'ప్రత్యక్ష సమాచారం';

  @override
  String get introVehicleHighlight2 => 'ఒక్క నొక్కుతో మొదలు';

  @override
  String get introVehicleTitle => 'మీ స్కూటర్,\nపూర్తిగా అనుసంధానం';

  @override
  String get legalAppName => 'యాప్';

  @override
  String get legalDocumentCouldNotLoad => 'ఈ పత్రాన్ని లోడ్ చేయలేకపోయాం';

  @override
  String get maintenanceAllocation => 'కేటాయింపు';

  @override
  String get maintenanceAllocationOff => 'ఆఫ్‌లో ఉంది';

  @override
  String get maintenanceAllocationOn => 'అనుమతించబడింది';

  @override
  String get maintenanceBattery => 'బ్యాటరీ';

  @override
  String get maintenanceCategory => 'వర్గం';

  @override
  String get maintenanceChangeStatus => 'స్థితి మార్చండి';

  @override
  String get maintenanceChassis => 'ఛాసిస్ నంబర్';

  @override
  String get maintenanceChecksOpen => 'కొన్ని మెకానిక్ తనిఖీలు ఇంకా మిగిలి ఉన్నాయి';

  @override
  String get maintenanceColour => 'రంగు';

  @override
  String get maintenanceCouldNotLoad => 'సర్వీస్‌లో ఉన్న వాహనాలను లోడ్ చేయలేకపోయాం';

  @override
  String get maintenanceCurrentHub => 'ప్రస్తుత హబ్';

  @override
  String get maintenanceEarlierReports => 'మునుపటి మెకానిక్ నివేదికలు';

  @override
  String get maintenanceEmptyBody => 'మీ హబ్‌లోని స్కూటర్ నిర్వహణకు వెళ్లినప్పుడు అది ఇక్కడ కనిపిస్తుంది.';

  @override
  String get maintenanceEmptyTitle => 'సర్వీస్‌లో వాహనాలు లేవు';

  @override
  String get maintenanceEvidence => 'ఆధార ఫోటోలు';

  @override
  String get maintenanceFleetCode => 'ఫ్లీట్ కోడ్';

  @override
  String get maintenanceHistory => 'స్థితి చరిత్ర';

  @override
  String maintenanceHistoryLimit(int limit) {
    return 'తాజా $limit మార్పులు చూపిస్తున్నాం.';
  }

  @override
  String get maintenanceHomeHub => 'హోమ్ హబ్';

  @override
  String get maintenanceInServiceSince => 'సర్వీస్‌కు వచ్చిన తేదీ';

  @override
  String get maintenanceLatestReport => 'తాజా మెకానిక్ నివేదిక';

  @override
  String get maintenanceMaker => 'తయారీదారు';

  @override
  String get maintenanceModel => 'మోడల్';

  @override
  String maintenanceMovedOn(String date) {
    return 'నిర్వహణకు పంపబడింది $date';
  }

  @override
  String get maintenanceNoHistory => 'స్థితి మార్పులు ఏవీ నమోదు కాలేదు.';

  @override
  String get maintenanceNoMatchBody => 'వేరే వాహన నంబర్, ఫ్లీట్ కోడ్, ఛాసిస్ లేదా మోడల్ ప్రయత్నించండి.';

  @override
  String get maintenanceNoMatchTitle => 'సరిపోలే వాహనాలు లేవు';

  @override
  String get maintenanceNoReportYet => 'ఈ వాహనానికి ఇంకా మెకానిక్ నివేదిక నమోదు కాలేదు.';

  @override
  String get maintenanceNotSafe => 'సురక్షితం కాదు';

  @override
  String get maintenanceOdometer => 'ఓడోమీటర్';

  @override
  String get maintenanceOnboarding => 'ఆన్‌బోర్డింగ్';

  @override
  String get maintenanceProgress => 'జరుగుతోంది';

  @override
  String maintenanceReasonFromReport(String reason) {
    return 'మెకానిక్ రిపోర్ట్: $reason';
  }

  @override
  String maintenanceReasonLine(String reason) {
    return 'కారణం: $reason';
  }

  @override
  String get maintenanceReportConfirmed => 'నిర్ధారించిన తేదీ';

  @override
  String get maintenanceReportMechanic => 'మెకానిక్';

  @override
  String get maintenanceReportPhotos => 'ఫోటోలు';

  @override
  String get maintenanceReportRecorded => 'నమోదు చేసిన తేదీ';

  @override
  String maintenanceReportsLimit(int limit) {
    return 'తాజా $limit నివేదికలు చూపిస్తున్నాం.';
  }

  @override
  String get maintenanceReportStatus => 'స్కూటర్ స్థితి';

  @override
  String get maintenanceSafeToReuse => 'మళ్లీ వాడటానికి సురక్షితం';

  @override
  String get maintenanceSearchHint => 'వాహన నంబర్, ఫ్లీట్ కోడ్, ఛాసిస్ లేదా మోడల్ వెతకండి';

  @override
  String get maintenanceSelectVehicle => 'వాహనాన్ని ఎంచుకోండి';

  @override
  String maintenanceStatusChanged(String status) {
    return 'స్థితి $statusకి మార్చబడింది';
  }

  @override
  String maintenanceStatusNow(String status) {
    return 'ప్రస్తుత స్థితి: $status';
  }

  @override
  String get maintenanceStatusOutOfServiceHint =>
      'రోడ్డు నుండి తీసివేయబడింది. ఇది సర్వీస్ నుండి బయటకు వెళ్తుంది, మీ అడ్మిన్ మాత్రమే దీన్ని తిరిగి తీసుకురాగలరు.';

  @override
  String get maintenanceTitle => 'సర్వీస్‌లో ఉన్న వాహనాలు';

  @override
  String get maintenanceUnderMaintenance => 'నిర్వహణలో';

  @override
  String get maintenanceVariant => 'వేరియంట్';

  @override
  String get maintenanceVehicleCouldNotLoad => 'ఈ వాహనాన్ని లోడ్ చేయలేకపోయాం';

  @override
  String get maintenanceVehicleDetails => 'వాహన వివరాలు';

  @override
  String get maintenanceVehicleTitle => 'సర్వీస్‌లో ఉన్న వాహనం';

  @override
  String get maintenanceVehicleType => 'వాహన రకం';

  @override
  String get mapsAllowLocation => 'అనుమతి ఇవ్వండి';

  @override
  String mapsAway(String distance) {
    return '$distance దూరంలో';
  }

  @override
  String get mapsCouldNotOpenMaps => 'Google Maps తెరవలేకపోయాం';

  @override
  String get mapsLocating => 'మీ లొకేషన్‌ను కనుగొంటున్నాం…';

  @override
  String get mapsLocationDeniedBody =>
      'మీ దగ్గరలోని హబ్‌లు మరియు స్వాప్ స్టేషన్‌లను చూపించడానికి మేము మీ లొకేషన్‌ను ఉపయోగిస్తాము.';

  @override
  String get mapsLocationDeniedTitle => 'లొకేషన్ యాక్సెస్‌కు అనుమతి ఇవ్వండి';

  @override
  String get mapsLocationOffBody => 'మీ దగ్గరలోని ప్రదేశాలను చూడటానికి లొకేషన్ సేవలను ఆన్ చేయండి.';

  @override
  String get mapsLocationOffTitle => 'లొకేషన్ ఆఫ్‌లో ఉంది';

  @override
  String get mapsLocationUnavailable => 'మీ లొకేషన్ కనుగొనలేకపోయాం';

  @override
  String mapsMinutes(String minutes) {
    return '$minutes నిమి';
  }

  @override
  String get mapsNavigate => 'దారి చూడండి';

  @override
  String get mapsOpenSettings => 'సెట్టింగ్‌లు తెరవండి';

  @override
  String get navBatterySwap => 'బ్యాటరీ స్వాప్';

  @override
  String get navNearbyHubs => 'సమీప హబ్‌లు';

  @override
  String get navReferEarn => 'రెఫర్ చేసి సంపాదించండి';

  @override
  String get navScooterDetails => 'స్కూటర్ వివరాలు';

  @override
  String get notificationsAll => 'అన్నీ';

  @override
  String get notificationsAllCaughtUp => 'మీరు అన్నీ చూసేశారు';

  @override
  String get notificationsAllClear => 'అంతా బాగుంది';

  @override
  String get notificationsCouldNotLoadNotifications => 'నోటిఫికేషన్లు తెరవలేకపోయాం';

  @override
  String get notificationsEarlier => 'ఇంతకుముందు';

  @override
  String get notificationsEmptyMessage => 'కొత్త అప్‌డేట్‌లు, అలర్ట్‌లు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get notificationsGotIt => 'సరే';

  @override
  String notificationsInboxCount(int count) {
    return 'మీ ఇన్‌బాక్స్‌లో $count నోటిఫికేషన్లు';
  }

  @override
  String get notificationsNoMatchingNotifications => 'సరిపోలే నోటిఫికేషన్లు లేవు';

  @override
  String get notificationsNothingNewNeedsAttention => 'కొత్తగా ఏమీ లేదు';

  @override
  String get notificationsNotifications => 'నోటిఫికేషన్లు';

  @override
  String get notificationsSearchNotifications => 'నోటిఫికేషన్లు వెతకండి';

  @override
  String get notificationsToday => 'ఈరోజు';

  @override
  String get notificationsUnread => 'చదవనివి';

  @override
  String notificationsUnreadCount(int count) {
    return '$count చదవనివి';
  }

  @override
  String get onboardingAcceptAgreementContinue => 'కొనసాగడానికి ఒప్పందాన్ని అంగీకరించండి';

  @override
  String get onboardingAddDateBirthFirstStep => 'కొనసాగించే ముందు మొదటి దశలో పుట్టిన తేదీ రాయండి';

  @override
  String get onboardingAddLeastOneReference => 'కనీసం ఒక రిఫరెన్స్ జోడించండి';

  @override
  String onboardingAddYourField(String field) {
    return 'మీ $field జోడించండి';
  }

  @override
  String get onboardingAgreementBody =>
      'ఈ ఒప్పందం మీకు మరియు మీ ఫ్లీట్ ఆపరేటర్‌కు మధ్య ఉంది. ఇందులో మీకు అప్పగించిన వాహనం, దాన్ని ఎలా వాడవచ్చు, దాని సంరక్షణలో మీ బాధ్యత, మీ ప్లాన్‌లోని డిపాజిట్లు మరియు రుసుములు, ఈ ఏర్పాటు ఎలా ముగుస్తుంది అనేవన్నీ ఉన్నాయి. అంగీకరించే ముందు పూర్తిగా చదవండి. కింది పెట్టెను గుర్తించడం ద్వారా మీరు రైడర్ ఒప్పందం మరియు ఆపరేటర్ రైడర్ విధానాలను చదివారని, వాటికి కట్టుబడి ఉంటారని ఖరారు చేస్తున్నారు.';

  @override
  String get onboardingAgreeToRiderAgreement => 'నేను రైడర్ ఒప్పందాన్ని చదివాను మరియు అంగీకరిస్తున్నాను';

  @override
  String get onboardingAnswered => 'సమాధానం ఇచ్చారు';

  @override
  String get onboardingApplicationSubmitted => 'దరఖాస్తు సమర్పించబడింది';

  @override
  String get onboardingAttached => 'జతచేయబడింది';

  @override
  String get onboardingBankAccount => 'బ్యాంకు ఖాతా';

  @override
  String get onboardingBankAccountNeeded => 'మీ ఖాతా నంబర్ ఎంటర్ చేసి, నిర్ధారించడానికి మళ్లీ టైప్ చేయండి.';

  @override
  String get onboardingBankAccountTooShort => 'ఈ ఖాతా నంబర్ చాలా చిన్నదిగా ఉంది.';

  @override
  String get onboardingBankBranch => 'శాఖ';

  @override
  String get onboardingBankCity => 'నగరం';

  @override
  String get onboardingBankIfsc => 'IFSC కోడ్';

  @override
  String get onboardingBankIfscFailed => 'ఇప్పుడు ఈ IFSC చెక్ చేయలేకపోయాం. కింద మీ బ్యాంకు వివరాలు నింపండి.';

  @override
  String get onboardingBankIfscHelper => '11 అక్షరాలు. ఇది మీ పాస్‌బుక్ లేదా చెక్‌పై ఉంటుంది.';

  @override
  String get onboardingBankIfscHint => 'ఉదా. SBIN0001234';

  @override
  String get onboardingBankIfscNotFound =>
      'ఈ IFSCకి బ్యాంకు కనిపించలేదు. కోడ్ చూడండి, లేదా కింద మీ బ్యాంకు వివరాలు నింపండి.';

  @override
  String get onboardingBankIfscPending => 'మీ IFSC ఎంటర్ చేసి, బ్యాంకు కనిపించే వరకు ఆగండి.';

  @override
  String get onboardingBankName => 'బ్యాంకు పేరు';

  @override
  String get onboardingBankProof => 'బ్యాంకు రుజువు (పాస్‌బుక్ లేదా రద్దు చేసిన చెక్)';

  @override
  String get onboardingBankState => 'రాష్ట్రం';

  @override
  String get onboardingCheckEverythingBeforeSubmitCan =>
      'సమర్పించే ముందు అన్నీ చూసుకోండి. ఏ దశనైనా ఇంకా మార్చుకోవచ్చు.';

  @override
  String get onboardingCouldNotLoadOnboarding => 'దరఖాస్తు తెరవలేకపోయాం';

  @override
  String get onboardingDateBirthNotValid => 'ఈ పుట్టిన తేదీ సరైనది కాదు';

  @override
  String get onboardingDocumentApproved => 'ఆమోదించబడింది';

  @override
  String get onboardingDocumentHasExpiredEnterDate => 'ఈ పత్రం గడువు ముగిసింది. ఈరోజు తర్వాతి తేదీ రాయండి.';

  @override
  String get onboardingDocumentInReview => 'అప్‌లోడ్ అయింది · పరిశీలనలో ఉంది';

  @override
  String get onboardingDocuments => 'పత్రాలు';

  @override
  String get onboardingEdit => 'మార్చండి';

  @override
  String onboardingEnterValidField(String field) {
    return 'సరైన $field రాయండి';
  }

  @override
  String get onboardingEveryStepHaveCompletedSaved =>
      'మీరు పూర్తి చేసిన ప్రతి దశ సేవ్ అయింది. తదుపరిసారి సైన్ ఇన్ చేసినప్పుడు అక్కడి నుంచే కొనసాగించవచ్చు.';

  @override
  String get onboardingExit => 'బయటకు వెళ్ళండి';

  @override
  String get onboardingExitOnboarding => 'దరఖాస్తు నుంచి బయటకు వెళ్ళాలా?';

  @override
  String onboardingFieldRequired(String field) {
    return '$field తప్పనిసరి';
  }

  @override
  String get onboardingGoOnboarding => 'దరఖాస్తుకు వెళ్ళండి';

  @override
  String get onboardingIntroGetStarted => 'ప్రారంభించండి';

  @override
  String get onboardingIntroNext => 'తర్వాత';

  @override
  String get onboardingLoadingOnboardingForm => 'మీ దరఖాస్తు తెరవబడుతోంది…';

  @override
  String get onboardingNoStepsConfigured =>
      'మీ ఫ్లీట్ ఆపరేటర్ ప్యాకేజీలో ఇంకా నమోదు దశలు ఏర్పాటు కాలేదు. వారితో రైడర్ నమోదు ఏర్పాటు చేయించి, ఆపై మళ్ళీ సైన్ ఇన్ చేయండి.';

  @override
  String get onboardingNothingFill => 'నింపడానికి ఏమీ లేదు';

  @override
  String get onboardingNothingFillStep => 'ఈ దశలో నింపడానికి ఏమీ లేదు.';

  @override
  String get onboardingNothingReviewYet => 'ఇంకా సమీక్షించడానికి ఏమీ లేదు';

  @override
  String get onboardingNothingToFillHere => 'ఇక్కడ నింపడానికి ఏమీ లేదు';

  @override
  String get onboardingNotProvided => 'ఇవ్వలేదు';

  @override
  String get onboardingPackage => 'ప్యాకేజీ';

  @override
  String get onboardingPleaseFixHighlightedFieldsBefore => 'కొనసాగించే ముందు గుర్తించిన గడులను సరిచేయండి';

  @override
  String get onboardingReferences => 'రిఫరెన్సులు';

  @override
  String get onboardingReferralApplied => 'వర్తించబడింది';

  @override
  String get onboardingReferralApply => 'వర్తించు';

  @override
  String get onboardingReferralCodeApplied => 'రెఫరల్ కోడ్ వర్తించబడింది';

  @override
  String get onboardingReferralFromInvite => 'మీ ఆహ్వాన లింక్ నుండి జోడించబడింది';

  @override
  String get onboardingReferralNotFound => 'దీనికి రెఫరల్ ఏదీ దొరకలేదు. కోడ్ లేదా మొబైల్ నంబర్‌ను తనిఖీ చేయండి.';

  @override
  String get onboardingReferralScan => 'రిఫరల్ QR స్కాన్ చేయండి';

  @override
  String get onboardingReferralTapApply => 'ఈ కోడ్ ఉపయోగించడానికి వర్తించు నొక్కండి, లేదా దాన్ని తీసివేయండి';

  @override
  String onboardingRejectedMessage(String documents) {
    return 'కొనసాగడానికి మళ్లీ అప్‌లోడ్ చేయండి: $documents';
  }

  @override
  String get onboardingRejectedTitle => 'పరిశీలనలో తిరస్కరించబడింది';

  @override
  String get onboardingReview => 'సమీక్షించండి';

  @override
  String get onboardingReviewApplication => 'దరఖాస్తును సమీక్షించండి';

  @override
  String get onboardingRiderOnboarding => 'రైడర్ నమోదు';

  @override
  String get onboardingSaving => 'సేవ్ అవుతోంది…';

  @override
  String get onboardingSignAgreementContinue => 'కొనసాగడానికి ఒప్పందంపై సంతకం చేయండి';

  @override
  String get onboardingSomeStepsStillIncompleteGo =>
      'కొన్ని దశలు ఇంకా అసంపూర్తిగా ఉన్నాయి. వెనక్కి వెళ్ళి పూర్తి చేయండి.';

  @override
  String get onboardingStartOnboardingSeeAnswersHere => 'మీ జవాబులు ఇక్కడ చూడటానికి దరఖాస్తు నింపడం మొదలుపెట్టండి.';

  @override
  String get onboardingStepAgreement => 'ఒప్పందం';

  @override
  String get onboardingStepEligibility => 'అర్హత';

  @override
  String get onboardingStepHandledByOperator => 'ఈ దశను మీ ఫ్లీట్ ఆపరేటర్ చూసుకుంటారు. తర్వాతిదానికి వెళ్ళండి.';

  @override
  String get onboardingStepTraining => 'శిక్షణ';

  @override
  String get onboardingSubmitApplication => 'దరఖాస్తు సమర్పించండి';

  @override
  String get onboardingTakePhotoDocumentChooseOne => 'పత్రం ఫోటో తీయండి, లేదా ఇప్పటికే ఉన్న ఫోటో ఎంచుకోండి';

  @override
  String get onboardingUploadRejectedAgain => 'సమర్పించే ముందు తిరస్కరించిన పత్రాలను మళ్లీ అప్‌లోడ్ చేయండి.';

  @override
  String get paymentRefundableDeposit => 'తిరిగి ఇచ్చే డిపాజిట్';

  @override
  String get paymentRentAndFees => 'అద్దె మరియు రుసుములు';

  @override
  String get paymentsAllClear => 'మీ చెల్లింపులన్నీ అయ్యాయి';

  @override
  String get paymentsAllClearMessage => 'ఇప్పుడు ఏమీ బకాయి లేదు. తదుపరిదానికి ముందు మేము చెబుతాము.';

  @override
  String get paymentsAmountDue => 'చెల్లించాల్సిన మొత్తం';

  @override
  String get paymentsAutoPay => 'ఆటో-డెబిట్';

  @override
  String get paymentsAutoPayActive => 'ఆన్';

  @override
  String get paymentsAutoPayAttention => 'ఆటో-డెబిట్‌కు శ్రద్ధ కావాలి. మళ్ళీ సెట్ చేయమని మీ ఫ్లీట్ మేనేజర్‌ను అడగండి.';

  @override
  String get paymentsAutoPayAuthPending => 'ఆమోదం కోసం వేచి ఉంది';

  @override
  String get paymentsAutoPayExpired => 'గడువు ముగిసింది';

  @override
  String get paymentsAutoPayFailed => 'విఫలమైంది';

  @override
  String get paymentsAutoPayNotEnabled => 'సెట్ చేయలేదు';

  @override
  String get paymentsAutoPayPaused => 'నిలిపివేశారు';

  @override
  String get paymentsAutoPayRevoked => 'రద్దు';

  @override
  String get paymentsAutoPaySetupRequired => 'సెటప్ కావాలి';

  @override
  String get paymentsBreakdown => 'వివరాలు';

  @override
  String get paymentsCouldNotLoad => 'చెల్లింపులు లోడ్ కాలేదు';

  @override
  String paymentsDueOnDate(String date) {
    return 'గడువు తేదీ: $date';
  }

  @override
  String get paymentsHistory => 'గత చెల్లింపులు';

  @override
  String get paymentsMandateExpires => 'మాండేట్ ముగుస్తుంది';

  @override
  String get paymentsMandateLimit => 'ప్రతి కోత పరిమితి';

  @override
  String get paymentsMethod => 'విధానం';

  @override
  String get paymentsNextDebit => 'తదుపరి కోత';

  @override
  String get paymentsNoPayments => 'ఇంకా చెల్లింపులు లేవు';

  @override
  String get paymentsNoPaymentsMessage => 'మీ చెల్లింపులు ఖరారైన తర్వాత ఇక్కడ కనిపిస్తాయి.';

  @override
  String get paymentsNothingDue => 'ఏమీ బకాయి లేదు';

  @override
  String get paymentsOverdue => 'గడువు దాటింది';

  @override
  String get paymentsPayAtHub => 'మీ హబ్‌లో చెల్లించండి, లేదా గడువు తేదీన ఆటో-డెబిట్ జరగనివ్వండి.';

  @override
  String get paymentsPayment => 'చెల్లింపు';

  @override
  String get paymentsSubtitle => 'బకాయిలు, ఆటో-డెబిట్ మరియు రసీదులు';

  @override
  String get paymentsTitle => 'చెల్లింపులు';

  @override
  String get pdiHintTyreWorn => 'ఉదా. ముందు టైరు పరిమితికి మించి అరిగింది';

  @override
  String pdiWorkPartner(String partner) {
    return 'పని భాగస్వామి: $partner';
  }

  @override
  String get planAccept => 'ప్లాన్ అంగీకరించండి';

  @override
  String get planAdvanceRental => 'ముందస్తు అద్దె';

  @override
  String get planBatteryDeposit => 'బ్యాటరీ సెక్యూరిటీ డిపాజిట్';

  @override
  String get planConsent => 'నేను ఈ ప్లాన్ చదివాను, దీనికి అంగీకరిస్తున్నాను';

  @override
  String get planCustom => 'కస్టమ్ ప్లాన్';

  @override
  String get planDaily => 'రోజువారీ ప్లాన్';

  @override
  String planDays(int count) {
    return '$count రోజుల ప్లాన్';
  }

  @override
  String get planDiscount => 'తగ్గింపు';

  @override
  String get planErrorAgreementMismatch => 'ఈ అద్దె ఈ స్కూటర్‌కు సరిపోలడం లేదు. మీ ఫ్లీట్ మేనేజర్‌ను సంప్రదించండి.';

  @override
  String get planErrorAgreementNotActive => 'మీ అద్దె ఇంకా యాక్టివ్ కాలేదు, కాబట్టి ఇది ఇప్పుడు చేయలేము.';

  @override
  String get planErrorAgreementNotReady =>
      'అంగీకరించిన ప్లాన్ హ్యాండోవర్‌కు సిద్ధంగా లేదు. రిఫ్రెష్ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get planErrorDepositNotConfigured =>
      'ఈ ప్లాన్‌కు స్కూటర్ సెక్యూరిటీ డిపాజిట్ సెట్ చేయలేదు. సున్నా అయినా దాన్ని జోడించమని మీ అడ్మిన్‌ను అడగండి.';

  @override
  String get planErrorExchangePlan => 'ఇది ఎక్స్ఛేంజ్ స్కూటర్, కాబట్టి దీని ప్లాన్ ఇప్పటికే అంగీకరించబడింది.';

  @override
  String get planErrorFeeNotConfigured =>
      'ఈ ప్లాన్‌కు ఆన్‌బోర్డింగ్ రుసుము సెట్ చేయలేదు. సున్నా అయినా దాన్ని జోడించమని మీ అడ్మిన్‌ను అడగండి.';

  @override
  String get planErrorFleetRequestRequired => 'చెల్లింపు అడిగే ముందు స్కూటర్ కోసం అభ్యర్థించండి.';

  @override
  String get planErrorOfferNotValid => 'ఈ ప్లాన్ ఆఫర్ ఇప్పుడు చెల్లదు. కొత్తది అడగండి.';

  @override
  String get planErrorPaymentReferenceRequired => 'రైడర్ ఇంకా చెల్లింపు రిఫరెన్స్ పంపలేదు.';

  @override
  String get planErrorPaymentStale => 'మొత్తం మారింది. రిఫ్రెష్ చేసి మళ్లీ చెల్లింపు అడగండి.';

  @override
  String get planErrorRequired => 'ముందుగా అద్దె ప్లాన్ ఎంచుకుని రైడర్ దాన్ని అంగీకరించేలా చేయండి.';

  @override
  String get planErrorSelectionChanged => 'ఇప్పుడే వేరే ప్లాన్ ఎంచుకోబడింది. రిఫ్రెష్ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get planErrorSelectionClosed => 'ప్లాన్‌ను ఇక మార్చలేరు.';

  @override
  String get planErrorTermsChanged => 'ప్లాన్ నిబంధనలు మారాయి. రిఫ్రెష్ చేసి మళ్లీ అంగీకరించండి.';

  @override
  String get planFortnightly => 'పక్షం ప్లాన్';

  @override
  String get planFree => 'ఉచితం';

  @override
  String get planIncluded => 'చేర్చబడినవి';

  @override
  String get planInsurance => 'బీమా';

  @override
  String get planMonthly => 'నెలవారీ ప్లాన్';

  @override
  String get planOfferNotLive => 'ఈ ఆఫర్ ఇప్పుడు తెరిచి లేదు. మీ ఫ్లీట్ మేనేజర్ కొత్తది పంపుతారు.';

  @override
  String get planOnboardingFee => 'ఆన్‌బోర్డింగ్ రుసుము';

  @override
  String get planPayableToday => 'ఈరోజు చెల్లించండి';

  @override
  String get planQuarterly => 'త్రైమాసిక ప్లాన్';

  @override
  String planRefundableNote(String amount) {
    return 'ఇందులో $amount తిరిగి ఇచ్చే డిపాజిట్ ఉంది';
  }

  @override
  String get planRent => 'అద్దె';

  @override
  String get planScooterAgeAdjustment => 'స్కూటర్ వయస్సు సర్దుబాటు';

  @override
  String get planScooterDeposit => 'స్కూటర్ సెక్యూరిటీ డిపాజిట్';

  @override
  String planUsageRate(String rate, String unit) {
    return 'ప్రతి $unitకు $rate';
  }

  @override
  String get planValidUntil => 'ఆఫర్ ఈ సమయం వరకు చెల్లుతుంది';

  @override
  String get planWeekly => 'వారపు ప్లాన్';

  @override
  String planWeeks(int count) {
    return '$count వారాల ప్లాన్';
  }

  @override
  String get profileHub => 'హబ్';

  @override
  String get profilePersonalDetails => 'వ్యక్తిగత వివరాలు';

  @override
  String get referActivity => 'కార్యాచరణ';

  @override
  String referCardReward(String amount) {
    return 'నా కోడ్‌తో చేరి $amount పొందండి';
  }

  @override
  String get referCodeCopied => 'రెఫరల్ కోడ్ కాపీ అయింది';

  @override
  String referCompleteBy(String date) {
    return 'వీటిని $date లోపు పూర్తి చేయండి';
  }

  @override
  String get referCopyCode => 'కోడ్ కాపీ చేయండి';

  @override
  String get referCopyMessage => 'ఆహ్వాన సందేశం కాపీ చేయండి';

  @override
  String get referCouldNotLoad => 'రెఫర్ & సంపాదించండి తెరవలేకపోయాం';

  @override
  String get referDetailTitle => 'రిఫరల్ వివరాలు';

  @override
  String get referDrawerHint =>
      'మీ కోడ్‌తో చేరడానికి స్నేహితులు దీన్ని స్కాన్ చేయవచ్చు. పెద్దదిగా చూడటానికి ట్యాప్ చేయండి.';

  @override
  String get referDrawerTitle => 'నా రిఫరల్ QR';

  @override
  String get referErrorAlreadyLinked => 'మీ ఖాతా ఇప్పటికే మరో రిఫరల్ కోడ్‌తో లింక్ అయింది.';

  @override
  String get referErrorCampaignInactive => 'రిఫర్ చేసి సంపాదించండి ప్రస్తుతం అందుబాటులో లేదు.';

  @override
  String get referErrorCodeExpired => 'ఈ ఆహ్వానం గడువు ముగిసింది. కొత్తది పంపమని మీ స్నేహితుడిని అడగండి.';

  @override
  String get referErrorLimit => 'ఈ రైడర్ రిఫరల్ పరిమితిని చేరుకున్నారు.';

  @override
  String get referErrorNotEligible => 'మీ రైడర్ ప్రొఫైల్ ఇంకా రిఫరల్‌లకు సిద్ధంగా లేదు.';

  @override
  String get referErrorNotEnabled => 'మీ కంపెనీకి రిఫర్ చేసి సంపాదించండి అందుబాటులో లేదు.';

  @override
  String get referErrorNotFound => 'రిఫరల్ కనుగొనబడలేదు.';

  @override
  String get referErrorSelf => 'మీ సొంత రిఫరల్ కోడ్ వాడలేరు.';

  @override
  String get referEventExpired => 'ఒక రిఫరల్ గడువు ముగిసింది';

  @override
  String get referEventOther => 'రిఫరల్ అప్‌డేట్';

  @override
  String get referEventProgress => 'ఒక రిఫరల్ ముందుకు సాగింది';

  @override
  String get referEventQualified => 'ఒక రిఫరల్ బహుమతికి అర్హత పొందింది';

  @override
  String get referEventRegistered => 'ఒక రైడర్ రిఫరల్ కోడ్‌తో చేరారు';

  @override
  String get referEventRewardPaid => 'ఒక రిఫరల్ బహుమతి చెల్లించబడింది';

  @override
  String get referFriendGets => 'మీ స్నేహితుడికి లభిస్తుంది';

  @override
  String get referHowItWorks => 'ఇది ఎలా పనిచేస్తుంది';

  @override
  String get referHowItWorksBody =>
      'మీ కోడ్ షేర్ చేయండి. మీ స్నేహితుడు చేరి ఈ దశలు పూర్తి చేసినప్పుడు రిఫరల్ బహుమతి వస్తుంది.';

  @override
  String get referInvited => 'ఆహ్వానించారు';

  @override
  String referInviteValidTill(String date) {
    return 'ఈ ఆహ్వానం $date వరకు చెల్లుబాటు';
  }

  @override
  String get referMessageCopied => 'ఆహ్వాన సందేశం కాపీ అయింది';

  @override
  String get referMilestoneActivated => 'రైడర్‌గా యాక్టివేట్ అవ్వండి';

  @override
  String referMilestoneActiveDays(String count) {
    return '$count రోజులు యాక్టివ్‌గా ఉండండి';
  }

  @override
  String referMilestoneAttendance(String count) {
    return '$count రోజులు హాజరు నమోదు చేయండి';
  }

  @override
  String referMilestoneDeliveries(String count) {
    return '$count డెలివరీలు పూర్తి చేయండి';
  }

  @override
  String get referMilestoneKyc => 'KYC పూర్తి చేయండి';

  @override
  String get referMilestoneOther => 'ప్రచార దశను పూర్తి చేయండి';

  @override
  String get referMilestonePayment => 'మొదటి చెల్లింపు చేయండి';

  @override
  String referMilestoneRides(String count) {
    return '$count రైడ్‌లు పూర్తి చేయండి';
  }

  @override
  String get referMilestoneTraining => 'శిక్షణ పూర్తి చేయండి';

  @override
  String get referMilestoneVehicle => 'స్కూటర్ కేటాయింపు పొందండి';

  @override
  String get referNoCampaignBody => 'కొత్త రివార్డుల కోసం త్వరలో మళ్ళీ చూడండి.';

  @override
  String get referNoCampaignTitle => 'ప్రస్తుతం రెఫరల్ క్యాంపెయిన్ లేదు';

  @override
  String get referNoReferralsBody => 'రైడర్లను ఆహ్వానించడానికి మీ కోడ్‌ను షేర్ చేయండి.';

  @override
  String get referNoReferralsTitle => 'ఇంకా రెఫరల్స్ లేవు';

  @override
  String get referPaid => 'చెల్లించారు';

  @override
  String get referPending => 'పెండింగ్';

  @override
  String get referProgress => 'పురోగతి';

  @override
  String get referQrSemantics => 'రిఫరల్ QR కోడ్';

  @override
  String get referQualified => 'అర్హత పొందారు';

  @override
  String get referRegistered => 'నమోదయ్యారు';

  @override
  String get referRewardEarned => 'సంపాదించారు';

  @override
  String get referRewardPending => 'పెండింగ్';

  @override
  String get referRewardProcessing => 'ప్రాసెస్ అవుతోంది';

  @override
  String get referRewardReversed => 'వెనక్కి తీసుకోబడింది';

  @override
  String get referRewards => 'బహుమతులు';

  @override
  String get referScanCameraFailed => 'కెమెరా ప్రారంభం కాలేదు. మళ్లీ ప్రయత్నించండి, లేదా QR కోడ్ ఫోటోను ఎంచుకోండి.';

  @override
  String referScanFound(String code) {
    return '$code కోడ్ దొరికింది';
  }

  @override
  String get referScanFromPhotos => 'ఫోటోల నుండి ఎంచుకోండి';

  @override
  String get referScanHint => 'కెమెరాను రిఫరల్ QR కోడ్ వైపు చూపండి';

  @override
  String get referScanNoCamera => 'ఈ పరికరంలో స్కాన్ చేయడానికి కెమెరా లేదు. బదులుగా QR కోడ్ ఫోటోను ఎంచుకోండి.';

  @override
  String get referScanNoQrInPhoto => 'ఆ ఫోటోలో QR కోడ్ కనిపించలేదు.';

  @override
  String get referScanNotReferral => 'ఆ QR కోడ్ రిఫరల్ కోడ్ కాదు.';

  @override
  String get referScanPermissionDenied =>
      'కెమెరా అనుమతి ఆఫ్‌లో ఉంది. స్కాన్ చేయడానికి సెట్టింగ్స్‌లో అనుమతించండి, లేదా QR కోడ్ ఫోటోను ఎంచుకోండి.';

  @override
  String get referScanTitle => 'రిఫరల్ QR స్కాన్ చేయండి';

  @override
  String get referScanToJoin => 'నా రిఫరల్ కోడ్‌తో చేరడానికి స్కాన్ చేయండి';

  @override
  String referShareAndroid(String link) {
    return 'Androidలో యాప్ పొందండి: $link';
  }

  @override
  String referShareCodeLine(String code) {
    return 'సైన్ అప్ చేసేటప్పుడు నా రిఫరల్ కోడ్ $code వాడండి.';
  }

  @override
  String referShareIntro(String app) {
    return '$appలో రైడర్‌గా నాతో చేరండి!';
  }

  @override
  String get referShareInvite => 'ఆహ్వానాన్ని షేర్ చేయండి';

  @override
  String referShareIphone(String link) {
    return 'iPhoneలో యాప్ పొందండి: $link';
  }

  @override
  String get referShareNow => 'షేర్ చేయండి';

  @override
  String referShareReward(String amount) {
    return 'చేరే దశలు పూర్తి చేసినప్పుడు మీకు $amount వస్తుంది.';
  }

  @override
  String get referShareSubtitle => 'మీ స్నేహితుడు QR స్కాన్ చేసి లేదా లింక్‌తో చేరవచ్చు.';

  @override
  String get referShareTitle => 'మీ ఆహ్వానం షేర్ చేయండి';

  @override
  String get referShowQr => 'QR చూపించు';

  @override
  String get referStatusActivated => 'యాక్టివేట్ అయింది';

  @override
  String get referStatusCancelled => 'రద్దు చేశారు';

  @override
  String get referStatusDisqualified => 'అనర్హత';

  @override
  String get referStatusExpired => 'గడువు ముగిసింది';

  @override
  String get referStatusInProgress => 'ప్రోగ్రెస్‌లో ఉంది';

  @override
  String get referStatusKycVerified => 'KYC ధృవీకరించబడింది';

  @override
  String get referStatusPaid => 'రివార్డ్ చెల్లించారు';

  @override
  String get referStatusRejected => 'తిరస్కరించారు';

  @override
  String get referStatusRewardApproved => 'రివార్డ్ ఆమోదించబడింది';

  @override
  String get referStatusRewardPending => 'రివార్డ్ పెండింగ్';

  @override
  String get referStatusUnderReview => 'సమీక్షలో ఉంది';

  @override
  String referStepsDone(int done, int total) {
    return '$done/$total దశలు';
  }

  @override
  String get referSubtitle => 'రైడర్లను ఆహ్వానించి రివార్డులు పొందండి';

  @override
  String get referTimeline => 'కాలక్రమం';

  @override
  String get referTotalEarned => 'మొత్తం సంపాదన';

  @override
  String referValidTill(String date) {
    return '$date వరకు చెల్లుతుంది';
  }

  @override
  String get referYouGet => 'మీకు లభిస్తుంది';

  @override
  String get referYourCode => 'మీ రెఫరల్ కోడ్';

  @override
  String get referYourQr => 'మీ రిఫరల్ QR';

  @override
  String get referYourQrSubtitle => 'యాప్ ఆన్‌బోర్డింగ్‌లో దీన్ని స్కాన్ చేయమని మీ స్నేహితుడికి చెప్పండి.';

  @override
  String get referYourReferrals => 'మీ రెఫరల్స్';

  @override
  String get rentalsAutoDebit => 'ఆటో-డెబిట్';

  @override
  String get rentalsAutoDebitKeepsEveryCycle =>
      'ఆటో-డెబిట్‌తో ప్రతిసారీ సమయానికి చెల్లింపు జరుగుతుంది, మీరే పంపనవసరం లేదు';

  @override
  String get rentalsBillingPeriod => 'బిల్లు కాలం';

  @override
  String get rentalsBills => 'బిల్లులు';

  @override
  String get rentalsCouldNotLoadBill => 'ఈ బిల్లును లోడ్ చేయలేకపోయాం';

  @override
  String get rentalsCouldNotLoadLedger => 'మీ లెడ్జర్‌ను లోడ్ చేయలేకపోయాం';

  @override
  String get rentalsCouldNotLoadPayments => 'మీ చెల్లింపులను లోడ్ చేయలేకపోయాం';

  @override
  String get rentalsCouldNotLoadRentPlan => 'మీ అద్దె ప్లాన్ తెరవలేకపోయాం';

  @override
  String get rentalsCredit => 'అందుబాటులో ఉన్న క్రెడిట్';

  @override
  String get rentalsCreditsApplied => 'వర్తించిన క్రెడిట్';

  @override
  String get rentalsCurrentPlan => 'ప్రస్తుత ప్లాన్';

  @override
  String get rentalsDepositHeld => 'ఉంచిన డిపాజిట్';

  @override
  String get rentalsDue => 'చెల్లింపు తేదీ';

  @override
  String get rentalsDueLater => 'తర్వాత చెల్లించాలి';

  @override
  String get rentalsFromWallet => 'మీ వాలెట్ నుండి';

  @override
  String get rentalsInvoiceHistory => 'బిల్లు చరిత్ర';

  @override
  String get rentalsLedger => 'లెడ్జర్';

  @override
  String get rentalsLedgerAdjustment => 'సర్దుబాటు';

  @override
  String get rentalsLedgerCharge => 'ఛార్జీ';

  @override
  String get rentalsLedgerCredit => 'క్రెడిట్';

  @override
  String get rentalsLedgerDeposit => 'డిపాజిట్';

  @override
  String get rentalsLedgerHint => 'మీ ఖాతాలోని ప్రతి ఛార్జీ, చెల్లింపు, క్రెడిట్, కొత్తవి ముందు.';

  @override
  String get rentalsLedgerPayment => 'చెల్లింపు';

  @override
  String get rentalsLedgerRefund => 'రీఫండ్';

  @override
  String get rentalsLedgerReversal => 'రివర్సల్';

  @override
  String get rentalsNoInvoicesYet => 'ఇంకా బిల్లులు లేవు';

  @override
  String get rentalsNoLedger => 'మీ లెడ్జర్‌లో ఇంకా ఏమీ లేదు';

  @override
  String get rentalsNoLedgerBody => 'ఛార్జీలు, చెల్లింపులు జరిగినప్పుడు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get rentalsNoPayments => 'ఇంకా చెల్లింపులు లేవు';

  @override
  String get rentalsNoPaymentsBody => 'మీ బిల్లుల కోసం చేసే చెల్లింపులు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get rentalsOutstanding => 'బకాయి';

  @override
  String rentalsOverdueNotice(String amount) {
    return '$amount గడువు దాటింది. అంతరాయం లేకుండా నడపడానికి త్వరగా చెల్లించండి.';
  }

  @override
  String get rentalsPaid => 'చెల్లించారు';

  @override
  String get rentalsPaid2 => 'చెల్లింపు తేదీ';

  @override
  String get rentalsPaidSoFar => 'ఇప్పటి వరకు చెల్లించింది';

  @override
  String get rentalsPayments => 'చెల్లింపులు';

  @override
  String rentalsReceiptInvoices(int count) {
    return '$count బిల్లు(లు) చెల్లించారు';
  }

  @override
  String rentalsRefunded(String amount) {
    return '$amount రీఫండ్ చేశారు';
  }

  @override
  String get rentalsRentals => 'అద్దె';

  @override
  String get rentalsRentHandledAutomatically => 'అద్దె, దానంతట అదే కోత అవుతుంది';

  @override
  String get rentalsRentReceipt => 'అద్దె రసీదు';

  @override
  String get rentalsRentReceiptsWillAppearHere => 'మీ అద్దె రసీదులు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get rentalsStatusDraft => 'డ్రాఫ్ట్';

  @override
  String get rentalsStatusDue => 'చెల్లించాలి';

  @override
  String get rentalsStatusOverdue => 'గడువు దాటింది';

  @override
  String get rentalsStatusPartlyPaid => 'పాక్షికంగా చెల్లించారు';

  @override
  String get rentalsStatusVoid => 'రద్దు';

  @override
  String get rentalsStillDue => 'ఇంకా బకాయి';

  @override
  String get rentalsSubtitle => 'మీ ప్లాన్, బిల్లులు, ఖాతా చరిత్ర';

  @override
  String get rentalsSubtotal => 'ఉపమొత్తం';

  @override
  String get rentalsTapReceiptSeeFullBreakdown => 'పూర్తి వివరం చూడటానికి రసీదును నొక్కండి';

  @override
  String get rentalsTax => 'పన్ను';

  @override
  String get rentalsUnallocated => 'ఇంకా వర్తించని చెల్లింపులు';

  @override
  String get rentalsYourAccount => 'మీ ఖాతా';

  @override
  String get reportStatusMechanicallyOk => 'మెకానికల్‌గా సరిగా ఉంది';

  @override
  String get reportStatusReadyForAllotment => 'కేటాయింపుకు సిద్ధం';

  @override
  String get reportStatusUnderRepairMajor => 'రిపేర్‌లో: పెద్దది';

  @override
  String get reportStatusUnderRepairMinor => 'రిపేర్‌లో: చిన్నది';

  @override
  String get returnsApproveCharges => 'ఛార్జీలను ఆమోదించండి';

  @override
  String returnsApproveSubtitle(String amount) {
    return 'మీ ఫోన్‌కు 6 అంకెల కోడ్ పంపాం. దాన్ని నమోదు చేస్తే $amount ఛార్జీలు ఆమోదించబడతాయి.';
  }

  @override
  String get returnsApproveTitle => 'కోడ్ నమోదు చేయండి';

  @override
  String get returnsCancel => 'రిటర్న్ రద్దు చేయండి';

  @override
  String get returnsCancelBody => 'స్కూటర్ మీ దగ్గరే ఉంటుంది, అద్దె ఎప్పటిలాగే కొనసాగుతుంది.';

  @override
  String get returnsCancelled => 'రిటర్న్ రద్దయింది';

  @override
  String get returnsCancelTitle => 'ఈ రిటర్న్‌ను రద్దు చేయాలా?';

  @override
  String get returnsCharges => 'ఛార్జీలు';

  @override
  String get returnsChargesApproved => 'ఛార్జీలు ఆమోదించబడ్డాయి';

  @override
  String get returnsChargesPending => 'హబ్ ఇంకా స్కూటర్‌ను తనిఖీ చేస్తోంది. ఛార్జీలు ఉంటే ఇక్కడ కనిపిస్తాయి.';

  @override
  String get returnsCodeExpired => 'ఆ కోడ్ గడువు ముగిసింది. కొత్తది అడగండి.';

  @override
  String get returnsCodeInvalid => 'ఆ కోడ్ పనిచేయలేదు. తనిఖీ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get returnsCouldNotLoad => 'మీ రిటర్న్‌లను లోడ్ చేయలేకపోయాం';

  @override
  String get returnsCouldNotLoadHubs => 'హబ్‌లను లోడ్ చేయలేకపోయాం';

  @override
  String get returnsDate => 'తిరిగి ఇచ్చే తేదీ';

  @override
  String get returnsDetails => 'వివరాలు';

  @override
  String get returnsDetailTitle => 'రిటర్న్';

  @override
  String get returnsDisputeCharges => 'ఛార్జీలపై అభ్యంతరం';

  @override
  String get returnsDisputeReason => 'ఏమి తప్పు?';

  @override
  String get returnsDisputeReasonRequired => 'హబ్ బృందం సమీక్షించడానికి కారణం జోడించండి.';

  @override
  String get returnsDisputeSent => 'అభ్యంతరం హబ్ బృందానికి పంపబడింది';

  @override
  String get returnsDisputeSubtitle => 'ఈ ఛార్జీలలో ఏమి తప్పు ఉందో హబ్ బృందానికి చెప్పండి.';

  @override
  String get returnsEndRentalBody =>
      'దాన్ని ఎప్పుడు, ఎక్కడ తిరిగి ఇస్తారో చెప్పండి. హబ్ బృందం దాన్ని తనిఖీ చేస్తుంది, ఏవైనా ఛార్జీలు ముందుగా మీ ఆమోదానికి వస్తాయి.';

  @override
  String get returnsEndRentalTitle => 'స్కూటర్ ఇక అవసరం లేదా?';

  @override
  String get returnsErrorAlreadyReceived => 'ఈ స్కూటర్‌ను ఇప్పటికే స్వీకరించారు.';

  @override
  String get returnsErrorAlreadyRequested => 'ఈ అద్దెకు ఇప్పటికే తిరిగి ఇచ్చే అభ్యర్థన ఉంది.';

  @override
  String get returnsErrorApprovalNotPending => 'ఈ జరిమానాలు మీ ఆమోదం కోసం వేచి లేవు.';

  @override
  String get returnsErrorBeforeAgreement => 'రిటర్న్ సమయం అద్దె మొదలవడానికి ముందుది.';

  @override
  String get returnsErrorInspectFirst => 'జరిమానాలు జోడించే ముందు రిటర్న్ తనిఖీ పూర్తి చేయండి.';

  @override
  String get returnsErrorNotCancellable => 'ఈ రిటర్న్‌ను ఇక రద్దు చేయలేరు.';

  @override
  String get returnsErrorNotDisputable => 'ఈ జరిమానాలపై ఇప్పుడు అభ్యంతరం చెప్పలేరు.';

  @override
  String get returnsErrorNotReceivable => 'ఈ రిటర్న్ రద్దయింది, కాబట్టి దీనిపై స్కూటర్‌ను స్వీకరించలేరు.';

  @override
  String get returnsErrorNotSubmittable => 'ఈ జరిమానాలను ఇప్పుడు సమర్పించలేరు.';

  @override
  String get returnsErrorNotTerminable => 'ఈ అద్దెను ఇప్పుడు తిరిగి ఇవ్వలేరు.';

  @override
  String get returnsErrorOverrideNotAllowed => 'ఈ దశలో రైడర్ ఆమోదాన్ని ఓవర్‌రైడ్ చేయలేరు.';

  @override
  String get returnsErrorPenaltiesLocked => 'రైడర్ వద్ద ఉన్నప్పుడు లేదా ఛార్జ్ చేసిన తర్వాత జరిమానాలను మార్చలేరు.';

  @override
  String get returnsErrorReceiveFirst => 'జరిమానాలు జోడించే ముందు స్కూటర్‌ను స్వీకరించండి.';

  @override
  String get returnsErrorRevisePenalties => 'రైడర్ ఈ జరిమానాలపై అభ్యంతరం చెప్పారు. జాబితాను సవరించి మళ్లీ సమర్పించండి.';

  @override
  String get returnsErrorStateChanged => 'ఈ జరిమానాలు ఇప్పుడే మారాయి. రిఫ్రెష్ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get returnsErrorSubmitFirst => 'ఆమోదించే ముందు జరిమానాలను సమర్పించండి.';

  @override
  String returnsEvidenceCount(int count) {
    return 'ఆధారంగా $count ఫోటో(లు)';
  }

  @override
  String get returnsHandedOver => 'అప్పగించారు';

  @override
  String get returnsHub => 'రిటర్న్ హబ్';

  @override
  String get returnsKindDamage => 'నష్టం';

  @override
  String get returnsKindMissing => 'తప్పిపోయిన వస్తువు';

  @override
  String get returnsLocationForHubs => 'మీకు దగ్గరలోని హబ్‌లను చూపించడానికి మీ లొకేషన్‌ను ఉపయోగిస్తాం.';

  @override
  String get returnsNextCheckIn => 'హబ్ బృందం స్కూటర్ ఫోటోలు తీస్తుంది, మెకానిక్ దాన్ని తనిఖీ చేస్తారు.';

  @override
  String get returnsNextConfirm =>
      'రిపోర్ట్‌ను, ఏవైనా ఛార్జీలను నిర్ధారించడానికి మీ ఫోన్‌కు కోడ్ వస్తుంది. నిర్ధారించిన వెంటనే మీ అద్దె ముగుస్తుంది.';

  @override
  String get returnsNextHandOver => 'ఎంచుకున్న తేదీన స్కూటర్, దాని బ్యాటరీ, ఛార్జర్‌ను హబ్‌కు తీసుకురండి.';

  @override
  String get returnsNoCharges => 'ఈ రిటర్న్‌కు ఛార్జీలు లేవు.';

  @override
  String get returnsNoHubsNearby => 'మీ దగ్గర హబ్‌లు కనిపించలేదు';

  @override
  String get returnsNone => 'ఇంకా రిటర్న్‌లు లేవు';

  @override
  String get returnsNoneBody => 'మీరు స్కూటర్‌ను తిరిగి ఇచ్చినప్పుడు, దాని స్థితిని ఇక్కడ చూడవచ్చు.';

  @override
  String get returnsNoteAdminApproved =>
      'మీ తరఫున ఒక అడ్మిన్ ఈ ఛార్జీలను ఆమోదించారు. తర్వాత హబ్ మేనేజర్ నిర్ధారిస్తారు. మీరు ఇంకా అభ్యంతరం చెప్పవచ్చు.';

  @override
  String get returnsNoteCancelled => 'మీరు ఈ రిటర్న్‌ను రద్దు చేశారు. మీ అద్దె ఎప్పటిలాగే కొనసాగుతుంది.';

  @override
  String get returnsNoteCheckInDone => 'రిటర్న్ పూర్తయింది. ఏవైనా ఛార్జీలు కింద ఉన్న సబ్మిషన్ రిపోర్ట్‌లో కనిపిస్తాయి.';

  @override
  String get returnsNoteCheckingIn =>
      'హబ్ బృందం మీ స్కూటర్‌ను తనిఖీ చేస్తోంది. మెకానిక్ రిపోర్ట్ సిద్ధమైనప్పుడు దాన్ని నిర్ధారించడానికి మీ ఫోన్‌కు కోడ్ వస్తుంది.';

  @override
  String get returnsNoteDisputed => 'మీరు ఈ ఛార్జీలపై అభ్యంతరం చెప్పారు. హబ్ బృందం వాటిని సమీక్షించి సవరించవచ్చు.';

  @override
  String get returnsNoteFinalChecks =>
      'మీ స్కూటర్ సబ్మిషన్ పూర్తయింది, మీ అద్దె ముగిసింది. మెకానిక్ చివరి తనిఖీ చేస్తున్నారు, ఇంకేమైనా దొరికితే మిమ్మల్ని నిర్ధారించమని అడుగుతారు.';

  @override
  String get returnsNoteInspecting =>
      'మీ స్కూటర్ హబ్‌లో ఉంది, తనిఖీ జరుగుతోంది. ఏవైనా ఛార్జీలు మీ ఆమోదం కోసం ఇక్కడ కనిపిస్తాయి.';

  @override
  String get returnsNoteNeedsYou =>
      'హబ్ కింది ఛార్జీలను గుర్తించింది. మీ ఫోన్‌కు పంపే కోడ్‌తో వాటిని ఆమోదించండి, లేదా అభ్యంతరం చెప్పండి.';

  @override
  String get returnsNoteNoCharges => 'రిటర్న్ పూర్తయింది. స్కూటర్ బాగానే తిరిగి వచ్చింది, కాబట్టి ఛార్జీలు లేవు.';

  @override
  String returnsNoteRequested(String date) {
    return '$date న స్కూటర్‌ను ఎంచుకున్న హబ్‌కు తీసుకెళ్లండి. హబ్ బృందం సబ్మిషన్ ప్రారంభిస్తుంది.';
  }

  @override
  String get returnsNotes => 'ఇంకేమైనా?';

  @override
  String returnsNoteSettled(String amount) {
    return 'రిటర్న్ పూర్తయింది. $amount ఛార్జీలు మీ బిల్లులో చేర్చబడ్డాయి.';
  }

  @override
  String get returnsNotesHint => 'హబ్ బృందం కోసం ఐచ్ఛిక గమనిక';

  @override
  String get returnsNoteYouApproved => 'మీరు ఛార్జీలను ఆమోదించారు. తర్వాత హబ్ మేనేజర్ వాటిని నిర్ధారిస్తారు.';

  @override
  String get returnsNothingToReturn => 'ప్రస్తుతం తిరిగి ఇవ్వాల్సింది ఏమీ లేదు';

  @override
  String get returnsNothingToReturnBody => 'మీకు యాక్టివ్ అద్దె లేదు, లేదా దాని రిటర్న్ ఇప్పటికే జరుగుతోంది.';

  @override
  String get returnsPickDate => 'తిరిగి ఇచ్చే తేదీని ఎంచుకోండి';

  @override
  String get returnsPickHub => 'హబ్‌ను ఎంచుకోండి';

  @override
  String get returnsPickHubSubtitle => 'మీకు దగ్గరలోని హబ్‌లు పైన ఉన్నాయి';

  @override
  String get returnsPickReason => 'ఒక కారణాన్ని ఎంచుకోండి';

  @override
  String returnsPlannedFor(String date) {
    return '$date కి ప్లాన్ చేశారు';
  }

  @override
  String get returnsProgress => 'పురోగతి';

  @override
  String get returnsReason => 'కారణం';

  @override
  String get returnsReasonBatteryIssues => 'బ్యాటరీ లేదా ఛార్జింగ్ సమస్యలు';

  @override
  String get returnsReasonChangingJob => 'ఉద్యోగం మారుతున్నాను';

  @override
  String get returnsReasonHealthOrFamily => 'ఆరోగ్య లేదా కుటుంబ కారణాలు';

  @override
  String get returnsReasonLowEarnings => 'తగినంత సంపాదన రావడం లేదు';

  @override
  String get returnsReasonNoLongerNeeded => 'ఇక ఇది అవసరం లేదు';

  @override
  String get returnsReasonOwnVehicle => 'నా సొంత వాహనం కొన్నాను';

  @override
  String get returnsReasonRelocating => 'వేరే నగరానికి వెళ్తున్నాను';

  @override
  String get returnsReasonServiceIssues => 'సేవతో సంతృప్తిగా లేను';

  @override
  String get returnsReasonTakingBreak => 'పని నుండి కొంత విరామం తీసుకుంటున్నాను';

  @override
  String get returnsReasonTooExpensive => 'అద్దె చాలా ఎక్కువ';

  @override
  String get returnsReasonVehicleIssues => 'స్కూటర్‌తో సమస్యలు';

  @override
  String get returnsRequested => 'రిటర్న్ అభ్యర్థన నమోదైంది. హబ్‌లో కలుద్దాం.';

  @override
  String get returnsRequestReturn => 'రిటర్న్ కోసం అభ్యర్థించండి';

  @override
  String get returnsRequestSubtitle => 'తేదీని, మీరు తీసుకువచ్చే హబ్‌ను ఎంచుకోండి';

  @override
  String get returnsSendDispute => 'అభ్యంతరం పంపండి';

  @override
  String get returnsStatusAwaitingManager => 'హబ్ మేనేజర్ వద్ద';

  @override
  String get returnsStatusCancelled => 'రద్దు చేశారు';

  @override
  String get returnsStatusCheckingIn => 'సబ్మిషన్ జరుగుతోంది';

  @override
  String get returnsStatusClosed => 'ముగిసింది';

  @override
  String get returnsStatusDisputed => 'వివాదంలో ఉంది';

  @override
  String get returnsStatusFinalChecks => 'చివరి తనిఖీలు';

  @override
  String get returnsStatusInspecting => 'తనిఖీ జరుగుతోంది';

  @override
  String get returnsStatusNeedsYou => 'మీ ఆమోదం అవసరం';

  @override
  String get returnsStatusRequested => 'రిటర్న్ అభ్యర్థించారు';

  @override
  String get returnsStepCheckIn => 'స్కూటర్ సబ్మిట్ అయింది';

  @override
  String get returnsStepClosed => 'రిటర్న్ పూర్తి';

  @override
  String get returnsStepFinalChecks => 'చివరి మెకానిక్ తనిఖీ';

  @override
  String get returnsStepHandedOver => 'స్కూటర్ అప్పగింత';

  @override
  String get returnsStepInspection => 'తనిఖీ, ఛార్జీలు';

  @override
  String get returnsStepRequested => 'రిటర్న్ అభ్యర్థన';

  @override
  String get returnsSubtitle => 'మీ అద్దె ముగించి స్కూటర్‌ను తిరిగి ఇవ్వండి';

  @override
  String get returnsTitle => 'స్కూటర్ తిరిగి ఇవ్వండి';

  @override
  String get returnsWhenWhere => 'ఎప్పుడు, ఎక్కడ';

  @override
  String get returnsWhy => 'మీరు దీన్ని ఎందుకు తిరిగి ఇస్తున్నారు?';

  @override
  String get returnsYourDispute => 'మీ అభ్యంతరం';

  @override
  String get returnsYourReturns => 'మీ రిటర్న్‌లు';

  @override
  String get rideParkedLocked => 'నిలిపి తాళం వేయబడింది.';

  @override
  String get rideRideSafeHelmetLightsChecked => 'జాగ్రత్తగా నడపండి. హెల్మెట్ పెట్టుకోండి, లైట్లు చూసుకోండి.';

  @override
  String get ridersActive => 'చురుకుగా';

  @override
  String get ridersCall => 'కాల్ చేయండి';

  @override
  String get ridersExited => 'వదిలేశారు';

  @override
  String get ridersOnboarding => 'నమోదు ప్రక్రియ';

  @override
  String get ridersTeam => 'బృందం';

  @override
  String get rideScooterConnectedUsePowerButton => 'మీ స్కూటర్ జత అయింది. ఆన్ చేయడానికి పవర్ బటన్ నొక్కండి.';

  @override
  String get rideVehicle => 'వాహనం ఆన్‌లో ఉంది';

  @override
  String get rideVehicleOff => 'వాహనం ఆఫ్‌లో ఉంది';

  @override
  String routerNoScreenAt(String location) {
    return '$location వద్ద ఏ స్క్రీన్ లేదు';
  }

  @override
  String get scooterAllowedFromHub => 'హబ్ నుంచి అనుమతి';

  @override
  String get scooterBatteryCharge => 'బ్యాటరీ చార్జ్';

  @override
  String get scooterBatterySerial => 'బ్యాటరీ సీరియల్';

  @override
  String get scooterBatteryType => 'బ్యాటరీ రకం';

  @override
  String get scooterCharging => 'చార్జింగ్';

  @override
  String get scooterClusterManager => 'క్లస్టర్ మేనేజర్';

  @override
  String get scooterControllerNumber => 'కంట్రోలర్ నంబర్';

  @override
  String get scooterCouldNotLoadVehicle => 'మీ వాహన వివరాలు తెరవలేకపోయాం';

  @override
  String get scooterDeliveryBox => 'డెలివరీ బాక్స్';

  @override
  String get scooterHealth => 'స్థితి';

  @override
  String get scooterHelmet => 'హెల్మెట్';

  @override
  String get scooterIdentity => 'గుర్తింపు';

  @override
  String get scooterMotorNumber => 'మోటార్ నంబర్';

  @override
  String get scooterNextService => 'తదుపరి సర్వీస్';

  @override
  String get scooterNoScooterHasBeenAllocated => 'మీకు ఇంకా స్కూటర్ కేటాయించలేదు.';

  @override
  String get scooterNoScooterMessage =>
      'మీ ఫ్లీట్ మేనేజర్ మీకు స్కూటర్ కేటాయించినప్పుడు, దాని వివరాలు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get scooterNoScooterTitle => 'ప్రస్తుతం స్కూటర్ లేదు';

  @override
  String get scooterOdometerService => 'ఓడోమీటర్ మరియు సర్వీస్';

  @override
  String get scooterParked => 'నిలిపిన చోటు';

  @override
  String get scooterPowertrain => 'పవర్‌ట్రెయిన్';

  @override
  String get scooterRange => 'పరిధి';

  @override
  String get scooterVehicleDetails => 'వాహన వివరాలు';

  @override
  String get scooterVehicleNumber => 'వాహన నంబర్';

  @override
  String get scooterViewFullDetails => 'పూర్తి వివరాలు చూడండి';

  @override
  String get scooterWhereBelongs => 'ఇది ఎక్కడిది';

  @override
  String get scooterWhoLooksAfter => 'మిమ్మల్ని ఎవరు చూసుకుంటారు';

  @override
  String get submissionAddDamagedItem => 'దెబ్బతిన్న భాగం జోడించండి';

  @override
  String get submissionBypass => 'కోడ్ వాడలేకపోతున్నారా?';

  @override
  String get submissionBypassing => 'కోడ్ దాటవేస్తున్నారు';

  @override
  String get submissionBypassReason => 'వారు కోడ్‌తో ఎందుకు నిర్ధారించలేకపోతున్నారు?';

  @override
  String submissionBypassRider(String reason) {
    return 'రైడర్ కోడ్ దాటవేశారు: $reason';
  }

  @override
  String submissionBypassTeamLead(String reason) {
    return 'టీమ్ లీడ్ కోడ్ దాటవేశారు: $reason';
  }

  @override
  String submissionCancelledBecause(String reason) {
    return 'రద్దు: $reason';
  }

  @override
  String get submissionCancelReason => 'కారణం';

  @override
  String get submissionCancelReasonNeeded => 'రిపోర్ట్ రద్దుకు కారణం నమోదు చేయండి.';

  @override
  String get submissionCancelReport => 'రిపోర్ట్ రద్దు చేయండి';

  @override
  String get submissionCancelReportHint => 'కారణం చెప్పండి. తర్వాత కొత్త రిపోర్ట్ నమోదు చేయవచ్చు.';

  @override
  String get submissionCancelReportTitle => 'ఈ రిపోర్ట్‌ను రద్దు చేయాలా?';

  @override
  String get submissionCharges => 'ఛార్జీలు';

  @override
  String get submissionChassis => 'ఛాసిస్';

  @override
  String get submissionChecksComplete => 'అన్ని మెకానిక్ తనిఖీలు పూర్తయ్యాయి';

  @override
  String get submissionChooseSparePart => 'దెబ్బతిన్న భాగాన్ని ఎంచుకోండి';

  @override
  String get submissionChooseSparePartHint => 'ధరలు మీ స్పేర్ పార్ట్స్ జాబితా నుండి వస్తాయి.';

  @override
  String get submissionCodeNotSent => 'కోడ్ పంపలేకపోయాం. మళ్లీ ప్రయత్నించండి లేదా కారణం నమోదు చేయండి.';

  @override
  String get submissionCodePending => 'ఇంకా కోడ్ లేదు';

  @override
  String get submissionCodeSent => 'కోడ్ పంపబడింది';

  @override
  String submissionCodeSentTo(String phone) {
    return '$phoneకు కోడ్ పంపబడింది';
  }

  @override
  String get submissionCodesSent => 'కోడ్‌లు పంపబడ్డాయి';

  @override
  String get submissionCollect => 'నిర్ధారణలు తీసుకోండి';

  @override
  String get submissionConfirm => 'రిపోర్ట్ నిర్ధారించండి';

  @override
  String get submissionConfirmed => 'రిపోర్ట్ నిర్ధారించబడింది';

  @override
  String get submissionConfirmHint =>
      'రైడర్‌కు, టీమ్ లీడ్‌కు ఒక్కొక్కరికి SMS ద్వారా కోడ్ వస్తుంది. నిర్ధారించడానికి రెండు కోడ్‌లు నమోదు చేయండి. ఎవరైనా కోడ్ వాడలేకపోతే, కారణం నమోదు చేయండి.';

  @override
  String get submissionConfirmTitle => 'రిపోర్ట్ నిర్ధారణ';

  @override
  String get submissionCouldNotLoad => 'ఈ సబ్మిషన్ లోడ్ కాలేదు';

  @override
  String get submissionCouldNotLoadParts => 'స్పేర్ పార్ట్స్ లోడ్ కాలేదు';

  @override
  String get submissionDamagedItems => 'దెబ్బతిన్న భాగాలు';

  @override
  String get submissionDamagedItemsHint =>
      'స్పేర్ పార్ట్స్ జాబితా నుండి ప్రతి దెబ్బతిన్న భాగాన్ని జోడించండి. దాని ధర ఆటోమేటిక్‌గా వస్తుంది.';

  @override
  String get submissionEvidence => 'ఆధార ఫోటోలు';

  @override
  String get submissionEvidenceHint => 'ఈ రిపోర్ట్‌కు ఆధారమైన ఫోటోలను ఎంచుకోండి.';

  @override
  String submissionEvidenceLimit(int count) {
    return 'మీరు గరిష్ఠంగా $count ఫోటోలు ఎంచుకోవచ్చు.';
  }

  @override
  String get submissionEvidenceNeeded => 'కనీసం ఒక ఆధార ఫోటో ఎంచుకోండి.';

  @override
  String get submissionExchangeStarted => 'ఎక్స్‌ఛేంజ్ ప్రారంభమైంది';

  @override
  String get submissionFindings => 'తనిఖీ ఫలితాలు';

  @override
  String get submissionImpose => 'రిపోర్ట్ అమలు చేయండి';

  @override
  String get submissionImposeBody =>
      'రైడర్ తనిఖీ ఫలితాలు, ఛార్జీలు చూశారని నిర్ధారించుకోండి. దీని తర్వాత రిపోర్ట్‌ను మార్చలేరు, రద్దు మాత్రమే చేయగలరు.';

  @override
  String get submissionImposed => 'రిపోర్ట్ అమలైంది';

  @override
  String get submissionImposeTitle => 'ఈ రిపోర్ట్‌ను అమలు చేయాలా?';

  @override
  String get submissionItemNote => 'గమనిక (ఐచ్ఛికం)';

  @override
  String get submissionItemNoteHint => 'నష్టం ఎక్కడ ఉంది?';

  @override
  String get submissionItemPhotoNeeded => 'ఈ భాగం యొక్క కనీసం ఒక ఫోటో తీయండి.';

  @override
  String get submissionItemPhotoOptionalHint =>
      'ఈ భాగానికి ఫోటో తప్పనిసరి కాదు, కానీ రైడర్‌కు ప్రశ్నలు ఉంటే ఉపయోగపడుతుంది.';

  @override
  String get submissionItemPhotoRequiredHint =>
      'ఈ భాగానికి ఆధారంగా ఫోటో అవసరం. నష్టం యొక్క స్పష్టమైన క్లోజ్-అప్ ఫోటో తీయండి.';

  @override
  String get submissionMaintenanceDetails => 'ఏమి సరిచేయాలి?';

  @override
  String get submissionMechanicName => 'సమర్పించినవారు / మెకానిక్ పేరు';

  @override
  String get submissionNameNeeded => 'మెకానిక్ పేరు నమోదు చేయండి';

  @override
  String get submissionNextComplete => 'అన్ని తనిఖీలు పూర్తయ్యాయి. ఇక్కడ ఇంకేమీ చేయాల్సిన పని లేదు.';

  @override
  String get submissionNextLabel => 'తదుపరి దశ';

  @override
  String get submissionNextOtps => 'రిపోర్ట్‌ను నిర్ధారించడానికి రైడర్, టీమ్ లీడ్ కోడ్‌లు తీసుకోండి.';

  @override
  String submissionNextPhotos(int count) {
    return 'ఇంకా తీయాల్సిన ఫోటోలు: $count. తర్వాత మెకానిక్ రిపోర్ట్ నమోదు చేయండి.';
  }

  @override
  String get submissionNextReport => 'అన్ని ఫోటోలు వచ్చాయి. ఇప్పుడు మెకానిక్ రిపోర్ట్ నమోదు చేయండి.';

  @override
  String get submissionNextReview => 'రైడర్‌తో రిపోర్ట్, ఛార్జీలను చూసి, తర్వాత దాన్ని అమలు చేయండి.';

  @override
  String get submissionNoDamagedItems => 'దెబ్బతిన్న భాగాలు ఏవీ జోడించలేదు, కాబట్టి రైడర్‌కు ఛార్జీ ఉండదు.';

  @override
  String get submissionNoPrices => 'ఇంకా పెనాల్టీ ధరలు సెట్ చేయలేదు. డ్యాష్‌బోర్డ్‌లో జోడించమని అడ్మిన్‌ను అడగండి.';

  @override
  String get submissionNoSparePartMatch => 'మీ శోధనకు సరిపోయే భాగం లేదు';

  @override
  String get submissionNothingToConfirm => 'నిర్ధారించడానికి ఏమీ లేదు';

  @override
  String get submissionNothingToConfirmBody => 'ఈ సబ్మిషన్‌లో కోడ్‌ల కోసం ఎదురుచూస్తున్న అమలైన రిపోర్ట్ ఏదీ లేదు.';

  @override
  String get submissionPartyRider => 'రైడర్';

  @override
  String get submissionPartyTeamLead => 'టీమ్ లీడ్';

  @override
  String submissionPhotoBattery(String name) {
    return 'బ్యాటరీ $name';
  }

  @override
  String get submissionPhotoBatteryGeneric => 'బ్యాటరీ';

  @override
  String get submissionPhotoChecklist => 'రిటర్న్ చెక్‌లిస్ట్';

  @override
  String submissionPhotoController(String number) {
    return 'కంట్రోలర్ $number';
  }

  @override
  String get submissionPhotoControllerGeneric => 'కంట్రోలర్';

  @override
  String get submissionPhotoDamage => 'నష్టం ఫోటో';

  @override
  String get submissionPhotoIot => 'IoT పరికరం';

  @override
  String get submissionPhotos => 'అవసరమైన ఫోటోలు';

  @override
  String get submissionPhotosHint =>
      'ఫోటో తీయడానికి ఖాళీ స్లాట్‌ను ట్యాప్ చేయండి. తీసిన ఫోటో చూడటానికి దాన్ని ట్యాప్ చేయండి.';

  @override
  String get submissionPriceChanged =>
      'ఒక భాగం ధర లేదా ఫోటో నియమం ఇప్పుడే మారింది. దాన్ని తీసివేసి జాబితా నుండి మళ్లీ జోడించండి.';

  @override
  String get submissionQuantity => 'పరిమాణం';

  @override
  String get submissionReceivingHub => 'స్వీకరించే హబ్';

  @override
  String get submissionRecordReport => 'మెకానిక్ రిపోర్ట్ నమోదు చేయండి';

  @override
  String get submissionRemovePhoto => 'ఫోటో తీసివేయండి';

  @override
  String submissionReportBy(String name) {
    return '$name ద్వారా';
  }

  @override
  String get submissionReportCancelled => 'రిపోర్ట్ రద్దయింది';

  @override
  String get submissionReports => 'మెకానిక్ రిపోర్ట్‌లు';

  @override
  String get submissionReportSaved => 'రిపోర్ట్ సేవ్ అయింది';

  @override
  String get submissionReportSummary => 'సారాంశం';

  @override
  String get submissionReportSummaryHint =>
      'సేవ్ చేసే ముందు ఆధార ఫోటోలు మరియు ఛార్జీలు చూసుకోండి. రిపోర్ట్ అమలు చేసినప్పుడు ఈ ఛార్జీలు చెల్లించమని రైడర్‌ను అడుగుతారు.';

  @override
  String get submissionResendAll => 'కోడ్‌లు మళ్లీ పంపండి';

  @override
  String get submissionRiderNote => 'రైడర్ నోట్';

  @override
  String get submissionSafeQuestion => 'స్కూటర్ ప్రస్తుత స్థితి';

  @override
  String get submissionSafetyNeeded => 'స్కూటర్ ప్రస్తుత స్థితిని ఎంచుకోండి';

  @override
  String get submissionsAll => 'అన్నీ';

  @override
  String get submissionSaveItem => 'భాగం సేవ్ చేయండి';

  @override
  String get submissionSaveReport => 'రిపోర్ట్ సేవ్ చేయండి';

  @override
  String submissionScooterStatusLine(String status) {
    return 'స్కూటర్ స్థితి: $status';
  }

  @override
  String get submissionsCouldNotLoad => 'రిటర్న్‌లు, ఎక్స్ఛేంజ్‌లు లోడ్ కాలేదు';

  @override
  String get submissionsDrawerSubtitle => 'తిరిగి వచ్చిన స్కూటర్ల సబ్మిషన్';

  @override
  String submissionsDropOff(String date) {
    return 'అప్పగింత $date';
  }

  @override
  String get submissionsDropOffDate => 'అప్పగించే తేదీ';

  @override
  String get submissionSearchSpareParts => 'భాగం పేరు లేదా కోడ్‌తో వెతకండి';

  @override
  String get submissionsEmptyAll => 'మీ హబ్ రిటర్న్‌లు, ఎక్స్ఛేంజ్‌లు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get submissionsEmptyChecks => 'ఏ సబ్మిషన్ జరగడం లేదు.';

  @override
  String get submissionsEmptyScheduled => 'ప్రస్తుతం మీ హబ్‌కు ఏ స్కూటర్ రావాల్సి లేదు.';

  @override
  String get submissionsEmptyTitle => 'ఇక్కడ ఏమీ లేదు';

  @override
  String get submissionSendCodes => 'కోడ్‌లు పంపండి';

  @override
  String get submissionsExchanges => 'ఎక్స్ఛేంజ్‌లు';

  @override
  String get submissionsExchangesDue => 'రావాల్సిన ఎక్స్ఛేంజ్‌లు';

  @override
  String get submissionsInChecks => 'తనిఖీలో';

  @override
  String get submissionSourceExchange => 'ఎక్స్ఛేంజ్';

  @override
  String get submissionSourceReturn => 'రిటర్న్';

  @override
  String get submissionsReturns => 'రిటర్న్‌లు';

  @override
  String get submissionsReturnsDue => 'రావాల్సిన రిటర్న్‌లు';

  @override
  String get submissionsScheduled => 'షెడ్యూల్ చేసినవి';

  @override
  String get submissionsSubtitle => 'రైడర్లు మీ హబ్‌కు తిరిగి తెచ్చే స్కూటర్ల సబ్మిషన్ ప్రారంభించండి.';

  @override
  String submissionStaffReturnBody(String rider, String vehicle) {
    return 'ఇది $vehicle సబ్మిషన్‌ను ఇప్పుడే ప్రారంభిస్తుంది. మెకానిక్ రిపోర్ట్ నిర్ధారించిన వెంటనే $rider అద్దె ముగుస్తుంది.';
  }

  @override
  String get submissionStaffReturnTitle => 'ఈ స్కూటర్‌ను వెనక్కి తీసుకోవాలా?';

  @override
  String get submissionStageCheckingIn => 'సబ్మిషన్ జరుగుతోంది';

  @override
  String get submissionStageDone => 'పూర్తయింది';

  @override
  String get submissionStageScheduled => 'షెడ్యూల్ అయింది';

  @override
  String get submissionStart => 'సబ్మిషన్ ప్రారంభించండి';

  @override
  String get submissionStartBody =>
      'రైడర్ స్కూటర్‌తో హబ్‌కు వచ్చాక ప్రారంభించండి. సబ్మిషన్ పూర్తయ్యే వరకు స్కూటర్‌ను మళ్లీ కేటాయించలేరు.';

  @override
  String get submissionStartBodyExchange =>
      'రైడర్ స్కూటర్‌తో హబ్‌కు వచ్చాక ప్రారంభించండి. ఎక్స్‌ఛేంజ్ పూర్తయ్యే వరకు స్కూటర్‌ను మళ్లీ కేటాయించలేరు.';

  @override
  String get submissionStarted => 'సబ్మిషన్ ప్రారంభమైంది';

  @override
  String get submissionStartedAt => 'ప్రారంభం';

  @override
  String get submissionStartExchange => 'ఎక్స్‌ఛేంజ్ ప్రారంభించండి';

  @override
  String get submissionStartTitle => 'సబ్మిషన్ ప్రారంభించండి';

  @override
  String get submissionStatusAvailableHint => 'నడపడానికి సురక్షితం. స్కూటర్ ఫ్లీట్‌కు తిరిగి వెళ్తుంది.';

  @override
  String get submissionStatusAwaitingPartsHint => 'విడిభాగాల కోసం వేచి ఉంది. అవి అమర్చే వరకు దీన్ని కేటాయించలేరు.';

  @override
  String get submissionStatusBrokenHint => 'పెద్ద రిపేర్ అవసరం. రిపేర్ అయ్యే వరకు దీన్ని కేటాయించలేరు.';

  @override
  String get submissionStatusCancelled => 'రద్దయింది';

  @override
  String get submissionStatusMaintenanceHint => 'రిపేర్ అవసరం. బాగయ్యే వరకు దీన్ని కేటాయించలేరు.';

  @override
  String get submissionsTitle => 'రిటర్న్‌లు & ఎక్స్ఛేంజ్‌లు';

  @override
  String get submissionSummary => 'మెకానిక్ గుర్తించినవి';

  @override
  String get submissionSummaryHint => 'బాడీ, బ్యాటరీ, కంట్రోలర్, యాక్సెసరీల పరిస్థితి';

  @override
  String get submissionSummaryNeeded => 'మెకానిక్ గుర్తించినవి వివరించండి';

  @override
  String get submissionUseCode => 'బదులుగా కోడ్ వాడండి';

  @override
  String get submissionVerifiedRider => 'రైడర్ కోడ్‌తో నిర్ధారించారు';

  @override
  String get submissionVerifiedTeamLead => 'టీమ్ లీడ్ కోడ్‌తో నిర్ధారించారు';

  @override
  String get submissionVerify => 'కోడ్ ధృవీకరించండి';

  @override
  String get submissionViewPhoto => 'ఫోటో చూడండి';

  @override
  String get submissionWhatNeedsWorkNeeded => 'ఏమి సరిచేయాలో వివరించండి';

  @override
  String get supportAccidentTheft => 'ప్రమాదం లేదా దొంగతనం';

  @override
  String get supportAddFewMoreDetails10 => 'మరిన్ని వివరాలు రాయండి (10+ అక్షరాలు)';

  @override
  String get supportAll => 'అన్నీ';

  @override
  String get supportBatteryCharging => 'బ్యాటరీ లేదా చార్జింగ్';

  @override
  String get supportBreakdownRoad => 'దారిలో మరమ్మతు';

  @override
  String get supportCouldNotLoadSupport => 'సహాయం తెరవలేకపోయాం';

  @override
  String get supportCouldNotLoadTicket => 'ఈ టికెట్‌ను లోడ్ చేయలేకపోయాం';

  @override
  String get supportDescription => 'వివరణ';

  @override
  String get supportDeskEmpty => 'ఇక్కడ టికెట్లు లేవు';

  @override
  String get supportDeskEmptyBody => 'మీ హబ్‌లలో రైడర్లు నమోదు చేసే టికెట్లు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get supportDeskSubtitle => 'మీ హబ్‌ల రైడర్ టికెట్లు';

  @override
  String get supportDeskTitle => 'సపోర్ట్ డెస్క్';

  @override
  String get supportDocumentsKyc => 'పత్రాలు మరియు కేవైసీ';

  @override
  String get supportHub => 'హబ్';

  @override
  String get supportInProgress => 'పురోగతిలో ఉంది';

  @override
  String get supportMarkResolved => 'పరిష్కరించినట్లు గుర్తించు';

  @override
  String get supportMoreDetailGiveFasterCan => 'మీరు ఎంత ఎక్కువ వివరం ఇస్తే అంత వేగంగా సాయం చేయగలం';

  @override
  String get supportNeedHelpWithSomething => 'ఏదైనా సహాయం కావాలా?';

  @override
  String get supportNothingOpenRightNow => 'ప్రస్తుతం ఏమీ తెరిచి లేదు';

  @override
  String get supportNoTicketsYet => 'ఇంకా ఫిర్యాదులు లేవు';

  @override
  String get supportOneLineSumsUpIssue => 'సమస్యను ఒక్క వాక్యంలో రాయండి';

  @override
  String supportOpenCount(int count) {
    return '$count తెరిచి ఉన్నాయి';
  }

  @override
  String get supportOpenTickets => 'తెరిచిన ఫిర్యాదులు';

  @override
  String get supportPaymentWallet => 'చెల్లింపు లేదా వాలెట్';

  @override
  String get supportPdfAttachment => 'PDF పత్రం';

  @override
  String supportPhotosHint(int count) {
    return 'సమస్యను వివరించడానికి సహాయపడితే $count ఫోటోల వరకు జోడించండి.';
  }

  @override
  String supportPhotosNotAttached(int count) {
    return 'టికెట్ నమోదైంది, కానీ $count ఫోటో(లు) జత చేయలేకపోయాం. టికెట్ నుండి వాటిని జోడించవచ్చు.';
  }

  @override
  String get supportPhotosOptional => 'ఫోటోలు (ఐచ్ఛికం)';

  @override
  String get supportPickTopic => 'ఒక అంశాన్ని ఎంచుకోండి, లేదా కింద మీ సొంత విషయం రాయండి.';

  @override
  String supportRaisedOn(String date) {
    return '$date న నమోదు చేశారు';
  }

  @override
  String get supportRaiseOneAboveIfSomething => 'ఏదైనా సరిచేయాలంటే పైన నమోదు చేయండి.';

  @override
  String get supportRaiseTicket => 'ఫిర్యాదు నమోదు చేయండి';

  @override
  String get supportResolveBody => 'రైడర్ ఇంకా సమాధానం ఇవ్వవచ్చు. వారి సమాధానం టికెట్‌ను మళ్లీ తెరుస్తుంది.';

  @override
  String get supportResolved => 'పరిష్కరించబడింది';

  @override
  String get supportResolvedReplyToReopen =>
      'ఈ టికెట్ పరిష్కరించబడింది. ఇంకా సహాయం కావాలంటే సందేశం పంపండి, అది మళ్లీ తెరవబడుతుంది.';

  @override
  String get supportResolveTitle => 'ఈ టికెట్‌ను పరిష్కరించినట్లు గుర్తించాలా?';

  @override
  String get supportSomethingElse => 'మరేదైనా';

  @override
  String get supportStartWorking => 'పని ప్రారంభించు';

  @override
  String get supportStatusUpdated => 'టికెట్ స్థితి అప్‌డేట్ అయింది';

  @override
  String get supportSubject => 'విషయం';

  @override
  String get supportSubmitTicket => 'ఫిర్యాదు సమర్పించండి';

  @override
  String get supportTeam => 'సపోర్ట్ బృందం';

  @override
  String get supportTeamLeadSeesStraightAway => 'మీ టీమ్ లీడ్ దీన్ని వెంటనే చూస్తారు.';

  @override
  String get supportTellUsMore => 'మరింత చెప్పండి';

  @override
  String get supportTellUsWhatAbout => 'ఇది దేని గురించో చెప్పండి';

  @override
  String get supportTellUsWhatHappenedAttach => 'ఏమి జరిగిందో చెప్పండి, ఉపయోగపడితే ఫోటో జతచేయండి. ';

  @override
  String get supportTicket => 'టికెట్';

  @override
  String get supportTicketRaised => 'టికెట్ నమోదైంది. మా బృందం దీనిపై పనిచేస్తోంది.';

  @override
  String get supportTicketReopened => 'టికెట్ మళ్లీ తెరవబడింది. మా బృందం మిమ్మల్ని సంప్రదిస్తుంది.';

  @override
  String get supportTickets => 'మీ ఫిర్యాదులు';

  @override
  String supportUpdated(String time) {
    return '$time అప్‌డేట్ అయింది';
  }

  @override
  String get supportWhatHappenedSinceWhen => 'ఏమి జరిగింది, ఎప్పటి నుంచి?';

  @override
  String get supportWhatsTheIssue => 'ఏమి సమస్య';

  @override
  String get supportWriteMessage => 'సందేశం రాయండి';

  @override
  String get supportYou => 'మీరు';

  @override
  String get swapCouldNotLoad => 'స్వాప్ స్టేషన్‌లు తెరవలేకపోయాం';

  @override
  String get swapNoneBody => 'ప్రస్తుతం బ్యాటరీ స్వాప్ స్టేషన్‌లు ఏవీ దొరకలేదు.';

  @override
  String get swapNoneTitle => 'స్వాప్ స్టేషన్‌లు ఏవీ కనిపించలేదు';

  @override
  String get swapSubtitle => 'మీకు దగ్గరలోని స్వాప్ స్టేషన్‌లు';

  @override
  String get swapTitle => 'బ్యాటరీ స్వాపింగ్';

  @override
  String swapUnits(String count) {
    return 'యూనిట్లు: $count';
  }

  @override
  String get teamAdvisor => 'సలహాదారు';

  @override
  String get teamBatteryExpert => 'బ్యాటరీ నిపుణుడు';

  @override
  String get teamMotorControllerRepair => 'మోటార్ కంట్రోలర్ రిపేర్';

  @override
  String get teamNotIncluded => 'ఫీచర్ చేర్చబడలేదు';

  @override
  String get teamNotIncludedMessage => 'ఈ ఫీచర్ మీ ప్రస్తుత ప్యాకేజీలో చేర్చబడలేదు.';

  @override
  String get teamTechnician => 'టెక్నీషియన్';

  @override
  String get trainingCareClean => 'శుభ్రంగా ఉంచండి';

  @override
  String get trainingCareCleanBody => 'స్కూటర్‌ను శుభ్రంగా, మంచి స్థితిలో ఉంచండి.';

  @override
  String get trainingCareReport => 'సమస్యలను తెలియజేయండి';

  @override
  String get trainingCareReportBody =>
      'ఏదైనా ప్రమాదం, నష్టం, అసాధారణ శబ్దం, హెచ్చరిక లైట్ లేదా వాహన లోపం ఉంటే వెంటనే మాకు తెలియజేయండి.';

  @override
  String get trainingCareTamper => 'ట్యాంపరింగ్ వద్దు';

  @override
  String get trainingCareTamperBody =>
      'బ్యాటరీ, మోటార్, కంట్రోలర్, వైరింగ్ లేదా GPS పరికరాన్ని తెరవవద్దు, మార్చవద్దు, ట్యాంపర్ చేయవద్దు.';

  @override
  String get trainingCareWater => 'లోతైన నీటిలోకి వద్దు';

  @override
  String get trainingCareWaterBody =>
      'వరద/లోతైన నీటి ప్రాంతాల గుండా స్కూటర్‌ను తీసుకెళ్లవద్దు, దానిపై అధిక ఒత్తిడి నీటిని వాడవద్దు.';

  @override
  String get trainingChargeEquipment => 'ఆమోదించిన పరికరాలనే వాడండి';

  @override
  String get trainingChargeEquipmentBody => 'మేము ఇచ్చిన లేదా ఆమోదించిన ఛార్జర్/బ్యాటరీ/యాక్సెసరీలను మాత్రమే వాడండి.';

  @override
  String get trainingChargePark => 'బాధ్యతగా పార్క్ చేయండి';

  @override
  String get trainingChargeParkBody =>
      'అనుమతి ఉన్న ప్రదేశాల్లో సురక్షితంగా పార్క్ చేయండి, నీరు, అగ్ని లేదా దొంగతనం ప్రమాదాలను నివారించండి.';

  @override
  String get trainingChargeRide => 'బాధ్యతగా నడపండి';

  @override
  String get trainingChargeRideBody =>
      'ఓవర్‌లోడింగ్, అసురక్షిత డ్రైవింగ్, జంపింగ్, రేసింగ్ లేదా స్కూటర్ దుర్వినియోగం వద్దు.';

  @override
  String get trainingChargeStations => 'నిర్దేశించిన స్టేషన్లలోనే ఛార్జ్/స్వాప్ చేయండి';

  @override
  String get trainingChargeStationsBody => 'ఆమోదించిన ఛార్జింగ్/స్వాపింగ్ స్టేషన్లను మాత్రమే ఉపయోగించండి.';

  @override
  String get trainingCharging => 'ఛార్జింగ్ & వినియోగం';

  @override
  String get trainingChargingSummary => 'సురక్షితమైన, సాఫీగా, ఇబ్బంది లేని రైడ్ కోసం ఈ సులభ మార్గదర్శకాలను పాటించండి.';

  @override
  String get trainingKeyPoints => 'ముఖ్య అంశాలు';

  @override
  String get trainingPayApp => 'చెల్లింపులు యాప్‌లో మాత్రమే';

  @override
  String get trainingPayAppBody =>
      'అద్దె, డిపాజిట్, ఇతర అన్ని చెల్లింపులు అధికారిక యాప్/చెల్లింపు ప్రక్రియ ద్వారానే చేయాలి.';

  @override
  String get trainingPayBribe => 'లంచం / అనధికారిక చెల్లింపు వద్దు';

  @override
  String get trainingPayBribeBody =>
      'TL లేదా కంపెనీ ప్రతినిధికి ఎప్పుడూ లంచం, కమీషన్ లేదా వ్యక్తిగత చెల్లింపు ఇవ్వవద్దు, ఇస్తానని చెప్పవద్దు.';

  @override
  String get trainingPayCash => 'నగదు చెల్లింపులు వద్దు';

  @override
  String get trainingPayCashBody => 'ఏ TL, సిబ్బంది లేదా ప్రతినిధికీ నగదు చెల్లించవద్దు.';

  @override
  String get trainingPayments => 'చెల్లింపులు & ప్రవర్తన';

  @override
  String get trainingPaymentsSummary =>
      'సురక్షితమైన, పారదర్శకమైన, ఇబ్బంది లేని లావాదేవీల కోసం ఈ సులభ మార్గదర్శకాలను పాటించండి.';

  @override
  String get trainingPayReport => 'ఫిర్యాదులు తెలియజేయండి';

  @override
  String get trainingPayReportBody =>
      'ఎవరైనా నగదు లేదా లంచం అడిగినా, అనధికార ఛార్జీ, దుష్ప్రవర్తన లేదా ఇతర సమస్య ఉన్నా నేరుగా మాకు తెలియజేయండి.';

  @override
  String get trainingVehicleCare => 'వాహన సంరక్షణ';

  @override
  String get trainingVehicleCareSummary => 'ప్రతి రైడ్‌కు స్కూటర్‌ను సురక్షితంగా, శుభ్రంగా, సిద్ధంగా ఉంచండి.';

  @override
  String get trainingViewed => 'చూశారు';

  @override
  String get validationEnterDateBeforeToday => 'ఈరోజు లేదా అంతకు ముందు తేదీ రాయండి';

  @override
  String get validationEnterDateLaterThanToday => 'ఈరోజు తర్వాతి తేదీ రాయండి';

  @override
  String get validationEnterValid12DigitAadhaar => 'సరైన 12 అంకెల ఆధార్ నంబర్ రాయండి';

  @override
  String get validationEnterValidEmailAddress => 'సరైన ఇమెయిల్ చిరునామా రాయండి';

  @override
  String get validationEnterValidIfscCode => 'సరైన ఐఎఫ్‌ఎస్‌సీ కోడ్ రాయండి';

  @override
  String get validationEnterValidPanAbcde1234f => 'సరైన పాన్ రాయండి (ABCDE1234F)';

  @override
  String get validationEnterValidUpiId => 'సరైన యూపీఐ ఐడీ రాయండి';

  @override
  String get validationField => 'ఈ గడి';

  @override
  String get verifyApprove => 'ఆమోదించండి';

  @override
  String get verifyApproveAllFirst => 'వాహనం కేటాయించడానికి అన్ని పత్రాలను ఆమోదించండి.';

  @override
  String get verifyApproved => 'ఆమోదించబడింది';

  @override
  String get verifyApproveDocument => 'ఈ పత్రాన్ని ఆమోదించాలా?';

  @override
  String verifyApproveMessage(String name) {
    return '$name ధృవీకరించబడినట్లు గుర్తించబడుతుంది. దీన్ని తర్వాత మార్చలేరు.';
  }

  @override
  String get verifyApproveReference => 'ఈ రిఫరెన్స్‌ను ఆమోదించాలా?';

  @override
  String get verifyContinue => 'వాహనం కేటాయించడానికి కొనసాగండి';

  @override
  String get verifyCouldNotCall => 'కాల్ ప్రారంభించలేకపోయాం.';

  @override
  String get verifyCouldNotLoad => 'ఈ జాబితాను లోడ్ చేయలేకపోయాం.';

  @override
  String get verifyDocumentApproved => 'పత్రం ఆమోదించబడింది';

  @override
  String get verifyDocumentRejected => 'పత్రం తిరస్కరించబడింది';

  @override
  String get verifyDocuments => 'పత్రాలు';

  @override
  String get verifyDocumentsHint =>
      'రైడర్ అప్‌లోడ్ చేసిన ప్రతి పత్రాన్ని తెరిచి చూడండి, తర్వాత ఆమోదించండి లేదా తిరస్కరించండి.';

  @override
  String get verifyDocumentsLocked =>
      'ఫ్లీట్ మేనేజర్లు ఇంకా పత్రాలను సమీక్షించలేరు. మీ అడ్మిన్ డ్యాష్‌బోర్డ్‌లో వాటిని సమీక్షించవచ్చు.';

  @override
  String get verifyNoDocuments => 'రైడర్ ఇంకా ఏ పత్రాన్నీ అప్‌లోడ్ చేయలేదు.';

  @override
  String get verifyNoReferences => 'రైడర్ ఏ రిఫరెన్స్‌నూ జోడించలేదు.';

  @override
  String get verifyReason => 'కారణం';

  @override
  String get verifyReasonHint => 'ఉదా. ఫోటో అస్పష్టంగా ఉంది';

  @override
  String get verifyReasonRequired => 'కారణం నమోదు చేయండి';

  @override
  String get verifyReferenceApproved => 'రిఫరెన్స్ ఆమోదించబడింది';

  @override
  String get verifyReferenceRejected => 'రిఫరెన్స్ తిరస్కరించబడింది';

  @override
  String get verifyReferences => 'రిఫరెన్స్‌లు';

  @override
  String get verifyReferencesHint =>
      'నిర్ధారించుకోవడానికి ప్రతి రిఫరెన్స్‌కు కాల్ చేయండి, తర్వాత ఆమోదించండి లేదా తిరస్కరించండి.';

  @override
  String get verifyReject => 'తిరస్కరించండి';

  @override
  String get verifyRejected => 'తిరస్కరించబడింది';

  @override
  String get verifyRejectSubtitle => 'తిరస్కరించడానికి చిన్న కారణం రాయండి.';

  @override
  String verifyRejectTitle(String name) {
    return '$name తిరస్కరించండి';
  }

  @override
  String verifyReviewedBy(String name) {
    return '$name సమీక్షించారు';
  }

  @override
  String get verifyTitle => 'రైడర్‌ను ధృవీకరించండి';

  @override
  String verifyUploadedOn(String date) {
    return '$dateన అప్‌లోడ్ చేశారు';
  }

  @override
  String get verifyView => 'చూడండి';

  @override
  String get walletAvailable => 'అందుబాటులో';

  @override
  String get walletCash => 'నగదు';

  @override
  String get walletClosingBalance => 'ముగింపు బ్యాలెన్స్';

  @override
  String walletCompletedOn(String date) {
    return '$date న పూర్తయింది';
  }

  @override
  String get walletCouldNotLoadDeposit => 'డిపాజిట్ వివరాలను రిఫ్రెష్ చేయలేకపోయాం';

  @override
  String get walletCouldNotLoadReceipt => 'రసీదును లోడ్ చేయలేకపోయాం';

  @override
  String get walletCouldNotLoadStatement => 'మీ స్టేట్‌మెంట్‌ను లోడ్ చేయలేకపోయాం';

  @override
  String get walletCouldNotLoadWallet => 'మీ వాలెట్ తెరవలేకపోయాం';

  @override
  String get walletCredited => 'జమ అయింది';

  @override
  String get walletCredits => 'జమ';

  @override
  String get walletDateTime => 'తేదీ మరియు సమయం';

  @override
  String get walletDebits => 'ఖర్చు';

  @override
  String get walletDeducted => 'తీసివేయబడింది';

  @override
  String get walletDeploymentPayment => 'మోహరింపు చెల్లింపు';

  @override
  String get walletDeposit => 'డిపాజిట్';

  @override
  String get walletDepositDeducted => 'తగ్గించింది';

  @override
  String get walletDepositHeld => 'ఉంచింది';

  @override
  String get walletDepositLocked => 'మీ అద్దె కోసం లాక్';

  @override
  String walletDepositMoved(String amount) {
    return 'డిపాజిట్ $amount';
  }

  @override
  String get walletDepositPaidIn => 'చెల్లించింది';

  @override
  String get walletDepositRequired => 'అవసరమైన మొత్తం';

  @override
  String get walletDepositReturnedAmount => 'తిరిగి ఇచ్చింది';

  @override
  String get walletDepositReturnedSeparately => 'మీరు వెళ్ళిపోయేటప్పుడు మీ డిపాజిట్ విడిగా తిరిగి వస్తుంది.';

  @override
  String get walletDepositReturns => 'తిరిగి చెల్లింపులు';

  @override
  String get walletDepositStatusCancelled => 'రద్దు';

  @override
  String get walletDepositStatusForfeited => 'జప్తు చేశారు';

  @override
  String get walletDepositStatusLocked => 'మీ అద్దె కోసం ఉంచారు';

  @override
  String get walletDepositStatusPaid => 'చెల్లించారు';

  @override
  String get walletDepositStatusPartlyDeducted => 'పాక్షికంగా తగ్గించారు';

  @override
  String get walletDepositStatusPartlyPaid => 'పాక్షికంగా చెల్లించారు';

  @override
  String get walletDepositStatusPending => 'చెల్లింపు కోసం వేచి ఉంది';

  @override
  String get walletDepositStatusReturnable => 'తిరిగి ఇవ్వడానికి సిద్ధం';

  @override
  String get walletDepositStatusReturned => 'తిరిగి ఇచ్చారు';

  @override
  String get walletDepositStatusReturnRequested => 'తిరిగి ఇవ్వమని అభ్యర్థించారు';

  @override
  String get walletDepositToPay => 'ఇంకా చెల్లించాలి';

  @override
  String get walletDestination => 'ఎవరికి చెల్లించారు';

  @override
  String get walletDueNow => 'ఇప్పుడు చెల్లించాలి';

  @override
  String get walletErrorDepositNotFound => 'ఈ డిపాజిట్ అందుబాటులో లేదు.';

  @override
  String get walletErrorNotFound => 'మీ వాలెట్ ఇంకా సెటప్ కాలేదు.';

  @override
  String get walletErrorReceiptNotFound => 'ఈ రసీదు అందుబాటులో లేదు.';

  @override
  String get walletErrorStatementPeriod => 'ఆ వ్యవధికి స్టేట్‌మెంట్ అందుబాటులో లేదు.';

  @override
  String get walletErrorTransactionNotFound => 'ఈ లావాదేవీ అందుబాటులో లేదు.';

  @override
  String get walletExpiringSoon => '7 రోజుల్లో ముగుస్తుంది';

  @override
  String walletFundedOf(String funded, String required) {
    return '$required లో $funded';
  }

  @override
  String get walletInvoicesSettled => 'చెల్లించిన బిల్లులు';

  @override
  String get walletIssued => 'జారీ చేశారు';

  @override
  String get walletKindAdjustment => 'సర్దుబాటు';

  @override
  String get walletKindDeposit => 'సెక్యూరిటీ డిపాజిట్';

  @override
  String get walletKindPayment => 'చెల్లింపు';

  @override
  String get walletKindPenalty => 'జరిమానా';

  @override
  String get walletKindRefund => 'వాపసు';

  @override
  String get walletKindRental => 'అద్దె';

  @override
  String get walletKindReward => 'బహుమతి';

  @override
  String get walletKindService => 'సర్వీస్ ఛార్జీ';

  @override
  String get walletKindTopUp => 'డబ్బు జోడించారు';

  @override
  String get walletLedgerWillFillUpAs => 'మీరు నడిపి సంపాదించే కొద్దీ మీ లెక్క నిండుతుంది.';

  @override
  String get walletMethod => 'పద్ధతి';

  @override
  String get walletMoney => 'మీ డబ్బు';

  @override
  String get walletMoneyIn => 'వచ్చిన డబ్బు';

  @override
  String get walletMoneyOut => 'వెళ్లిన డబ్బు';

  @override
  String get walletNothingMatchesFilterYet => 'ఈ వడపోతకు ఇంకా ఏమీ సరిపోలేదు.';

  @override
  String get walletNoTransactionsHere => 'ఇక్కడ లావాదేవీలు లేవు';

  @override
  String get walletOnHold => 'నిలిపి ఉంచారు';

  @override
  String get walletOpeningBalance => 'ప్రారంభ బ్యాలెన్స్';

  @override
  String get walletPayments => 'చెల్లింపులు';

  @override
  String get walletReceipt => 'రసీదు';

  @override
  String get walletReceiptNumber => 'రసీదు సంఖ్య';

  @override
  String get walletReferenceId => 'రిఫరెన్స్ ఐడీ';

  @override
  String get walletRefundable => 'తిరిగి ఇచ్చేది';

  @override
  String walletRequestedOn(String date) {
    return '$date న అభ్యర్థన';
  }

  @override
  String get walletReturnApproved => 'ఆమోదించారు';

  @override
  String get walletReturnCancelled => 'రద్దు';

  @override
  String get walletReturnDone => 'తిరిగి ఇచ్చారు';

  @override
  String get walletReturnFailed => 'విఫలమైంది';

  @override
  String get walletReturnProcessing => 'ప్రాసెస్ అవుతోంది';

  @override
  String get walletReturnRejected => 'తిరస్కరించారు';

  @override
  String get walletReturnRequested => 'అభ్యర్థించారు';

  @override
  String get walletReturnReview => 'సమీక్షలో ఉంది';

  @override
  String get walletRewardExpired => 'రివార్డ్ గడువు ముగిసింది';

  @override
  String get walletRewardReversed => 'రివార్డ్ వెనక్కి తీసుకున్నారు';

  @override
  String get walletRewardsEarned => 'ఇప్పటివరకు సంపాదించింది';

  @override
  String get walletSearchTransactions => 'లావాదేవీలు వెతకండి';

  @override
  String get walletSecurityDeposit => 'సెక్యూరిటీ డిపాజిట్';

  @override
  String get walletStateFailed => 'విఫలమైంది';

  @override
  String get walletStatement => 'స్టేట్‌మెంట్';

  @override
  String get walletStatementEmpty => 'ఈ నెల ఏమీ లేదు';

  @override
  String get walletStatementEmptyBody => 'ఈ నెల మీ వాలెట్‌లోకి వచ్చే లేదా వెళ్లే డబ్బు ఇక్కడ కనిపిస్తుంది.';

  @override
  String walletStatementReference(String reference) {
    return 'స్టేట్‌మెంట్ రిఫరెన్స్ $reference';
  }

  @override
  String get walletStatementSubtitle => 'నెలవారీగా, ఖచ్చితమైన వచ్చిన, వెళ్లిన డబ్బు';

  @override
  String get walletStatementSummary => 'ఈ నెల';

  @override
  String get walletStatePending => 'పెండింగ్';

  @override
  String get walletStateReversed => 'వెనక్కి తీసుకున్నారు';

  @override
  String get walletStateSettled => 'పూర్తయింది';

  @override
  String get walletToBank => 'మీ బ్యాంక్ ఖాతాకు';

  @override
  String get walletToWallet => 'మీ వాలెట్‌కు';

  @override
  String get walletTransactions => 'లావాదేవీలు';

  @override
  String get walletViewReceipt => 'రసీదు';

  @override
  String get workPartnerEcommerce => 'ఈ-కామర్స్';

  @override
  String get workPartnerFoodDelivery => 'ఫుడ్ డెలివరీ';

  @override
  String get workPartnerOnDemandLogistics => 'ఆన్-డిమాండ్ లాజిస్టిక్స్';

  @override
  String get workPartnerParcelLogistics => 'పార్సెల్ లాజిస్టిక్స్';

  @override
  String get workPartnerPharmacy => 'ఫార్మసీ మరియు ఆరోగ్య సేవ';

  @override
  String get workPartnerQuickCommerce => 'క్విక్ కామర్స్';

  @override
  String get workPartnerSpecialtyDelivery => 'ప్రత్యేక డెలివరీ';

  @override
  String deploymentPayOnline(String amount) {
    return '$amount ఆన్‌లైన్‌లో చెల్లించండి';
  }

  @override
  String get deploymentOnlinePaymentDone => 'చెల్లింపు పూర్తయింది. దీన్ని మీ ఫ్లీట్ మేనేజర్‌కు పంపుతున్నాం.';

  @override
  String get deploymentOnlinePaymentCancelled => 'చెల్లింపు రద్దయింది';

  @override
  String get deploymentOnlinePaymentFailed => 'చెల్లింపు జరగలేదు. మళ్లీ ప్రయత్నించండి.';

  @override
  String submissionPhotoItemsLimit(int count) {
    return '$count దెబ్బతిన్న భాగాలకు మాత్రమే ఫోటోలు జోడించవచ్చు. ఈ భాగం జోడించడానికి వాటిలో ఒకదాన్ని తీసివేయండి.';
  }

  @override
  String submissionPhotoItemsLimitHint(int count) {
    return '$count దెబ్బతిన్న భాగాలకు మాత్రమే ఫోటోలు జోడించవచ్చు, ఆ పరిమితి పూర్తయింది. ఈ భాగాన్ని ఫోటో లేకుండా సేవ్ చేయవచ్చు.';
  }

  @override
  String get profileDateOfBirth => 'పుట్టిన తేదీ';

  @override
  String get profileAddress => 'చిరునామా';

  @override
  String get profileState => 'రాష్ట్రం';

  @override
  String get profilePinCode => 'పిన్ కోడ్';

  @override
  String get profileEmergencyContact => 'అత్యవసర సంప్రదింపు';

  @override
  String get profileCouldNotLoad => 'మీ ప్రొఫైల్ తెరవలేకపోయాం';

  @override
  String get profileCurrentAddress => 'ప్రస్తుత చిరునామా';

  @override
  String get profilePermanentAddress => 'శాశ్వత చిరునామా';

  @override
  String get profileSameAsCurrentAddress => 'ప్రస్తుత చిరునామా లాగానే';

  @override
  String get damageChargesPayAtHubTitle => 'మీ హబ్‌లో చెల్లించండి';

  @override
  String damageChargesPayAtHubMessage(String amount) {
    return 'యాప్‌లో ఇంకా ఆన్‌లైన్ చెల్లింపు అందుబాటులో లేదు. దయచేసి $amount మీ హబ్‌లో చెల్లించండి. హబ్ నమోదు చేసిన తర్వాత ఇది ఇక్కడ కనిపిస్తుంది.';
  }

  @override
  String damageChargesPaymentProcessing(String amount) {
    return '$amount చెల్లింపు ప్రాసెస్ అవుతోంది. నిర్ధారించిన తర్వాత ఇది ఇక్కడ కనిపిస్తుంది.';
  }

  @override
  String get damageChargesSectionToPay => 'చెల్లించాల్సినవి';

  @override
  String get damageChargesSectionPaid => 'చెల్లించినవి';
}
