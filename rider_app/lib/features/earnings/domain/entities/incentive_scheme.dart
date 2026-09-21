import 'package:equatable/equatable.dart';

class IncentiveScheme extends Equatable {
  const IncentiveScheme({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.tone,
    required this.current,
    required this.target,
    required this.unit,
    required this.rewardAmount,
    required this.expiresAt,
    required this.terms,
  });

  final String id;
  final String title;
  final String description;

  final String icon;

  final String tone;
  final num current;
  final num target;
  final String unit;
  final num rewardAmount;
  final DateTime expiresAt;
  final String terms;

  double get progress => target <= 0 ? 0 : (current / target).clamp(0.0, 1.0);
  bool get achieved => current >= target;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    icon,
    tone,
    current,
    target,
    unit,
    rewardAmount,
    expiresAt,
    terms,
  ];
}

class IncentivesOverview extends Equatable {
  const IncentivesOverview({
    required this.earnedThisWeek,
    required this.schemes,
  });

  final num earnedThisWeek;
  final List<IncentiveScheme> schemes;

  List<IncentiveScheme> get active =>
      schemes.where((s) => !s.achieved).toList(growable: false);

  List<IncentiveScheme> get achieved =>
      schemes.where((s) => s.achieved).toList(growable: false);

  @override
  List<Object?> get props => [earnedThisWeek, schemes];
}
