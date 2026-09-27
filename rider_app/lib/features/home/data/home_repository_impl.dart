import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/home_summary.dart';
import '../domain/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._deployments);

  final DeploymentApi _deployments;

  @override
  Future<Result<HomeSummary>> getSummary() async {
    final DateTime now = DateTime.now();

    final Result<RiderWallet> wallet = await _deployments.riderWallet();
    final num walletBalance = wallet.fold((_) => 0, (w) => w.totalPaid);

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

        tripsToday: 14,
        distanceTodayKm: 62.4,
        onlineMinutes: 318,

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

  static DateTime _nextWeekday(DateTime from, int weekday) {
    final int delta = (weekday - from.weekday + 7) % 7;
    return DateTime(from.year, from.month, from.day + (delta == 0 ? 7 : delta));
  }
}
