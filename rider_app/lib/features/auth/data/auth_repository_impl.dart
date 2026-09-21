import 'package:evseye_core/evseye_core.dart';

import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._auth, this._riderApp);

  final AuthApi _auth;
  final RiderAppApi _riderApp;

  @override
  Future<Result<RiderEnrollment>> enroll(String mobile) => _riderApp.enroll(mobile);

  @override
  Future<Result<OtpChallenge>> requestOtp(String mobile) => _auth.requestOtp(mobile);

  @override
  Future<Result<AuthUser>> verifyOtp({required String otpRequestId, required String code}) =>
      _auth.verifyOtp(otpRequestId: otpRequestId, code: code);

  @override
  Future<Result<AuthUser>> currentUser() => _auth.me();

  @override
  Future<void> signOut() => _auth.signOut();
}
