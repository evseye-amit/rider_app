import 'package:evseye_core/evseye_core.dart';

import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._api);

  final AuthApi _api;

  @override
  Future<Result<OtpChallenge>> requestOtp(String mobile) => _api.requestOtp(mobile);

  @override
  Future<Result<AuthUser>> verifyOtp({
    required String otpRequestId,
    required String code,
  }) =>
      _api.verifyOtp(otpRequestId: otpRequestId, code: code);

  @override
  Future<Result<AuthUser>> currentUser() => _api.me();

  @override
  Future<void> signOut() => _api.signOut();
}
