import 'package:equatable/equatable.dart';

class ReferralInvite extends Equatable {
  const ReferralInvite({required this.code, required this.shareLink, this.expiresAt});

  final String code;
  final String shareLink;
  final DateTime? expiresAt;

  @override
  List<Object?> get props => [code, shareLink, expiresAt];
}
