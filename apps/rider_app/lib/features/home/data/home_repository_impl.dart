import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/home_summary.dart';
import '../domain/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._deployments, this._agreements);

  final DeploymentApi _deployments;
  final RentalAgreementsApi _agreements;

  @override
  Future<Result<HomeSummary>> getSummary() async {
    final DateTime now = DateTime.now();

    final (Result<RiderWallet> wallet, Result<List<RentalAgreementDto>> agreements) = await (
      _deployments.riderWallet(),
      _agreements.list(),
    ).wait;
    final num walletBalance = wallet.fold((_) => 0, (w) => w.totalPaid);
    final RentalAgreementDto? rental = agreements.valueOrNull?.where((agreement) => agreement.isActive).firstOrNull;

    return Result.ok(
      HomeSummary(
        todayEarnings: 1240,
        earningsDelta: '+12%',

        incentiveEarned: 320,
        incentiveTarget: 500,
        incentiveTrips: 14,
        incentiveTripsTarget: 20,
        rentDue: 1750,
        rentDueDate: _nextWeekday(now, DateTime.monday),
        rentPlan: ActiveLocale.strings.commonWeeklyPlan,

        walletBalance: walletBalance,

        dailyRent: rental == null ? null : _dailyRent(rental),
        workingDays: _workingDays(rental?.startDate, now),

        weeklyEarnings: [980, 1120, 860, 1340, 1210, 1490, 1240],
        weeklyLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],

        announcements: [
          Announcement(
            id: 'surge_okhla',
            title: ActiveLocale.strings.homeSurgeOkhlaTill9Pm,
            message: ActiveLocale.strings.homeExtra15TripOkhlaPhase,
            tone: 'success',
            icon: 'bolt',
          ),
          Announcement(
            id: 'service_due',
            title: ActiveLocale.strings.homeServiceDue240Km,
            message: ActiveLocale.strings.homeBookSlotOkhlaHubBefore,
            tone: 'warning',
            icon: 'build',
          ),
        ],

        quickActions: [
          QuickAction(
            key: 'wallet',
            label: ActiveLocale.strings.commonWallet,
            icon: 'wallet',
            tone: 'primary',
            route: '/wallet',
          ),
          QuickAction(
            key: 'rentals',
            label: ActiveLocale.strings.homeRent,
            icon: 'receipt',
            tone: 'primary',
            route: '/rentals',
          ),
          QuickAction(
            key: 'incentives',
            label: ActiveLocale.strings.commonIncentives,
            icon: 'trophy',
            tone: 'success',
            route: '/incentives',
          ),
          QuickAction(
            key: 'support',
            label: ActiveLocale.strings.commonSupport,
            icon: 'support',
            tone: 'info',
            route: '/support',
          ),
        ],
      ),
    );
  }

  static num? _dailyRent(RentalAgreementDto rental) {
    final int? days = switch (rental.rentalPeriodType) {
      'DAILY' => 1,
      'WEEKLY' => 7,
      'FORTNIGHTLY' => 14,
      'MONTHLY' => 30,
      'QUARTERLY' => 90,
      _ => null,
    };
    return days == null ? null : rental.recurringAmount / days;
  }

  static int? _workingDays(DateTime? start, DateTime now) {
    if (start == null) return null;
    final int days =
        DateTime.utc(now.year, now.month, now.day).difference(DateTime.utc(start.year, start.month, start.day)).inDays +
        1;
    return days < 0 ? 0 : days;
  }

  static DateTime _nextWeekday(DateTime from, int weekday) {
    final int delta = (weekday - from.weekday + 7) % 7;
    return DateTime(from.year, from.month, from.day + (delta == 0 ? 7 : delta));
  }
}
