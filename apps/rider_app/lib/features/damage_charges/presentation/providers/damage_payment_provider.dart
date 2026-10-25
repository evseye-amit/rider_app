import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/payments/online_payments.dart';
import '../../../../core/session/rider_session_provider.dart';
import '../../../home/presentation/providers/home_summary_provider.dart';
import '../../../payments/presentation/providers/payments_provider.dart';
import 'damage_charges_providers.dart';

enum DamagePaymentNotice { pending, review }

class DamagePaymentState extends Equatable {
  const DamagePaymentState({this.paying = false, this.notice});

  final bool paying;
  final DamagePaymentNotice? notice;

  @override
  List<Object?> get props => [paying, notice];
}

class DamagePaymentController extends Notifier<DamagePaymentState> {
  @override
  DamagePaymentState build() => const DamagePaymentState();

  Future<OnlinePaymentOutcome?> pay({required String description}) async {
    if (state.paying) return null;
    final String mobile = ref.read(riderSessionProvider).mobile;
    state = DamagePaymentState(paying: true, notice: state.notice);
    final OnlinePaymentOutcome outcome = await ref
        .read(onlinePaymentsProvider)
        .pay(
          PaymentOrderRequest.submissionPenalty(),
          description: description,
          contact: mobile.isEmpty ? null : mobile,
        );
    if (!ref.mounted) return outcome;
    state = DamagePaymentState(
      notice: switch (outcome) {
        OnlinePaymentPending() => DamagePaymentNotice.pending,
        OnlinePaymentNeedsSupport() => DamagePaymentNotice.review,
        _ => state.notice,
      },
    );
    ref
      ..invalidate(damageChargesSummaryProvider)
      ..invalidate(damageChargesProvider)
      ..invalidate(damageChargeProvider)
      ..invalidate(homeSummaryProvider)
      ..invalidate(paymentsOverviewProvider);
    return outcome;
  }
}

final damagePaymentProvider = NotifierProvider.autoDispose<DamagePaymentController, DamagePaymentState>(
  DamagePaymentController.new,
);
