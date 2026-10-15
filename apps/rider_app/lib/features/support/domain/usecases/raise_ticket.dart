import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/support_ticket.dart';
import '../support_repository.dart';

class RaiseTicketParams extends Equatable {
  const RaiseTicketParams({required this.subject, required this.message, this.photos = const []});

  final String subject;
  final String message;
  final List<File> photos;

  @override
  List<Object?> get props => [subject, message, photos];
}

class RaiseTicket extends UseCase<RaisedTicket, RaiseTicketParams> {
  const RaiseTicket(this._repository);

  final SupportRepository _repository;

  @override
  Future<Result<RaisedTicket>> call(RaiseTicketParams params) =>
      _repository.raise(subject: params.subject, message: params.message, photos: params.photos);
}
