import 'package:evseye_core/evseye_core.dart';

import '../../../core/demo/demo_data.dart';
import '../domain/entities/support_overview.dart';
import '../domain/entities/support_ticket.dart';
import '../domain/support_repository.dart';

class SupportRepositoryImpl implements SupportRepository {
  SupportRepositoryImpl();

  @override
  Future<Result<SupportOverview>> getOverview() async {
    return Result.ok(
      SupportOverview(
        roadsideNumber: '1800 267 8899',
        supportEmail: 'support@pinkrides.in',
        hubName: Demo.hub,
        teamLead: TeamLead(name: Demo.teamLead, mobile: Demo.teamLeadMobile, role: 'Team lead · ${Demo.hub}'),
        categories: [
          SupportCategory(
            key: 'battery',
            label: ActiveLocale.strings.supportBatteryCharging,
            icon: 'battery',
            tone: 'warning',
            sla: ActiveLocale.strings.supportResponseWithin30Min,
          ),
          SupportCategory(
            key: 'breakdown',
            label: ActiveLocale.strings.supportBreakdownRoad,
            icon: 'build',
            tone: 'danger',
            sla: ActiveLocale.strings.supportRoadsideWithin45Min,
          ),
          SupportCategory(
            key: 'payment',
            label: ActiveLocale.strings.supportPaymentWallet,
            icon: 'wallet',
            tone: 'primary',
            sla: ActiveLocale.strings.supportResponseWithin4Hours,
          ),
          SupportCategory(
            key: 'documents',
            label: ActiveLocale.strings.supportDocumentsKyc,
            icon: 'document',
            tone: 'info',
            sla: ActiveLocale.strings.supportResponseWithin1Day,
          ),
          SupportCategory(
            key: 'accident',
            label: ActiveLocale.strings.supportAccidentTheft,
            icon: 'shield',
            tone: 'danger',
            sla: ActiveLocale.strings.supportCallBackWithin15Min,
          ),
          SupportCategory(
            key: 'other',
            label: ActiveLocale.strings.supportSomethingElse,
            icon: 'help',
            tone: 'muted',
            sla: ActiveLocale.strings.supportResponseWithin1Day,
          ),
        ],
        tickets: _tickets(),
        faqs: [
          SupportFaq(
            question: ActiveLocale.strings.supportWhenDoesMyRentGet,
            answer: ActiveLocale.strings.supportEveryMondayMorningAgainstNach,
          ),
          SupportFaq(
            question: ActiveLocale.strings.supportWhatHappensIfBatteryDies,
            answer:
                ActiveLocale.strings.supportRaiseBatteryChargingTicketSwap +
                ActiveLocale.strings.supportTripsLostSwapDoNot,
          ),
          SupportFaq(
            question: ActiveLocale.strings.supportHowSoonCanIWithdraw,
            answer: ActiveLocale.strings.supportAnySettledBalanceCanWithdrawn,
          ),
          SupportFaq(
            question: ActiveLocale.strings.supportCanIKeepScooterOvernight,
            answer: ActiveLocale.strings.supportYesWeeklyMonthlyPlansDaily,
          ),
        ],
      ),
    );
  }

  static List<SupportTicket> _tickets() => [
    SupportTicket(
      id: 'TKT-4471',
      categoryKey: 'battery',
      title: ActiveLocale.strings.supportBatteryDrops20Within40,
      status: TicketStatus.open,
      createdAt: Demo.daysAgo(1),
      updatedAt: Demo.hoursAgo(5),
      messageCount: 4,
      repairCost: 0,
    ),
    SupportTicket(
      id: 'TKT-4462',
      categoryKey: 'payment',
      title: ActiveLocale.strings.supportReferralBonusSunilNotCredited,
      status: TicketStatus.open,
      createdAt: Demo.daysAgo(3),
      updatedAt: Demo.daysAgo(2),
      messageCount: 2,
      repairCost: 0,
    ),
    SupportTicket(
      id: 'TKT-4398',
      categoryKey: 'documents',
      title: ActiveLocale.strings.supportLicenceReUploadAfterRenewal,
      status: TicketStatus.resolved,
      createdAt: Demo.daysAgo(12),
      updatedAt: Demo.daysAgo(10),
      messageCount: 6,
      repairCost: 0,
    ),
    SupportTicket(
      id: 'TKT-4310',
      categoryKey: 'breakdown',
      title: ActiveLocale.strings.supportRearTyrePunctureNearAshram,
      status: TicketStatus.resolved,
      createdAt: Demo.daysAgo(21),
      updatedAt: Demo.daysAgo(21),
      messageCount: 3,
      repairCost: 450,
      costBorneByRider: true,
    ),
  ];

  @override
  Future<Result<SupportTicket>> raiseTicket({
    required String categoryKey,
    required String subject,
    required String description,
    required bool vehicleAffected,
    required int photoCount,
  }) async {
    final DateTime now = Demo.now;
    return Result.ok(
      SupportTicket(
        id: 'TKT-4472',
        categoryKey: categoryKey,
        title: subject,
        status: TicketStatus.open,
        createdAt: now,
        updatedAt: now,
        messageCount: 1,
      ),
    );
  }
}
