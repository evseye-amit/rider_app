import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/wallet_repository_impl.dart';
import 'domain/usecases/get_wallet.dart';
import 'domain/wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => WalletRepositoryImpl(ref.watch(deploymentApiProvider)),
);

final getWalletProvider = Provider<GetWallet>((ref) => GetWallet(ref.watch(walletRepositoryProvider)));
