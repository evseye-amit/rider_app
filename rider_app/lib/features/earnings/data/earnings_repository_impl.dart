import 'package:evseye_core/evseye_core.dart';

import '../../../core/demo/demo_data.dart';
import '../domain/earnings_repository.dart';
import '../domain/entities/earnings_overview.dart';
import '../domain/entities/incentive_scheme.dart';

class EarningsRepositoryImpl implements EarningsRepository {
  const EarningsRepositoryImpl();

  @override
  Future<Result<EarningsOverview>> getEarnings() async {
    final List<EarningsBar> daily = _daily();
    return Result.ok(
      EarningsOverview(
        bars: {
          EarningsPeriod.daily: daily,
          EarningsPeriod.weekly: _weekly(),
          EarningsPeriod.monthly: _monthly(),
        },
        breakdowns: const {
          EarningsPeriod.daily: EarningsBreakdown(
            baseFare: 620,
            distancePay: 340,
            surge: 90,
            incentives: 190,
            deductions: 0,
          ),
          EarningsPeriod.weekly: EarningsBreakdown(
            baseFare: 4180,
            distancePay: 2290,
            surge: 610,
            incentives: 1160,

            deductions: 1850,
          ),
          EarningsPeriod.monthly: EarningsBreakdown(
            baseFare: 17240,
            distancePay: 9480,
            surge: 2310,
            incentives: 4320,
            deductions: 7600,
          ),
        },
        dailyEntries: daily.reversed.toList(growable: false),
      ),
    );
  }

  static List<EarningsBar> _daily() {
    final DateTime today = Demo.today();
    final int mondayOffset = today.weekday - DateTime.monday;
    return [
      for (int i = 0; i < Demo.weekEarnings.length; i++)
        EarningsBar(
          label: Demo.weekLabels[i],
          amount: Demo.weekEarnings[i],
          trips: Demo.weekTrips[i],
          date: today.subtract(Duration(days: mondayOffset - i)),
        ),
    ];
  }

  static List<EarningsBar> _weekly() {
    const List<num> amounts = [6840, 7220, 6510, 7980, 8240];
    const List<int> trips = [78, 84, 74, 91, 93];
    final DateTime today = Demo.today();
    return [
      for (int i = 0; i < amounts.length; i++)
        EarningsBar(
          label: i == amounts.length - 1 ? LocaleController.strings.commonWeek : 'W${i + 1}',
          amount: amounts[i],
          trips: trips[i],
          date: today.subtract(Duration(days: 7 * (amounts.length - 1 - i))),
        ),
    ];
  }

  static List<EarningsBar> _monthly() {
    const List<String> labels = ['May', 'Jun', 'Jul', 'Aug', 'Sep'];
    const List<num> amounts = [26400, 28150, 27320, 30640, 21480];
    const List<int> trips = [308, 326, 314, 352, 241];
    final DateTime now = Demo.now;
    return [
      for (int i = 0; i < labels.length; i++)
        EarningsBar(
          label: labels[i],
          amount: amounts[i],
          trips: trips[i],
          date: DateTime(now.year, now.month - (labels.length - 1 - i), 1),
        ),
    ];
  }

  @override
  Future<Result<IncentivesOverview>> getIncentives() async {
    return Result.ok(
      IncentivesOverview(
        earnedThisWeek: 1160,
        schemes: [
          IncentiveScheme(
            id: 'daily_trips',
            title: LocaleController.strings.earningsDailyTripTarget,
            description: LocaleController.strings.earningsComplete20TripsToday,
            icon: 'trophy',
            tone: 'primary',
            current: Demo.tripsToday,
            target: 20,
            unit: 'trips',
            rewardAmount: Demo.incentiveTarget,
            expiresAt: Demo.today().add(const Duration(days: 1)),
            terms: LocaleController.strings.earningsCancelledTripsDoNotCount,
          ),
          IncentiveScheme(
            id: 'evening_surge',
            title: LocaleController.strings.earningsEveningSurge,
            description: LocaleController.strings.earningsRideBetween6Pm9,
            icon: 'bolt',
            tone: 'warning',
            current: 4,
            target: 8,
            unit: 'trips',
            rewardAmount: 240,
            expiresAt: Demo.today().add(const Duration(days: 1)),
            terms: '₹15 a trip, paid on top of the fare.',
          ),
          IncentiveScheme(
            id: 'weekly_distance',
            title: LocaleController.strings.earningsWeeklyDistance,
            description: LocaleController.strings.earningsCover400KmWeek,
            icon: 'route',
            tone: 'info',
            current: 362,
            target: 400,
            unit: 'km',
            rewardAmount: 400,
            expiresAt: Demo.nextWeekday(DateTime.monday),
            terms: LocaleController.strings.earningsMeasuredByVehicleOdometerNot,
          ),
          IncentiveScheme(
            id: 'perfect_week',
            title: LocaleController.strings.earningsPerfectWeek,
            description: LocaleController.strings.earningsSixDaysPresentWithNo,
            icon: 'star',
            tone: 'success',
            current: 6,
            target: 6,
            unit: 'days',
            rewardAmount: 600,
            expiresAt: Demo.nextWeekday(DateTime.monday),
            terms: LocaleController.strings.earningsOneClearedSchemeSoAchieved,
          ),
          IncentiveScheme(
            id: 'referral',
            title: LocaleController.strings.earningsReferRider,
            description: LocaleController.strings.earningsReferralCompletes20Trips,
            icon: 'group',
            tone: 'cyan',
            current: 1,
            target: 3,
            unit: 'riders',
            rewardAmount: 1500,
            expiresAt: Demo.today().add(const Duration(days: 24)),
            terms: '₹500 a rider, credited once they clear 20 trips.',
          ),
        ],
      ),
    );
  }
}
