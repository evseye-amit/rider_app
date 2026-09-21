import 'package:evseye_core/evseye_core.dart';

import 'entities/wallet_summary.dart';

abstract interface class WalletRepository {
  Future<Result<WalletSummary>> getWallet();
}
