import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';
import '../entities/payment_review.dart';

class RejectPaymentParams {
  const RejectPaymentParams({required this.allocationId, required this.reason, required this.expectedVersion});

  final String allocationId;
  final String reason;
  final int expectedVersion;
}

class PaymentReceiptRef extends Equatable {
  const PaymentReceiptRef({required this.paymentId, required this.photoId});

  final String paymentId;
  final String photoId;

  @override
  List<Object?> get props => [paymentId, photoId];
}

class GetPaymentReview extends UseCase<PaymentReview, String> {
  const GetPaymentReview(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<PaymentReview>> call(String allocationId) => _repository.paymentReview(allocationId);
}

class RejectPayment extends UseCase<DeploymentPayment, RejectPaymentParams> {
  const RejectPayment(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeploymentPayment>> call(RejectPaymentParams params) =>
      _repository.rejectPayment(params.allocationId, reason: params.reason, expectedVersion: params.expectedVersion);
}

class GetPaymentReceiptUrl extends UseCase<String, PaymentReceiptRef> {
  const GetPaymentReceiptUrl(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<String>> call(PaymentReceiptRef params) =>
      _repository.paymentReceiptUrl(params.paymentId, params.photoId);
}
