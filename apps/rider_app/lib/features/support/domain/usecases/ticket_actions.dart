import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/support_ticket.dart';
import '../support_repository.dart';

class TicketReplyParams extends Equatable {
  const TicketReplyParams({required this.id, required this.message});

  final String id;
  final String message;

  @override
  List<Object?> get props => [id, message];
}

class TicketPhotoParams extends Equatable {
  const TicketPhotoParams({required this.id, required this.photo});

  final String id;
  final File photo;

  @override
  List<Object?> get props => [id, photo];
}

class TicketAttachmentParams extends Equatable {
  const TicketAttachmentParams({required this.id, required this.attachmentId});

  final String id;
  final String attachmentId;

  @override
  List<Object?> get props => [id, attachmentId];
}

class ReplyToTicket extends UseCase<TicketStatus, TicketReplyParams> {
  const ReplyToTicket(this._repository);

  final SupportRepository _repository;

  @override
  Future<Result<TicketStatus>> call(TicketReplyParams params) => _repository.reply(params.id, params.message);
}

class AttachToTicket extends UseCase<void, TicketPhotoParams> {
  const AttachToTicket(this._repository);

  final SupportRepository _repository;

  @override
  Future<Result<void>> call(TicketPhotoParams params) => _repository.attach(params.id, params.photo);
}

class GetTicketAttachmentUrl extends UseCase<String, TicketAttachmentParams> {
  const GetTicketAttachmentUrl(this._repository);

  final SupportRepository _repository;

  @override
  Future<Result<String>> call(TicketAttachmentParams params) =>
      _repository.attachmentUrl(params.id, params.attachmentId);
}
