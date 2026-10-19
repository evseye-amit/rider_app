import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/desk_ticket.dart';

class DeskStatusStyle {
  const DeskStatusStyle._(this.label, this.tone, this.icon);

  factory DeskStatusStyle.of(BuildContext context, TicketStatus status) => switch (status) {
    TicketStatus.open => DeskStatusStyle._(context.l10n.commonOpen, StatusTone.warning, Icons.mark_chat_unread_rounded),
    TicketStatus.inProgress => DeskStatusStyle._(
      context.l10n.supportInProgress,
      StatusTone.info,
      Icons.support_agent_rounded,
    ),
    TicketStatus.resolved => DeskStatusStyle._(
      context.l10n.supportResolved,
      StatusTone.success,
      Icons.check_circle_rounded,
    ),
  };

  final String label;
  final StatusTone tone;
  final IconData icon;
}

class DeskTicketTile extends StatelessWidget {
  const DeskTicketTile({required this.ticket, required this.hubName, required this.onOpen, super.key});

  final DeskTicket ticket;
  final String? hubName;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final DeskStatusStyle style = DeskStatusStyle.of(context, ticket.status);
    return Pressable(
      onTap: onOpen,
      scale: 0.99,
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppAvatar(name: ticket.riderName, size: 40),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.riderName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.titleMedium.copyWith(fontSize: 15),
                      ),
                      if (hubName != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          hubName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySmall.copyWith(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
              ],
            ),
            const SizedBox(height: Insets.sm + 2),
            Text(
              ticket.subject,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.titleSmall.copyWith(fontSize: 13.5),
            ),
            const SizedBox(height: Insets.sm + 2),
            Row(
              children: [
                StatusChip(label: style.label, tone: style.tone, dense: true),
                const Spacer(),
                Text(
                  Fmt.relative(ticket.lastActivityAt),
                  style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
