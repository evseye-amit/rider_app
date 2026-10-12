import 'package:evseye_core/evseye_core.dart';

import 'entities/support_overview.dart';
import 'entities/support_ticket.dart';

abstract interface class SupportRepository {
  Future<Result<SupportOverview>> getOverview();

  Future<Result<SupportTicket>> raiseTicket({
    required String categoryKey,
    required String subject,
    required String description,
    required bool vehicleAffected,
    required int photoCount,
  });
}
