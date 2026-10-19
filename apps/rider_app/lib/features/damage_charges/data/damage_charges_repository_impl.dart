import 'package:evseye_core/evseye_core.dart';

import '../domain/damage_charges_repository.dart';
import '../domain/entities/damage_charge.dart';

class DamageChargesRepositoryImpl implements DamageChargesRepository {
  const DamageChargesRepositoryImpl(this._penalties, this._billing, this._submissions);

  final SubmissionPenaltyApi _penalties;
  final RiderBillingApi _billing;
  final VehicleSubmissionApi _submissions;

  @override
  Future<Result<List<DamageCharge>>> getCharges({required bool includePaid}) async => (await _penalties.list(
    includePaid: includePaid,
    limit: 100,
  )).map((page) => [for (final SubmissionPenaltyDto dto in page.items) _charge(dto)]);

  @override
  Future<Result<DamageCharge>> getCharge(String id) async => (await _penalties.detail(id)).map(_charge);

  @override
  Future<Result<String>> getPhotoUrl({required String submissionId, required String photoId}) =>
      _submissions.riderPhotoUrl(submissionId, photoId);

  @override
  Future<Result<DamagePaymentResult>> pay(String id, {required String idempotencyKey}) async =>
      (await _billing.payInvoice(id, idempotencyKey: idempotencyKey)).map(
        (checkout) => checkout.isPaid
            ? const DamagePaymentResult(outcome: DamagePaymentOutcome.paid, remaining: 0)
            : DamagePaymentResult(outcome: DamagePaymentOutcome.payRestAtHub, remaining: checkout.amount),
      );

  static DamageCharge _charge(SubmissionPenaltyDto dto) => DamageCharge(
    id: dto.invoiceId,
    total: dto.totalAmount,
    paid: dto.paidAmount,
    credit: dto.settledCreditAmount,
    due: dto.outstandingAmount,
    state: switch (dto) {
      SubmissionPenaltyDto(isVoid: true) => DamageChargeState.cancelled,
      SubmissionPenaltyDto(:final num outstandingAmount) when outstandingAmount <= 0 => DamageChargeState.paid,
      SubmissionPenaltyDto(paymentStatus: PenaltyPaymentStatus.partiallyPaid) => DamageChargeState.partlyPaid,
      SubmissionPenaltyDto(:final num paidAmount, :final num settledCreditAmount)
          when paidAmount + settledCreditAmount > 0 =>
        DamageChargeState.partlyPaid,
      _ => DamageChargeState.unpaid,
    },
    finalCheck: dto.stage == SubmissionStage.deep,
    summary: dto.summary,
    lines: [
      for (final PenaltyChargeLineDto line in dto.lines)
        DamageChargeLine(
          name: line.name,
          quantity: line.quantity,
          unitAmount: line.unitAmount,
          amount: line.amount,
          note: line.details == line.name ? '' : line.details,
          photoIds: line.evidencePhotoIds,
        ),
    ],
    raisedAt: dto.createdAt,
    reportId: dto.reportId,
    submissionId: dto.submissionId,
  );
}
