import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/desk_ticket.dart';
import '../support_desk_repository.dart';

class DeskQuery extends Equatable {
  const DeskQuery({this.cursor, this.status});

  final String? cursor;
  final TicketStatus? status;

  @override
  List<Object?> get props => [cursor, status];
}

class DeskReplyParams extends Equatable {
  const DeskReplyParams({required this.id, required this.message});

  final String id;
  final String message;

  @override
  List<Object?> get props => [id, message];
}

class DeskStatusParams extends Equatable {
  const DeskStatusParams({required this.id, required this.status});

  final String id;
  final TicketStatus status;

  @override
  List<Object?> get props => [id, status];
}

class DeskPhotoParams extends Equatable {
  const DeskPhotoParams({required this.id, required this.photo});

  final String id;
  final File photo;

  @override
  List<Object?> get props => [id, photo];
}

class DeskAttachmentParams extends Equatable {
  const DeskAttachmentParams({required this.id, required this.attachmentId});

  final String id;
  final String attachmentId;

  @override
  List<Object?> get props => [id, attachmentId];
}

class GetDeskTickets extends UseCase<DeskPage, DeskQuery> {
  const GetDeskTickets(this._repository);

  final SupportDeskRepository _repository;

  @override
  Future<Result<DeskPage>> call(DeskQuery params) => _repository.tickets(cursor: params.cursor, status: params.status);
}

class GetDeskTicket extends UseCase<DeskThread, String> {
  const GetDeskTicket(this._repository);

  final SupportDeskRepository _repository;

  @override
  Future<Result<DeskThread>> call(String params) => _repository.ticket(params);
}

class ReplyToDeskTicket extends UseCase<void, DeskReplyParams> {
  const ReplyToDeskTicket(this._repository);

  final SupportDeskRepository _repository;

  @override
  Future<Result<void>> call(DeskReplyParams params) => _repository.reply(params.id, params.message);
}

class SetDeskTicketStatus extends UseCase<void, DeskStatusParams> {
  const SetDeskTicketStatus(this._repository);

  final SupportDeskRepository _repository;

  @override
  Future<Result<void>> call(DeskStatusParams params) => _repository.setStatus(params.id, params.status);
}

class AttachToDeskTicket extends UseCase<void, DeskPhotoParams> {
  const AttachToDeskTicket(this._repository);

  final SupportDeskRepository _repository;

  @override
  Future<Result<void>> call(DeskPhotoParams params) => _repository.attach(params.id, params.photo);
}

class GetDeskAttachmentUrl extends UseCase<String, DeskAttachmentParams> {
  const GetDeskAttachmentUrl(this._repository);

  final SupportDeskRepository _repository;

  @override
  Future<Result<String>> call(DeskAttachmentParams params) => _repository.attachmentUrl(params.id, params.attachmentId);
}
