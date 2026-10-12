import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/support_repository_impl.dart';
import 'domain/support_repository.dart';
import 'domain/usecases/get_support_overview.dart';
import 'domain/usecases/raise_ticket.dart';

final supportRepositoryProvider = Provider<SupportRepository>((_) => SupportRepositoryImpl());

final getSupportOverviewProvider = Provider<GetSupportOverview>(
  (ref) => GetSupportOverview(ref.watch(supportRepositoryProvider)),
);

final raiseTicketProvider = Provider<RaiseTicket>((ref) => RaiseTicket(ref.watch(supportRepositoryProvider)));
