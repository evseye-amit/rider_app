// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppL10nHi extends AppL10n {
  AppL10nHi([String locale = 'hi']) : super(locale);

  @override
  String get allocationAddItem => 'चीज़ जोड़ें';

  @override
  String get allocationAddLeastOneItem => 'कम से कम एक चीज़ जोड़ें';

  @override
  String get allocationAllHubs => 'सभी हब';

  @override
  String get allocationAllocateVehicle => 'गाड़ी दें';

  @override
  String get allocationAllocateVehicleWaitingRiderStart => 'शुरू करने के लिए इंतज़ार कर रहे राइडर को गाड़ी दें।';

  @override
  String get allocationAskPayment => 'भुगतान मांगें';

  @override
  String get allocationAskPaymentConfirm =>
      'राशि राइडर के स्वीकार किए गए प्लान से तय होती है। राइडर को पेमेंट का अनुरोध भेजें?';

  @override
  String get allocationAskPaymentExchange =>
      'यह एक्सचेंज स्कूटर है। इसका प्लान पहले से तय है, इसलिए इस हैंडओवर पर कुछ नहीं लिया जाएगा। जारी रखें?';

  @override
  String get allocationAssign => 'सौंपें';

  @override
  String get allocationAssignTeamLead => 'टीम लीड असाइन करें';

  @override
  String get allocationAssignVehicle => 'गाड़ी सौंपें';

  @override
  String get allocationBack => 'पीछे';

  @override
  String get allocationBackDesk => 'डेस्क पर वापस';

  @override
  String get allocationBackToAllocations => 'आवंटन पर वापस जाएँ';

  @override
  String get allocationBatteryChargeCharger => 'बैटरी चार्ज और चार्जर';

  @override
  String get allocationBodyPaintwork => 'बॉडी और पेंट का काम';

  @override
  String get allocationCallRider => 'कॉल करें';

  @override
  String get allocationChangePlan => 'प्लान बदलें';

  @override
  String get allocationChangeTeamLead => 'टीम लीड बदलें';

  @override
  String get allocationChecklistRiderWillAcceptItem => 'वह सूची जिसे राइडर एक-एक करके स्वीकार करेगा';

  @override
  String get allocationChecklistTapToggleMandatory => 'सूची · अनिवार्य बदलने के लिए दबाएं';

  @override
  String get allocationChoosePlan => 'रेंटल प्लान चुनें';

  @override
  String get allocationChooseTeamLead => 'टीम लीड चुनें';

  @override
  String get allocationChooseWorkPartner => 'काम का साथी चुनें';

  @override
  String get allocationComplete2 => 'पूरा हुआ।';

  @override
  String get allocationConfirmHaveReceivedAmountRider =>
      'पक्का करें कि राइडर ने जिस रेफ़रेंस के लिए भेजा था वह रकम आपको मिल गई है। यह वापस नहीं हो सकता।';

  @override
  String allocationConfirmReceivedAmount(String amount) {
    return 'पुष्टि करें कि आपको राइडर से $amount मिल गए हैं।';
  }

  @override
  String get allocationContinueHandover => 'हैंडओवर जारी रखें';

  @override
  String get allocationCouldNotAllocateVehicle => 'गाड़ी आवंटित नहीं हो पाई';

  @override
  String get allocationCouldNotLoadAllocations => 'आवंटन नहीं खुल पाए';

  @override
  String get allocationCouldNotLoadAvailableVehicles => 'उपलब्ध गाड़ियां नहीं खुल पाईं';

  @override
  String get allocationCouldNotLoadHandover => 'यह हैंडओवर नहीं खुल पाया';

  @override
  String get allocationCouldNotLoadTeamLeads => 'टीम लीड लोड नहीं हो सके';

  @override
  String get allocationCouldNotLoadWorkPartners => 'काम के साथी लोड नहीं हो सके';

  @override
  String get allocationDeAllocateVehicle => 'गाड़ी वापस लें';

  @override
  String get allocationDeployed => 'तैनात';

  @override
  String allocationDeployedMessage(String vehicle, String rider) {
    return '$vehicle अब $rider के साथ सड़क पर है।';
  }

  @override
  String get allocationDeployedTitle => 'स्कूटर तैनात हो गया!';

  @override
  String get allocationEveryOnboardedRiderHubsHas => 'आपके हब के हर जुड़े राइडर के पास गाड़ी है या हैंडओवर चल रहा है।';

  @override
  String get allocationFleetOnlyBody => 'स्कूटर देने का काम हब के फ़्लीट मैनेजर लॉगिन से होता है।';

  @override
  String get allocationFleetOnlyTitle => 'इस लॉगिन के लिए उपलब्ध नहीं';

  @override
  String get allocationFront => 'आगे';

  @override
  String get allocationHandoverCompleteMessage =>
      'ट्रेनिंग पूरी हो गई और स्कूटर राइडर के पास है। यह हैंडओवर पूरा हो गया।';

  @override
  String get allocationHandoverHistory => 'सौंपने का इतिहास';

  @override
  String get allocationHelmetHandedOver => 'हेलमेट सौंपा गया';

  @override
  String get allocationHornMirrors => 'हॉर्न और शीशे';

  @override
  String get allocationIdle => 'खाली';

  @override
  String get allocationInspectionAcceptedTraining => 'जांच स्वीकार · ट्रेनिंग';

  @override
  String get allocationInspectionSentRider => 'जांच राइडर को भेजी गई';

  @override
  String get allocationInspectionSentRider2 => 'जांच राइडर को भेजी गई';

  @override
  String get allocationLeftSide => 'बायां हिस्सा';

  @override
  String get allocationLightsIndicators => 'लाइट और इंडिकेटर';

  @override
  String get allocationMarkAsPaid => 'भुगतान हुआ लगाएं';

  @override
  String get allocationMatchWaitingRiderWithVehicle => 'इंतज़ार कर रहे राइडर को गाड़ी दें, फिर हैंडओवर पूरा कराएं';

  @override
  String get allocationMove => 'अब आपकी बारी';

  @override
  String get allocationNoBatteryPlan => 'बैटरी प्लान नहीं';

  @override
  String get allocationNobodyWaiting => 'कोई इंतज़ार में नहीं';

  @override
  String get allocationNoHandoversProgress => 'कोई हैंडओवर नहीं चल रहा';

  @override
  String get allocationNoTeamLeads => 'कोई टीम लीड नहीं मिला';

  @override
  String get allocationNoTeamLeadsMessage => 'अपने एडमिन से एक सक्रिय टीम लीड जोड़ने को कहें।';

  @override
  String get allocationNothingCurrentlyAllocatedRider => 'अभी किसी राइडर को कुछ नहीं दिया गया है।';

  @override
  String get allocationNoVehiclesOut => 'कोई गाड़ी बाहर नहीं';

  @override
  String get allocationNoVehiclesReady => 'कोई गाड़ी तैयार नहीं';

  @override
  String get allocationNoWorkPartners => 'कोई काम का साथी नहीं मिला';

  @override
  String get allocationNoWorkPartnersMessage => 'अपने एडमिन से काम के साथी जोड़ने को कहें।';

  @override
  String get allocationPaymentCouldNotLoad => 'पेमेंट लोड नहीं हो सका';

  @override
  String get allocationPaymentNoScreenshot => 'राइडर ने स्क्रीनशॉट नहीं जोड़ा।';

  @override
  String get allocationPaymentReceived => 'भुगतान मिल गया?';

  @override
  String get allocationPaymentRejected => 'पेमेंट रिजेक्ट हुआ। राइडर इसे ठीक करके फिर भेज सकता है।';

  @override
  String allocationPaymentRejectedNote(String reason) {
    return 'आपने यह पेमेंट रिजेक्ट किया: $reason। राइडर के दोबारा भेजने का इंतज़ार है।';
  }

  @override
  String get allocationPaymentRequested => 'भुगतान मांगा गया';

  @override
  String get allocationPaymentRequestedAmount => 'मांगा गया पेमेंट';

  @override
  String get allocationPaymentRequestedRiderSeesNow => 'भुगतान मांगा गया, राइडर को अब दिख रहा है';

  @override
  String get allocationPaymentScreenshots => 'पेमेंट के स्क्रीनशॉट';

  @override
  String get allocationPaymentVerified => 'भुगतान जांच लिया गया';

  @override
  String get allocationPaymentWaitingRider => 'राइडर ने अभी तक पेमेंट की जानकारी नहीं भेजी है।';

  @override
  String get allocationPhotoBack => 'पीछे';

  @override
  String get allocationPhotoCannotOpen => 'यह फ़ोटो अभी नहीं खुल सकती।';

  @override
  String get allocationPhotoDeclaration => 'घोषणा पत्र';

  @override
  String get allocationPhotoFront => 'आगे';

  @override
  String get allocationPhotoLeft => 'बाईं ओर';

  @override
  String get allocationPhotoRider => 'वाहन के साथ राइडर';

  @override
  String get allocationPhotoRight => 'दाईं ओर';

  @override
  String get allocationPhotoUploaded => 'अपलोड हो गई';

  @override
  String get allocationPlanAcceptedChip => 'राइडर ने स्वीकार किया';

  @override
  String get allocationPlanAwaitingBody =>
      'राइडर के अपने ऐप में इस प्लान को स्वीकार करने का इंतज़ार है। स्वीकार होने तक आप इसे बदल सकते हैं।';

  @override
  String get allocationPlanAwaitingChip => 'राइडर का इंतज़ार';

  @override
  String get allocationPlanCouldNotLoad => 'रेंटल प्लान लोड नहीं हो सके';

  @override
  String get allocationPlanExchangeBody =>
      'यह स्कूटर एक्सचेंज में दिया जा रहा है। राइडर का एक्सचेंज प्लान आगे चलेगा, इसलिए कोई नया प्लान या डिपॉज़िट नहीं लेना है।';

  @override
  String get allocationPlanExchangeChip => 'एक्सचेंज प्लान';

  @override
  String get allocationPlanExpiredBody =>
      'प्लान ऑफ़र की समय-सीमा खत्म हो गई या उसे बदल दिया गया। फिर से प्लान चुनकर राइडर को भेजें।';

  @override
  String get allocationPlanNoneBody =>
      'इस स्कूटर और हब के लिए कोई प्रकाशित रेंटल प्लान नहीं है। अपने एडमिन से रेट कार्ड प्रकाशित करने को कहें।';

  @override
  String get allocationPlanNoneTitle => 'कोई प्लान उपलब्ध नहीं';

  @override
  String get allocationPlanNotChosenBody =>
      'इस राइडर के लिए रेंटल प्लान चुनें। राइडर इसे अपने ऐप में देखकर स्वीकार करेगा, और पेमेंट इसी से तय होगा।';

  @override
  String get allocationPlanNotChosenChip => 'नहीं चुना गया';

  @override
  String get allocationPlanPickSubtitle => 'कीमतें इस राइडर, स्कूटर और हब के हिसाब से तय होती हैं।';

  @override
  String get allocationPlanPickTitle => 'रेंटल प्लान चुनें';

  @override
  String get allocationPlanSend => 'राइडर को भेजें';

  @override
  String get allocationPlanSentSnack => 'प्लान भेज दिया गया। राइडर इसे अपने ऐप में स्वीकार कर सकता है।';

  @override
  String get allocationPlanTitle => 'रेंटल प्लान';

  @override
  String get allocationPlanWaitingButton => 'राइडर की स्वीकृति का इंतज़ार';

  @override
  String get allocationReason => 'कारण';

  @override
  String get allocationRejectConfirm => 'पेमेंट रिजेक्ट करें';

  @override
  String get allocationRejectPayment => 'रिजेक्ट करें';

  @override
  String get allocationRejectReason => 'आप इसे क्यों रिजेक्ट कर रहे हैं?';

  @override
  String get allocationRejectReasonHint => 'उदाहरण: रेफरेंस मिली हुई रकम से मेल नहीं खाता';

  @override
  String get allocationRejectReasonNeeded => 'कम से कम 3 अक्षर लिखें';

  @override
  String get allocationReserved2 => 'रोकने की तिथि';

  @override
  String get allocationReviewPayment => 'पेमेंट जाँचें';

  @override
  String get allocationRider => 'राइडर';

  @override
  String get allocationRiderCompletingSafetyTrainingTheir =>
      'राइडर अपने ऐप में सुरक्षा ट्रेनिंग पूरी कर रहा है। हर अनिवार्य पाठ पूरा होते ही स्कूटर सौंप दिया जाएगा।';

  @override
  String get allocationRiderGoingThroughChecklistTheir =>
      'राइडर अपने ऐप में आपकी सूची देख रहा है। जिन्हें वे अस्वीकार करते हैं वे नोट के साथ वापस आती हैं।';

  @override
  String get allocationRiderNoLongerWaitingVehicle => 'यह राइडर अब गाड़ी का इंतज़ार नहीं कर रहा।';

  @override
  String get allocationRiding => 'चल रही है';

  @override
  String get allocationRightSide => 'दायां हिस्सा';

  @override
  String get allocationRoad => 'सड़क पर';

  @override
  String allocationScooterAge(int months) {
    return 'स्कूटर की उम्र (महीने): $months';
  }

  @override
  String get allocationSearchRiderNameCodeMobile => 'राइडर का नाम, कोड या मोबाइल खोजें';

  @override
  String get allocationSearchRiderVehicle => 'राइडर या गाड़ी खोजें';

  @override
  String get allocationSearchRiderVehicleNumber => 'राइडर या गाड़ी नंबर खोजें';

  @override
  String get allocationSearchTeamLead => 'नाम, मोबाइल या कर्मचारी कोड से खोजें';

  @override
  String get allocationSearchWorkPartner => 'काम के साथी खोजें';

  @override
  String get allocationSendPaymentRequest => 'भुगतान की मांग भेजें';

  @override
  String get allocationSendRider => 'राइडर को भेजें';

  @override
  String get allocationStartReturn => 'वापसी शुरू करें';

  @override
  String get allocationStepPhotos => 'फ़ोटो और जाँच';

  @override
  String get allocationStepRider => 'राइडर जाँच और ट्रेनिंग';

  @override
  String get allocationTeamLead => 'टीम लीड';

  @override
  String get allocationTeamLeadMissing =>
      'अभी कोई टीम लीड नहीं है। इसके बिना हैंडओवर पूरा नहीं हो सकता, इसलिए एक चुनें।';

  @override
  String get allocationTeamLeadNotSaved =>
      'स्कूटर रिज़र्व हो गया, लेकिन टीम लीड सेव नहीं हुआ। इसे अलॉटमेंट पेज पर असाइन करें।';

  @override
  String get allocationTeamLeadPickerSubtitle => 'टीम लीड इस राइडर की देखरेख करेगा।';

  @override
  String get allocationTeamLeadRequired =>
      'इस हैंडओवर के लिए पहले एक टीम लीड चाहिए। फ्लीट मैनेजर इसे अलॉटमेंट पेज पर असाइन कर सकते हैं।';

  @override
  String allocationTeamLeadRiderCount(int count) {
    return 'राइडर: $count';
  }

  @override
  String get allocationTeamLeadSaved => 'टीम लीड सेव हो गया';

  @override
  String get allocationTyresPressure => 'टायर और हवा';

  @override
  String get allocationUploadEvidenceContinue => 'आगे बढ़ने के लिए सबूत अपलोड करें';

  @override
  String get allocationVehicleHasAvailableOnboardedAllocation =>
      'यहां दिखने के लिए गाड़ी आपके किसी हब में उपलब्ध, पूरी तरह जुड़ी और देने योग्य होनी चाहिए।';

  @override
  String get allocationVehiclePhotos => 'वाहन की फ़ोटो';

  @override
  String get allocationVehiclePhotosHint =>
      'वाहन की हर तरफ़ की फ़ोटो, वाहन के साथ राइडर की एक फ़ोटो और हस्ताक्षर किए गए घोषणा पत्र की एक फ़ोटो लें। जाँच जमा करने से पहले सभी फ़ोटो ज़रूरी हैं।';

  @override
  String get allocationVehicleReserved => 'गाड़ी रोक ली गई';

  @override
  String get allocationVerifyPayment => 'भुगतान जांचें';

  @override
  String get allocationWaiting => 'इंतज़ार में';

  @override
  String get allocationWaitingRider => 'राइडर का इंतज़ार';

  @override
  String get allocationWaitingRiderAcceptInspection => 'राइडर के जांच स्वीकार करने का इंतज़ार';

  @override
  String get allocationWaitingRiderFinishTraining => 'राइडर के ट्रेनिंग पूरी करने का इंतज़ार';

  @override
  String get allocationWaitingRiderInspection => 'राइडर का इंतज़ार: जांच';

  @override
  String get allocationWaitingRiderPageRefreshesIts => 'राइडर का इंतज़ार, यह पेज अपने आप ताज़ा होता रहेगा।';

  @override
  String get allocationWaitingRiderTraining => 'राइडर का इंतज़ार: ट्रेनिंग';

  @override
  String get allocationWorkPartner => 'काम का साथी';

  @override
  String get allocationWorkPartnerHelper => 'वह कंपनी जिसके लिए यह राइडर काम करेगा।';

  @override
  String get allocationWorkPartnerNeeded => 'राइडर का काम का साथी चुनें';

  @override
  String get appGoHome => 'होम पर जाएं';

  @override
  String get authChangeNumber => 'नंबर बदलें';

  @override
  String get authCodeDidNotVerifyPlease => 'यह कोड जांच में सही नहीं निकला। फिर कोशिश करें।';

  @override
  String get authContinue => 'आगे बढ़ें';

  @override
  String get authEditNumber => 'नंबर बदलें';

  @override
  String authLegalAgreement(String terms, String privacy) {
    return 'आगे बढ़ें पर क्लिक करके आप हमारी $terms और $privacy स्वीकार कर रहे हैं';
  }

  @override
  String get authLegalPrivacy => 'निजता नीति';

  @override
  String get authLegalTerms => 'सेवा की शर्तें';

  @override
  String get authLiveFleetVisibility => 'फ़्लीट की\nलाइव जानकारी';

  @override
  String get authNumberVerified => 'नंबर जांच लिया गया';

  @override
  String get authOnlyNumbersRegisteredByAdmin => 'सिर्फ़ आपके एडमिन के दर्ज किए नंबर ही साइन इन कर सकते हैं';

  @override
  String get authOpsSupport => '24x7 ऑपरेशन\nसहायता';

  @override
  String authOtpSentTo(String mobile) {
    return '+91 $mobile पर 6 अंकों का कोड भेजा गया';
  }

  @override
  String get authResendCode => 'कोड दोबारा भेजें';

  @override
  String authResendCodeIn(String seconds) {
    return '$seconds में कोड दोबारा भेजें';
  }

  @override
  String get authRoadsideHelp => '24x7\nसड़क पर मदद';

  @override
  String get authSameDayPayouts => 'उसी दिन\nभुगतान';

  @override
  String get authSessionEncryptedEndEnd => 'आपका सेशन पूरी तरह सुरक्षित है';

  @override
  String get authSignRunHub => 'अपना हब चलाने के लिए साइन इन करें';

  @override
  String get authSignWithMobileNumberRegistered =>
      'आवंटन, राइडर और मरम्मत संभालने के लिए अपने हब में दर्ज मोबाइल नंबर से साइन इन करें।';

  @override
  String get authSignWithMobileNumberRegistered2 => 'अपने फ़्लीट ऑपरेटर के पास दर्ज मोबाइल नंबर से साइन इन करें।';

  @override
  String get authVerifiedHubNetwork => 'जांचा हुआ\nहब नेटवर्क';

  @override
  String get authVerifiedOperators => 'जांचे हुए\nऑपरेटर';

  @override
  String get authVerifying => 'जांचा जा रहा है…';

  @override
  String get authVerifyingNumber => 'आपका नंबर जांचा जा रहा है…';

  @override
  String get authVerifyNumber => 'अपना नंबर जांचें';

  @override
  String get authWelcomeBack => 'वापसी पर स्वागत है';

  @override
  String get authWhyChooseUs => 'हमें क्यों चुनें';

  @override
  String get authWhyRideWithUs => 'हमारे साथ क्यों चलें';

  @override
  String get authWillText6DigitCode => 'हम आपको 6 अंकों का कोड भेजेंगे';

  @override
  String get authWrongNumber => 'ग़लत नंबर?';

  @override
  String get checkInBasicReport => 'मैकेनिक रिपोर्ट';

  @override
  String checkInConfirmedByManager(String reason) {
    return 'हब टीम ने आपके कोड के बिना पुष्टि की: $reason';
  }

  @override
  String get checkInConfirmedByOtp => 'आपके कोड से पुष्टि हुई।';

  @override
  String get checkInCouldNotLoad => 'सबमिशन लोड नहीं हो सका।';

  @override
  String get checkInDeepReport => 'अंतिम मैकेनिक जाँच';

  @override
  String get checkInHub => 'हब';

  @override
  String get checkInNoCharges => 'कोई शुल्क नहीं';

  @override
  String get checkInOtpHint =>
      'आपके फ़ोन पर एक कोड आएगा। इस रिपोर्ट और इसके शुल्क की पुष्टि के लिए इसे हब टीम को बताएँ।';

  @override
  String get checkInPhotos => 'फ़ोटो';

  @override
  String checkInPhotosCount(int taken, int total) {
    return '$total में से $taken ली गईं';
  }

  @override
  String get checkInSafe => 'फिर से इस्तेमाल के लिए सुरक्षित';

  @override
  String get checkInStatusDraft => 'समीक्षा में';

  @override
  String get checkInStatusPosted => 'पुष्टि हो गई';

  @override
  String get checkInStatusSubmitted => 'पुष्टि बाकी';

  @override
  String get checkInTitle => 'स्कूटर सबमिशन';

  @override
  String get checkInTotal => 'कुल शुल्क';

  @override
  String checkInUnsafe(String reason) {
    return 'दोबारा इस्तेमाल के लिए सुरक्षित नहीं: $reason';
  }

  @override
  String get checkInViewPhotos => 'देखें';

  @override
  String get checkInWaitingReport => 'हब टीम फ़ोटो ले रही है। मैकेनिक की रिपोर्ट तैयार होते ही यहाँ दिखेगी।';

  @override
  String get commonAboutApp => 'इस ऐप के बारे में';

  @override
  String get commonAbsent => 'गैरहाज़िर';

  @override
  String get commonAccountCannotDo => 'आपका खाता यह नहीं कर सकता।';

  @override
  String get commonAccountNumbersDoNotMatch => 'खाता नंबर मेल नहीं खा रहे';

  @override
  String get commonAccountNumbersMatch => 'खाता नंबर मिल गए';

  @override
  String get commonAddAnotherReference => 'एक और रेफ़रेंस जोड़ें';

  @override
  String get commonAddNominee => 'नॉमिनी जोड़ें';

  @override
  String get commonAddPhoto => 'फ़ोटो जोड़ें';

  @override
  String get commonAllocated => 'दी गई तिथि';

  @override
  String get commonAllocation => 'आवंटन';

  @override
  String get commonAppWillChangeRightAway => 'ऐप तुरंत बदल जाएगा।';

  @override
  String get commonAttendance => 'हाज़िरी';

  @override
  String get commonBankAccountNumber => 'बैंक खाता नंबर';

  @override
  String get commonBrakes => 'ब्रेक';

  @override
  String get commonBrother => 'भाई';

  @override
  String get commonCamera => 'कैमरा';

  @override
  String get commonCameraAccessNeeded => 'फ़ोटो लेने के लिए Settings में कैमरा की अनुमति दें।';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonCanChangeLaterFromMenu => 'आप इसे बाद में मेन्यू से बदल सकते हैं।';

  @override
  String get commonCategory => 'श्रेणी';

  @override
  String get commonChooseLanguage => 'अपनी भाषा चुनें';

  @override
  String get commonCity => 'शहर';

  @override
  String get commonColleague => 'सहकर्मी';

  @override
  String get commonColour => 'रंग';

  @override
  String get commonConfirm => 'पक्का करें';

  @override
  String get commonConfirmAccountNumber => 'खाता नंबर दोबारा डालें';

  @override
  String get commonCouldNotOpenDocumentTry => 'दस्तावेज़ नहीं खुला। फिर कोशिश करें।';

  @override
  String get commonCouldNotReadLocalData => 'फ़ोन का डेटा पढ़ नहीं पाए।';

  @override
  String get commonDaughter => 'बेटी';

  @override
  String get commonEnterAccountNumber => 'अपना खाता नंबर डालें';

  @override
  String get commonEnterValid10DigitMobile => 'सही 10 अंकों का मोबाइल नंबर डालें';

  @override
  String get commonFather => 'पिता';

  @override
  String get commonFriend => 'दोस्त';

  @override
  String get commonFullName => 'पूरा नाम';

  @override
  String get commonGallery => 'गैलरी';

  @override
  String get commonHandover => 'सौंपना';

  @override
  String get commonHaveAlreadyUsedNumberAnother => 'आप यह नंबर किसी और रेफ़रेंस के लिए पहले ही दे चुके हैं';

  @override
  String get commonHintGuardian => 'जैसे अभिभावक';

  @override
  String get commonHowTheyRelated => 'वे आपके क्या लगते हैं?';

  @override
  String get commonIncentives => 'इनाम';

  @override
  String get commonIotUnit => 'डिवाइस';

  @override
  String get commonJpgPngPdfUp5 => 'JPG, PNG या PDF · 5 MB तक';

  @override
  String get commonLanguage => 'भाषा';

  @override
  String get commonLoadMore => 'और दिखाएँ';

  @override
  String get commonMake100 => 'इसे 100% करें';

  @override
  String get commonManager => 'मैनेजर';

  @override
  String get commonMandatory => 'अनिवार्य';

  @override
  String get commonMarkedPresentShiftHasStarted => 'हाज़िरी लग गई। आपकी शिफ़्ट शुरू हो गई।';

  @override
  String get commonMobile => 'मोबाइल';

  @override
  String get commonMobileNumber => 'मोबाइल नंबर';

  @override
  String get commonModel => 'मॉडल';

  @override
  String get commonMother => 'माता';

  @override
  String get commonNoInternetConnection => 'इंटरनेट कनेक्शन नहीं है।';

  @override
  String get commonNominationComplete => 'आपका नॉमिनेशन पूरा हो गया।';

  @override
  String get commonNotFound => 'नहीं मिला।';

  @override
  String get commonNow => 'अभी';

  @override
  String get commonOdometer => 'ओडोमीटर';

  @override
  String get commonOff => 'बंद';

  @override
  String get commonOn => 'चालू';

  @override
  String get commonOpen => 'खोलें';

  @override
  String get commonOptional => 'वैकल्पिक';

  @override
  String get commonOther => 'अन्य';

  @override
  String get commonOtherRelationship => 'दूसरा रिश्ता';

  @override
  String get commonOwnNumberUseDifferentOne => 'यह आपका ही नंबर है। कोई दूसरा डालें।';

  @override
  String get commonPaidDate => 'अब तक भुगतान';

  @override
  String get commonPayment => 'भुगतान';

  @override
  String get commonPending => 'बाकी';

  @override
  String get commonPreDeliveryInspection => 'डिलीवरी से पहले जांच';

  @override
  String get commonPresent => 'हाज़िर';

  @override
  String get commonPrivacyPolicy => 'निजता नीति';

  @override
  String get commonProfile => 'प्रोफ़ाइल';

  @override
  String get commonRaised => 'दर्ज हुआ';

  @override
  String get commonRefresh => 'रिफ्रेश करें';

  @override
  String get commonRejectedUploadAgain => 'अस्वीकार, दोबारा अपलोड करें';

  @override
  String commonRejectionReason(String reason) {
    return 'कारण: $reason';
  }

  @override
  String get commonRelationship => 'रिश्ता';

  @override
  String get commonRemove => 'हटाएं';

  @override
  String get commonRetake => 'दोबारा लें';

  @override
  String get commonRetry => 'फिर कोशिश करें';

  @override
  String get commonSave => 'सेव करें';

  @override
  String get commonScooter => 'आपका स्कूटर';

  @override
  String get commonSearch => 'खोजें';

  @override
  String get commonSelect => 'चुनें';

  @override
  String get commonSelectDate => 'तारीख चुनें';

  @override
  String get commonSessionHasExpiredPleaseSign => 'आपका सेशन ख़त्म हो गया। दोबारा साइन इन करें।';

  @override
  String get commonShare => 'शेयर';

  @override
  String get commonSharesAddUp100 => 'हिस्से मिलाकर 100% हो गए';

  @override
  String get commonSignBeforeReadingClientConfiguration => 'क्लाइंट सेटिंग पढ़ने से पहले साइन इन करें।';

  @override
  String get commonSignContinue => 'आगे बढ़ने के लिए साइन इन करें।';

  @override
  String get commonSignOut => 'साइन आउट';

  @override
  String get commonSignOut2 => 'साइन आउट करें?';

  @override
  String get commonSister => 'बहन';

  @override
  String get commonSkip => 'छोड़ें';

  @override
  String get commonSomethingWentWrongPleaseTry => 'कुछ गड़बड़ हो गई। फिर कोशिश करें।';

  @override
  String get commonSon => 'बेटा';

  @override
  String get commonSpouse => 'जीवनसाथी';

  @override
  String get commonStatus => 'स्थिति';

  @override
  String get commonSubmitInspection => 'जांच जमा करें';

  @override
  String get commonSupport => 'सहायता';

  @override
  String get commonTakeOneNowChooseFrom => 'अभी एक लें, या गैलरी से चुनें';

  @override
  String get commonTeamLead => 'टीम लीड';

  @override
  String get commonTellUsHowTheyRelated => 'बताएं वे आपके क्या लगते हैं';

  @override
  String get commonTermsService => 'सेवा की शर्तें';

  @override
  String get commonTheirName => 'उनका नाम';

  @override
  String get commonTooManyAttemptsWaitMoment => 'बहुत बार कोशिश हो चुकी। थोड़ा रुकें।';

  @override
  String get commonTotal => 'कुल';

  @override
  String get commonTryAgain => 'फिर कोशिश करें';

  @override
  String get commonTypeAgain => 'इसे दोबारा लिखें';

  @override
  String get commonUpload => 'अपलोड करें';

  @override
  String get commonUploaded => 'अपलोड हो गया';

  @override
  String get commonVehicle => 'गाड़ी';

  @override
  String get commonVersion => 'संस्करण';

  @override
  String get commonWallet => 'वॉलेट';

  @override
  String get commonWhatHappensNext => 'आगे क्या होगा';

  @override
  String get commonWillNeedMobileNumberOtp => 'दोबारा साइन इन करने के लिए आपको मोबाइल नंबर और ओटीपी चाहिए होगा।';

  @override
  String get companyCodeHint => 'जैसे yogmaya';

  @override
  String get companyCodeLabel => 'कंपनी कोड';

  @override
  String get companyCodeRequired => 'अपना कंपनी कोड डालें';

  @override
  String get companyHelp => 'यह कोड आपके वेलकम मैसेज में मिलेगा। अगर आपके पास नहीं है, तो अपनी हब टीम से पूछें।';

  @override
  String get companyNotFound => 'इस कोड वाली कोई कंपनी नहीं मिली। कोड जाँचकर फिर से कोशिश करें।';

  @override
  String get companyNotReady => 'यह कंपनी अभी ऐप के लिए तैयार नहीं है। कृपया अपने फ़्लीट ऑपरेटर से संपर्क करें।';

  @override
  String get companySubtitle => 'अपने फ़्लीट ऑपरेटर का दिया हुआ कंपनी कोड डालें। यह सिर्फ़ एक बार करना होगा।';

  @override
  String get companyTitle => 'अपनी कंपनी खोजें';

  @override
  String companyWelcome(String name) {
    return '$name में आपका स्वागत है';
  }

  @override
  String get consentAgree =>
      'मैं घोषणा करता/करती हूँ कि मैंने इस सहमति फ़ॉर्म की सभी बातें समझ ली हैं और डेटा प्रिंसिपल के तौर पर अपनी सहमति देता/देती हूँ।';

  @override
  String get consentReviewLatest =>
      'ऐप का इस्तेमाल जारी रखने के लिए कृपया इस सहमति का नया संस्करण पढ़ें और उसे स्वीकार करें।';

  @override
  String get consentRiderTitle => 'राइडर सहमति';

  @override
  String get consentSubtitle =>
      'कृपया पढ़ें कि हम आपकी जानकारी कैसे इकट्ठा और इस्तेमाल करते हैं, फिर आगे बढ़ने के लिए अपनी सहमति दें।';

  @override
  String get damageChargeAmountToPay => 'भरने की राशि';

  @override
  String get damageChargeCancelledBody => 'यह शुल्क रद्द कर दिया गया है। आपको इसे भरने की ज़रूरत नहीं है।';

  @override
  String get damageChargeCouldNotLoad => 'यह शुल्क लोड नहीं हो सका';

  @override
  String get damageChargeCreditUsed => 'इस्तेमाल हुआ क्रेडिट';

  @override
  String damageChargeEach(String amount) {
    return '$amount प्रति नग';
  }

  @override
  String get damageChargeLeftToPay => 'बाकी राशि';

  @override
  String get damageChargePaidBody => 'आपने यह शुल्क पूरा भर दिया है।';

  @override
  String get damageChargePaidMessage => 'भुगतान हो गया। धन्यवाद!';

  @override
  String get damageChargePaidSoFar => 'अब तक भुगतान';

  @override
  String get damageChargePaidTitle => 'पूरा भुगतान हो गया';

  @override
  String damageChargePay(String amount) {
    return '$amount भरें';
  }

  @override
  String damageChargePayAtHubMessage(String amount) {
    return 'आपके वॉलेट से पूरी राशि नहीं भरी जा सकी। ऐप में अभी ऑनलाइन भुगतान उपलब्ध नहीं है, इसलिए बाकी $amount अपने हब पर भरें।';
  }

  @override
  String get damageChargePayAtHubTitle => 'बाकी राशि हब पर भरें';

  @override
  String get damageChargePayConfirmMessage => 'पहले आपके वॉलेट बैलेंस का इस्तेमाल होगा।';

  @override
  String damageChargePayConfirmTitle(String amount) {
    return '$amount भरें?';
  }

  @override
  String get damageChargePaymentsOff => 'अभी भुगतान बंद हैं। कृपया बाद में फिर कोशिश करें, या अपने हब पर भरें।';

  @override
  String damageChargeRaisedOn(String date) {
    return '$date को लगाया गया';
  }

  @override
  String get damageChargesAll => 'सभी';

  @override
  String get damageChargesCouldNotLoad => 'नुकसान के शुल्क लोड नहीं हो सके';

  @override
  String get damageChargesNoneMessage => 'स्कूटर लौटाते या बदलते समय हब को नुकसान मिलता है, तो उसका शुल्क यहाँ दिखेगा।';

  @override
  String get damageChargesNoneTitle => 'कोई नुकसान शुल्क नहीं';

  @override
  String get damageChargesNothingToPay => 'भरने के लिए कुछ नहीं';

  @override
  String get damageChargesNothingToPayMessage => 'आपका कोई नुकसान शुल्क बकाया नहीं है।';

  @override
  String get damageChargesNoUnpaid => 'कोई नुकसान शुल्क बकाया नहीं';

  @override
  String get damageChargesSeeAll => 'सभी देखें';

  @override
  String get damageChargeStatusCancelled => 'रद्द';

  @override
  String get damageChargeStatusPaid => 'भुगतान हो गया';

  @override
  String get damageChargeStatusPartlyPaid => 'आंशिक भुगतान';

  @override
  String get damageChargesTitle => 'नुकसान के शुल्क';

  @override
  String damageChargesToPay(int count) {
    return '$count भरने हैं';
  }

  @override
  String get damageChargesUnpaid => 'बकाया';

  @override
  String get damageChargesViewAndPay => 'देखें और भरें';

  @override
  String get damageChargeTitle => 'नुकसान का शुल्क';

  @override
  String get damageChargeTotal => 'कुल शुल्क';

  @override
  String get damageChargeWhatWasCharged => 'किस चीज़ का शुल्क';

  @override
  String get deallocAccessoriesReturned => 'लौटाए गए सामान';

  @override
  String get deallocAnyNewDamageRecordHere =>
      'यहां दर्ज किया गया कोई भी नया नुक़सान राइडर की सुरक्षा जमा राशि से आंका जाता है, इसलिए उसे साफ़-साफ़ दर्ज करें।';

  @override
  String get deallocAssessment => 'आकलन';

  @override
  String get deallocAvailable => 'उपलब्ध';

  @override
  String get deallocBatteryReturnedHub => 'बैटरी हब को लौटाई गई';

  @override
  String get deallocBothRiderTeamLeadMust => 'राइडर और टीम लीड दोनों को पक्का करना होगा';

  @override
  String get deallocChargerCable => 'चार्जर और केबल';

  @override
  String get deallocChargeReturn => 'वापसी के समय चार्ज';

  @override
  String get deallocCloseRide => 'सवारी बंद करें';

  @override
  String get deallocCodesValid10MinutesAsk =>
      'कोड 10 मिनट तक चलते हैं। हर व्यक्ति से उनका कोड बुलवाएं, उनका फ़ोन न लें।';

  @override
  String get deallocCompareAgainstHandoverSet => 'हैंडओवर वाली फ़ोटो से मिलाएं';

  @override
  String get deallocCompleteDeAllocation => 'वापसी पूरी करें';

  @override
  String get deallocComponents => 'पुर्ज़े';

  @override
  String get deallocConditionAssessment => 'हालत का आकलन';

  @override
  String get deallocConfirmBatteryBack => 'पक्का करें कि बैटरी वापस आ गई है';

  @override
  String get deallocContinueAssessment => 'आकलन पर बढ़ें';

  @override
  String get deallocContinueVerification => 'जांच पर बढ़ें';

  @override
  String get deallocDamaged => 'नुक़सान हुआ';

  @override
  String get deallocDamageDescription => 'नुक़सान का विवरण';

  @override
  String get deallocDeductedFromRidersSecurityDeposit => 'जांच के बाद राइडर की सुरक्षा जमा राशि से काटा जाता है।';

  @override
  String get deallocDescribeDamage => 'नुक़सान बताएं';

  @override
  String get deallocEndRideContinue => 'आगे बढ़ने के लिए सवारी बंद करें';

  @override
  String get deallocEndRidersActiveRide => 'राइडर की चालू सवारी बंद करें';

  @override
  String get deallocEnterAll6Digits => 'पूरे 6 अंक डालें';

  @override
  String get deallocEnterClosingOdometer => 'वापसी का ओडोमीटर डालें';

  @override
  String get deallocEnterRidersCode => 'राइडर का कोड डालें';

  @override
  String get deallocEnterTeamLeadsCode => 'टीम लीड का कोड डालें';

  @override
  String get deallocEstimatedRecovery => 'अनुमानित वसूली';

  @override
  String get deallocExcellent => 'बहुत अच्छी';

  @override
  String get deallocGood => 'ठीक-ठाक';

  @override
  String get deallocLoggedBackIntoChargingBay => 'चार्जिंग बे की सूची में दोबारा दर्ज हो गई।';

  @override
  String get deallocMinorScuffsNothingRecover => 'हल्की खरोंचें, वसूलने लायक कुछ नहीं';

  @override
  String get deallocNoDamageBeyondNormalWear => 'सामान्य घिसावट के अलावा कोई नुक़सान नहीं';

  @override
  String get deallocNotUsableUntilFurtherNotice => 'अगली सूचना तक इस्तेमाल लायक नहीं';

  @override
  String get deallocOdometerReturn => 'वापसी पर ओडोमीटर';

  @override
  String get deallocOffRoad => 'सड़क से बाहर';

  @override
  String get deallocPhotographVehicleExactlyAsCame => 'गाड़ी को ठीक उसी हालत में फ़ोटो लें जैसी वह लौटी है';

  @override
  String get deallocRcInsurancePuc => 'आरसी, बीमा और पीयूसी';

  @override
  String get deallocReadyAllocateAnotherRider => 'किसी और राइडर को देने के लिए तैयार';

  @override
  String get deallocRecordVehicleCondition => 'गाड़ी की हालत दर्ज करें';

  @override
  String get deallocRecordWhatComesBackWhat => 'क्या लौटा और क्या नहीं, दर्ज करें';

  @override
  String get deallocRecoverableDamageRaiseMaintenanceJob => 'वसूलने लायक नुक़सान, मरम्मत का काम दर्ज करें';

  @override
  String get deallocReturnCondition => 'वापसी की हालत';

  @override
  String get deallocReturnPhotos => 'वापसी की फ़ोटो';

  @override
  String get deallocRiderConfirmation => 'राइडर की पुष्टि';

  @override
  String get deallocSendWorkshopFirst => 'पहले वर्कशॉप भेजें';

  @override
  String get deallocService => 'सर्विस में';

  @override
  String get deallocSetFleetStatus => 'गाड़ी की स्थिति तय करें';

  @override
  String get deallocSetFleetStatus2 => 'गाड़ी की स्थिति तय करें';

  @override
  String get deallocStopsTelemetryClosesShiftSettles =>
      'जानकारी आना बंद होता है, शिफ़्ट बंद होती है और आख़िरी ट्रिप निपट जाता है।';

  @override
  String get deallocTeamLeadConfirmation => 'टीम लीड की पुष्टि';

  @override
  String get deallocTwoPartyVerification => 'दोनों पक्षों की जांच';

  @override
  String get deallocVehicleAngles => 'गाड़ी के कोण';

  @override
  String get deallocVehicleCondition => 'गाड़ी की हालत';

  @override
  String get deallocVerification => 'जांच';

  @override
  String get deallocWhatDamagedHowBadly => 'क्या ख़राब हुआ, और कितना';

  @override
  String get deploymentAcceptScooter => 'स्कूटर स्वीकार करें';

  @override
  String get deploymentAcceptScooter2 => 'यह स्कूटर स्वीकार करें?';

  @override
  String get deploymentAllSetUp => 'आप पूरी तरह तैयार हैं';

  @override
  String get deploymentAlmostThere => 'बस थोड़ा और';

  @override
  String get deploymentAmountDue => 'बकाया रकम';

  @override
  String get deploymentAwaitingVerification => 'जांच बाकी है';

  @override
  String get deploymentAwaitingVerificationHint => 'आपके फ्लीट मैनेजर जल्द ही इसकी पुष्टि करेंगे।';

  @override
  String get deploymentBankTransfer => 'बैंक ट्रांसफ़र';

  @override
  String get deploymentCard => 'कार्ड';

  @override
  String get deploymentCashHub => 'हब पर नकद';

  @override
  String get deploymentCheckEachItem => 'हर चीज़ जांचें';

  @override
  String get deploymentCheckingWithFleetManagerEvery => 'हर कुछ सेकंड में आपके फ़्लीट मैनेजर से पूछा जा रहा है…';

  @override
  String get deploymentChooseUpiApp => 'UPI ऐप चुनें';

  @override
  String get deploymentConfirmEveryItemHasBeen =>
      'आप पक्का करते हैं कि हर चीज़ टीम लीड के साथ जांची गई है और स्कूटर चलाने लायक है।';

  @override
  String get deploymentCouldNotLoadChecklist => 'सूची नहीं खुल पाई';

  @override
  String get deploymentCouldNotLoadTraining => 'ट्रेनिंग नहीं खुल पाई';

  @override
  String get deploymentCouldNotReachServer => 'सर्वर से जुड़ नहीं पाए';

  @override
  String get deploymentCouldNotSubmitInspection => 'जांच जमा नहीं हो पाई';

  @override
  String get deploymentDone => 'हो गया';

  @override
  String get deploymentEnterTransactionReferencePaidWith => 'जिस रेफ़रेंस से भुगतान किया वह डालें';

  @override
  String get deploymentFinishHygieneCheck => 'स्वच्छता जाँच पूरी करें';

  @override
  String get deploymentFlagAsProblem => 'समस्या बताएं';

  @override
  String get deploymentFlaggedByRider => 'राइडर ने बताया';

  @override
  String get deploymentFleetManagerHasNotAsked => 'आपके फ़्लीट मैनेजर ने अभी भुगतान नहीं मांगा है।';

  @override
  String get deploymentFleetManagerHasNotSubmitted => 'आपके फ़्लीट मैनेजर ने अभी जांच जमा नहीं की है।';

  @override
  String get deploymentFleetManagerPreparingVehicleIts =>
      'आपका फ़्लीट मैनेजर गाड़ी तैयार कर रहा है। तैयार होते ही भुगतान की जानकारी यहां दिखेगी।';

  @override
  String get deploymentFleetManagerPuttingTogetherPayment =>
      'आपका फ़्लीट मैनेजर भुगतान की जानकारी तैयार कर रहा है। थोड़ी देर में आपसे भुगतान मांगा जाएगा।';

  @override
  String get deploymentFleetManagerWillAllocateScooter =>
      'आपका फ़्लीट मैनेजर आपको स्कूटर देगा। ऐसा होते ही हम आपको सीधे यहां ले आएंगे।';

  @override
  String get deploymentGoThroughEachItemWith =>
      'हर चीज़ अपने टीम लीड के साथ जांचें। जो ठीक न हो उसे बताएं, वह आपके नोट के साथ वर्कशॉप जाएगा।';

  @override
  String get deploymentHowDidPay => 'आपने कैसे भुगतान किया?';

  @override
  String get deploymentHygieneComplete => 'स्वच्छता जाँच पूरी हुई';

  @override
  String get deploymentInspection => 'जांच';

  @override
  String get deploymentInspectionAccepted => 'जांच स्वीकार हुई';

  @override
  String get deploymentItemsMarkedAsProblemGo =>
      'जिन चीज़ों को समस्या बताया गया वे आपके नोट के साथ फ़्लीट मैनेजर को जाती हैं। बाकी पर हैंडओवर चलता रहता है।';

  @override
  String deploymentManagerNextStep(String vehicle) {
    return 'आपका फ़्लीट मैनेजर $vehicle के अगले चरण पर है।';
  }

  @override
  String get deploymentNoPaymentShow => 'दिखाने के लिए कोई भुगतान नहीं';

  @override
  String get deploymentNoteWorkshopTeam => 'वर्कशॉप टीम के लिए नोट';

  @override
  String get deploymentNoUpiApps => 'इस फ़ोन पर कोई UPI ऐप नहीं मिला।';

  @override
  String get deploymentOpenEachModuleReadThrough =>
      'हर पाठ खोलकर पूरा पढ़ें। अनिवार्य पाठ पूरे किए बिना आप ख़त्म नहीं कर सकते।';

  @override
  String get deploymentPaidVia => 'इससे चुकाया';

  @override
  String get deploymentPaymentReceived => 'भुगतान मिल गया';

  @override
  String deploymentPaymentRejectedBody(String reason) {
    return 'आपके फ्लीट मैनेजर इस पेमेंट की पुष्टि नहीं कर पाए: $reason। जानकारी जाँचकर फिर से भेजें।';
  }

  @override
  String get deploymentPaymentRejectedTitle => 'पेमेंट की पुष्टि नहीं हुई';

  @override
  String get deploymentPaymentSubmitted => 'भुगतान जमा हो गया';

  @override
  String get deploymentPaymentSupport =>
      'यह पेमेंट अभी ऐप से नहीं भेजा जा सकता। कृपया अपने हब या सपोर्ट से संपर्क करें।';

  @override
  String get deploymentPayScooter => 'अपने स्कूटर का भुगतान करें';

  @override
  String deploymentPayWithUpiApp(String amount) {
    return '$amount UPI ऐप से चुकाएँ';
  }

  @override
  String get deploymentPlanAcceptedSnack => 'प्लान स्वीकार हो गया। अब आपका फ़्लीट मैनेजर पेमेंट मांगेगा।';

  @override
  String get deploymentPlanCouldNotLoad => 'आपका प्लान लोड नहीं हो सका';

  @override
  String get deploymentPlanIntro =>
      'आपके फ़्लीट मैनेजर ने आपके लिए यह प्लान चुना है। किराया और आज देय राशि देखें, शर्तें पढ़ें, फिर आगे बढ़ने के लिए स्वीकार करें।';

  @override
  String get deploymentPlanNextPayment => 'आपने यह प्लान स्वीकार कर लिया है। अब आपका फ़्लीट मैनेजर पेमेंट मांगेगा।';

  @override
  String get deploymentPlanTitle => 'आपका रेंटल प्लान';

  @override
  String get deploymentPreparingScooter => 'आपका स्कूटर तैयार हो रहा है';

  @override
  String get deploymentProgressSavedSignAgainAny => 'आपकी प्रगति सेव है। कभी भी दोबारा साइन इन करके वहीं से शुरू करें।';

  @override
  String get deploymentReceiptAdd => 'स्क्रीनशॉट जोड़ें';

  @override
  String get deploymentReceiptAdded => 'स्क्रीनशॉट जोड़ा गया';

  @override
  String get deploymentReceiptsSent => 'भेजे गए स्क्रीनशॉट';

  @override
  String get deploymentReceiptTitle => 'पेमेंट का स्क्रीनशॉट (वैकल्पिक)';

  @override
  String get deploymentReceiptTooLarge => 'यह इमेज 5 MB से बड़ी है। छोटी इमेज चुनें।';

  @override
  String get deploymentReference => 'रेफ़रेंस';

  @override
  String get deploymentReferenceReceiptNumber => 'रेफ़रेंस या रसीद नंबर';

  @override
  String get deploymentRequired => 'ज़रूरी';

  @override
  String get deploymentRide => 'चलाएं';

  @override
  String get deploymentRiderHygiene => 'राइडर स्वच्छता';

  @override
  String get deploymentScooterReserved => 'स्कूटर रोक लिया गया';

  @override
  String get deploymentSubmitted => 'जमा हो गया';

  @override
  String get deploymentSubmitWithProblemsFlagged => 'समस्याएं बताकर जमा करें?';

  @override
  String get deploymentTransactionReference => 'लेनदेन रेफ़रेंस';

  @override
  String deploymentUpiCouldNotOpen(String app) {
    return '$app नहीं खुल सका। कोई दूसरा ऐप आज़माएँ।';
  }

  @override
  String get deploymentUpiFailed => 'भुगतान नहीं हो पाया। फिर से कोशिश करें या कोई दूसरा ऐप चुनें।';

  @override
  String deploymentUpiOpened(String app) {
    return '$app में भुगतान पूरा करें, फिर वापस आकर UPI रेफ़रेंस डालें।';
  }

  @override
  String get deploymentUpiPaid => 'भुगतान हो गया। हमने UPI रेफ़रेंस भर दिया है। इसे जाँचें, फिर नीचे वाला बटन दबाएँ।';

  @override
  String deploymentUpiPayingTo(String amount, String payee) {
    return '$payee को $amount का भुगतान';
  }

  @override
  String get deploymentUpiProcessing =>
      'आपका भुगतान अभी प्रोसेस हो रहा है। अपना UPI ऐप देखें, फिर नीचे वाला बटन दबाएँ।';

  @override
  String get deploymentUpiTransactionIdEG => 'यूपीआई लेनदेन आईडी, जैसे 4284 7192 3456';

  @override
  String get deploymentWaitingAllocation => 'आवंटन का इंतज़ार';

  @override
  String get deploymentWhatWrong => 'क्या ख़राबी है?';

  @override
  String deploymentWritingPdi(String vehicle) {
    return 'आपका फ़्लीट मैनेजर $vehicle की डिलीवरी से पहले की जांच लिख रहा है। आगे आप उसे देखेंगे।';
  }

  @override
  String get deploymentYourPlan => 'आपका प्लान';

  @override
  String get errorActiveScooterRequired => 'इसके लिए आपके नाम पर स्कूटर होना ज़रूरी है।';

  @override
  String get errorCouldNotReachServerCheck => 'सर्वर से जुड़ नहीं पाए। अपना कनेक्शन जांचें।';

  @override
  String get errorDidNotLookRight => 'यह सही नहीं लगा।';

  @override
  String get errorInspectionWithRider => 'जांच राइडर के पास';

  @override
  String get errorPaymentPending => 'भुगतान बाकी';

  @override
  String get errorRiderProfileMissing => 'राइडर प्रोफ़ाइल नहीं मिली।';

  @override
  String get errorServerTookTooLongAnswer => 'सर्वर ने जवाब देने में बहुत समय लिया।';

  @override
  String get errorSessionHasExpiredSignAgain => 'आपका सेशन ख़त्म हो गया। दोबारा साइन इन करें।';

  @override
  String get errorTrainingProgress => 'ट्रेनिंग चल रही है';

  @override
  String get errorUnknown => 'पता नहीं';

  @override
  String get esignAddNameFirst => 'पहले प्रोफ़ाइल चरण में अपना पूरा नाम जोड़ें';

  @override
  String get esignSigned => 'हस्ताक्षरित';

  @override
  String get esignTapToSign => 'हस्ताक्षर करने के लिए टैप करें';

  @override
  String get esignTitle => 'आपका ई-हस्ताक्षर';

  @override
  String get esignYourName => 'आपका नाम';

  @override
  String get exchangeAcceptConfirm => 'मंज़ूर करने का मतलब है कि आप इस स्कूटर की नई शर्तें मानते हैं।';

  @override
  String get exchangeAccepted => 'ऑफर मंज़ूर हुआ';

  @override
  String get exchangeAcceptedOfferTitle => 'आपका नया प्लान';

  @override
  String get exchangeAcceptOffer => 'ऑफर मंज़ूर करें';

  @override
  String get exchangeAgreementHistory => 'एग्रीमेंट का इतिहास';

  @override
  String get exchangeCancelConfirm => 'यह रिक्वेस्ट बंद कर दी जाएगी।';

  @override
  String get exchangeCancelled => 'रिक्वेस्ट रद्द हुई';

  @override
  String get exchangeCancelRequest => 'रिक्वेस्ट रद्द करें';

  @override
  String get exchangeChooseReason => 'आपको गाड़ी क्यों बदलनी है?';

  @override
  String get exchangeCompleted => 'पूरा हुआ';

  @override
  String get exchangeConsent => 'मैंने यह ऑफ़र पढ़ लिया है और मैं इससे सहमत हूँ';

  @override
  String get exchangeCouldNotLoad => 'बदलने की जानकारी नहीं मिली';

  @override
  String get exchangeCurrentScooter => 'अभी का स्कूटर';

  @override
  String exchangeDepositDue(String amount) {
    return 'नया स्कूटर लेने से पहले $amount और जमा राशि दें।';
  }

  @override
  String get exchangeDepositHeld => 'हब के पास रखी अतिरिक्त जमा राशि';

  @override
  String get exchangeDepositMoved => 'जमा राशि ट्रांसफ़र';

  @override
  String get exchangeDepositRefund => 'जमा राशि वापसी';

  @override
  String get exchangeDepositToPay => 'अतिरिक्त जमा राशि देनी है';

  @override
  String get exchangeDetails => 'रिक्वेस्ट की जानकारी';

  @override
  String get exchangeDetailTitle => 'बदलने की रिक्वेस्ट';

  @override
  String get exchangeErrorAlreadyReturned => 'पुराना स्कूटर पहले ही लौटाया जा चुका है।';

  @override
  String get exchangeErrorBatteryPlan => 'राइडर का बैटरी प्लान इस स्कूटर के लिए उपलब्ध नहीं है।';

  @override
  String get exchangeErrorBillingChanged => 'ऑफर मंज़ूर होने के बाद बिलिंग बदल गई। कृपया सपोर्ट से बात करें।';

  @override
  String get exchangeErrorCannotCancel =>
      'आपका स्कूटर पहले ही लौटाया जा चुका है, इसलिए यहाँ रिक्वेस्ट रद्द नहीं हो सकती। कृपया अपने हब से बात करें।';

  @override
  String get exchangeErrorChanged => 'यह रिक्वेस्ट अभी बदली गई है। नीचे खींचकर रीफ़्रेश करें और फिर कोशिश करें।';

  @override
  String get exchangeErrorDepositsUnsettled => 'जमा राशि अभी तय नहीं हुई। पहले जमा राशि तय करें।';

  @override
  String get exchangeErrorDisabled => 'अभी गाड़ी बदलने की सुविधा चालू नहीं है। कृपया अपने हब से बात करें।';

  @override
  String get exchangeErrorDuesPending =>
      'पहले अपना बकाया चुकाएँ। गाड़ी खराब होने या सुरक्षा के लिए बदलाव अब भी हो सकता है।';

  @override
  String get exchangeErrorHandoverUnfinished => 'नया स्कूटर अभी दिया नहीं गया है। पहले हैंडओवर के स्टेप्स पूरे करें।';

  @override
  String get exchangeErrorHoldExpired => 'स्कूटर रखने का समय खत्म हो गया। नया स्कूटर फिर से चुनें।';

  @override
  String get exchangeErrorInspectionUnfinished => 'पहले वापसी की जाँच पूरी करें।';

  @override
  String get exchangeErrorNoRental => 'आपका कोई चालू किराया नहीं मिला।';

  @override
  String get exchangeErrorNotEligible => 'राइडर इस स्कूटर के लिए योग्य नहीं है।';

  @override
  String get exchangeErrorNoTerms => 'राइडर की शर्तें सेट नहीं हैं। एडमिन से एक सक्रिय शर्तें प्रकाशित करने को कहें।';

  @override
  String get exchangeErrorNotFound => 'यह रिक्वेस्ट अब मौजूद नहीं है।';

  @override
  String get exchangeErrorOfferClosed => 'यह ऑफर अब खुला नहीं है।';

  @override
  String get exchangeErrorOfferInvalid => 'यह ऑफर जाँचा नहीं जा सका। अपने हब से इसे दोबारा भेजने को कहें।';

  @override
  String get exchangeErrorPricingSetup => 'इस स्कूटर की कीमत अभी सेट नहीं है। ऑपरेटर से रेट कार्ड जाँचने को कहें।';

  @override
  String get exchangeErrorRecordsMissing => 'इस रिक्वेस्ट के कुछ रिकॉर्ड नहीं मिले। कृपया सपोर्ट से बात करें।';

  @override
  String get exchangeErrorRentalInactive => 'आपका किराया चालू नहीं है, इसलिए गाड़ी बदलने की रिक्वेस्ट नहीं भेज सकते।';

  @override
  String get exchangeErrorReturnFirst => 'नया स्कूटर चुनने से पहले पुराने स्कूटर की वापसी पूरी करें।';

  @override
  String get exchangeErrorReturnUnfinished => 'वापसी अभी पूरी नहीं हुई। पहले राइडर का OTP जाँचें और वापसी पूरी करें।';

  @override
  String get exchangeErrorSameScooter => 'राइडर के अभी के स्कूटर से अलग स्कूटर चुनें।';

  @override
  String get exchangeErrorScooterReserved => 'वह स्कूटर किसी दूसरी रिक्वेस्ट के लिए रखा गया है।';

  @override
  String get exchangeErrorScooterUnavailable => 'वह स्कूटर अब उपलब्ध नहीं है। कोई दूसरा चुनें।';

  @override
  String get exchangeErrorSecurityChange =>
      'इस स्कूटर के लिए अलग सिक्योरिटी डिपॉज़िट चाहिए। पहले डिपॉज़िट अलग से बदलें।';

  @override
  String get exchangeErrorSecurityTopUp => 'पूरा करने से पहले राइडर की सिक्योरिटी डिपॉज़िट बढ़ानी होगी।';

  @override
  String get exchangeErrorStale => 'यह ऑफर बनने के बाद आपका किराया बदल गया है। अपने हब से नया ऑफर माँगें।';

  @override
  String get exchangeErrorTooSoon => 'यह स्कूटर आपको अभी कुछ ही दिन पहले मिला है। कुछ दिन बाद फिर कोशिश करें।';

  @override
  String get exchangeExtraRentNow => 'अभी अतिरिक्त किराया';

  @override
  String get exchangeFee => 'बदलने का शुल्क';

  @override
  String get exchangeFeeWaived => 'माफ़';

  @override
  String get exchangeHubReason => 'हब की वजह';

  @override
  String get exchangeNeedsYou => 'आपका जवाब चाहिए';

  @override
  String get exchangeNewRent => 'नया किराया';

  @override
  String get exchangeNewRentFrom => 'नया किराया शुरू';

  @override
  String get exchangeNewScooter => 'नया स्कूटर';

  @override
  String get exchangeNextApproved => 'मंज़ूर हो गया। आपका हब जाँच के लिए आपको अभी का स्कूटर लाने को कहेगा।';

  @override
  String exchangeNextBringIn(String date) {
    return '$date को अपना मौजूदा स्कूटर चुने गए हब पर लाएँ। हब टीम एक्सचेंज शुरू करेगी।';
  }

  @override
  String get exchangeNextCancelled => 'यह रिक्वेस्ट रद्द हो गई।';

  @override
  String get exchangeNextCheckingIn =>
      'हब टीम आपके मौजूदा स्कूटर की जाँच कर रही है। मैकेनिक की रिपोर्ट की पुष्टि के लिए आपके फ़ोन पर कोड आएगा।';

  @override
  String get exchangeNextChoosing => 'पुराना स्कूटर लौट गया है। आपका हब आपके लिए नया स्कूटर चुन रहा है।';

  @override
  String get exchangeNextCompleted => 'गाड़ी बदल गई। अपने नए स्कूटर का मज़ा लें!';

  @override
  String get exchangeNextDeposit => 'ऑफर मंज़ूर हो गया। आपका हब नए स्कूटर की जमा राशि तय कर रहा है।';

  @override
  String get exchangeNextExpired => 'यह रिक्वेस्ट पूरी होने से पहले ही खत्म हो गई।';

  @override
  String get exchangeNextHandover => 'आपका नया स्कूटर तैयार है। इसे हब से ले लें।';

  @override
  String get exchangeNextOffer => 'आपका ऑफर तैयार है। जानकारी देखें और मंज़ूर करें या मना करें।';

  @override
  String get exchangeNextRejected => 'आपका हब इस रिक्वेस्ट को मंज़ूर नहीं कर सका।';

  @override
  String get exchangeNextRequested => 'आपका हब जल्द ही आपकी रिक्वेस्ट देखेगा।';

  @override
  String get exchangeNextReserved => 'आपके लिए एक नया स्कूटर रखा गया है। आपका ऑफर जल्द तैयार होगा।';

  @override
  String get exchangeNextReturn => 'अभी का स्कूटर हब पर लौटाएँ ताकि वे उसकी जाँच कर सकें।';

  @override
  String get exchangeNone => 'कोई रिक्वेस्ट नहीं';

  @override
  String get exchangeNoneMessage => 'अगर स्कूटर में दिक्कत है तो गाड़ी बदलने की रिक्वेस्ट भेजें, आपका हब मदद करेगा।';

  @override
  String get exchangeNoRentalBody => 'स्कूटर किराए पर मिलने के बाद आप गाड़ी बदलने की रिक्वेस्ट भेज सकते हैं।';

  @override
  String get exchangeNoRentalTitle => 'कोई चालू किराया नहीं';

  @override
  String get exchangeNoteHint => 'समस्या बताएँ (ज़रूरी नहीं)';

  @override
  String get exchangeNoteLabel => 'हब के लिए नोट';

  @override
  String get exchangeNotes => 'आपका नोट';

  @override
  String get exchangeOfferExpiredMessage => 'यह ऑफर खत्म हो गया है। आपका हब नया भेज सकता है।';

  @override
  String get exchangeOfferExpires => 'ऑफर की आखिरी तारीख';

  @override
  String get exchangeOfferTitle => 'आपका ऑफर';

  @override
  String get exchangeOpen => 'चल रही हैं';

  @override
  String get exchangeOpenExists => 'आपकी एक रिक्वेस्ट पहले से चल रही है।';

  @override
  String get exchangePast => 'पूरी हुईं';

  @override
  String get exchangePerDay => '/ दिन';

  @override
  String get exchangePerFortnight => '/ 2 हफ़्ते';

  @override
  String get exchangePerMonth => '/ महीना';

  @override
  String get exchangePerQuarter => '/ 3 महीने';

  @override
  String get exchangePerWeek => '/ हफ़्ता';

  @override
  String get exchangeProgress => 'प्रगति';

  @override
  String get exchangeRaised => 'कब माँगी';

  @override
  String get exchangeReason => 'वजह';

  @override
  String get exchangeReasonBreakdown => 'गाड़ी खराब';

  @override
  String get exchangeReasonBreakdownHint => 'स्कूटर बंद हो गया या बार-बार खराब होता है';

  @override
  String get exchangeReasonOtherHint => 'कोई और वजह';

  @override
  String get exchangeReasonSafety => 'सुरक्षा बदलाव';

  @override
  String get exchangeReasonSafetyHint => 'सुरक्षा जाँच के कारण दूसरा स्कूटर चाहिए';

  @override
  String get exchangeReasonUnsafe => 'चलाना सुरक्षित नहीं';

  @override
  String get exchangeReasonUnsafeHint => 'ब्रेक, लाइट या टायर सुरक्षित नहीं लगते';

  @override
  String get exchangeReasonUpgrade => 'बेहतर गाड़ी';

  @override
  String get exchangeReasonUpgradeHint => 'आपको दूसरा मॉडल चाहिए';

  @override
  String get exchangeRejected => 'ऑफर मना किया';

  @override
  String get exchangeRejectOffer => 'ऑफर मना करें';

  @override
  String get exchangeRejectReason => 'वजह';

  @override
  String get exchangeRejectReasonRequired => 'कृपया वजह लिखें';

  @override
  String get exchangeRejectSubtitle => 'अपने हब को वजह बताएँ ताकि वे बेहतर भेज सकें।';

  @override
  String get exchangeRentalCouldNotLoad => 'आपका किराया लोड नहीं हो सका';

  @override
  String get exchangeRentCredit => 'किराया क्रेडिट';

  @override
  String get exchangeRequestAction => 'गाड़ी बदलने की रिक्वेस्ट';

  @override
  String get exchangeRequestSent => 'गाड़ी बदलने की रिक्वेस्ट भेज दी गई';

  @override
  String get exchangeRequestSubtitle => 'अपने हब को बताएँ कि आपको दूसरा स्कूटर क्यों चाहिए।';

  @override
  String get exchangeReturnDate => 'जमा करने की तारीख';

  @override
  String get exchangeSendRequest => 'रिक्वेस्ट भेजें';

  @override
  String get exchangeStageAccepted => 'मंज़ूर';

  @override
  String get exchangeStageCompleted => 'पूरा हुआ';

  @override
  String get exchangeStageHandover => 'गाड़ी बदलनी है';

  @override
  String get exchangeStageOfferReady => 'ऑफर तैयार';

  @override
  String get exchangeStageRequested => 'माँगी गई';

  @override
  String get exchangeStatusApproved => 'मंज़ूर';

  @override
  String get exchangeStatusCancelled => 'रद्द';

  @override
  String get exchangeStatusCheckingIn => 'एक्सचेंज हो रहा है';

  @override
  String get exchangeStatusChoosing => 'स्कूटर चुना जा रहा है';

  @override
  String get exchangeStatusExpired => 'समय खत्म';

  @override
  String get exchangeStatusRejected => 'नामंज़ूर';

  @override
  String get exchangeStatusReturn => 'स्कूटर लौटाएँ';

  @override
  String get exchangeStepApproval => 'हब की मंज़ूरी';

  @override
  String get exchangeStepDeposit => 'जमा राशि';

  @override
  String get exchangeStepHandover => 'नया स्कूटर लेना';

  @override
  String get exchangeStepOffer => 'नए स्कूटर का ऑफर';

  @override
  String get exchangeStepRequested => 'रिक्वेस्ट भेजी';

  @override
  String get exchangeStepReturn => 'पुराना स्कूटर लौटाना';

  @override
  String get exchangeSubtitle => 'दूसरी स्कूटर के लिए कहें';

  @override
  String get exchangeTitle => 'गाड़ी बदलना';

  @override
  String get exchangeVersionCurrent => 'मौजूदा';

  @override
  String exchangeVersionFrom(String date) {
    return '$date से';
  }

  @override
  String exchangeVersionNumber(String number) {
    return 'वर्ज़न $number';
  }

  @override
  String get exchangeVersionPrevious => 'पिछला';

  @override
  String get exchangeWhenWhere => 'कब और कहाँ';

  @override
  String get exchangeWhenWhereHint => 'चुनें कि आप अपना मौजूदा स्कूटर कब और कहाँ लाएँगे।';

  @override
  String get fleetOnboardingActive => 'सक्रिय';

  @override
  String get fleetOnboardingArchived => 'संग्रहीत';

  @override
  String get fleetOnboardingDraft => 'ड्राफ़्ट';

  @override
  String get fleetOnboardingInProgress => 'जारी है';

  @override
  String get fleetOnboardingPendingReview => 'समीक्षा का इंतज़ार';

  @override
  String get fleetOnboardingRejected => 'अस्वीकृत';

  @override
  String get fleetSearchAllocationActive => 'राइडर के पास';

  @override
  String get fleetSearchAllocationCancelled => 'रद्द';

  @override
  String get fleetSearchAllocationHandover => 'हैंडओवर चल रहा है';

  @override
  String get fleetSearchAllocationReturned => 'लौटा दिया गया';

  @override
  String get fleetSearchAllocationReturning => 'रिटर्न चल रहा है';

  @override
  String get fleetSearchCouldNotLoad => 'स्कूटर नहीं खोजे जा सके';

  @override
  String get fleetSearchCouldNotLoadRiderHistory => 'राइडर इतिहास लोड नहीं हो सका';

  @override
  String get fleetSearchCouldNotLoadScooter => 'यह स्कूटर लोड नहीं हो सका';

  @override
  String get fleetSearchCurrentRider => 'मौजूदा राइडर';

  @override
  String get fleetSearchEmptyMessage => 'वाहन नंबर, फ़्लीट कोड या चेसिस नंबर जाँचकर फिर कोशिश करें।';

  @override
  String get fleetSearchEmptyTitle => 'कोई स्कूटर नहीं मिला';

  @override
  String get fleetSearchHint => 'नंबर, कोड या चेसिस से स्कूटर खोजें';

  @override
  String get fleetSearchLatestSubmission => 'हाल का रिटर्न या एक्सचेंज';

  @override
  String get fleetSearchNoRider => 'अभी यह स्कूटर किसी राइडर के पास नहीं है।';

  @override
  String get fleetSearchNoRiderHistory => 'अब तक यह स्कूटर किसी राइडर को नहीं दिया गया है।';

  @override
  String get fleetSearchNoSubmission => 'अभी तक कोई रिटर्न या एक्सचेंज नहीं हुआ।';

  @override
  String get fleetSearchOtherHub => 'दूसरा हब';

  @override
  String get fleetSearchRiderHistory => 'राइडर इतिहास';

  @override
  String get fleetSearchRiderHistoryOtherHub => 'राइडर इतिहास सिर्फ़ आपके हब के स्कूटरों के लिए दिखता है।';

  @override
  String fleetSearchSince(String date) {
    return '$date से';
  }

  @override
  String get fleetSearchStartMessage => 'वाहन नंबर, फ़्लीट कोड या चेसिस नंबर के कम से कम 2 अक्षर लिखें।';

  @override
  String get fleetSearchStartTitle => 'हर हब में खोजें';

  @override
  String get fleetSearchSubmissionDone => 'पूरा हुआ';

  @override
  String get fleetSearchSubmissionOpen => 'चल रहा है';

  @override
  String get fleetSearchTitle => 'स्कूटर खोजें';

  @override
  String get fleetStatusAllocated => 'आवंटित';

  @override
  String get fleetStatusAllocating => 'आवंटन हो रहा है';

  @override
  String get fleetStatusAvailable => 'उपलब्ध';

  @override
  String get fleetStatusAwaitingParts => 'पुर्ज़ों का इंतज़ार';

  @override
  String get fleetStatusBroken => 'खराब';

  @override
  String get fleetStatusInspectionPending => 'जाँच का इंतज़ार';

  @override
  String get fleetStatusInTransit => 'रास्ते में';

  @override
  String get fleetStatusInUse => 'इस्तेमाल में';

  @override
  String get fleetStatusMaintenance => 'मेंटेनेंस में';

  @override
  String get fleetStatusOutOfService => 'सेवा से बाहर';

  @override
  String get fleetStatusReserved => 'आरक्षित';

  @override
  String get fleetStatusReturning => 'वापसी हो रही है';

  @override
  String get homeCouldNotLoadDashboard => 'आपका डैशबोर्ड नहीं खुल पाया';

  @override
  String get homeDailyRental => 'दैनिक किराया';

  @override
  String get homeDepositsHandoverFees => 'जमा राशि और हैंडओवर शुल्क';

  @override
  String get homeHelpSupport => 'मदद और सहायता';

  @override
  String get homeHistory => 'इतिहास';

  @override
  String get homeLastPayment => 'पिछला भुगतान';

  @override
  String get homeMarkAbsent => 'गैरहाज़िर लगाएं';

  @override
  String get homeMarkedAbsentScooterNowDisabled => 'गैरहाज़िरी लग गई। स्कूटर अब बंद है।';

  @override
  String get homeMarkYourselfAbsent => 'खुद को गैरहाज़िर लगाएं?';

  @override
  String get homeMarkYourselfPresentSwitchVehicle => 'गाड़ी चालू करने के लिए पहले हाज़िरी लगाएं।';

  @override
  String homeNextDebitOn(String date) {
    return 'अगली कटौती $date';
  }

  @override
  String get homePersonalDetailsKyc => 'निजी जानकारी और केवाईसी';

  @override
  String get homeRent => 'किराया';

  @override
  String get homeRentDue => 'बकाया किराया';

  @override
  String homeRentDueOn(String date) {
    return 'देय तारीख $date';
  }

  @override
  String homeRentOverdue(String amount) {
    return '$amount की देय तिथि निकल गई';
  }

  @override
  String get homeScooter => 'स्कूटर';

  @override
  String get homeShiftWillEndScooterWill =>
      'आपकी शिफ़्ट ख़त्म हो जाएगी और स्कूटर बंद हो जाएगा। हफ़्तावार और महीनेवार प्लान में किराया फिर भी लगेगा।';

  @override
  String get homeWithdraw => 'निकालें';

  @override
  String get homeWorkingDays => 'कार्य दिवस';

  @override
  String get hubAllHubs => 'सभी हब';

  @override
  String get hubAllocate => 'आवंटित करें';

  @override
  String get hubAllotmentsInQueue => 'कतार में आवंटन';

  @override
  String get hubAllotmentsInQueueInfo => 'इस हब के सक्रिय राइडर जो वाहन का इंतज़ार कर रहे हैं।';

  @override
  String get hubChooseHub => 'हब चुनें';

  @override
  String get hubChooseHubSubtitle => 'एक हब देखें, या अपने सभी हब एक साथ।';

  @override
  String get hubCouldNotLoadHub => 'आपका हब नहीं खुल पाया';

  @override
  String hubCount(int count) {
    return '$count हब';
  }

  @override
  String get hubFleetAtHub => 'हब पर';

  @override
  String get hubFleetManager => 'फ़्लीट मैनेजर';

  @override
  String get hubFleetMapped => 'कुल फ्लीट';

  @override
  String get hubFleetOnField => 'फील्ड पर';

  @override
  String get hubFleetUtilisation => 'फ़्लीट का उपयोग';

  @override
  String hubGstinLine(String gstin) {
    return 'GSTIN: $gstin';
  }

  @override
  String get hubHome => 'होम';

  @override
  String get hubHubGlance => 'आपके हब का हाल';

  @override
  String get hubMaintenance => 'मरम्मत';

  @override
  String get hubMarkedAbsentShiftClosed => 'गैरहाज़िरी लग गई। आपकी शिफ़्ट बंद हो गई।';

  @override
  String get hubNoHubAssigned => 'आपको कोई हब नहीं दिया गया है।';

  @override
  String hubQuickSupportLine(String number) {
    return 'त्वरित सहायता: $number';
  }

  @override
  String get hubQuickView => 'हब की झलक';

  @override
  String get hubQuickViewInfo => 'आपके चुने हुए हब की लाइव गिनती।';

  @override
  String get hubReturn => 'वापसी';

  @override
  String get hubRfdsAvailable => 'उपलब्ध RFD';

  @override
  String get hubRfdsAvailableInfo => 'डिप्लॉयमेंट के लिए तैयार: इस हब के वाहन जो आवंटन के लिए खाली हैं।';

  @override
  String get hubsCouldNotLoad => 'नज़दीकी हब नहीं खुल पाए';

  @override
  String get hubService => 'सर्विस';

  @override
  String get hubShowDataFor => 'इसका डेटा दिखाएँ';

  @override
  String get hubsNoneBody => 'आपकी लोकेशन के आस-पास कोई सक्रिय हब नहीं है।';

  @override
  String get hubsNoneTitle => 'आपके पास कोई हब नहीं';

  @override
  String get hubSomethingWentWrong => 'कुछ गड़बड़ हो गई।';

  @override
  String get hubsSubtitle => 'आपके सबसे नज़दीकी हब';

  @override
  String get hubSubmissionsInQueue => 'कतार में सबमिशन';

  @override
  String get hubSubmissionsInQueueInfo =>
      'इस हब पर बाकी रिटर्न और एक्सचेंज, जिनके वाहन का सबमिशन अभी पूरा नहीं हुआ है।';

  @override
  String get hubUnderMaintenanceFleet => 'मेंटेनेंस में फ़्लीट';

  @override
  String get hubUnderMaintenanceFleetInfo => 'इस हब के वाहन जो अभी मेंटेनेंस में हैं।';

  @override
  String get inspectionErrorSafeForReuse => 'बताएँ कि स्कूटर दोबारा देने के लिए सुरक्षित है या नहीं।';

  @override
  String get inspectionErrorUnsafeReason => 'बताएँ कि स्कूटर दोबारा देने के लिए सुरक्षित क्यों नहीं है।';

  @override
  String get introCouldNotLoad => 'परिचय स्लाइड नहीं खुल पाईं।';

  @override
  String get introEarnBody => 'रोज़ भुगतान, साफ़-साफ़ इनाम और ऐसा किराया प्लान जो आपकी असल सवारी के हिसाब से हो।';

  @override
  String get introEarnHighlight1 => 'उसी दिन निपटान';

  @override
  String get introEarnHighlight2 => 'कोई छिपी कटौती नहीं';

  @override
  String get introEarnTitle => 'ज़्यादा कमाएं,\nसाफ़ सवारी करें';

  @override
  String get introSupportBody => 'सड़क पर मदद, सर्विस बुकिंग और एक टीम लीड जो वही देख सकता है जो आप देखते हैं।';

  @override
  String get introSupportHighlight1 => '24x7 सड़क पर मदद';

  @override
  String get introSupportHighlight2 => 'आपके हब पर सर्विस';

  @override
  String get introSupportTitle => 'मदद जो\nवाक़ई पहुंचे';

  @override
  String get introVehicleBody =>
      'गाड़ी के डिवाइस से बैटरी, रेंज और स्थिति की लाइव जानकारी। ऐप से ही अनलॉक करें और शिफ़्ट शुरू करें।';

  @override
  String get introVehicleHighlight1 => 'लाइव जानकारी';

  @override
  String get introVehicleHighlight2 => 'एक दबाव में शुरू';

  @override
  String get introVehicleTitle => 'आपका स्कूटर,\nपूरी तरह जुड़ा हुआ';

  @override
  String get legalAppName => 'ऐप';

  @override
  String get legalDocumentCouldNotLoad => 'यह दस्तावेज़ लोड नहीं हो सका';

  @override
  String get maintenanceAllocation => 'आवंटन';

  @override
  String get maintenanceAllocationOff => 'बंद है';

  @override
  String get maintenanceAllocationOn => 'अनुमति है';

  @override
  String get maintenanceBattery => 'बैटरी';

  @override
  String get maintenanceCategory => 'श्रेणी';

  @override
  String get maintenanceChangeStatus => 'स्थिति बदलें';

  @override
  String get maintenanceChassis => 'चेसिस नंबर';

  @override
  String get maintenanceChecksOpen => 'कुछ मैकेनिक जाँच अभी बाकी हैं';

  @override
  String get maintenanceColour => 'रंग';

  @override
  String get maintenanceCouldNotLoad => 'सर्विस वाले वाहन लोड नहीं हो सके';

  @override
  String get maintenanceCurrentHub => 'मौजूदा हब';

  @override
  String get maintenanceEarlierReports => 'पिछली मैकेनिक रिपोर्ट';

  @override
  String get maintenanceEmptyBody => 'जब आपके हब का कोई स्कूटर मेंटेनेंस में भेजा जाएगा, वह यहाँ दिखेगा।';

  @override
  String get maintenanceEmptyTitle => 'सर्विस में कोई वाहन नहीं';

  @override
  String get maintenanceEvidence => 'सबूत की फ़ोटो';

  @override
  String get maintenanceFleetCode => 'फ़्लीट कोड';

  @override
  String get maintenanceHistory => 'स्टेटस इतिहास';

  @override
  String maintenanceHistoryLimit(int limit) {
    return 'नवीनतम $limit बदलाव दिखा रहे हैं।';
  }

  @override
  String get maintenanceHomeHub => 'होम हब';

  @override
  String get maintenanceInServiceSince => 'सर्विस में आने की तारीख';

  @override
  String get maintenanceLatestReport => 'नवीनतम मैकेनिक रिपोर्ट';

  @override
  String get maintenanceMaker => 'निर्माता';

  @override
  String get maintenanceModel => 'मॉडल';

  @override
  String maintenanceMovedOn(String date) {
    return 'मेंटेनेंस में भेजा गया $date';
  }

  @override
  String get maintenanceNoHistory => 'कोई स्टेटस बदलाव दर्ज नहीं है।';

  @override
  String get maintenanceNoMatchBody => 'कोई दूसरा वाहन नंबर, फ़्लीट कोड, चेसिस या मॉडल आज़माएँ।';

  @override
  String get maintenanceNoMatchTitle => 'कोई मिलता-जुलता वाहन नहीं';

  @override
  String get maintenanceNoReportYet => 'इस वाहन की अभी तक कोई मैकेनिक रिपोर्ट दर्ज नहीं हुई है।';

  @override
  String get maintenanceNotSafe => 'सुरक्षित नहीं';

  @override
  String get maintenanceOdometer => 'ओडोमीटर';

  @override
  String get maintenanceOnboarding => 'ऑनबोर्डिंग';

  @override
  String get maintenanceProgress => 'चल रहा है';

  @override
  String maintenanceReasonFromReport(String reason) {
    return 'मैकेनिक रिपोर्ट: $reason';
  }

  @override
  String maintenanceReasonLine(String reason) {
    return 'कारण: $reason';
  }

  @override
  String get maintenanceReportConfirmed => 'पुष्टि की तारीख';

  @override
  String get maintenanceReportMechanic => 'मैकेनिक';

  @override
  String get maintenanceReportPhotos => 'फ़ोटो';

  @override
  String get maintenanceReportRecorded => 'दर्ज करने की तारीख';

  @override
  String maintenanceReportsLimit(int limit) {
    return 'नवीनतम $limit रिपोर्ट दिखा रहे हैं।';
  }

  @override
  String get maintenanceReportStatus => 'स्कूटर की स्थिति';

  @override
  String get maintenanceSafeToReuse => 'इस्तेमाल के लिए सुरक्षित';

  @override
  String get maintenanceSearchHint => 'वाहन नंबर, फ़्लीट कोड, चेसिस या मॉडल खोजें';

  @override
  String get maintenanceSelectVehicle => 'गाड़ी चुनें';

  @override
  String maintenanceStatusChanged(String status) {
    return 'स्थिति बदलकर $status कर दी गई';
  }

  @override
  String maintenanceStatusNow(String status) {
    return 'अभी की स्थिति: $status';
  }

  @override
  String get maintenanceStatusOutOfServiceHint =>
      'सड़क से हटा दिया गया। यह सर्विस से हट जाएगा, और इसे सिर्फ़ आपके एडमिन ही वापस ला सकते हैं।';

  @override
  String get maintenanceTitle => 'सर्विस में वाहन';

  @override
  String get maintenanceUnderMaintenance => 'मेंटेनेंस में';

  @override
  String get maintenanceVariant => 'वेरिएंट';

  @override
  String get maintenanceVehicleCouldNotLoad => 'यह वाहन लोड नहीं हो सका';

  @override
  String get maintenanceVehicleDetails => 'वाहन का विवरण';

  @override
  String get maintenanceVehicleTitle => 'सर्विस में वाहन';

  @override
  String get maintenanceVehicleType => 'वाहन का प्रकार';

  @override
  String get mapsAllowLocation => 'अनुमति दें';

  @override
  String mapsAway(String distance) {
    return '$distance दूर';
  }

  @override
  String get mapsCouldNotOpenMaps => 'Google Maps नहीं खुल पाया';

  @override
  String get mapsLocating => 'आपकी लोकेशन ढूंढ रहे हैं…';

  @override
  String get mapsLocationDeniedBody => 'हम आपकी लोकेशन से आपके पास के हब और स्वैप स्टेशन दिखाते हैं।';

  @override
  String get mapsLocationDeniedTitle => 'लोकेशन की अनुमति दें';

  @override
  String get mapsLocationOffBody => 'अपने आस-पास की जगहें देखने के लिए लोकेशन सेवाएं चालू करें।';

  @override
  String get mapsLocationOffTitle => 'लोकेशन बंद है';

  @override
  String get mapsLocationUnavailable => 'आपकी लोकेशन नहीं मिल पाई';

  @override
  String mapsMinutes(String minutes) {
    return '$minutes मिनट';
  }

  @override
  String get mapsNavigate => 'रास्ता देखें';

  @override
  String get mapsOpenSettings => 'सेटिंग्स खोलें';

  @override
  String get navBatterySwap => 'बैटरी स्वैप';

  @override
  String get navNearbyHubs => 'नज़दीकी हब';

  @override
  String get navReferEarn => 'रेफ़र करें और कमाएं';

  @override
  String get navScooterDetails => 'स्कूटर विवरण';

  @override
  String get notificationsAll => 'सभी';

  @override
  String get notificationsAllCaughtUp => 'आप पूरी तरह अपडेट हैं';

  @override
  String get notificationsAllClear => 'सब ठीक है';

  @override
  String get notificationsCouldNotLoadNotifications => 'सूचनाएं नहीं खुल पाईं';

  @override
  String get notificationsEarlier => 'पहले';

  @override
  String get notificationsEmptyMessage => 'नए अपडेट और अलर्ट यहाँ दिखेंगे।';

  @override
  String get notificationsGotIt => 'ठीक है';

  @override
  String notificationsInboxCount(int count) {
    return 'आपके इनबॉक्स में $count सूचनाएँ';
  }

  @override
  String get notificationsNoMatchingNotifications => 'कोई मिलती-जुलती सूचना नहीं';

  @override
  String get notificationsNothingNewNeedsAttention => 'अभी कुछ नया नहीं है';

  @override
  String get notificationsNotifications => 'सूचनाएं';

  @override
  String get notificationsSearchNotifications => 'सूचनाएं खोजें';

  @override
  String get notificationsToday => 'आज';

  @override
  String get notificationsUnread => 'बिना पढ़ा';

  @override
  String notificationsUnreadCount(int count) {
    return '$count अपठित';
  }

  @override
  String get onboardingAcceptAgreementContinue => 'आगे बढ़ने के लिए अनुबंध स्वीकार करें';

  @override
  String get onboardingAddDateBirthFirstStep => 'आगे बढ़ने से पहले पहले चरण में जन्म तिथि डालें';

  @override
  String get onboardingAddLeastOneReference => 'कम से कम एक रेफ़रेंस जोड़ें';

  @override
  String onboardingAddYourField(String field) {
    return 'अपना $field जोड़ें';
  }

  @override
  String get onboardingAgreementBody =>
      'यह अनुबंध आपके और आपके फ़्लीट ऑपरेटर के बीच है। इसमें आपको सौंपी गई गाड़ी, उसका इस्तेमाल कैसे किया जा सकता है, उसकी देखभाल की आपकी ज़िम्मेदारी, आपके प्लान की जमा राशि और शुल्क, और यह व्यवस्था कैसे ख़त्म होती है, सब शामिल है। स्वीकार करने से पहले इसे पूरा पढ़ें। नीचे बॉक्स पर निशान लगाकर आप पक्का करते हैं कि आपने राइडर अनुबंध और ऑपरेटर की राइडर नीतियां पढ़ ली हैं और उनसे बंधे रहने को सहमत हैं।';

  @override
  String get onboardingAgreeToRiderAgreement => 'मैंने राइडर अनुबंध पढ़ लिया है और सहमत हूं';

  @override
  String get onboardingAnswered => 'जवाब दिया';

  @override
  String get onboardingApplicationSubmitted => 'आवेदन जमा हो गया';

  @override
  String get onboardingAttached => 'जुड़ गया';

  @override
  String get onboardingBankAccount => 'बैंक खाता';

  @override
  String get onboardingBankAccountNeeded => 'अपना खाता नंबर डालें और पुष्टि के लिए फिर से टाइप करें।';

  @override
  String get onboardingBankAccountTooShort => 'यह खाता नंबर बहुत छोटा लग रहा है।';

  @override
  String get onboardingBankBranch => 'शाखा';

  @override
  String get onboardingBankCity => 'शहर';

  @override
  String get onboardingBankIfsc => 'IFSC कोड';

  @override
  String get onboardingBankIfscFailed => 'अभी यह IFSC जाँचा नहीं जा सका। नीचे अपने बैंक की जानकारी भरें।';

  @override
  String get onboardingBankIfscHelper => '11 अक्षर। यह आपकी पासबुक या चेक पर मिलेगा।';

  @override
  String get onboardingBankIfscHint => 'उदा. SBIN0001234';

  @override
  String get onboardingBankIfscNotFound =>
      'इस IFSC के लिए कोई बैंक नहीं मिला। कोड जाँचें, या नीचे अपने बैंक की जानकारी भरें।';

  @override
  String get onboardingBankIfscPending => 'अपना IFSC डालें और बैंक दिखने तक रुकें।';

  @override
  String get onboardingBankName => 'बैंक का नाम';

  @override
  String get onboardingBankProof => 'बैंक प्रमाण (पासबुक या रद्द चेक)';

  @override
  String get onboardingBankState => 'राज्य';

  @override
  String get onboardingCheckEverythingBeforeSubmitCan =>
      'जमा करने से पहले सब जांच लें। आप कोई भी चरण अब भी बदल सकते हैं।';

  @override
  String get onboardingCouldNotLoadOnboarding => 'फ़ॉर्म नहीं खुल पाया';

  @override
  String get onboardingDateBirthNotValid => 'यह जन्म तिथि सही नहीं है';

  @override
  String get onboardingDocumentApproved => 'स्वीकृत';

  @override
  String get onboardingDocumentHasExpiredEnterDate => 'यह दस्तावेज़ ख़त्म हो चुका है। आज के बाद की तारीख डालें।';

  @override
  String get onboardingDocumentInReview => 'अपलोड हो गया · जाँच जारी';

  @override
  String get onboardingDocuments => 'दस्तावेज़';

  @override
  String get onboardingEdit => 'बदलें';

  @override
  String onboardingEnterValidField(String field) {
    return 'सही $field डालें';
  }

  @override
  String get onboardingEveryStepHaveCompletedSaved =>
      'आपका हर पूरा किया गया चरण सेव है। अगली बार साइन इन करने पर वहीं से शुरू कर सकते हैं।';

  @override
  String get onboardingExit => 'बाहर निकलें';

  @override
  String get onboardingExitOnboarding => 'फ़ॉर्म से बाहर निकलें?';

  @override
  String onboardingFieldRequired(String field) {
    return '$field ज़रूरी है';
  }

  @override
  String get onboardingGoOnboarding => 'फ़ॉर्म पर जाएं';

  @override
  String get onboardingIntroGetStarted => 'शुरू करें';

  @override
  String get onboardingIntroNext => 'अगला';

  @override
  String get onboardingLoadingOnboardingForm => 'आपका फ़ॉर्म खुल रहा है…';

  @override
  String get onboardingNoStepsConfigured =>
      'आपके फ़्लीट ऑपरेटर के पैकेज में अभी कोई ऑनबोर्डिंग चरण तय नहीं है। उनसे राइडर ऑनबोर्डिंग सेट कराएं, फिर दोबारा साइन इन करें।';

  @override
  String get onboardingNothingFill => 'भरने के लिए कुछ नहीं';

  @override
  String get onboardingNothingFillStep => 'इस चरण में भरने के लिए कुछ नहीं है।';

  @override
  String get onboardingNothingReviewYet => 'अभी जांचने के लिए कुछ नहीं';

  @override
  String get onboardingNothingToFillHere => 'यहां भरने के लिए कुछ नहीं';

  @override
  String get onboardingNotProvided => 'नहीं दिया गया';

  @override
  String get onboardingPackage => 'पैकेज';

  @override
  String get onboardingPleaseFixHighlightedFieldsBefore => 'आगे बढ़ने से पहले लाल रंग वाले खाने ठीक करें';

  @override
  String get onboardingReferences => 'रेफ़रेंस';

  @override
  String get onboardingReferralApplied => 'लागू हुआ';

  @override
  String get onboardingReferralApply => 'लागू करें';

  @override
  String get onboardingReferralCodeApplied => 'रेफ़रल कोड लागू हो गया';

  @override
  String get onboardingReferralFromInvite => 'आपके आमंत्रण लिंक से जोड़ा गया';

  @override
  String get onboardingReferralNotFound => 'इसके लिए कोई रेफ़रल नहीं मिला। कोड या मोबाइल नंबर जाँचें।';

  @override
  String get onboardingReferralScan => 'रेफ़रल QR स्कैन करें';

  @override
  String get onboardingReferralTapApply => 'यह कोड इस्तेमाल करने के लिए लागू करें दबाएँ, या इसे हटा दें';

  @override
  String onboardingRejectedMessage(String documents) {
    return 'आगे बढ़ने के लिए दोबारा अपलोड करें: $documents';
  }

  @override
  String get onboardingRejectedTitle => 'जाँच में अस्वीकार';

  @override
  String get onboardingReview => 'जांचें';

  @override
  String get onboardingReviewApplication => 'आवेदन जांचें';

  @override
  String get onboardingRiderOnboarding => 'राइडर का जुड़ना';

  @override
  String get onboardingSaving => 'सेव हो रहा है…';

  @override
  String get onboardingSignAgreementContinue => 'आगे बढ़ने के लिए अनुबंध पर हस्ताक्षर करें';

  @override
  String get onboardingSomeStepsStillIncompleteGo => 'कुछ चरण अभी अधूरे हैं। पीछे जाकर उन्हें पूरा करें।';

  @override
  String get onboardingStartOnboardingSeeAnswersHere => 'अपने जवाब यहां देखने के लिए फ़ॉर्म भरना शुरू करें।';

  @override
  String get onboardingStepAgreement => 'अनुबंध';

  @override
  String get onboardingStepEligibility => 'पात्रता';

  @override
  String get onboardingStepHandledByOperator => 'यह चरण आपका फ़्लीट ऑपरेटर संभालता है। अगले पर बढ़ें।';

  @override
  String get onboardingStepTraining => 'ट्रेनिंग';

  @override
  String get onboardingSubmitApplication => 'आवेदन जमा करें';

  @override
  String get onboardingTakePhotoDocumentChooseOne => 'दस्तावेज़ की फ़ोटो लें, या पहले से मौजूद फ़ोटो चुनें';

  @override
  String get onboardingUploadRejectedAgain => 'जमा करने से पहले अस्वीकार हुए दस्तावेज़ दोबारा अपलोड करें।';

  @override
  String get paymentRefundableDeposit => 'वापस मिलने वाला डिपॉज़िट';

  @override
  String get paymentRentAndFees => 'किराया और शुल्क';

  @override
  String get paymentsAllClear => 'आपका सारा भुगतान हो गया';

  @override
  String get paymentsAllClearMessage => 'अभी कुछ बकाया नहीं है। अगली बार से पहले हम बता देंगे।';

  @override
  String get paymentsAmountDue => 'बकाया रकम';

  @override
  String get paymentsAutoPay => 'ऑटो-डेबिट';

  @override
  String get paymentsAutoPayActive => 'चालू';

  @override
  String get paymentsAutoPayAttention =>
      'ऑटो-डेबिट पर ध्यान देना है। इसे दोबारा सेट करने के लिए अपने फ्लीट मैनेजर से कहें।';

  @override
  String get paymentsAutoPayAuthPending => 'मंज़ूरी का इंतज़ार';

  @override
  String get paymentsAutoPayExpired => 'खत्म';

  @override
  String get paymentsAutoPayFailed => 'विफल';

  @override
  String get paymentsAutoPayNotEnabled => 'सेट नहीं है';

  @override
  String get paymentsAutoPayPaused => 'रोका गया';

  @override
  String get paymentsAutoPayRevoked => 'रद्द';

  @override
  String get paymentsAutoPaySetupRequired => 'सेटअप बाकी';

  @override
  String get paymentsCouldNotLoad => 'भुगतान लोड नहीं हो सके';

  @override
  String get paymentsDueOn => 'देय तारीख';

  @override
  String get paymentsHistory => 'पुराने भुगतान';

  @override
  String get paymentsMandateExpires => 'मैंडेट खत्म';

  @override
  String get paymentsMandateLimit => 'प्रति कटौती सीमा';

  @override
  String get paymentsMethod => 'तरीका';

  @override
  String get paymentsNextDebit => 'अगली कटौती';

  @override
  String get paymentsNoPayments => 'अभी कोई भुगतान नहीं';

  @override
  String get paymentsNoPaymentsMessage => 'आपके भुगतान पक्के होने पर यहाँ दिखेंगे।';

  @override
  String get paymentsNothingDue => 'कुछ बकाया नहीं';

  @override
  String get paymentsOverdue => 'समय बीत गया';

  @override
  String get paymentsPayAtHub => 'अपने हब पर भुगतान करें, या देय तारीख पर ऑटो-डेबिट होने दें।';

  @override
  String get paymentsPayment => 'भुगतान';

  @override
  String get paymentsSubtitle => 'बकाया, ऑटो-डेबिट और रसीदें';

  @override
  String get paymentsTitle => 'भुगतान';

  @override
  String get pdiHintTyreWorn => 'जैसे अगला टायर तय सीमा से ज़्यादा घिसा है';

  @override
  String pdiWorkPartner(String partner) {
    return 'काम का साथी: $partner';
  }

  @override
  String get planAccept => 'प्लान स्वीकार करें';

  @override
  String get planAdvanceRental => 'अग्रिम किराया';

  @override
  String get planBatteryDeposit => 'बैटरी सिक्योरिटी डिपॉज़िट';

  @override
  String get planConsent => 'मैंने यह प्लान पढ़ लिया है और मैं इससे सहमत हूँ';

  @override
  String get planCustom => 'कस्टम प्लान';

  @override
  String get planDaily => 'दैनिक प्लान';

  @override
  String planDays(int count) {
    return '$count दिन का प्लान';
  }

  @override
  String get planDiscount => 'छूट';

  @override
  String get planErrorAgreementMismatch => 'यह रेंटल इस स्कूटर से मेल नहीं खाता। अपने फ़्लीट मैनेजर से संपर्क करें।';

  @override
  String get planErrorAgreementNotActive => 'आपका रेंटल अभी सक्रिय नहीं है, इसलिए यह अभी नहीं हो सकता।';

  @override
  String get planErrorAgreementNotReady =>
      'स्वीकार किया गया प्लान हैंडओवर के लिए तैयार नहीं है। रिफ़्रेश करके फिर कोशिश करें।';

  @override
  String get planErrorDepositNotConfigured =>
      'इस प्लान में स्कूटर सिक्योरिटी डिपॉज़िट सेट नहीं है। अपने एडमिन से इसे जोड़ने को कहें, चाहे यह शून्य हो।';

  @override
  String get planErrorExchangePlan => 'यह एक्सचेंज स्कूटर है, इसलिए इसका प्लान पहले से तय है।';

  @override
  String get planErrorFeeNotConfigured =>
      'इस प्लान में ऑनबोर्डिंग शुल्क सेट नहीं है। अपने एडमिन से इसे जोड़ने को कहें, चाहे यह शून्य हो।';

  @override
  String get planErrorFleetRequestRequired => 'पेमेंट मांगने से पहले स्कूटर का अनुरोध करें।';

  @override
  String get planErrorOfferNotValid => 'यह प्लान ऑफ़र अब मान्य नहीं है। नया ऑफ़र मांगें।';

  @override
  String get planErrorPaymentReferenceRequired => 'राइडर ने अभी तक पेमेंट रेफ़रेंस नहीं भेजा है।';

  @override
  String get planErrorPaymentStale => 'राशि बदल गई है। रिफ़्रेश करके फिर से पेमेंट मांगें।';

  @override
  String get planErrorRequired => 'पहले रेंटल प्लान चुनें और राइडर से उसे स्वीकार करवाएँ।';

  @override
  String get planErrorSelectionChanged => 'अभी-अभी कोई दूसरा प्लान चुना गया है। रिफ़्रेश करके फिर कोशिश करें।';

  @override
  String get planErrorSelectionClosed => 'अब प्लान नहीं बदला जा सकता।';

  @override
  String get planErrorTermsChanged => 'प्लान की शर्तें बदल गई हैं। रिफ़्रेश करके फिर से स्वीकार करें।';

  @override
  String get planFortnightly => 'पाक्षिक प्लान';

  @override
  String get planFree => 'मुफ़्त';

  @override
  String get planIncluded => 'शामिल';

  @override
  String get planInsurance => 'बीमा';

  @override
  String get planMonthly => 'मासिक प्लान';

  @override
  String get planOfferNotLive => 'यह ऑफ़र अब खुला नहीं है। आपका फ़्लीट मैनेजर नया ऑफ़र भेजेगा।';

  @override
  String get planOnboardingFee => 'ऑनबोर्डिंग शुल्क';

  @override
  String get planPayableToday => 'आज देय';

  @override
  String get planQuarterly => 'तिमाही प्लान';

  @override
  String planRefundableNote(String amount) {
    return 'इसमें $amount वापस मिलने वाला डिपॉज़िट शामिल है';
  }

  @override
  String get planRent => 'किराया';

  @override
  String get planScooterAgeAdjustment => 'स्कूटर की उम्र के हिसाब से बदलाव';

  @override
  String get planScooterDeposit => 'स्कूटर सिक्योरिटी डिपॉज़िट';

  @override
  String planUsageRate(String rate, String unit) {
    return '$rate प्रति $unit';
  }

  @override
  String get planValidUntil => 'ऑफ़र इस समय तक मान्य';

  @override
  String get planWeekly => 'साप्ताहिक प्लान';

  @override
  String planWeeks(int count) {
    return '$count सप्ताह का प्लान';
  }

  @override
  String get profileAddressHub => 'पता और हब';

  @override
  String get profileEmail => 'ईमेल';

  @override
  String get profileHub => 'हब';

  @override
  String get profileHubCode => 'हब कोड';

  @override
  String get profileJoined => 'जुड़ने की तिथि';

  @override
  String get profilePersonalDetails => 'निजी जानकारी';

  @override
  String get referActivity => 'गतिविधि';

  @override
  String referCardReward(String amount) {
    return 'मेरे कोड से जुड़ें और $amount पाएँ';
  }

  @override
  String get referCodeCopied => 'रेफ़रल कोड कॉपी हो गया';

  @override
  String referCompleteBy(String date) {
    return 'इन्हें $date तक पूरा करें';
  }

  @override
  String get referCopyCode => 'कोड कॉपी करें';

  @override
  String get referCopyMessage => 'आमंत्रण संदेश कॉपी करें';

  @override
  String get referCouldNotLoad => 'रेफ़र और कमाएं नहीं खुल पाया';

  @override
  String get referDetailTitle => 'रेफ़रल विवरण';

  @override
  String get referDrawerHint => 'दोस्त इसे स्कैन करके आपके कोड से जुड़ सकता है। बड़ा करने के लिए टैप करें।';

  @override
  String get referDrawerTitle => 'मेरा रेफ़रल QR';

  @override
  String get referErrorAlreadyLinked => 'आपका खाता पहले से किसी दूसरे रेफ़रल कोड से जुड़ा है।';

  @override
  String get referErrorCampaignInactive => 'रेफ़र और कमाएँ अभी चालू नहीं है।';

  @override
  String get referErrorCodeExpired => 'यह आमंत्रण समाप्त हो गया है। अपने दोस्त से नया भेजने को कहें।';

  @override
  String get referErrorLimit => 'इस राइडर की रेफ़रल सीमा पूरी हो गई है।';

  @override
  String get referErrorNotEligible => 'आपकी राइडर प्रोफ़ाइल अभी रेफ़रल के लिए तैयार नहीं है।';

  @override
  String get referErrorNotEnabled => 'आपकी कंपनी के लिए रेफ़र और कमाएँ उपलब्ध नहीं है।';

  @override
  String get referErrorNotFound => 'रेफ़रल नहीं मिला।';

  @override
  String get referErrorSelf => 'आप अपना रेफ़रल कोड इस्तेमाल नहीं कर सकते।';

  @override
  String get referEventExpired => 'एक रेफ़रल समाप्त हुआ';

  @override
  String get referEventOther => 'रेफ़रल अपडेट';

  @override
  String get referEventProgress => 'एक रेफ़रल आगे बढ़ा';

  @override
  String get referEventQualified => 'एक रेफ़रल इनाम के योग्य हुआ';

  @override
  String get referEventRegistered => 'एक राइडर रेफ़रल कोड से जुड़ा';

  @override
  String get referEventRewardPaid => 'एक रेफ़रल इनाम का भुगतान हुआ';

  @override
  String get referFriendGets => 'आपके दोस्त को मिलेगा';

  @override
  String get referHowItWorks => 'यह कैसे काम करता है';

  @override
  String get referHowItWorksBody =>
      'अपना कोड शेयर करें। जब आपका दोस्त जुड़कर ये कदम पूरे करेगा, तो रेफ़रल इनाम मिलेगा।';

  @override
  String get referInvited => 'आमंत्रित';

  @override
  String referInviteValidTill(String date) {
    return 'यह आमंत्रण $date तक मान्य है';
  }

  @override
  String get referMessageCopied => 'आमंत्रण संदेश कॉपी हुआ';

  @override
  String get referMilestoneActivated => 'राइडर के रूप में सक्रिय हों';

  @override
  String referMilestoneActiveDays(String count) {
    return '$count दिन सक्रिय रहें';
  }

  @override
  String referMilestoneAttendance(String count) {
    return '$count दिन हाज़िरी लगाएँ';
  }

  @override
  String referMilestoneDeliveries(String count) {
    return '$count डिलीवरी पूरी करें';
  }

  @override
  String get referMilestoneKyc => 'KYC पूरा करें';

  @override
  String get referMilestoneOther => 'अभियान का कदम पूरा करें';

  @override
  String get referMilestonePayment => 'पहला भुगतान करें';

  @override
  String referMilestoneRides(String count) {
    return '$count राइड पूरी करें';
  }

  @override
  String get referMilestoneTraining => 'प्रशिक्षण पूरा करें';

  @override
  String get referMilestoneVehicle => 'स्कूटर अलॉट करवाएँ';

  @override
  String get referNoCampaignBody => 'नए इनामों के लिए जल्द ही दोबारा देखें।';

  @override
  String get referNoCampaignTitle => 'अभी कोई रेफ़रल अभियान नहीं है';

  @override
  String get referNoReferralsBody => 'राइडर्स को आमंत्रित करने के लिए अपना कोड शेयर करें।';

  @override
  String get referNoReferralsTitle => 'अभी कोई रेफ़रल नहीं';

  @override
  String get referPaid => 'भुगतान हुआ';

  @override
  String get referPending => 'बाकी';

  @override
  String get referProgress => 'प्रगति';

  @override
  String get referQrSemantics => 'रेफ़रल QR कोड';

  @override
  String get referQualified => 'योग्य';

  @override
  String get referRegistered => 'पंजीकृत';

  @override
  String get referRewardEarned => 'अर्जित';

  @override
  String get referRewardPending => 'बाकी';

  @override
  String get referRewardProcessing => 'प्रोसेस हो रहा है';

  @override
  String get referRewardReversed => 'वापस लिया गया';

  @override
  String get referRewards => 'इनाम';

  @override
  String get referScanCameraFailed => 'कैमरा शुरू नहीं हो सका। फिर कोशिश करें, या QR कोड की फ़ोटो चुनें।';

  @override
  String referScanFound(String code) {
    return 'कोड $code मिला';
  }

  @override
  String get referScanFromPhotos => 'फ़ोटो से चुनें';

  @override
  String get referScanHint => 'कैमरे को रेफ़रल QR कोड की ओर करें';

  @override
  String get referScanNoCamera => 'इस डिवाइस पर स्कैन करने के लिए कैमरा नहीं है। इसके बजाय QR कोड की फ़ोटो चुनें।';

  @override
  String get referScanNoQrInPhoto => 'उस फ़ोटो में कोई QR कोड नहीं मिला।';

  @override
  String get referScanNotReferral => 'वह QR कोड रेफ़रल कोड नहीं है।';

  @override
  String get referScanPermissionDenied =>
      'कैमरा अनुमति बंद है। स्कैन करने के लिए सेटिंग्स में अनुमति दें, या QR कोड की फ़ोटो चुनें।';

  @override
  String get referScanTitle => 'रेफ़रल QR स्कैन करें';

  @override
  String get referScanToJoin => 'मेरे रेफ़रल कोड से जुड़ने के लिए स्कैन करें';

  @override
  String referShareAndroid(String link) {
    return 'Android पर ऐप पाएँ: $link';
  }

  @override
  String referShareCodeLine(String code) {
    return 'साइन अप करते समय मेरा रेफ़रल कोड $code इस्तेमाल करें।';
  }

  @override
  String referShareIntro(String app) {
    return '$app पर राइडर के रूप में मेरे साथ जुड़ें!';
  }

  @override
  String get referShareInvite => 'आमंत्रण भेजें';

  @override
  String referShareIphone(String link) {
    return 'iPhone पर ऐप पाएँ: $link';
  }

  @override
  String get referShareNow => 'शेयर करें';

  @override
  String referShareReward(String amount) {
    return 'जुड़ने के कदम पूरे करने पर आपको $amount मिलेंगे।';
  }

  @override
  String get referShareSubtitle => 'आपका दोस्त QR स्कैन करके या लिंक से जुड़ सकता है।';

  @override
  String get referShareTitle => 'अपना आमंत्रण शेयर करें';

  @override
  String get referShowQr => 'QR दिखाएँ';

  @override
  String get referStatusActivated => 'सक्रिय';

  @override
  String get referStatusCancelled => 'रद्द';

  @override
  String get referStatusDisqualified => 'अयोग्य';

  @override
  String get referStatusExpired => 'समाप्त';

  @override
  String get referStatusInProgress => 'प्रगति पर';

  @override
  String get referStatusKycVerified => 'KYC सत्यापित';

  @override
  String get referStatusPaid => 'इनाम का भुगतान हुआ';

  @override
  String get referStatusRejected => 'अस्वीकृत';

  @override
  String get referStatusRewardApproved => 'इनाम स्वीकृत';

  @override
  String get referStatusRewardPending => 'इनाम बाकी';

  @override
  String get referStatusUnderReview => 'समीक्षा में';

  @override
  String referStepsDone(int done, int total) {
    return '$done/$total कदम';
  }

  @override
  String get referSubtitle => 'राइडर्स को आमंत्रित करें और इनाम कमाएं';

  @override
  String get referTimeline => 'समयरेखा';

  @override
  String get referTotalEarned => 'कुल कमाई';

  @override
  String referValidTill(String date) {
    return '$date तक मान्य';
  }

  @override
  String get referYouGet => 'आपको मिलेगा';

  @override
  String get referYourCode => 'आपका रेफ़रल कोड';

  @override
  String get referYourQr => 'आपका रेफ़रल QR';

  @override
  String get referYourQrSubtitle => 'अपने दोस्त से ऐप के ऑनबोर्डिंग में इसे स्कैन करने को कहें।';

  @override
  String get referYourReferrals => 'आपके रेफ़रल';

  @override
  String get rentalsAutoDebit => 'ऑटो-डेबिट';

  @override
  String get rentalsAutoDebitKeepsEveryCycle =>
      'ऑटो-डेबिट से हर बार समय पर भुगतान हो जाता है, खुद भेजने की ज़रूरत नहीं';

  @override
  String get rentalsBillingPeriod => 'बिल अवधि';

  @override
  String get rentalsBills => 'बिल';

  @override
  String get rentalsCouldNotLoadBill => 'यह बिल लोड नहीं हो सका';

  @override
  String get rentalsCouldNotLoadLedger => 'आपकी खाता बही लोड नहीं हो सकी';

  @override
  String get rentalsCouldNotLoadPayments => 'आपके भुगतान लोड नहीं हो सके';

  @override
  String get rentalsCouldNotLoadRentPlan => 'आपका किराया प्लान नहीं खुल पाया';

  @override
  String get rentalsCredit => 'उपलब्ध क्रेडिट';

  @override
  String get rentalsCreditsApplied => 'लागू क्रेडिट';

  @override
  String get rentalsCurrentPlan => 'मौजूदा प्लान';

  @override
  String get rentalsDepositHeld => 'जमा राशि रखी गई';

  @override
  String get rentalsDue => 'देय तिथि';

  @override
  String get rentalsDueLater => 'बाद में देय';

  @override
  String get rentalsFromWallet => 'आपके वॉलेट से';

  @override
  String get rentalsInvoiceHistory => 'बिल इतिहास';

  @override
  String get rentalsLedger => 'खाता बही';

  @override
  String get rentalsLedgerAdjustment => 'समायोजन';

  @override
  String get rentalsLedgerCharge => 'शुल्क';

  @override
  String get rentalsLedgerCredit => 'क्रेडिट';

  @override
  String get rentalsLedgerDeposit => 'जमा राशि';

  @override
  String get rentalsLedgerHint => 'आपके खाते का हर शुल्क, भुगतान और क्रेडिट, सबसे नया पहले।';

  @override
  String get rentalsLedgerPayment => 'भुगतान';

  @override
  String get rentalsLedgerRefund => 'रिफ़ंड';

  @override
  String get rentalsLedgerReversal => 'रिवर्सल';

  @override
  String get rentalsNoInvoicesYet => 'अभी कोई बिल नहीं';

  @override
  String get rentalsNoLedger => 'खाता बही में अभी कुछ नहीं';

  @override
  String get rentalsNoLedgerBody => 'शुल्क और भुगतान होते ही यहाँ दिखेंगे।';

  @override
  String get rentalsNoPayments => 'अभी तक कोई भुगतान नहीं';

  @override
  String get rentalsNoPaymentsBody => 'आपके बिलों के लिए किए गए भुगतान यहाँ दिखेंगे।';

  @override
  String get rentalsOutstanding => 'बकाया';

  @override
  String rentalsOverdueNotice(String amount) {
    return '$amount की देय तिथि निकल चुकी है। बिना रुकावट चलाते रहने के लिए जल्द भुगतान करें।';
  }

  @override
  String get rentalsPaid => 'चुका दिया';

  @override
  String get rentalsPaid2 => 'भुगतान तिथि';

  @override
  String get rentalsPaidSoFar => 'अब तक भुगतान';

  @override
  String get rentalsPayments => 'भुगतान';

  @override
  String rentalsReceiptInvoices(int count) {
    return '$count बिल चुकाए गए';
  }

  @override
  String rentalsRefunded(String amount) {
    return '$amount वापस किया गया';
  }

  @override
  String get rentalsRentals => 'किराया';

  @override
  String get rentalsRentHandledAutomatically => 'किराया, अपने आप कट जाता है';

  @override
  String get rentalsRentReceipt => 'किराया रसीद';

  @override
  String get rentalsRentReceiptsWillAppearHere => 'आपकी किराया रसीदें यहां दिखेंगी।';

  @override
  String get rentalsStatusDraft => 'ड्राफ़्ट';

  @override
  String get rentalsStatusDue => 'देय';

  @override
  String get rentalsStatusOverdue => 'देय तिथि निकल गई';

  @override
  String get rentalsStatusPartlyPaid => 'आंशिक भुगतान';

  @override
  String get rentalsStatusVoid => 'रद्द';

  @override
  String get rentalsStillDue => 'अभी बाकी';

  @override
  String get rentalsSubtitle => 'आपका प्लान, बिल और खाते का इतिहास';

  @override
  String get rentalsSubtotal => 'उप-योग';

  @override
  String get rentalsTapReceiptSeeFullBreakdown => 'पूरा ब्यौरा देखने के लिए रसीद दबाएं';

  @override
  String get rentalsTax => 'टैक्स';

  @override
  String get rentalsUnallocated => 'अभी लागू न हुए भुगतान';

  @override
  String get rentalsYourAccount => 'आपका खाता';

  @override
  String get reportStatusMechanicallyOk => 'मैकेनिकली ठीक';

  @override
  String get reportStatusReadyForAllotment => 'अलॉटमेंट के लिए तैयार';

  @override
  String get reportStatusUnderRepairMajor => 'मरम्मत में: बड़ी';

  @override
  String get reportStatusUnderRepairMinor => 'मरम्मत में: छोटी';

  @override
  String get returnsApproveCharges => 'शुल्क मंज़ूर करें';

  @override
  String returnsApproveSubtitle(String amount) {
    return 'हमने आपके फ़ोन पर 6 अंकों का कोड भेजा है। इसे डालने से $amount के शुल्क मंज़ूर हो जाएँगे।';
  }

  @override
  String get returnsApproveTitle => 'कोड डालें';

  @override
  String get returnsCancel => 'वापसी रद्द करें';

  @override
  String get returnsCancelBody => 'स्कूटर आपके पास रहेगा और किराया पहले की तरह चलता रहेगा।';

  @override
  String get returnsCancelled => 'वापसी रद्द हो गई';

  @override
  String get returnsCancelTitle => 'यह वापसी रद्द करें?';

  @override
  String get returnsCharges => 'शुल्क';

  @override
  String get returnsChargesApproved => 'शुल्क मंज़ूर हो गए';

  @override
  String get returnsChargesPending => 'हब अभी स्कूटर की जाँच कर रहा है। कोई शुल्क हुआ तो यहाँ दिखेगा।';

  @override
  String get returnsCodeExpired => 'इस कोड की समय-सीमा खत्म हो गई। नया कोड मँगाएँ।';

  @override
  String get returnsCodeInvalid => 'यह कोड काम नहीं किया। जाँच कर फिर से कोशिश करें।';

  @override
  String get returnsCouldNotLoad => 'आपकी वापसी की जानकारी लोड नहीं हो सकी';

  @override
  String get returnsCouldNotLoadHubs => 'हब लोड नहीं हो सके';

  @override
  String get returnsDate => 'वापसी की तारीख';

  @override
  String get returnsDetails => 'विवरण';

  @override
  String get returnsDetailTitle => 'वापसी';

  @override
  String get returnsDisputeCharges => 'शुल्क पर आपत्ति करें';

  @override
  String get returnsDisputeReason => 'क्या गलत है?';

  @override
  String get returnsDisputeReasonRequired => 'कारण लिखें ताकि हब टीम समीक्षा कर सके।';

  @override
  String get returnsDisputeSent => 'आपत्ति हब टीम को भेज दी गई';

  @override
  String get returnsDisputeSubtitle => 'हब टीम को बताएँ कि इन शुल्कों में क्या गलत है।';

  @override
  String get returnsEndRentalBody =>
      'बताइए कि आप इसे कब और कहाँ लौटाएँगे। हब टीम इसकी जाँच करेगी, और कोई भी शुल्क पहले आपकी मंज़ूरी के लिए आएगा।';

  @override
  String get returnsEndRentalTitle => 'स्कूटर की ज़रूरत नहीं रही?';

  @override
  String get returnsErrorAlreadyReceived => 'यह स्कूटर पहले ही जमा हो चुका है।';

  @override
  String get returnsErrorAlreadyRequested => 'इस रेंटल के लिए वापसी की रिक्वेस्ट पहले से है।';

  @override
  String get returnsErrorApprovalNotPending => 'ये पेनल्टी आपकी मंज़ूरी के लिए बाकी नहीं हैं।';

  @override
  String get returnsErrorBeforeAgreement => 'वापसी का समय रेंटल शुरू होने से पहले का है।';

  @override
  String get returnsErrorInspectFirst => 'पेनल्टी जोड़ने से पहले वापसी की जाँच पूरी करें।';

  @override
  String get returnsErrorNotCancellable => 'यह वापसी अब रद्द नहीं की जा सकती।';

  @override
  String get returnsErrorNotDisputable => 'इन पेनल्टी पर अभी आपत्ति नहीं की जा सकती।';

  @override
  String get returnsErrorNotReceivable => 'यह वापसी रद्द हो चुकी है, इसलिए इस पर स्कूटर जमा नहीं हो सकता।';

  @override
  String get returnsErrorNotSubmittable => 'ये पेनल्टी अभी सबमिट नहीं की जा सकतीं।';

  @override
  String get returnsErrorNotTerminable => 'यह रेंटल अभी वापस नहीं किया जा सकता।';

  @override
  String get returnsErrorOverrideNotAllowed => 'इस स्टेज पर राइडर की मंज़ूरी को ओवरराइड नहीं किया जा सकता।';

  @override
  String get returnsErrorPenaltiesLocked => 'राइडर के पास होने या चार्ज हो जाने पर पेनल्टी बदली नहीं जा सकती।';

  @override
  String get returnsErrorReceiveFirst => 'पेनल्टी जोड़ने से पहले स्कूटर जमा करें।';

  @override
  String get returnsErrorRevisePenalties => 'राइडर ने इन पेनल्टी पर आपत्ति की है। सूची बदलकर फिर से सबमिट करें।';

  @override
  String get returnsErrorStateChanged => 'ये पेनल्टी अभी बदली हैं। रीफ़्रेश करके फिर कोशिश करें।';

  @override
  String get returnsErrorSubmitFirst => 'मंज़ूरी से पहले पेनल्टी सबमिट करें।';

  @override
  String returnsEvidenceCount(int count) {
    return 'सबूत के तौर पर $count फ़ोटो';
  }

  @override
  String get returnsHandedOver => 'सौंपा गया';

  @override
  String get returnsHub => 'वापसी हब';

  @override
  String get returnsKindDamage => 'नुकसान';

  @override
  String get returnsKindMissing => 'गायब सामान';

  @override
  String get returnsLocationForHubs => 'आपके सबसे पास के हब दिखाने के लिए हम आपकी लोकेशन का उपयोग करते हैं।';

  @override
  String get returnsNextCheckIn => 'हब टीम स्कूटर की फ़ोटो लेती है और मैकेनिक उसकी जाँच करता है।';

  @override
  String get returnsNextConfirm =>
      'रिपोर्ट और किसी भी शुल्क की पुष्टि के लिए आपके फ़ोन पर कोड आता है। पुष्टि होते ही आपका किराया खत्म हो जाता है।';

  @override
  String get returnsNextHandOver => 'चुनी हुई तारीख को स्कूटर, उसकी बैटरी और चार्जर हब पर लाएँ।';

  @override
  String get returnsNoCharges => 'इस वापसी पर कोई शुल्क नहीं।';

  @override
  String get returnsNoHubsNearby => 'आपके पास कोई हब नहीं मिला';

  @override
  String get returnsNone => 'अभी तक कोई वापसी नहीं';

  @override
  String get returnsNoneBody => 'जब आप स्कूटर लौटाएँगे, तो उसकी स्थिति यहाँ देख सकेंगे।';

  @override
  String get returnsNoteAdminApproved =>
      'एक एडमिन ने आपकी ओर से ये शुल्क मंज़ूर किए हैं। अब हब मैनेजर पुष्टि करेंगे। आप अब भी आपत्ति कर सकते हैं।';

  @override
  String get returnsNoteCancelled => 'आपने यह वापसी रद्द कर दी। आपका किराया पहले की तरह चलता रहेगा।';

  @override
  String get returnsNoteCheckInDone => 'वापसी बंद हुई। नीचे की सबमिशन रिपोर्ट में कोई भी शुल्क दिखता है।';

  @override
  String get returnsNoteCheckingIn =>
      'हब टीम आपके स्कूटर की जाँच कर रही है। मैकेनिक की रिपोर्ट तैयार होने पर पुष्टि के लिए आपके फ़ोन पर कोड आएगा।';

  @override
  String get returnsNoteDisputed => 'आपने इन शुल्कों पर आपत्ति की है। हब टीम इनकी समीक्षा करेगी और इन्हें बदल सकती है।';

  @override
  String get returnsNoteFinalChecks =>
      'आपके स्कूटर का सबमिशन हो गया है और आपका किराया खत्म हो गया है। मैकेनिक अंतिम जाँच कर रहा है, कुछ और मिलने पर आपसे पुष्टि माँगी जाएगी।';

  @override
  String get returnsNoteInspecting =>
      'स्कूटर हब पर है और उसकी जाँच हो रही है। कोई भी शुल्क आपकी मंज़ूरी के लिए यहाँ दिखेगा।';

  @override
  String get returnsNoteNeedsYou =>
      'हब ने नीचे दिए शुल्क पाए हैं। आपके फ़ोन पर भेजे गए कोड से उन्हें मंज़ूर करें, या उन पर आपत्ति करें।';

  @override
  String get returnsNoteNoCharges => 'वापसी पूरी हुई। स्कूटर ठीक हालत में लौटा, इसलिए कोई शुल्क नहीं है।';

  @override
  String returnsNoteRequested(String date) {
    return '$date को स्कूटर चुने हुए हब पर ले जाएँ। हब टीम सबमिशन शुरू करेगी।';
  }

  @override
  String get returnsNotes => 'कुछ और?';

  @override
  String returnsNoteSettled(String amount) {
    return 'वापसी पूरी हुई। $amount का शुल्क आपके बिल में जोड़ा गया।';
  }

  @override
  String get returnsNotesHint => 'हब टीम के लिए वैकल्पिक नोट';

  @override
  String get returnsNoteYouApproved => 'आपने शुल्क मंज़ूर कर दिए। अब हब मैनेजर उनकी पुष्टि करेंगे।';

  @override
  String get returnsNothingToReturn => 'अभी लौटाने के लिए कुछ नहीं है';

  @override
  String get returnsNothingToReturnBody => 'आपका कोई सक्रिय किराया नहीं है, या उसकी वापसी पहले से चल रही है।';

  @override
  String get returnsPickDate => 'वापसी की तारीख चुनें';

  @override
  String get returnsPickHub => 'हब चुनें';

  @override
  String get returnsPickHubSubtitle => 'आपके सबसे पास वाले हब ऊपर हैं';

  @override
  String get returnsPickReason => 'एक कारण चुनें';

  @override
  String returnsPlannedFor(String date) {
    return '$date के लिए तय';
  }

  @override
  String get returnsProgress => 'प्रगति';

  @override
  String get returnsReason => 'कारण';

  @override
  String get returnsReasonBatteryIssues => 'बैटरी या चार्जिंग में दिक्कत';

  @override
  String get returnsReasonChangingJob => 'नौकरी बदल रहे हैं';

  @override
  String get returnsReasonHealthOrFamily => 'स्वास्थ्य या पारिवारिक कारण';

  @override
  String get returnsReasonLowEarnings => 'पर्याप्त कमाई नहीं हो रही';

  @override
  String get returnsReasonNoLongerNeeded => 'अब इसकी ज़रूरत नहीं है';

  @override
  String get returnsReasonOwnVehicle => 'अपना वाहन खरीद लिया';

  @override
  String get returnsReasonRelocating => 'दूसरे शहर जा रहे हैं';

  @override
  String get returnsReasonServiceIssues => 'सेवा से संतुष्ट नहीं';

  @override
  String get returnsReasonTakingBreak => 'काम से कुछ समय की छुट्टी ले रहे हैं';

  @override
  String get returnsReasonTooExpensive => 'किराया बहुत ज़्यादा है';

  @override
  String get returnsReasonVehicleIssues => 'स्कूटर में दिक्कतें';

  @override
  String get returnsRequested => 'वापसी का अनुरोध हो गया। हब पर मिलते हैं।';

  @override
  String get returnsRequestReturn => 'वापसी का अनुरोध करें';

  @override
  String get returnsRequestSubtitle => 'तारीख और वह हब चुनें जहाँ आप इसे लाएँगे';

  @override
  String get returnsSendDispute => 'आपत्ति भेजें';

  @override
  String get returnsStatusAwaitingManager => 'हब मैनेजर के पास';

  @override
  String get returnsStatusCancelled => 'रद्द';

  @override
  String get returnsStatusCheckingIn => 'सबमिशन हो रहा है';

  @override
  String get returnsStatusClosed => 'बंद';

  @override
  String get returnsStatusDisputed => 'विवादित';

  @override
  String get returnsStatusFinalChecks => 'अंतिम जाँच';

  @override
  String get returnsStatusInspecting => 'जाँच चल रही है';

  @override
  String get returnsStatusNeedsYou => 'आपकी मंज़ूरी चाहिए';

  @override
  String get returnsStatusRequested => 'वापसी का अनुरोध';

  @override
  String get returnsStepCheckIn => 'स्कूटर सबमिट हुआ';

  @override
  String get returnsStepClosed => 'वापसी पूरी';

  @override
  String get returnsStepFinalChecks => 'अंतिम मैकेनिक जाँच';

  @override
  String get returnsStepHandedOver => 'स्कूटर सौंपा गया';

  @override
  String get returnsStepInspection => 'जाँच और शुल्क';

  @override
  String get returnsStepRequested => 'वापसी का अनुरोध';

  @override
  String get returnsSubtitle => 'किराया खत्म करें और स्कूटर वापस करें';

  @override
  String get returnsTitle => 'स्कूटर लौटाएँ';

  @override
  String get returnsWhenWhere => 'कब और कहाँ';

  @override
  String get returnsWhy => 'आप इसे क्यों लौटा रहे हैं?';

  @override
  String get returnsYourDispute => 'आपकी आपत्ति';

  @override
  String get returnsYourReturns => 'आपकी वापसी';

  @override
  String get rideParkedLocked => 'खड़ी और बंद है।';

  @override
  String get rideRideSafeHelmetLightsChecked => 'सावधानी से चलाएं। हेलमेट पहनें, लाइट जांचें।';

  @override
  String get ridersActive => 'चालू';

  @override
  String get ridersCall => 'कॉल करें';

  @override
  String get ridersExited => 'छोड़ दिया';

  @override
  String get ridersOnboarding => 'जुड़ने की प्रक्रिया';

  @override
  String get ridersTeam => 'टीम';

  @override
  String get rideScooterConnectedUsePowerButton => 'आपका स्कूटर जुड़ गया है। चालू करने के लिए पावर बटन दबाएं।';

  @override
  String get rideVehicle => 'गाड़ी चालू है';

  @override
  String get rideVehicleOff => 'गाड़ी बंद है';

  @override
  String routerNoScreenAt(String location) {
    return '$location पर कोई स्क्रीन नहीं';
  }

  @override
  String get scooterAllowedFromHub => 'हब से अनुमति';

  @override
  String get scooterBatteryCharge => 'बैटरी चार्ज';

  @override
  String get scooterBatterySerial => 'बैटरी सीरियल';

  @override
  String get scooterBatteryType => 'बैटरी का प्रकार';

  @override
  String get scooterCharging => 'चार्जिंग';

  @override
  String get scooterClusterManager => 'क्लस्टर मैनेजर';

  @override
  String get scooterControllerNumber => 'कंट्रोलर नंबर';

  @override
  String get scooterCouldNotLoadVehicle => 'आपकी गाड़ी की जानकारी नहीं खुल पाई';

  @override
  String get scooterDeliveryBox => 'डिलीवरी बॉक्स';

  @override
  String get scooterHealth => 'स्थिति';

  @override
  String get scooterHelmet => 'हेलमेट';

  @override
  String get scooterIdentity => 'पहचान';

  @override
  String get scooterMotorNumber => 'मोटर नंबर';

  @override
  String get scooterNextService => 'अगली सर्विस';

  @override
  String get scooterNoScooterHasBeenAllocated => 'आपको अभी कोई स्कूटर नहीं दिया गया है।';

  @override
  String get scooterNoScooterMessage => 'जब आपका फ्लीट मैनेजर आपको स्कूटर देगा, उसकी जानकारी यहाँ दिखेगी।';

  @override
  String get scooterNoScooterTitle => 'अभी कोई स्कूटर नहीं';

  @override
  String get scooterOdometerService => 'ओडोमीटर और सर्विस';

  @override
  String get scooterParked => 'खड़ी है';

  @override
  String get scooterPowertrain => 'पावरट्रेन';

  @override
  String get scooterRange => 'रेंज';

  @override
  String get scooterVehicleDetails => 'गाड़ी का ब्यौरा';

  @override
  String get scooterVehicleNumber => 'गाड़ी नंबर';

  @override
  String get scooterViewFullDetails => 'पूरा ब्यौरा देखें';

  @override
  String get scooterWhereBelongs => 'यह कहां का है';

  @override
  String get scooterWhoLooksAfter => 'आपका ध्यान कौन रखता है';

  @override
  String get submissionAddDamagedItem => 'खराब पार्ट जोड़ें';

  @override
  String get submissionBypass => 'कोड इस्तेमाल नहीं हो सकता?';

  @override
  String get submissionBypassing => 'कोड छोड़ा जा रहा है';

  @override
  String get submissionBypassReason => 'वे कोड से पुष्टि क्यों नहीं कर सकते?';

  @override
  String submissionBypassRider(String reason) {
    return 'राइडर का कोड छोड़ा गया: $reason';
  }

  @override
  String submissionBypassTeamLead(String reason) {
    return 'टीम लीड का कोड छोड़ा गया: $reason';
  }

  @override
  String submissionCancelledBecause(String reason) {
    return 'रद्द: $reason';
  }

  @override
  String get submissionCancelReason => 'कारण';

  @override
  String get submissionCancelReasonNeeded => 'रिपोर्ट रद्द करने का कारण लिखें।';

  @override
  String get submissionCancelReport => 'रिपोर्ट रद्द करें';

  @override
  String get submissionCancelReportHint => 'कारण बताएँ। इसके बाद आप नई रिपोर्ट दर्ज कर सकते हैं।';

  @override
  String get submissionCancelReportTitle => 'यह रिपोर्ट रद्द करें?';

  @override
  String get submissionCharges => 'शुल्क';

  @override
  String get submissionChassis => 'चेसिस';

  @override
  String get submissionChecksComplete => 'सभी मैकेनिक जाँच पूरी हैं';

  @override
  String get submissionChooseSparePart => 'खराब पार्ट चुनें';

  @override
  String get submissionChooseSparePartHint => 'कीमतें आपकी स्पेयर पार्ट्स सूची से आती हैं।';

  @override
  String get submissionCodeNotSent => 'कोड भेजा नहीं जा सका। फिर कोशिश करें या कारण दर्ज करें।';

  @override
  String get submissionCodePending => 'अभी कोड नहीं';

  @override
  String get submissionCodeSent => 'कोड भेजा गया';

  @override
  String submissionCodeSentTo(String phone) {
    return '$phone पर कोड भेजा गया';
  }

  @override
  String get submissionCodesSent => 'कोड भेजे गए';

  @override
  String get submissionCollect => 'पुष्टि लें';

  @override
  String get submissionConfirm => 'रिपोर्ट की पुष्टि करें';

  @override
  String get submissionConfirmed => 'रिपोर्ट की पुष्टि हुई';

  @override
  String get submissionConfirmHint =>
      'राइडर और टीम लीड दोनों को SMS से कोड मिलता है। पुष्टि के लिए दोनों कोड डालें। अगर कोई कोड इस्तेमाल न कर सके, तो कारण दर्ज करें।';

  @override
  String get submissionConfirmTitle => 'रिपोर्ट की पुष्टि';

  @override
  String get submissionCouldNotLoad => 'यह सबमिशन लोड नहीं हो सका';

  @override
  String get submissionCouldNotLoadParts => 'स्पेयर पार्ट्स लोड नहीं हो सके';

  @override
  String get submissionDamagedItems => 'नुकसान वाले पार्ट्स';

  @override
  String get submissionDamagedItemsHint =>
      'स्पेयर पार्ट्स की सूची से हर खराब पार्ट जोड़ें। उसकी कीमत अपने आप भर जाएगी।';

  @override
  String get submissionEvidence => 'सबूत की फ़ोटो';

  @override
  String get submissionEvidenceHint => 'वे फ़ोटो चुनें जो इस रिपोर्ट को साबित करती हैं।';

  @override
  String submissionEvidenceLimit(int count) {
    return 'आप अधिकतम $count फ़ोटो चुन सकते हैं।';
  }

  @override
  String get submissionEvidenceNeeded => 'कम से कम एक सबूत फ़ोटो चुनें।';

  @override
  String get submissionExchangeStarted => 'एक्सचेंज शुरू हुआ';

  @override
  String get submissionFindings => 'जाँच के नतीजे';

  @override
  String get submissionImpose => 'रिपोर्ट लागू करें';

  @override
  String get submissionImposeBody =>
      'पक्का करें कि राइडर ने जाँच के नतीजे और शुल्क देख लिए हैं। इसके बाद रिपोर्ट बदली नहीं जा सकती, सिर्फ़ रद्द की जा सकती है।';

  @override
  String get submissionImposed => 'रिपोर्ट लागू हुई';

  @override
  String get submissionImposeTitle => 'यह रिपोर्ट लागू करें?';

  @override
  String get submissionItemNote => 'नोट (वैकल्पिक)';

  @override
  String get submissionItemNoteHint => 'नुकसान कहाँ है?';

  @override
  String get submissionItemPhotoNeeded => 'इस पार्ट की कम से कम एक फ़ोटो लें।';

  @override
  String get submissionItemPhotoOptionalHint =>
      'इस पार्ट के लिए फ़ोटो ज़रूरी नहीं है, पर राइडर के सवाल होने पर यह काम आती है।';

  @override
  String get submissionItemPhotoRequiredHint =>
      'इस पार्ट के लिए सबूत की फ़ोटो ज़रूरी है। नुकसान की साफ़ नज़दीकी फ़ोटो लें।';

  @override
  String get submissionMaintenanceDetails => 'क्या ठीक करना है?';

  @override
  String get submissionMechanicName => 'जमा करने वाले / मैकेनिक का नाम';

  @override
  String get submissionNameNeeded => 'मैकेनिक का नाम लिखें';

  @override
  String get submissionNextComplete => 'सभी जाँच पूरी हो गईं। यहाँ और कुछ नहीं करना है।';

  @override
  String get submissionNextLabel => 'अगला कदम';

  @override
  String get submissionNextOtps => 'रिपोर्ट की पुष्टि के लिए राइडर और टीम लीड के कोड लें।';

  @override
  String submissionNextPhotos(int count) {
    return 'अभी लेनी बाकी फ़ोटो: $count। फिर मैकेनिक की रिपोर्ट दर्ज करें।';
  }

  @override
  String get submissionNextReport => 'सभी फ़ोटो आ गईं। अब मैकेनिक की रिपोर्ट दर्ज करें।';

  @override
  String get submissionNextReview => 'राइडर के साथ रिपोर्ट और शुल्क देखें, फिर उसे लागू करें।';

  @override
  String get submissionNoDamagedItems => 'कोई खराब पार्ट नहीं जोड़ा गया, इसलिए राइडर से कोई शुल्क नहीं लिया जाएगा।';

  @override
  String get submissionNoPrices => 'अभी कोई पेनल्टी कीमत सेट नहीं है। डैशबोर्ड पर जोड़ने के लिए एडमिन से कहें।';

  @override
  String get submissionNoSparePartMatch => 'आपकी खोज से कोई पार्ट नहीं मिला';

  @override
  String get submissionNothingToConfirm => 'पुष्टि के लिए कुछ नहीं';

  @override
  String get submissionNothingToConfirmBody => 'इस सबमिशन पर कोड का इंतज़ार कर रही कोई लागू रिपोर्ट नहीं है।';

  @override
  String get submissionPartyRider => 'राइडर';

  @override
  String get submissionPartyTeamLead => 'टीम लीड';

  @override
  String submissionPhotoBattery(String name) {
    return 'बैटरी $name';
  }

  @override
  String get submissionPhotoBatteryGeneric => 'बैटरी';

  @override
  String get submissionPhotoChecklist => 'वापसी चेकलिस्ट';

  @override
  String submissionPhotoController(String number) {
    return 'कंट्रोलर $number';
  }

  @override
  String get submissionPhotoControllerGeneric => 'कंट्रोलर';

  @override
  String get submissionPhotoDamage => 'नुकसान की फ़ोटो';

  @override
  String get submissionPhotoIot => 'IoT डिवाइस';

  @override
  String get submissionPhotos => 'ज़रूरी फ़ोटो';

  @override
  String get submissionPhotosHint =>
      'फ़ोटो लेने के लिए खाली स्लॉट पर टैप करें। ली गई फ़ोटो देखने के लिए उस पर टैप करें।';

  @override
  String get submissionPriceChanged => 'किसी पार्ट की कीमत या फ़ोटो का नियम अभी बदला है। उसे हटाकर सूची से फिर जोड़ें।';

  @override
  String get submissionQuantity => 'मात्रा';

  @override
  String get submissionReceivingHub => 'प्राप्त करने वाला हब';

  @override
  String get submissionRecordReport => 'मैकेनिक रिपोर्ट दर्ज करें';

  @override
  String get submissionRemovePhoto => 'फ़ोटो हटाएँ';

  @override
  String submissionReportBy(String name) {
    return '$name द्वारा';
  }

  @override
  String get submissionReportCancelled => 'रिपोर्ट रद्द हुई';

  @override
  String get submissionReports => 'मैकेनिक रिपोर्ट';

  @override
  String get submissionReportSaved => 'रिपोर्ट सहेजी गई';

  @override
  String get submissionReportSummary => 'सारांश';

  @override
  String get submissionReportSummaryHint =>
      'सेव करने से पहले सबूत की फ़ोटो और शुल्क जाँच लें। रिपोर्ट लागू करने पर राइडर से ये शुल्क भरने को कहा जाएगा।';

  @override
  String get submissionResendAll => 'कोड दोबारा भेजें';

  @override
  String get submissionRiderNote => 'राइडर का नोट';

  @override
  String get submissionSafeQuestion => 'स्कूटर की मौजूदा स्थिति';

  @override
  String get submissionSafetyNeeded => 'स्कूटर की मौजूदा स्थिति चुनें';

  @override
  String get submissionsAll => 'सभी';

  @override
  String get submissionSaveItem => 'पार्ट सहेजें';

  @override
  String get submissionSaveReport => 'रिपोर्ट सहेजें';

  @override
  String submissionScooterStatusLine(String status) {
    return 'स्कूटर की स्थिति: $status';
  }

  @override
  String get submissionsCouldNotLoad => 'वापसी और एक्सचेंज लोड नहीं हो सके';

  @override
  String get submissionsDrawerSubtitle => 'वापस आए स्कूटरों का सबमिशन शुरू करें';

  @override
  String submissionsDropOff(String date) {
    return 'जमा $date';
  }

  @override
  String get submissionsDropOffDate => 'जमा करने की तारीख';

  @override
  String get submissionSearchSpareParts => 'पार्ट के नाम या कोड से खोजें';

  @override
  String get submissionsEmptyAll => 'आपके हब की वापसी और एक्सचेंज यहाँ दिखते हैं।';

  @override
  String get submissionsEmptyChecks => 'कोई सबमिशन चल नहीं रहा है।';

  @override
  String get submissionsEmptyScheduled => 'अभी आपके हब पर कोई स्कूटर आना बाकी नहीं है।';

  @override
  String get submissionsEmptyTitle => 'यहाँ कुछ नहीं है';

  @override
  String get submissionSendCodes => 'कोड भेजें';

  @override
  String get submissionsExchanges => 'एक्सचेंज';

  @override
  String get submissionsExchangesDue => 'बाकी एक्सचेंज';

  @override
  String get submissionsInChecks => 'जाँच में';

  @override
  String get submissionSourceExchange => 'एक्सचेंज';

  @override
  String get submissionSourceReturn => 'वापसी';

  @override
  String get submissionsReturns => 'वापसी';

  @override
  String get submissionsReturnsDue => 'बाकी वापसी';

  @override
  String get submissionsScheduled => 'निर्धारित';

  @override
  String get submissionsSubtitle => 'राइडर्स जो स्कूटर आपके हब पर वापस लाते हैं, उनका सबमिशन शुरू करें।';

  @override
  String submissionStaffReturnBody(String rider, String vehicle) {
    return 'इससे $vehicle का सबमिशन अभी शुरू होगा। मैकेनिक की रिपोर्ट की पुष्टि होते ही $rider का किराया खत्म हो जाएगा।';
  }

  @override
  String get submissionStaffReturnTitle => 'यह स्कूटर वापस लें?';

  @override
  String get submissionStageCheckingIn => 'सबमिशन हो रहा है';

  @override
  String get submissionStageDone => 'पूरा';

  @override
  String get submissionStageScheduled => 'निर्धारित';

  @override
  String get submissionStart => 'सबमिशन शुरू करें';

  @override
  String get submissionStartBody =>
      'राइडर स्कूटर के साथ हब पर आ जाए तब शुरू करें। सबमिशन पूरा होने तक स्कूटर दोबारा अलॉट नहीं हो सकता।';

  @override
  String get submissionStartBodyExchange =>
      'राइडर स्कूटर के साथ हब पर आ जाए तब शुरू करें। एक्सचेंज पूरा होने तक स्कूटर दोबारा अलॉट नहीं हो सकता।';

  @override
  String get submissionStarted => 'सबमिशन शुरू हुआ';

  @override
  String get submissionStartedAt => 'शुरू हुआ';

  @override
  String get submissionStartExchange => 'एक्सचेंज शुरू करें';

  @override
  String get submissionStartTitle => 'सबमिशन शुरू करें';

  @override
  String get submissionStatusAvailableHint => 'चलाने के लिए सुरक्षित। स्कूटर फ्लीट में वापस जाएगा।';

  @override
  String get submissionStatusAwaitingPartsHint => 'स्पेयर पार्ट्स का इंतज़ार। लगने तक इसे अलॉट नहीं किया जा सकता।';

  @override
  String get submissionStatusBrokenHint => 'बड़ी मरम्मत चाहिए। मरम्मत होने तक इसे अलॉट नहीं किया जा सकता।';

  @override
  String get submissionStatusCancelled => 'रद्द';

  @override
  String get submissionStatusMaintenanceHint => 'मरम्मत चाहिए। ठीक होने तक इसे अलॉट नहीं किया जा सकता।';

  @override
  String get submissionsTitle => 'वापसी और एक्सचेंज';

  @override
  String get submissionSummary => 'मैकेनिक को क्या मिला';

  @override
  String get submissionSummaryHint => 'बॉडी, बैटरी, कंट्रोलर और एक्सेसरीज़ की हालत';

  @override
  String get submissionSummaryNeeded => 'बताएँ कि मैकेनिक को क्या मिला';

  @override
  String get submissionUseCode => 'इसके बजाय कोड इस्तेमाल करें';

  @override
  String get submissionVerifiedRider => 'राइडर ने कोड से पुष्टि की';

  @override
  String get submissionVerifiedTeamLead => 'टीम लीड ने कोड से पुष्टि की';

  @override
  String get submissionVerify => 'कोड सत्यापित करें';

  @override
  String get submissionViewPhoto => 'फ़ोटो देखें';

  @override
  String get submissionWhatNeedsWorkNeeded => 'बताएँ कि क्या ठीक करना है';

  @override
  String get supportAccidentTheft => 'दुर्घटना या चोरी';

  @override
  String get supportAddFewMoreDetails10 => 'थोड़ा और विस्तार से बताएं (10+ अक्षर)';

  @override
  String get supportAll => 'सभी';

  @override
  String get supportBatteryCharging => 'बैटरी या चार्जिंग';

  @override
  String get supportBreakdownRoad => 'रास्ते में खराबी';

  @override
  String get supportCouldNotLoadSupport => 'सहायता नहीं खुल पाई';

  @override
  String get supportCouldNotLoadTicket => 'यह टिकट लोड नहीं हो सका';

  @override
  String get supportDescription => 'विवरण';

  @override
  String get supportDeskEmpty => 'यहाँ कोई टिकट नहीं';

  @override
  String get supportDeskEmptyBody => 'आपके हब पर राइडर्स जो टिकट बनाएँगे, वे यहाँ दिखेंगे।';

  @override
  String get supportDeskSubtitle => 'आपके हब के राइडर्स के टिकट';

  @override
  String get supportDeskTitle => 'सपोर्ट डेस्क';

  @override
  String get supportDocumentsKyc => 'दस्तावेज़ और केवाईसी';

  @override
  String get supportHub => 'हब';

  @override
  String get supportInProgress => 'प्रगति में';

  @override
  String get supportMarkResolved => 'हल हुआ मानें';

  @override
  String get supportMoreDetailGiveFasterCan => 'आप जितना ज़्यादा बताएंगे, हम उतनी जल्दी मदद कर पाएंगे';

  @override
  String get supportNeedHelpWithSomething => 'किसी चीज़ में मदद चाहिए?';

  @override
  String get supportNothingOpenRightNow => 'अभी कुछ खुला नहीं है';

  @override
  String get supportNoTicketsYet => 'अभी कोई शिकायत नहीं';

  @override
  String get supportOneLineSumsUpIssue => 'एक लाइन में समस्या बताएं';

  @override
  String supportOpenCount(int count) {
    return '$count खुले';
  }

  @override
  String get supportOpenTickets => 'खुली शिकायतें';

  @override
  String get supportPaymentWallet => 'भुगतान या वॉलेट';

  @override
  String get supportPdfAttachment => 'PDF दस्तावेज़';

  @override
  String supportPhotosHint(int count) {
    return 'समस्या समझाने में मदद हो तो $count तक फ़ोटो जोड़ें।';
  }

  @override
  String supportPhotosNotAttached(int count) {
    return 'टिकट बन गया, लेकिन $count फ़ोटो नहीं जुड़ सकीं। आप उन्हें टिकट से जोड़ सकते हैं।';
  }

  @override
  String get supportPhotosOptional => 'फ़ोटो (वैकल्पिक)';

  @override
  String get supportPickTopic => 'कोई विषय चुनें, या नीचे अपना विषय लिखें।';

  @override
  String supportRaisedOn(String date) {
    return '$date को बनाया गया';
  }

  @override
  String get supportRaiseOneAboveIfSomething => 'कुछ ठीक कराना हो तो ऊपर दर्ज करें।';

  @override
  String get supportRaiseTicket => 'शिकायत दर्ज करें';

  @override
  String get supportResolveBody => 'राइडर अब भी जवाब दे सकता है। उनका जवाब टिकट फिर से खोल देगा।';

  @override
  String get supportResolved => 'हल हो गया';

  @override
  String get supportResolvedReplyToReopen =>
      'यह टिकट हल हो चुका है। अगर अब भी मदद चाहिए तो संदेश भेजें, टिकट फिर से खुल जाएगा।';

  @override
  String get supportResolveTitle => 'इस टिकट को हल हुआ मानें?';

  @override
  String get supportSomethingElse => 'कुछ और';

  @override
  String get supportStartWorking => 'काम शुरू करें';

  @override
  String get supportStatusUpdated => 'टिकट की स्थिति अपडेट हुई';

  @override
  String get supportSubject => 'विषय';

  @override
  String get supportSubmitTicket => 'शिकायत जमा करें';

  @override
  String get supportTeam => 'सपोर्ट टीम';

  @override
  String get supportTeamLeadSeesStraightAway => 'आपका टीम लीड इसे तुरंत देख लेता है।';

  @override
  String get supportTellUsMore => 'और बताएं';

  @override
  String get supportTellUsWhatAbout => 'बताएं यह किस बारे में है';

  @override
  String get supportTellUsWhatHappenedAttach => 'बताएं क्या हुआ, और मदद मिले तो फ़ोटो भी लगाएं। ';

  @override
  String get supportTicket => 'टिकट';

  @override
  String get supportTicketRaised => 'टिकट बन गया। हमारी टीम इस पर काम कर रही है।';

  @override
  String get supportTicketReopened => 'टिकट फिर से खुल गया। हमारी टीम आपसे संपर्क करेगी।';

  @override
  String get supportTickets => 'आपकी शिकायतें';

  @override
  String supportUpdated(String time) {
    return '$time अपडेट हुआ';
  }

  @override
  String get supportWhatHappenedSinceWhen => 'क्या हुआ, और कब से?';

  @override
  String get supportWhatsTheIssue => 'क्या समस्या है';

  @override
  String get supportWriteMessage => 'संदेश लिखें';

  @override
  String get supportYou => 'आप';

  @override
  String get swapCouldNotLoad => 'स्वैप स्टेशन नहीं खुल पाए';

  @override
  String get swapNoneBody => 'अभी हमें कोई बैटरी स्वैप स्टेशन नहीं मिला।';

  @override
  String get swapNoneTitle => 'कोई स्वैप स्टेशन नहीं मिला';

  @override
  String get swapSubtitle => 'आपके सबसे नज़दीकी स्वैप स्टेशन';

  @override
  String get swapTitle => 'बैटरी स्वैपिंग';

  @override
  String swapUnits(String count) {
    return 'यूनिट: $count';
  }

  @override
  String get teamAdvisor => 'सलाहकार';

  @override
  String get teamBatteryExpert => 'बैटरी एक्सपर्ट';

  @override
  String get teamMotorControllerRepair => 'मोटर कंट्रोलर रिपेयर';

  @override
  String get teamNotIncluded => 'फ़ीचर शामिल नहीं';

  @override
  String get teamNotIncludedMessage => 'यह फ़ीचर आपके मौजूदा पैकेज में शामिल नहीं है।';

  @override
  String get teamTechnician => 'टेक्नीशियन';

  @override
  String get trainingCareClean => 'साफ़ रखें';

  @override
  String get trainingCareCleanBody => 'स्कूटर को साफ़ और अच्छी हालत में रखें।';

  @override
  String get trainingCareReport => 'समस्या तुरंत बताएँ';

  @override
  String get trainingCareReportBody =>
      'कोई भी दुर्घटना, नुकसान, अजीब आवाज़, वॉर्निंग लाइट या वाहन में खराबी हो तो तुरंत हमें बताएँ।';

  @override
  String get trainingCareTamper => 'छेड़छाड़ न करें';

  @override
  String get trainingCareTamperBody =>
      'बैटरी, मोटर, कंट्रोलर, वायरिंग या GPS डिवाइस को न खोलें, न बदलें और न ही उनसे छेड़छाड़ करें।';

  @override
  String get trainingCareWater => 'गहरे पानी में न ले जाएँ';

  @override
  String get trainingCareWaterBody =>
      'स्कूटर को बाढ़ वाले या गहरे पानी वाले इलाकों से न ले जाएँ और उस पर तेज़ प्रेशर वाला पानी न डालें।';

  @override
  String get trainingChargeEquipment => 'मंज़ूर उपकरण ही इस्तेमाल करें';

  @override
  String get trainingChargeEquipmentBody => 'सिर्फ़ हमारे दिए या मंज़ूर किए गए चार्जर/बैटरी/एक्सेसरी इस्तेमाल करें।';

  @override
  String get trainingChargePark => 'ज़िम्मेदारी से पार्क करें';

  @override
  String get trainingChargeParkBody => 'अनुमति वाली जगहों पर सुरक्षित पार्क करें और पानी, आग या चोरी के खतरे से बचें।';

  @override
  String get trainingChargeRide => 'ज़िम्मेदारी से चलाएँ';

  @override
  String get trainingChargeRideBody =>
      'ओवरलोडिंग, लापरवाही से चलाना, जंप करना, रेस लगाना या स्कूटर का गलत इस्तेमाल न करें।';

  @override
  String get trainingChargeStations => 'सिर्फ़ तय स्टेशनों पर चार्ज/स्वैप करें';

  @override
  String get trainingChargeStationsBody => 'सिर्फ़ मंज़ूर किए गए चार्जिंग/स्वैपिंग स्टेशन ही इस्तेमाल करें।';

  @override
  String get trainingCharging => 'चार्जिंग और इस्तेमाल';

  @override
  String get trainingChargingSummary => 'सुरक्षित, आसान और बिना झंझट की राइड के लिए ये आसान नियम मानें।';

  @override
  String get trainingKeyPoints => 'मुख्य बातें';

  @override
  String get trainingPayApp => 'भुगतान सिर्फ़ ऐप से';

  @override
  String get trainingPayAppBody =>
      'किराया, डिपॉज़िट और बाकी सभी भुगतान सिर्फ़ आधिकारिक ऐप/पेमेंट प्रक्रिया से ही करें।';

  @override
  String get trainingPayBribe => 'रिश्वत / गैर-आधिकारिक भुगतान नहीं';

  @override
  String get trainingPayBribeBody =>
      'किसी TL या कंपनी प्रतिनिधि को कभी रिश्वत, कमीशन या निजी भुगतान न दें और न ही इसकी पेशकश करें।';

  @override
  String get trainingPayCash => 'नकद भुगतान नहीं';

  @override
  String get trainingPayCashBody => 'किसी भी TL, स्टाफ़ या प्रतिनिधि को नकद भुगतान न करें।';

  @override
  String get trainingPayments => 'भुगतान और आचरण';

  @override
  String get trainingPaymentsSummary => 'सुरक्षित, पारदर्शी और बिना झंझट के लेन-देन के लिए ये आसान नियम मानें।';

  @override
  String get trainingPayReport => 'शिकायत बताएँ';

  @override
  String get trainingPayReportBody =>
      'अगर कोई नकद या रिश्वत माँगे, बिना अनुमति का शुल्क ले, गलत व्यवहार करे या कोई और समस्या हो, तो सीधे हमें बताएँ।';

  @override
  String get trainingVehicleCare => 'वाहन की देखभाल';

  @override
  String get trainingVehicleCareSummary => 'हर राइड के लिए स्कूटर को सुरक्षित, साफ़ और तैयार रखें।';

  @override
  String get trainingViewed => 'देख लिया';

  @override
  String get validationEnterDateBeforeToday => 'आज या उससे पहले की तारीख डालें';

  @override
  String get validationEnterDateLaterThanToday => 'आज के बाद की तारीख डालें';

  @override
  String get validationEnterValid12DigitAadhaar => 'सही 12 अंकों का आधार नंबर डालें';

  @override
  String get validationEnterValidEmailAddress => 'सही ईमेल पता डालें';

  @override
  String get validationEnterValidIfscCode => 'सही आईएफ़एससी कोड डालें';

  @override
  String get validationEnterValidPanAbcde1234f => 'सही पैन डालें (ABCDE1234F)';

  @override
  String get validationEnterValidUpiId => 'सही यूपीआई आईडी डालें';

  @override
  String get validationField => 'यह खाना';

  @override
  String get verifyApprove => 'स्वीकार करें';

  @override
  String get verifyApproveAllFirst => 'वाहन आवंटित करने के लिए सभी दस्तावेज़ स्वीकार करें।';

  @override
  String get verifyApproved => 'स्वीकृत';

  @override
  String get verifyApproveDocument => 'यह दस्तावेज़ स्वीकार करें?';

  @override
  String verifyApproveMessage(String name) {
    return '$name को सत्यापित माना जाएगा। इसे बाद में बदला नहीं जा सकता।';
  }

  @override
  String get verifyApproveReference => 'यह रेफ़रेंस स्वीकार करें?';

  @override
  String get verifyContinue => 'वाहन आवंटित करने के लिए आगे बढ़ें';

  @override
  String get verifyCouldNotCall => 'कॉल शुरू नहीं हो सकी।';

  @override
  String get verifyCouldNotLoad => 'यह सूची लोड नहीं हो सकी।';

  @override
  String get verifyDocumentApproved => 'दस्तावेज़ स्वीकार हो गया';

  @override
  String get verifyDocumentRejected => 'दस्तावेज़ अस्वीकार हो गया';

  @override
  String get verifyDocuments => 'दस्तावेज़';

  @override
  String get verifyDocumentsHint => 'राइडर के अपलोड किए हर दस्तावेज़ को खोलकर देखें, फिर उसे स्वीकार या अस्वीकार करें।';

  @override
  String get verifyDocumentsLocked =>
      'फ़्लीट मैनेजर अभी दस्तावेज़ों की जाँच नहीं कर सकते। आपके एडमिन डैशबोर्ड पर इनकी जाँच कर सकते हैं।';

  @override
  String get verifyNoDocuments => 'राइडर ने अभी तक कोई दस्तावेज़ अपलोड नहीं किया है।';

  @override
  String get verifyNoReferences => 'राइडर ने कोई रेफ़रेंस नहीं जोड़ा है।';

  @override
  String get verifyReason => 'कारण';

  @override
  String get verifyReasonHint => 'जैसे फ़ोटो धुंधली है';

  @override
  String get verifyReasonRequired => 'कारण लिखें';

  @override
  String get verifyReferenceApproved => 'रेफ़रेंस स्वीकार हो गया';

  @override
  String get verifyReferenceRejected => 'रेफ़रेंस अस्वीकार हो गया';

  @override
  String get verifyReferences => 'रेफ़रेंस';

  @override
  String get verifyReferencesHint => 'पुष्टि के लिए हर रेफ़रेंस को कॉल करें, फिर स्वीकार या अस्वीकार करें।';

  @override
  String get verifyReject => 'अस्वीकार करें';

  @override
  String get verifyRejected => 'अस्वीकृत';

  @override
  String get verifyRejectSubtitle => 'अस्वीकार करने का छोटा-सा कारण लिखें।';

  @override
  String verifyRejectTitle(String name) {
    return '$name अस्वीकार करें';
  }

  @override
  String verifyReviewedBy(String name) {
    return '$name ने जाँच की';
  }

  @override
  String get verifyTitle => 'राइडर की जाँच करें';

  @override
  String verifyUploadedOn(String date) {
    return '$date को अपलोड किया';
  }

  @override
  String get verifyView => 'देखें';

  @override
  String get walletAvailable => 'उपलब्ध';

  @override
  String get walletCash => 'नकद';

  @override
  String get walletClosingBalance => 'अंतिम बैलेंस';

  @override
  String walletCompletedOn(String date) {
    return '$date को पूरा';
  }

  @override
  String get walletCouldNotLoadDeposit => 'जमा राशि का विवरण रीफ़्रेश नहीं हो सका';

  @override
  String get walletCouldNotLoadReceipt => 'रसीद लोड नहीं हो सकी';

  @override
  String get walletCouldNotLoadStatement => 'आपका स्टेटमेंट लोड नहीं हो सका';

  @override
  String get walletCouldNotLoadWallet => 'आपका वॉलेट नहीं खुल पाया';

  @override
  String get walletCredited => 'जमा हुआ';

  @override
  String get walletCredits => 'जमा';

  @override
  String get walletDateTime => 'तारीख और समय';

  @override
  String get walletDebits => 'निकासी';

  @override
  String get walletDeducted => 'काटा गया';

  @override
  String get walletDeploymentPayment => 'तैनाती भुगतान';

  @override
  String get walletDeposit => 'जमा राशि';

  @override
  String get walletDepositDeducted => 'काटी गई';

  @override
  String get walletDepositHeld => 'रखी गई';

  @override
  String get walletDepositLocked => 'आपके किराए के लिए लॉक';

  @override
  String walletDepositMoved(String amount) {
    return 'जमा राशि $amount';
  }

  @override
  String get walletDepositPaidIn => 'जमा किया';

  @override
  String get walletDepositRequired => 'ज़रूरी राशि';

  @override
  String get walletDepositReturnedAmount => 'लौटाई गई';

  @override
  String get walletDepositReturnedSeparately => 'आपकी जमा राशि छोड़ते समय अलग से वापस मिलती है।';

  @override
  String get walletDepositReturns => 'वापसी';

  @override
  String get walletDepositStatusCancelled => 'रद्द';

  @override
  String get walletDepositStatusForfeited => 'ज़ब्त';

  @override
  String get walletDepositStatusLocked => 'आपके किराए के लिए रखी गई';

  @override
  String get walletDepositStatusPaid => 'भुगतान हो गया';

  @override
  String get walletDepositStatusPartlyDeducted => 'आंशिक रूप से काटी गई';

  @override
  String get walletDepositStatusPartlyPaid => 'आंशिक भुगतान';

  @override
  String get walletDepositStatusPending => 'भुगतान का इंतज़ार';

  @override
  String get walletDepositStatusReturnable => 'लौटाने के लिए तैयार';

  @override
  String get walletDepositStatusReturned => 'लौटा दी गई';

  @override
  String get walletDepositStatusReturnRequested => 'वापसी का अनुरोध किया';

  @override
  String get walletDepositToPay => 'अभी देना बाकी';

  @override
  String get walletDestination => 'किसे दिया गया';

  @override
  String get walletDueNow => 'अभी देना है';

  @override
  String get walletErrorDepositNotFound => 'यह डिपॉज़िट उपलब्ध नहीं है।';

  @override
  String get walletErrorNotFound => 'आपका वॉलेट अभी सेट नहीं हुआ है।';

  @override
  String get walletErrorReceiptNotFound => 'यह रसीद उपलब्ध नहीं है।';

  @override
  String get walletErrorStatementPeriod => 'उस अवधि का स्टेटमेंट उपलब्ध नहीं है।';

  @override
  String get walletErrorTransactionNotFound => 'यह लेनदेन उपलब्ध नहीं है।';

  @override
  String get walletExpiringSoon => '7 दिन में खत्म';

  @override
  String walletFundedOf(String funded, String required) {
    return '$required में से $funded';
  }

  @override
  String get walletInvoicesSettled => 'चुकाए गए बिल';

  @override
  String get walletIssued => 'जारी';

  @override
  String get walletKindAdjustment => 'समायोजन';

  @override
  String get walletKindDeposit => 'सुरक्षा जमा';

  @override
  String get walletKindPayment => 'भुगतान';

  @override
  String get walletKindPenalty => 'जुर्माना';

  @override
  String get walletKindRefund => 'वापसी';

  @override
  String get walletKindRental => 'किराया';

  @override
  String get walletKindReward => 'इनाम';

  @override
  String get walletKindService => 'सर्विस चार्ज';

  @override
  String get walletKindTopUp => 'पैसे जोड़े';

  @override
  String get walletLedgerWillFillUpAs => 'जैसे-जैसे आप चलाएंगे और कमाएंगे, आपका खाता भरता जाएगा।';

  @override
  String get walletMethod => 'तरीका';

  @override
  String get walletMoney => 'आपका पैसा';

  @override
  String get walletMoneyIn => 'आया पैसा';

  @override
  String get walletMoneyOut => 'गया पैसा';

  @override
  String get walletNothingMatchesFilterYet => 'इस फ़िल्टर से अभी कुछ नहीं मिला।';

  @override
  String get walletNoTransactionsHere => 'यहां कोई लेनदेन नहीं';

  @override
  String get walletOnHold => 'रोका गया';

  @override
  String get walletOpeningBalance => 'शुरुआती बैलेंस';

  @override
  String get walletPayments => 'भुगतान';

  @override
  String get walletReceipt => 'रसीद';

  @override
  String get walletReceiptNumber => 'रसीद संख्या';

  @override
  String get walletReferenceId => 'रेफ़रेंस आईडी';

  @override
  String get walletRefundable => 'वापस मिलने योग्य';

  @override
  String walletRequestedOn(String date) {
    return '$date को अनुरोध';
  }

  @override
  String get walletReturnApproved => 'मंज़ूर';

  @override
  String get walletReturnCancelled => 'रद्द';

  @override
  String get walletReturnDone => 'लौटा दी गई';

  @override
  String get walletReturnFailed => 'विफल';

  @override
  String get walletReturnProcessing => 'प्रक्रिया में';

  @override
  String get walletReturnRejected => 'अस्वीकृत';

  @override
  String get walletReturnRequested => 'अनुरोध किया';

  @override
  String get walletReturnReview => 'समीक्षा में';

  @override
  String get walletRewardExpired => 'इनाम की समय-सीमा खत्म';

  @override
  String get walletRewardReversed => 'इनाम वापस लिया गया';

  @override
  String get walletRewardsEarned => 'अब तक कमाया';

  @override
  String get walletSearchTransactions => 'लेनदेन खोजें';

  @override
  String get walletSecurityDeposit => 'सुरक्षा जमा';

  @override
  String get walletStateFailed => 'विफल';

  @override
  String get walletStatement => 'स्टेटमेंट';

  @override
  String get walletStatementEmpty => 'इस महीने कुछ नहीं';

  @override
  String get walletStatementEmptyBody => 'इस महीने वॉलेट में आने-जाने वाला पैसा यहाँ दिखेगा।';

  @override
  String walletStatementReference(String reference) {
    return 'स्टेटमेंट संदर्भ $reference';
  }

  @override
  String get walletStatementSubtitle => 'हर महीने का सटीक आना-जाना';

  @override
  String get walletStatementSummary => 'इस महीने';

  @override
  String get walletStatePending => 'बाकी';

  @override
  String get walletStateReversed => 'वापस लिया';

  @override
  String get walletStateSettled => 'पूरा';

  @override
  String get walletToBank => 'आपके बैंक खाते में';

  @override
  String get walletToWallet => 'आपके वॉलेट में';

  @override
  String get walletTransactions => 'लेनदेन';

  @override
  String get walletViewReceipt => 'रसीद';

  @override
  String get workPartnerEcommerce => 'ई-कॉमर्स';

  @override
  String get workPartnerFoodDelivery => 'फ़ूड डिलीवरी';

  @override
  String get workPartnerOnDemandLogistics => 'ऑन-डिमांड लॉजिस्टिक्स';

  @override
  String get workPartnerParcelLogistics => 'पार्सल लॉजिस्टिक्स';

  @override
  String get workPartnerPharmacy => 'फ़ार्मेसी और हेल्थकेयर';

  @override
  String get workPartnerQuickCommerce => 'क्विक कॉमर्स';

  @override
  String get workPartnerSpecialtyDelivery => 'स्पेशलिटी डिलीवरी';
}
