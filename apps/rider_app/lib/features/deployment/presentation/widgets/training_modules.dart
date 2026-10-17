import 'package:evseye_core/evseye_core.dart';

enum TrainingModule {
  vehicleCare('assets/training/vehicle_care.png'),
  chargingUsage('assets/training/charging_usage.png'),
  paymentsConduct('assets/training/payments_conduct.png');

  const TrainingModule(this.asset);

  final String asset;

  String title(AppL10n l10n) => switch (this) {
    TrainingModule.vehicleCare => l10n.trainingVehicleCare,
    TrainingModule.chargingUsage => l10n.trainingCharging,
    TrainingModule.paymentsConduct => l10n.trainingPayments,
  };

  String summary(AppL10n l10n) => switch (this) {
    TrainingModule.vehicleCare => l10n.trainingVehicleCareSummary,
    TrainingModule.chargingUsage => l10n.trainingChargingSummary,
    TrainingModule.paymentsConduct => l10n.trainingPaymentsSummary,
  };

  List<(String, String)> points(AppL10n l10n) => switch (this) {
    TrainingModule.vehicleCare => [
      (l10n.trainingCareClean, l10n.trainingCareCleanBody),
      (l10n.trainingCareWater, l10n.trainingCareWaterBody),
      (l10n.trainingCareTamper, l10n.trainingCareTamperBody),
      (l10n.trainingCareReport, l10n.trainingCareReportBody),
    ],
    TrainingModule.chargingUsage => [
      (l10n.trainingChargeStations, l10n.trainingChargeStationsBody),
      (l10n.trainingChargeEquipment, l10n.trainingChargeEquipmentBody),
      (l10n.trainingChargePark, l10n.trainingChargeParkBody),
      (l10n.trainingChargeRide, l10n.trainingChargeRideBody),
    ],
    TrainingModule.paymentsConduct => [
      (l10n.trainingPayApp, l10n.trainingPayAppBody),
      (l10n.trainingPayCash, l10n.trainingPayCashBody),
      (l10n.trainingPayBribe, l10n.trainingPayBribeBody),
      (l10n.trainingPayReport, l10n.trainingPayReportBody),
    ],
  };
}
