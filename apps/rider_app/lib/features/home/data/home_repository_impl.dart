import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/home_summary.dart';
import '../domain/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._deployments, this._riderApp, this._payments);

  final DeploymentApi _deployments;
  final RiderAppApi _riderApp;
  final RiderPaymentsApi _payments;

  @override
  Future<Result<HomeSummary>> getSummary() async {
    final (Result<RiderWallet> wallet, Result<RiderHomeDto> home, Result<PaymentsHome> payments) = await (
      _deployments.riderWallet(),
      _riderApp.home(),
      _payments.home(),
    ).wait;
    final num walletBalance = wallet.fold((_) => 0, (w) => w.totalPaid);
    final RiderHomeDto? stats = home.valueOrNull;
    final PaymentsHome? dues = payments.valueOrNull;

    return Result.ok(
      HomeSummary(
        todayEarnings: 1240,
        earningsDelta: '+12%',

        incentiveEarned: 320,
        incentiveTarget: 500,
        incentiveTrips: 14,
        incentiveTripsTarget: 20,
        rentDue: dues?.amountDue,
        rentOverdue: dues?.overdueAmount ?? 0,
        rentDueDate: dues?.dueDate,

        walletBalance: walletBalance,

        category: stats?.partnerName ?? stats?.businessCategory,
        dailyRent: stats?.dailyRentalAmount,
        workingDays: stats?.rentalDays,

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
}
