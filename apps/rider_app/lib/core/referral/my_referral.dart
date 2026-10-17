import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyReferral extends Equatable {
  const MyReferral({required this.code, required this.qrData, this.title});

  final String code;
  final String qrData;
  final String? title;

  @override
  List<Object?> get props => [code, qrData, title];
}

final myReferralProvider = FutureProvider.autoDispose<MyReferral?>((ref) async {
  final ReferralHomeDto home = (await ref.watch(referralApiProvider).home()).getOrThrow();
  final String? code = home.code;
  if (code == null || home.campaign == null) return null;
  return MyReferral(code: code, qrData: home.qrPayload ?? home.shareLink ?? code, title: home.campaign?.title);
});
