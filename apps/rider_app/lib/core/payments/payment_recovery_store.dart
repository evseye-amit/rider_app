import 'dart:convert';

import 'package:evseye_core/evseye_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingPayment {
  const PendingPayment({
    required this.slot,
    required this.body,
    required this.idempotencyKey,
    required this.createdAt,
    this.paymentRequestId,
    this.paidInCheckout = false,
  });

  factory PendingPayment.start(PaymentOrderRequest request) => PendingPayment(
    slot: request.slot,
    body: request.body,
    idempotencyKey: newIdempotencyKey(),
    createdAt: DateTime.now(),
  );

  static PendingPayment? fromJson(Map<String, dynamic> json) {
    final String slot = _text(json['slot']);
    final String key = _text(json['idempotencyKey']);
    final DateTime? createdAt = DateTime.tryParse(_text(json['createdAt']));
    if (slot.isEmpty || key.isEmpty || createdAt == null) return null;
    return PendingPayment(
      slot: slot,
      body: _map(json['body']),
      idempotencyKey: key,
      createdAt: createdAt,
      paymentRequestId: _text(json['paymentRequestId']).isEmpty ? null : _text(json['paymentRequestId']),
      paidInCheckout: json['paidInCheckout'] == true,
    );
  }

  final String slot;
  final Map<String, Object?> body;
  final String idempotencyKey;
  final DateTime createdAt;
  final String? paymentRequestId;
  final bool paidInCheckout;

  PaymentOrderRequest get request => PaymentOrderRequest.restore(body: body, slot: slot);

  bool matches(PaymentOrderRequest request) => request.slot == slot && jsonEncode(request.body) == jsonEncode(body);

  PendingPayment copyWith({String? paymentRequestId, bool? paidInCheckout}) => PendingPayment(
    slot: slot,
    body: body,
    idempotencyKey: idempotencyKey,
    createdAt: createdAt,
    paymentRequestId: paymentRequestId ?? this.paymentRequestId,
    paidInCheckout: paidInCheckout ?? this.paidInCheckout,
  );

  Map<String, Object?> toJson() => {
    'slot': slot,
    'body': body,
    'idempotencyKey': idempotencyKey,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'paymentRequestId': paymentRequestId,
    'paidInCheckout': paidInCheckout,
  };
}

class PaymentRecoveryStore {
  PaymentRecoveryStore(this._preferences);

  static const String _key = 'payments.pending.v1';
  static const Duration _retention = Duration(days: 14);

  final SharedPreferences _preferences;

  PendingPayment? read(String scope, String slot) => _scope(scope)[slot];

  List<PendingPayment> all(String scope) => _scope(scope).values.toList(growable: false);

  PendingPayment? byRequestId(String scope, String paymentRequestId) {
    for (final PendingPayment payment in _scope(scope).values) {
      if (payment.paymentRequestId == paymentRequestId) return payment;
    }
    return null;
  }

  Future<void> write(String scope, PendingPayment payment) =>
      _update(scope, (slots) => slots[payment.slot] = payment.toJson());

  Future<void> remove(String scope, String slot) => _update(scope, (slots) => slots.remove(slot));

  Future<void> removeRequest(String scope, String paymentRequestId) =>
      _update(scope, (slots) => slots.removeWhere((_, value) => _map(value)['paymentRequestId'] == paymentRequestId));

  Map<String, PendingPayment> _scope(String scope) {
    final DateTime cutoff = DateTime.now().subtract(_retention);
    return {
      for (final MapEntry<String, dynamic> entry in _map(_decode()[scope]).entries)
        if (PendingPayment.fromJson(_map(entry.value)) case final PendingPayment payment
            when payment.createdAt.isAfter(cutoff))
          entry.key: payment,
    };
  }

  Map<String, dynamic> _decode() {
    final String? raw = _preferences.getString(_key);
    if (raw == null || raw.isEmpty) return <String, dynamic>{};
    try {
      return _map(jsonDecode(raw));
    } on FormatException {
      return <String, dynamic>{};
    }
  }

  Future<void> _update(String scope, void Function(Map<String, dynamic> slots) change) async {
    final Map<String, dynamic> all = Map<String, dynamic>.of(_decode());
    final Map<String, dynamic> slots = _map(all[scope]);
    change(slots);
    if (slots.isEmpty) {
      all.remove(scope);
    } else {
      all[scope] = slots;
    }
    await _preferences.setString(_key, jsonEncode(all));
  }
}

Map<String, dynamic> _map(Object? value) => value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

String _text(Object? value) => value?.toString().trim() ?? '';
