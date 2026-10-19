import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../allocation_dependencies.dart';
import '../../domain/entities/payment_review.dart';
import '../../domain/usecases/payment_review_usecases.dart';

final paymentReviewProvider = FutureProvider.autoDispose.family<PaymentReview, String>(
  (ref, allocationId) async => (await ref.watch(getPaymentReviewProvider)(allocationId)).getOrThrow(),
);

final paymentReceiptUrlProvider = FutureProvider.autoDispose.family<String, PaymentReceiptRef>(
  (ref, receipt) async => (await ref.watch(getPaymentReceiptUrlProvider)(receipt)).getOrThrow(),
);
