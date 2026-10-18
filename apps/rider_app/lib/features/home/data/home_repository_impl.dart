import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/home_summary.dart';
import '../domain/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._deployments, this._riderApp, this._payments);

  final DeploymentApi _deployments;
  final RiderAppApi _riderApp;
  final RiderPaymentsApi _payments;

  @override
  Future<Result<HomeSummary>> getSummary() async {
    final (Result<RiderWallet> wallet, Result<RiderHomeDto> home, Result<PaymentsHome> payments) = await (
      _deployments.riderWallet(),
      _riderApp.home(),
      _payments.home(),
    ).wait;
    if (home case Err<RiderHomeDto>(:final failure) when payments.isErr && wallet.isErr) return Result.err(failure);

    final RiderHomeDto? stats = home.valueOrNull;
    final PaymentsHome? dues = payments.valueOrNull;
    final RiderPaymentRecord? lastPayment = dues?.recentPayments.firstOrNull;

    return Result.ok(
      HomeSummary(
        rentDue: dues?.amountDue,
        rentOverdue: dues?.overdueAmount ?? 0,
        rentDueDate: dues?.dueDate,
        paidToDate: wallet.valueOrNull?.totalPaid,
        autoPay: dues?.autoPayStatus,
        nextDebitDate: dues?.nextAutoPayDate,
        lastPaymentAmount: lastPayment?.amount,
        lastPaymentAt: lastPayment?.receivedAt,
        category: stats?.partnerName ?? stats?.businessCategory,
        dailyRent: stats?.dailyRentalAmount,
        workingDays: stats?.rentalDays,
      ),
    );
  }
}
