import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet_auto_pay.dart';
import '../../domain/usecases/wallet_auto_pay_usecases.dart';
import '../../wallet_dependencies.dart';
import 'wallet_provider.dart';

class WalletAutoPayNotifier extends AsyncNotifier<WalletAutoPay?> {
  static const List<Duration> _backoff = [
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 30),
    Duration(seconds: 60),
  ];

  Timer? _timer;
  int _attempt = 0;

  @override
  Future<WalletAutoPay?> build() async {
    ref.onDispose(() => _timer?.cancel());
    _attempt = 0;
    final WalletAutoPay? value = await _fetch();
    _schedule(value);
    return value;
  }

  Future<Result<WalletAutoPay>> enable({required String mandateId, required int revision}) =>
      _change(WalletAutoPayChange.enable(mandateId: mandateId, revision: revision));

  Future<Result<WalletAutoPay>> disable() => _change(const WalletAutoPayChange.disable());

  Future<Result<WalletAutoPay>> _change(WalletAutoPayChange change) async {
    final Result<WalletAutoPay> result = await ref.read(setWalletAutoPayProvider)(change);
    if (!ref.mounted) return result;
    if (result case Ok<WalletAutoPay>(:final value)) {
      _attempt = 0;
      state = AsyncData(value);
      _schedule(value);
      ref
        ..invalidate(walletOverviewProvider)
        ..invalidate(walletTransactionsProvider);
    }
    return result;
  }

  Future<WalletAutoPay?> _fetch() async => (await ref.read(getWalletAutoPayProvider)(const NoParams())).valueOrNull;

  void _schedule(WalletAutoPay? value) {
    _timer?.cancel();
    if (value?.openRequest?.state.isAwaitingBank != true || _attempt >= _backoff.length) return;
    _timer = Timer(_backoff[_attempt++], _poll);
  }

  Future<void> _poll() async {
    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) return;
    final WalletAutoPay? value = await _fetch();
    if (!ref.mounted || value == null) return;
    final bool settled = state.value?.openRequest != null && value.openRequest == null;
    state = AsyncData(value);
    if (settled) {
      ref
        ..invalidate(walletOverviewProvider)
        ..invalidate(walletTransactionsProvider);
    }
    _schedule(value);
  }
}

final walletAutoPayProvider = AsyncNotifierProvider.autoDispose<WalletAutoPayNotifier, WalletAutoPay?>(
  WalletAutoPayNotifier.new,
);
