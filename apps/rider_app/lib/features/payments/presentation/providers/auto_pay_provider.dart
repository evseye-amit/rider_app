import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ledger/presentation/providers/ledger_provider.dart';
import '../../domain/entities/auto_pay.dart';
import '../../payments_dependencies.dart';

class AutoPayNotifier extends AsyncNotifier<AutoPay?> {
  static const List<Duration> _backoff = [
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 30),
    Duration(seconds: 60),
  ];

  Timer? _timer;
  int _attempt = 0;

  @override
  Future<AutoPay?> build() async {
    ref.onDispose(() => _timer?.cancel());
    _attempt = 0;
    final AutoPay? value = (await ref.watch(getAutoPayProvider)(const NoParams())).getOrThrow();
    _schedule(value);
    return value;
  }

  void _schedule(AutoPay? value) {
    _timer?.cancel();
    final bool waiting = value != null && (value.activating || (value.openRequest?.state.isAwaitingBank ?? false));
    if (!waiting || _attempt >= _backoff.length) return;
    _timer = Timer(_backoff[_attempt++], _poll);
  }

  Future<void> _poll() async {
    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) return;
    final AutoPay? value = (await ref.read(getAutoPayProvider)(const NoParams())).valueOrNull;
    if (!ref.mounted || value == null) return;
    final bool settled = state.value?.openRequest != null && value.openRequest == null;
    state = AsyncData(value);
    if (settled) {
      ref
        ..invalidate(ledgerOverviewProvider)
        ..invalidate(ledgerTransactionsProvider);
    }
    _schedule(value);
  }
}

final autoPayProvider = AsyncNotifierProvider.autoDispose<AutoPayNotifier, AutoPay?>(AutoPayNotifier.new);
