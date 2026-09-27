import 'l10n.dart';

/// Resolves a message reference used inside a JSON flow config.
///
/// Flow configs carry `@messageKey` instead of literal text so the same
/// document renders in every supported language. Anything that is not a
/// reference is returned unchanged.
String resolveConfigText(String value, [AppL10n? messages]) {
  if (!value.startsWith('@')) return value;
  final AppL10n l10n = messages ?? ActiveLocale.strings;
  return switch (value.substring(1)) {
      'allocationBack' => l10n.allocationBack,
      'allocationDeAllocateVehicle' => l10n.allocationDeAllocateVehicle,
      'allocationFront' => l10n.allocationFront,
      'allocationLeftSide' => l10n.allocationLeftSide,
      'allocationRightSide' => l10n.allocationRightSide,
      'commonIotUnit' => l10n.commonIotUnit,
      'deallocAccessoriesReturned' => l10n.deallocAccessoriesReturned,
      'deallocAnyNewDamageRecordHere' => l10n.deallocAnyNewDamageRecordHere,
      'deallocAssessment' => l10n.deallocAssessment,
      'deallocAvailable' => l10n.deallocAvailable,
      'deallocBatteryReturnedHub' => l10n.deallocBatteryReturnedHub,
      'deallocBothRiderTeamLeadMust' => l10n.deallocBothRiderTeamLeadMust,
      'deallocChargeReturn' => l10n.deallocChargeReturn,
      'deallocChargerCable' => l10n.deallocChargerCable,
      'deallocCloseRide' => l10n.deallocCloseRide,
      'deallocCodesValid10MinutesAsk' => l10n.deallocCodesValid10MinutesAsk,
      'deallocCompareAgainstHandoverSet' => l10n.deallocCompareAgainstHandoverSet,
      'deallocCompleteDeAllocation' => l10n.deallocCompleteDeAllocation,
      'deallocComponents' => l10n.deallocComponents,
      'deallocConditionAssessment' => l10n.deallocConditionAssessment,
      'deallocConfirmBatteryBack' => l10n.deallocConfirmBatteryBack,
      'deallocContinueAssessment' => l10n.deallocContinueAssessment,
      'deallocContinueVerification' => l10n.deallocContinueVerification,
      'deallocDamageDescription' => l10n.deallocDamageDescription,
      'deallocDamaged' => l10n.deallocDamaged,
      'deallocDeductedFromRidersSecurityDeposit' => l10n.deallocDeductedFromRidersSecurityDeposit,
      'deallocDescribeDamage' => l10n.deallocDescribeDamage,
      'deallocEndRideContinue' => l10n.deallocEndRideContinue,
      'deallocEndRidersActiveRide' => l10n.deallocEndRidersActiveRide,
      'deallocEnterAll6Digits' => l10n.deallocEnterAll6Digits,
      'deallocEnterClosingOdometer' => l10n.deallocEnterClosingOdometer,
      'deallocEnterRidersCode' => l10n.deallocEnterRidersCode,
      'deallocEnterTeamLeadsCode' => l10n.deallocEnterTeamLeadsCode,
      'deallocEstimatedRecovery' => l10n.deallocEstimatedRecovery,
      'deallocExcellent' => l10n.deallocExcellent,
      'deallocGood' => l10n.deallocGood,
      'deallocLoggedBackIntoChargingBay' => l10n.deallocLoggedBackIntoChargingBay,
      'deallocMinorScuffsNothingRecover' => l10n.deallocMinorScuffsNothingRecover,
      'deallocNoDamageBeyondNormalWear' => l10n.deallocNoDamageBeyondNormalWear,
      'deallocNotUsableUntilFurtherNotice' => l10n.deallocNotUsableUntilFurtherNotice,
      'deallocOdometerReturn' => l10n.deallocOdometerReturn,
      'deallocOffRoad' => l10n.deallocOffRoad,
      'deallocPhotographVehicleExactlyAsCame' => l10n.deallocPhotographVehicleExactlyAsCame,
      'deallocRcInsurancePuc' => l10n.deallocRcInsurancePuc,
      'deallocReadyAllocateAnotherRider' => l10n.deallocReadyAllocateAnotherRider,
      'deallocRecordVehicleCondition' => l10n.deallocRecordVehicleCondition,
      'deallocRecordWhatComesBackWhat' => l10n.deallocRecordWhatComesBackWhat,
      'deallocRecoverableDamageRaiseMaintenanceJob' => l10n.deallocRecoverableDamageRaiseMaintenanceJob,
      'deallocReturnCondition' => l10n.deallocReturnCondition,
      'deallocReturnPhotos' => l10n.deallocReturnPhotos,
      'deallocRiderConfirmation' => l10n.deallocRiderConfirmation,
      'deallocSendWorkshopFirst' => l10n.deallocSendWorkshopFirst,
      'deallocService' => l10n.deallocService,
      'deallocSetFleetStatus' => l10n.deallocSetFleetStatus,
      'deallocSetFleetStatus2' => l10n.deallocSetFleetStatus2,
      'deallocStopsTelemetryClosesShiftSettles' => l10n.deallocStopsTelemetryClosesShiftSettles,
      'deallocTeamLeadConfirmation' => l10n.deallocTeamLeadConfirmation,
      'deallocTwoPartyVerification' => l10n.deallocTwoPartyVerification,
      'deallocVehicleAngles' => l10n.deallocVehicleAngles,
      'deallocVehicleCondition' => l10n.deallocVehicleCondition,
      'deallocVerification' => l10n.deallocVerification,
      'deallocWhatDamagedHowBadly' => l10n.deallocWhatDamagedHowBadly,
      'maintenanceBattery' => l10n.maintenanceBattery,
      'scooterDeliveryBox' => l10n.scooterDeliveryBox,
      'scooterHelmet' => l10n.scooterHelmet,
      _ => value,
    };
}

/// Walks a decoded flow config and replaces every `@messageKey` it finds.
Object? resolveConfigMessages(Object? node, [AppL10n? messages]) {
  if (node is String) return resolveConfigText(node, messages);
  if (node is List) {
    return node.map((e) => resolveConfigMessages(e, messages)).toList(growable: false);
  }
  if (node is Map) {
    return node.map((k, v) => MapEntry(k, resolveConfigMessages(v, messages)));
  }
  return node;
}
