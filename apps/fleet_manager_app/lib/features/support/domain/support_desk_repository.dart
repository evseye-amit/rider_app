import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import 'entities/desk_ticket.dart';

abstract interface class SupportDeskRepository {
  Future<Result<DeskPage>> tickets({String? cursor, TicketStatus? status});

  Future<Result<DeskThread>> ticket(String id);

  Future<Result<void>> reply(String id, String message);

  Future<Result<void>> setStatus(String id, TicketStatus status);

  Future<Result<void>> attach(String id, File photo);

  Future<Result<String>> attachmentUrl(String id, String attachmentId);
}
