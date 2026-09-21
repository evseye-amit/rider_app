import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class AskPaymentParams {
  const AskPaymentParams({required this.allocationId, required this.items});

  final String allocationId;
  final List<PaymentLineItem> items;
}

class AskPayment extends UseCase<DeploymentPayment, AskPaymentParams> {
  const AskPayment(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeploymentPayment>> call(AskPaymentParams params) => _repository.askPayment(params.allocationId, params.items);
}
