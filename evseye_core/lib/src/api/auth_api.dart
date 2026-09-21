import '../utils/result.dart';
import 'api_client.dart';
import 'api_env.dart';
import 'token_store.dart';

class OtpChallenge {
  const OtpChallenge({required this.otpRequestId, required this.expiresAt});

  factory OtpChallenge.fromJson(Map<String, dynamic> json) => OtpChallenge(
        otpRequestId: json['otpRequestId'] as String,
        expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? '') ??
            DateTime.now().add(const Duration(minutes: 5)),
      );

  final String otpRequestId;
  final DateTime expiresAt;

  Duration get remaining {
    final Duration left = expiresAt.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }
}

class AuthUser {
  const AuthUser({required this.id, required this.clientId, required this.roles});

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        clientId: json['clientId'] as String?,
        roles: (json['roles'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(growable: false),
      );

  final String id;
  final String? clientId;
  final List<String> roles;

  bool hasRole(String role) => roles.contains(role);

  bool get isRider => hasRole('RIDER');
  bool get isFleetManager => hasRole('FLEET_MANAGER');
  bool get isClientAdmin => hasRole('CLIENT_ADMIN');
}

class AuthApi {
  const AuthApi(this._client, this._tokens);

  final ApiClient _client;
  final TokenStore _tokens;

  Future<Result<OtpChallenge>> requestOtp(String mobile, {String? companyCode}) {
    return _client.post<OtpChallenge>(
      '/auth/otp/request',
      skipAuth: true,
      body: {
        'phone': _normalise(mobile),
        'companyCode': companyCode ?? ApiEnv.companyCode,
      },
      parse: (data) => OtpChallenge.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<Result<AuthUser>> verifyOtp({
    required String otpRequestId,
    required String code,
  }) async {
    final Result<Map<String, dynamic>> tokens = await _client.post<Map<String, dynamic>>(
      '/auth/otp/verify',
      skipAuth: true,
      body: {'otpRequestId': otpRequestId, 'code': code},
      parse: (data) => Map<String, dynamic>.from(data as Map),
    );

    return switch (tokens) {
      Err<Map<String, dynamic>>(:final failure) => Result.err(failure),
      Ok<Map<String, dynamic>>(:final value) => await () async {
          await _tokens.save(
            accessToken: value['accessToken'] as String,
            refreshToken: value['refreshToken'] as String,
          );
          return me();
        }(),
    };
  }

  Future<Result<AuthUser>> me() => _client.get<AuthUser>(
        '/auth/me',
        parse: (data) => AuthUser.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<void> signOut() async {
    final String? refresh = _tokens.refreshToken;
    if (refresh != null && refresh.isNotEmpty) {
      await _client.post<void>(
        '/auth/logout',
        body: {'refreshToken': refresh},
        parse: (_) {},
      );
    }
    await _tokens.clear();
  }

  static String _normalise(String mobile) {
    final String digits = mobile.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 10) return digits.substring(digits.length - 10);
    return digits;
  }
}
