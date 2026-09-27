import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/auth_repository_impl.dart';
import 'domain/auth_repository.dart';
import 'domain/usecases/request_otp.dart';
import 'domain/usecases/restore_session.dart';
import 'domain/usecases/sign_out.dart';
import 'domain/usecases/verify_otp.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepositoryImpl(ref.watch(authApiProvider)));

final requestOtpProvider = Provider<RequestOtp>((ref) => RequestOtp(ref.watch(authRepositoryProvider)));

final verifyOtpProvider = Provider<VerifyOtp>((ref) => VerifyOtp(ref.watch(authRepositoryProvider)));

final restoreSessionProvider = Provider<RestoreSession>((ref) => RestoreSession(ref.watch(authRepositoryProvider)));

final signOutProvider = Provider<SignOut>((ref) => SignOut(ref.watch(authRepositoryProvider)));
