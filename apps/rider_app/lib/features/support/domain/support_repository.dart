import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import 'entities/support_ticket.dart';

abstract interface class SupportRepository {
  Future<Result<TicketPage>> tickets({String? cursor});

  Future<Result<TicketThread>> ticket(String id);

  Future<Result<RaisedTicket>> raise({required String subject, required String message, required List<File> photos});

  Future<Result<TicketStatus>> reply(String id, String message);

  Future<Result<void>> attach(String id, File photo);

  Future<Result<String>> attachmentUrl(String id, String attachmentId);
}
