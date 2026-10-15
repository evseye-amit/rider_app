import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/support_repository_impl.dart';
import 'domain/support_repository.dart';
import 'domain/usecases/get_support_tickets.dart';
import 'domain/usecases/raise_ticket.dart';
import 'domain/usecases/ticket_actions.dart';

final supportRepositoryProvider = Provider<SupportRepository>(
  (ref) => SupportRepositoryImpl(ref.watch(riderSupportApiProvider)),
);

final getSupportTicketsProvider = Provider<GetSupportTickets>(
  (ref) => GetSupportTickets(ref.watch(supportRepositoryProvider)),
);

final getSupportTicketProvider = Provider<GetSupportTicket>(
  (ref) => GetSupportTicket(ref.watch(supportRepositoryProvider)),
);

final raiseTicketProvider = Provider<RaiseTicket>((ref) => RaiseTicket(ref.watch(supportRepositoryProvider)));

final replyToTicketProvider = Provider<ReplyToTicket>((ref) => ReplyToTicket(ref.watch(supportRepositoryProvider)));

final attachToTicketProvider = Provider<AttachToTicket>((ref) => AttachToTicket(ref.watch(supportRepositoryProvider)));

final getTicketAttachmentUrlProvider = Provider<GetTicketAttachmentUrl>(
  (ref) => GetTicketAttachmentUrl(ref.watch(supportRepositoryProvider)),
);
