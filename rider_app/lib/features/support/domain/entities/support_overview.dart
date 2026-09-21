import 'package:equatable/equatable.dart';

import 'support_ticket.dart';

class SupportCategory extends Equatable {
  const SupportCategory({
    required this.key,
    required this.label,
    required this.icon,
    required this.tone,
    required this.sla,
  });

  final String key;
  final String label;
  final String icon;
  final String tone;
  final String sla;

  @override
  List<Object?> get props => [key, label, icon, tone, sla];
}

class TeamLead extends Equatable {
  const TeamLead({
    required this.name,
    required this.mobile,
    required this.role,
  });

  final String name;
  final String mobile;
  final String role;

  @override
  List<Object?> get props => [name, mobile, role];
}

class SupportFaq extends Equatable {
  const SupportFaq({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  List<Object?> get props => [question, answer];
}

class SupportOverview extends Equatable {
  const SupportOverview({
    required this.roadsideNumber,
    required this.supportEmail,
    required this.hubName,
    required this.teamLead,
    required this.categories,
    required this.tickets,
    required this.faqs,
  });

  final String roadsideNumber;
  final String supportEmail;
  final String hubName;
  final TeamLead teamLead;
  final List<SupportCategory> categories;
  final List<SupportTicket> tickets;
  final List<SupportFaq> faqs;

  List<SupportTicket> get openTickets => tickets
      .where((t) => t.status == TicketStatus.open)
      .toList(growable: false);

  SupportCategory? categoryFor(String key) {
    for (final category in categories) {
      if (category.key == key) return category;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    roadsideNumber,
    supportEmail,
    hubName,
    teamLead,
    categories,
    tickets,
    faqs,
  ];
}
