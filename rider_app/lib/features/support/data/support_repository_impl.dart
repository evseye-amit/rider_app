import 'package:evseye_core/evseye_core.dart';

import '../../../core/demo/demo_data.dart';
import '../domain/entities/support_overview.dart';
import '../domain/entities/support_ticket.dart';
import '../domain/support_repository.dart';

class SupportRepositoryImpl implements SupportRepository {
  const SupportRepositoryImpl();

  @override
  Future<Result<SupportOverview>> getOverview() async {
    return Result.ok(
      SupportOverview(
        roadsideNumber: '1800 267 8899',
        supportEmail: 'riders@evseye.in',
        hubName: Demo.hub,
        teamLead: const TeamLead(
          name: Demo.teamLead,
          mobile: Demo.teamLeadMobile,
          role: 'Team lead · ${Demo.hub}',
        ),
        categories: const [
          SupportCategory(
            key: 'battery',
            label: 'Battery or charging',
            icon: 'battery',
            tone: 'warning',
            sla: 'Response within 30 min',
          ),
          SupportCategory(
            key: 'breakdown',
            label: 'Breakdown on the road',
            icon: 'build',
            tone: 'danger',
            sla: 'Roadside within 45 min',
          ),
          SupportCategory(
            key: 'payment',
            label: 'Payment or wallet',
            icon: 'wallet',
            tone: 'primary',
            sla: 'Response within 4 hours',
          ),
          SupportCategory(
            key: 'documents',
            label: 'Documents and KYC',
            icon: 'document',
            tone: 'info',
            sla: 'Response within 1 day',
          ),
          SupportCategory(
            key: 'accident',
            label: 'Accident or theft',
            icon: 'shield',
            tone: 'danger',
            sla: 'Call back within 15 min',
          ),
          SupportCategory(
            key: 'other',
            label: 'Something else',
            icon: 'help',
            tone: 'muted',
            sla: 'Response within 1 day',
          ),
        ],
        tickets: _tickets(),
        faqs: const [
          SupportFaq(
            question: 'When does my rent get debited?',
            answer:
                'Every Monday morning against your NACH mandate. If the wallet '
                'is short, the debit retries on Tuesday before it is marked failed.',
          ),
          SupportFaq(
            question: 'What happens if the battery dies mid-shift?',
            answer:
                'Raise a Battery or charging ticket and swap at the nearest hub. '
                'Trips lost to a swap do not count against your incentive target.',
          ),
          SupportFaq(
            question: 'How soon can I withdraw my earnings?',
            answer:
                'Any settled balance can be withdrawn once a day. Payouts before '
                '6 pm reach the account the same evening.',
          ),
          SupportFaq(
            question: 'Can I keep the scooter overnight?',
            answer:
                'Yes, on weekly and monthly plans. Daily plans return to the hub '
                'at shift close, and rent still applies if you keep it out.',
          ),
        ],
      ),
    );
  }

  static List<SupportTicket> _tickets() => [
        SupportTicket(
          id: 'TKT-4471',
          categoryKey: 'battery',
          title: 'Battery drops to 20% within 40 km',
          status: TicketStatus.open,
          createdAt: Demo.daysAgo(1),
          updatedAt: Demo.hoursAgo(5),
          messageCount: 4,
        ),
        SupportTicket(
          id: 'TKT-4462',
          categoryKey: 'payment',
          title: 'Referral bonus for Sunil not credited',
          status: TicketStatus.open,
          createdAt: Demo.daysAgo(3),
          updatedAt: Demo.daysAgo(2),
          messageCount: 2,
        ),
        SupportTicket(
          id: 'TKT-4398',
          categoryKey: 'documents',
          title: 'Licence re-upload after renewal',
          status: TicketStatus.resolved,
          createdAt: Demo.daysAgo(12),
          updatedAt: Demo.daysAgo(10),
          messageCount: 6,
        ),
        SupportTicket(
          id: 'TKT-4310',
          categoryKey: 'breakdown',
          title: 'Rear tyre puncture near Ashram',
          status: TicketStatus.resolved,
          createdAt: Demo.daysAgo(21),
          updatedAt: Demo.daysAgo(21),
          messageCount: 3,
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
