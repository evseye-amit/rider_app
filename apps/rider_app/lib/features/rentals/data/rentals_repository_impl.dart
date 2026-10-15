import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/rental.dart';
import '../domain/rentals_repository.dart';

class RentalsRepositoryImpl implements RentalsRepository {
  const RentalsRepositoryImpl(this._billing, this._agreements);

  final RiderBillingApi _billing;
  final RentalAgreementsApi _agreements;

  @override
  Future<Result<RentalsOverview>> getRentals() async {
    final (overview, invoices, agreements) = await (_billing.overview(), _billing.invoices(), _agreements.list()).wait;
    if (overview case Err<BillingOverviewDto>(:final failure)) return Result.err(failure);
    if (invoices case Err<List<InvoiceDto>>(:final failure)) return Result.err(failure);
    final BillingOverviewDto summary = (overview as Ok<BillingOverviewDto>).value;
    final RentalAgreementDto? active = agreements.valueOrNull?.where((agreement) => agreement.isActive).firstOrNull;
    return Result.ok(
      RentalsOverview(
        plan: active == null ? null : _plan(active),
        summary: BillingSummary(
          outstanding: summary.outstanding,
          overdue: summary.overdue,
          dueLater: summary.futureDue,
          credit: summary.availableCredit,
          depositHeld: summary.depositHeld,
          unallocated: summary.unallocatedPayments,
          autoPay: summary.autoPayEnabled,
        ),
        bills: [
          for (final InvoiceDto invoice in (invoices as Ok<List<InvoiceDto>>).value)
            if (invoice.status != BillingInvoiceStatus.draft) _bill(invoice),
        ],
      ),
    );
  }

  @override
  Future<Result<BillDetail>> bill(String id) async => (await _billing.invoice(id)).map(
    (detail) => BillDetail(
      bill: _bill(detail.invoice),
      lines: [
        for (final InvoiceLineDto line in detail.lines)
          BillLine(description: line.description, amount: line.amount, isCredit: line.isCredit, tax: line.taxAmount),
      ],
      subtotal: detail.invoice.subtotal,
      credit: detail.invoice.credit,
      tax: detail.invoice.tax,
      walletPaid: detail.walletPaid,
      settlementCredit: detail.invoice.settlementCredit,
    ),
  );

  @override
  Future<Result<List<LedgerLine>>> ledger() async => (await _billing.ledger()).map(
    (entries) => [
      for (final LedgerEntryDto entry in entries)
        LedgerLine(
          id: entry.id,
          kind: switch (entry.entryType) {
            'CREDIT' => LedgerKind.credit,
            'PAYMENT' => LedgerKind.payment,
            'REFUND' => LedgerKind.refund,
            'ADJUSTMENT' => LedgerKind.adjustment,
            'REVERSAL' => LedgerKind.reversal,
            _ => LedgerKind.charge,
          },
          description: entry.description,
          debit: entry.debit,
          credit: entry.credit,
          at: entry.effectiveAt,
          isDeposit: entry.isDepositLiability,
        ),
    ],
  );

  @override
  Future<Result<List<PaymentReceipt>>> receipts() async => (await _billing.paymentReceipts()).map(
    (receipts) => [
      for (final PaymentReceiptDto receipt in receipts)
        PaymentReceipt(
          id: receipt.id,
          amount: receipt.amount,
          method: receipt.method,
          confirmed: receipt.isConfirmed,
          receivedAt: receipt.receivedAt,
          invoiceCount: receipt.invoiceCount,
          refunded: receipt.refunded,
          reference: receipt.reference,
        ),
    ],
  );

  static RentalPlan _plan(RentalAgreementDto agreement) {
    final String scooter = [?agreement.vehicleModel, ?agreement.vehicleVariant].join(' ').trim();
    return RentalPlan(
      agreementNumber: agreement.agreementNumber,
      rent: agreement.recurringAmount,
      period: agreement.rentalPeriodType,
      scooterName: scooter.isEmpty ? null : scooter,
    );
  }

  static Bill _bill(InvoiceDto invoice) => Bill(
    id: invoice.id,
    number: invoice.number,
    status: switch (invoice.status) {
      BillingInvoiceStatus.finalized => BillStatus.due,
      BillingInvoiceStatus.partiallyPaid => BillStatus.partlyPaid,
      BillingInvoiceStatus.paid => BillStatus.paid,
      BillingInvoiceStatus.overdue => BillStatus.overdue,
      BillingInvoiceStatus.voided => BillStatus.voided,
      BillingInvoiceStatus.draft => BillStatus.draft,
    },
    total: invoice.total,
    paid: invoice.paid,
    outstanding: invoice.outstanding,
    createdAt: invoice.createdAt,
    dueDate: invoice.dueDate,
    paidAt: invoice.paidAt,
    periodStart: invoice.periodStart,
    periodEnd: invoice.periodEnd,
  );
}
