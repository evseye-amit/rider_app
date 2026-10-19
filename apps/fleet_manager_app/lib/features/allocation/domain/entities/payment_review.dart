import 'package:evseye_core/evseye_core.dart';

class PaymentReview {
  const PaymentReview({required this.payment, required this.receipts});

  final DeploymentPayment payment;
  final List<DeploymentPaymentReceipt> receipts;
}
