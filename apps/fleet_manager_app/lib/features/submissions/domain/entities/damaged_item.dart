import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

class DamagePhoto extends Equatable {
  const DamagePhoto({required this.id, required this.file});

  final String id;
  final File file;

  @override
  List<Object?> get props => [id, file.path];
}

class DamagedItem extends Equatable {
  const DamagedItem({
    required this.findingId,
    required this.part,
    required this.quantity,
    required this.note,
    required this.photos,
  });

  final String findingId;
  final PenaltyPriceDto part;
  final int quantity;
  final String note;
  final List<DamagePhoto> photos;

  num get amount => part.amount * quantity;

  SubmissionPenaltyInput toInput() => SubmissionPenaltyInput(
    priceId: part.id,
    configurationVersion: part.version,
    findingType: PenaltyCategory.damage,
    findingId: findingId,
    quantity: quantity,
    details: note.isEmpty ? part.name : note,
    evidencePhotoIds: [for (final DamagePhoto photo in photos) photo.id],
  );

  @override
  List<Object?> get props => [findingId, part.id, part.version, quantity, note, photos];
}
