import 'package:equatable/equatable.dart';

class HomeSummary extends Equatable {
  const HomeSummary({
    required this.todayEarnings,
    required this.earningsDelta,
    required this.incentiveEarned,
    required this.incentiveTarget,
    required this.incentiveTrips,
    required this.incentiveTripsTarget,
    required this.rentDue,
    required this.rentOverdue,
    required this.rentDueDate,
    required this.walletBalance,
    required this.weeklyEarnings,
    required this.weeklyLabels,
    required this.announcements,
    required this.quickActions,
    this.category,
    this.dailyRent,
    this.workingDays,
  });

  final num todayEarnings;
  final String earningsDelta;
  final num incentiveEarned;
  final num incentiveTarget;
  final int incentiveTrips;
  final int incentiveTripsTarget;
  final num? rentDue;
  final num rentOverdue;
  final DateTime? rentDueDate;
  final num walletBalance;
  final List<num> weeklyEarnings;
  final List<String> weeklyLabels;
  final List<Announcement> announcements;
  final List<QuickAction> quickActions;
  final String? category;
  final num? dailyRent;
  final int? workingDays;

  double get incentiveProgress =>
      incentiveTripsTarget == 0 ? 0 : (incentiveTrips / incentiveTripsTarget).clamp(0.0, 1.0);

  int get tripsToIncentive => (incentiveTripsTarget - incentiveTrips).clamp(0, 999);

  @override
  List<Object?> get props => [
    todayEarnings,
    incentiveEarned,
    rentDue,
    rentOverdue,
    rentDueDate,
    walletBalance,
    announcements,
    quickActions,
    category,
    dailyRent,
    workingDays,
  ];
}

class Announcement extends Equatable {
  const Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.tone,
    required this.icon,
  });

  final String id;
  final String title;
  final String message;
  final String tone;
  final String icon;

  @override
  List<Object?> get props => [id, title, message, tone, icon];
}

class QuickAction extends Equatable {
  const QuickAction({
    required this.key,
    required this.label,
    required this.icon,
    required this.tone,
    required this.route,
  });

  final String key;
  final String label;
  final String icon;
  final String tone;
  final String route;

  @override
  List<Object?> get props => [key, label, icon, tone, route];
}
