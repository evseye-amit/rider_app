import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet_summary.dart';
import '../../wallet_dependencies.dart';

final walletProvider = FutureProvider.autoDispose<WalletSummary>(
  (ref) async => (await ref.watch(getWalletProvider)(const NoParams())).getOrThrow(),
);
