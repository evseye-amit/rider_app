import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_upi_india/flutter_upi_india.dart';

enum UpiOutcome { paid, processing, failed, opened, notOpened }

typedef UpiPaymentResult = ({UpiOutcome outcome, String? reference});

abstract final class UpiCheckout {
  static bool get available => FlavorConfig.upiId.isNotEmpty;

  static bool get _merchant => FlavorConfig.upiMerchantCode.isNotEmpty;

  static Future<List<ApplicationMeta>> apps() async {
    try {
      final List<ApplicationMeta> found = await UpiPay.getInstalledUpiApplications(
        statusType: _merchant
            ? UpiApplicationDiscoveryAppStatusType.all
            : UpiApplicationDiscoveryAppStatusType.workingWithWarnings,
      );
      return [
        for (final ApplicationMeta app in found)
          if (!Platform.isIOS || app.upiApplication.discoveryCustomScheme != null) app,
      ];
    } on PlatformException {
      return const [];
    }
  }

  static Future<UpiPaymentResult> pay({
    required ApplicationMeta app,
    required num amount,
    required String reference,
    required String note,
  }) async {
    final UpiTransactionResponse response;
    try {
      response = await UpiPay.initiateTransaction(
        app: app.upiApplication,
        receiverUpiAddress: FlavorConfig.upiId,
        receiverName: FlavorConfig.upiPayeeName,
        transactionRef: reference,
        amount: amount.toStringAsFixed(2),
        transactionNote: note,
        merchantCode: _merchant ? FlavorConfig.upiMerchantCode : null,
      );
    } on UnsupportedError {
      return (outcome: UpiOutcome.processing, reference: null);
    } on PlatformException {
      return (outcome: Platform.isAndroid ? UpiOutcome.failed : UpiOutcome.notOpened, reference: null);
    }
    if (!Platform.isAndroid) {
      return (
        outcome: response.status == UpiTransactionStatus.launched ? UpiOutcome.opened : UpiOutcome.notOpened,
        reference: null,
      );
    }
    final UpiOutcome outcome = switch (response.status) {
      UpiTransactionStatus.success => UpiOutcome.paid,
      UpiTransactionStatus.submitted => UpiOutcome.processing,
      _ => UpiOutcome.failed,
    };
    return (outcome: outcome, reference: outcome == UpiOutcome.failed ? null : _upiReference(response));
  }

  static String? _upiReference(UpiTransactionResponse response) => [
    response.approvalRefNo,
    response.txnId,
  ].map((value) => value?.trim() ?? '').where((value) => value.isNotEmpty && value.toLowerCase() != 'null').firstOrNull;
}
