import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/support_ticket.dart';

class TicketStatusStyle {
  const TicketStatusStyle._(this.label, this.tone, this.icon);

  factory TicketStatusStyle.of(BuildContext context, TicketStatus status) => switch (status) {
    TicketStatus.open => TicketStatusStyle._(
      context.l10n.commonOpen,
      StatusTone.warning,
      Icons.mark_chat_unread_rounded,
    ),
    TicketStatus.inProgress => TicketStatusStyle._(
      context.l10n.supportInProgress,
      StatusTone.info,
      Icons.support_agent_rounded,
    ),
    TicketStatus.resolved => TicketStatusStyle._(
      context.l10n.supportResolved,
      StatusTone.success,
      Icons.check_circle_rounded,
    ),
  };

  final String label;
  final StatusTone tone;
  final IconData icon;
}
