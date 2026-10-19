import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../deployment_repository.dart';

class ReceiptUploadParams {
  const ReceiptUploadParams({required this.paymentId, required this.file});

  final String paymentId;
  final File file;
}

class ReceiptRef extends Equatable {
  const ReceiptRef({required this.paymentId, required this.photoId});

  final String paymentId;
  final String photoId;

  @override
  List<Object?> get props => [paymentId, photoId];
}

class UploadPaymentReceipt extends UseCase<String, ReceiptUploadParams> {
  const UploadPaymentReceipt(this._repository);

  final DeploymentRepository _repository;

  @override
  Future<Result<String>> call(ReceiptUploadParams params) => _repository.uploadReceipt(params.paymentId, params.file);
}

class GetPaymentReceiptUrl extends UseCase<String, ReceiptRef> {
  const GetPaymentReceiptUrl(this._repository);

  final DeploymentRepository _repository;

  @override
  Future<Result<String>> call(ReceiptRef params) => _repository.receiptUrl(params.paymentId, params.photoId);
}
