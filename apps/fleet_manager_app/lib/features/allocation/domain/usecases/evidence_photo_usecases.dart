import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class EvidencePhotoParams extends Equatable {
  const EvidencePhotoParams({required this.inspectionId, required this.photoType, required this.file});

  final String inspectionId;
  final String photoType;
  final File file;

  @override
  List<Object?> get props => [inspectionId, photoType, file.path];
}

class UploadEvidencePhoto extends UseCase<RemotePhoto, EvidencePhotoParams> {
  const UploadEvidencePhoto(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<RemotePhoto>> call(EvidencePhotoParams params) =>
      _repository.uploadEvidencePhoto(params.inspectionId, photoType: params.photoType, file: params.file);
}

class GetPhotoUrl extends UseCase<String, String> {
  const GetPhotoUrl(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<String>> call(String params) => _repository.photoUrl(params);
}
