import 'package:equatable/equatable.dart';

class ReferralInvite extends Equatable {
  const ReferralInvite({required this.code, required this.shareLink, this.inviteToken, this.qrPayload, this.expiresAt});

  final String code;
  final String shareLink;
  final String? inviteToken;
  final String? qrPayload;
  final DateTime? expiresAt;

  String get qrData => qrPayload ?? (shareLink.isEmpty ? code : shareLink);

  @override
  List<Object?> get props => [code, shareLink, inviteToken, qrPayload, expiresAt];
}
