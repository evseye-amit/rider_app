import 'package:evseye_core/evseye_core.dart';

abstract interface class AuthRepository {
  Future<Result<OtpChallenge>> requestOtp(String mobile);

  Future<Result<AuthUser>> verifyOtp({required String otpRequestId, required String code});

  Future<Result<AuthUser>> currentUser();

  Future<void> signOut();
}
