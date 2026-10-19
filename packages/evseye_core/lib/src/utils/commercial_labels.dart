import '../api/commercial_api.dart';
import '../l10n/l10n.dart';
import 'formatters.dart';

String rentalPeriodSuffix(AppL10n l10n, CommercialBreakdown breakdown) {
  final int? duration = breakdown.durationValue;
  return switch (breakdown.period) {
    'DAILY' => l10n.exchangePerDay,
    'WEEKLY' => l10n.exchangePerWeek,
    'FORTNIGHTLY' => l10n.exchangePerFortnight,
    'MONTHLY' => l10n.exchangePerMonth,
    'QUARTERLY' => l10n.exchangePerQuarter,
    _ when duration == null => '',
    _ when (breakdown.durationUnit ?? '').toUpperCase().startsWith('WEEK') => l10n.planWeeks(duration),
    _ => l10n.planDays(duration),
  };
}

String rentalPeriodName(AppL10n l10n, CommercialBreakdown breakdown) {
  final int? duration = breakdown.durationValue;
  return switch (breakdown.period) {
    'DAILY' => l10n.planDaily,
    'WEEKLY' => l10n.planWeekly,
    'FORTNIGHTLY' => l10n.planFortnightly,
    'MONTHLY' => l10n.planMonthly,
    'QUARTERLY' => l10n.planQuarterly,
    _ when duration == null => l10n.planCustom,
    _ when (breakdown.durationUnit ?? '').toUpperCase().startsWith('WEEK') => l10n.planWeeks(duration),
    _ => l10n.planDays(duration),
  };
}

String rentWithPeriodLabel(AppL10n l10n, CommercialBreakdown breakdown) => [
  Fmt.money(breakdown.recurringAmount),
  rentalPeriodSuffix(l10n, breakdown),
].where((part) => part.isNotEmpty).join(' ');

String commercialChargeLabel(AppL10n l10n, String type) => switch (type.toUpperCase()) {
  'RENTAL' => l10n.planAdvanceRental,
  'ONBOARDING_FEE' => l10n.planOnboardingFee,
  'VEHICLE_SECURITY' => l10n.planScooterDeposit,
  'BATTERY_SECURITY' => l10n.planBatteryDeposit,
  'INSURANCE' => l10n.planInsurance,
  'VEHICLE_AGE' => l10n.planScooterAgeAdjustment,
  'PROMOTION' || 'DISCOUNT' => l10n.planDiscount,
  _ => _spaced(type),
};

String usageRateLabel(AppL10n l10n, CommercialUsage usage) =>
    l10n.planUsageRate(Fmt.money(usage.rate), _spaced(usage.unit).toLowerCase());

String _spaced(String code) {
  final String spaced = code.replaceAll('_', ' ').toLowerCase().trim();
  return spaced.isEmpty ? '—' : '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
