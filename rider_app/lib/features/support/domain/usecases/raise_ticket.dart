import 'package:evseye_core/evseye_core.dart';

import '../entities/support_ticket.dart';
import '../support_repository.dart';

class RaiseTicketParams {
  const RaiseTicketParams({
    required this.categoryKey,
    required this.subject,
    required this.description,
    required this.vehicleAffected,
    required this.photoCount,
  });

  final String categoryKey;
  final String subject;
  final String description;
  final bool vehicleAffected;
  final int photoCount;
}

class RaiseTicket extends UseCase<SupportTicket, RaiseTicketParams> {
  const RaiseTicket(this._repository);

  final SupportRepository _repository;

  @override
  Future<Result<SupportTicket>> call(RaiseTicketParams params) =>
      _repository.raiseTicket(
        categoryKey: params.categoryKey,
        subject: params.subject,
        description: params.description,
        vehicleAffected: params.vehicleAffected,
        photoCount: params.photoCount,
      );
}
