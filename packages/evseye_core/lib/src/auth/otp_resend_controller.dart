import 'dart:async';

import 'package:flutter/foundation.dart';

class OtpResendController extends ChangeNotifier {
  OtpResendController({this.cooldownSeconds = 30});

  final int cooldownSeconds;
  Timer? _timer;
  int _remaining = 0;
  bool _busy = false;

  int get remaining => _remaining;
  bool get canResend => _remaining == 0 && !_busy;
  bool get busy => _busy;

  void start() {
    _timer?.cancel();
    _remaining = cooldownSeconds;
    _tick();
  }

  Future<T?> run<T>(Future<T> Function() action) async {
    if (!canResend) return null;
    _busy = true; notifyListeners();
    try { return await action(); } finally { _busy = false; notifyListeners(); }
  }

  void _tick() {
    notifyListeners();
    if (_remaining <= 0) return;
    _timer = Timer(const Duration(seconds: 1), () { _remaining -= 1; _tick(); });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }
}
