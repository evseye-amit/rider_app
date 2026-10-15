import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/session/fleet_session_provider.dart';
import 'data/support_desk_repository_impl.dart';
import 'domain/support_desk_repository.dart';
import 'domain/usecases/support_desk_usecases.dart';

final supportDeskRepositoryProvider = Provider<SupportDeskRepository>((ref) {
  ref.watch(fleetSessionProvider.select((session) => session.user?.id));
  return SupportDeskRepositoryImpl(ref.watch(staffSupportApiProvider), ref.watch(apiClientProvider));
});

final getDeskTicketsProvider = Provider<GetDeskTickets>(
  (ref) => GetDeskTickets(ref.watch(supportDeskRepositoryProvider)),
);

final getDeskTicketProvider = Provider<GetDeskTicket>((ref) => GetDeskTicket(ref.watch(supportDeskRepositoryProvider)));

final replyToDeskTicketProvider = Provider<ReplyToDeskTicket>(
  (ref) => ReplyToDeskTicket(ref.watch(supportDeskRepositoryProvider)),
);

final setDeskTicketStatusProvider = Provider<SetDeskTicketStatus>(
  (ref) => SetDeskTicketStatus(ref.watch(supportDeskRepositoryProvider)),
);

final attachToDeskTicketProvider = Provider<AttachToDeskTicket>(
  (ref) => AttachToDeskTicket(ref.watch(supportDeskRepositoryProvider)),
);

final getDeskAttachmentUrlProvider = Provider<GetDeskAttachmentUrl>(
  (ref) => GetDeskAttachmentUrl(ref.watch(supportDeskRepositoryProvider)),
);
