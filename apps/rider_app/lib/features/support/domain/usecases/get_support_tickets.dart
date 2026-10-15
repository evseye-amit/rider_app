import 'package:evseye_core/evseye_core.dart';

import '../entities/support_ticket.dart';
import '../support_repository.dart';

class GetSupportTickets extends UseCase<TicketPage, String?> {
  const GetSupportTickets(this._repository);

  final SupportRepository _repository;

  @override
  Future<Result<TicketPage>> call(String? params) => _repository.tickets(cursor: params);
}

class GetSupportTicket extends UseCase<TicketThread, String> {
  const GetSupportTicket(this._repository);

  final SupportRepository _repository;

  @override
  Future<Result<TicketThread>> call(String params) => _repository.ticket(params);
}
