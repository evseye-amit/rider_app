import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/home_summary.dart';
import '../domain/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._deployments, this._riderApp, this._payments, this._penalties);

  final DeploymentApi _deployments;
  final RiderAppApi _riderApp;
  final RiderPaymentsApi _payments;
  final SubmissionPenaltyApi _penalties;

  @override
  Future<Result<HomeSummary>> getSummary() async {
    final (
      Result<RiderWallet> wallet,
      Result<RiderHomeDto> home,
      Result<PaymentsHome> payments,
      Result<SubmissionPenaltySummaryDto> penalties,
    ) = await (
      _deployments.riderWallet(),
      _riderApp.home(),
      _payments.home(),
      _penalties.summary(),
    ).wait;
    if (home case Err<RiderHomeDto>(:final failure) when payments.isErr && wallet.isErr) return Result.err(failure);

    final RiderHomeDto? stats = home.valueOrNull;
    final PaymentsHome? dues = payments.valueOrNull;
    final RiderPaymentRecord? lastPayment = dues?.recentPayments.firstOrNull;
    final SubmissionPenaltySummaryDto? damage = penalties.valueOrNull;
    final num damageDue = damage?.outstandingAmount ?? 0;

    return Result.ok(
      HomeSummary(
        rentDue: dues == null ? null : _atLeastZero(dues.amountDue - damageDue),
        rentOverdue: _atLeastZero((dues?.overdueAmount ?? 0) - damageDue),
        rentDueDate: dues?.dueDate,
        paidToDate: wallet.valueOrNull?.totalPaid,
        autoPay: dues?.autoPayStatus,
        nextDebitDate: dues?.nextAutoPayDate,
        lastPaymentAmount: lastPayment?.amount,
        lastPaymentAt: lastPayment?.receivedAt,
        workPartner: stats?.partnerName,
        dailyRent: stats?.dailyRentalAmount,
        workingDays: stats?.rentalDays,
        damageDue: damageDue,
        damageCount: damage?.pendingCount ?? 0,
      ),
    );
  }

  static num _atLeastZero(num value) => value < 0 ? 0 : value;
}
