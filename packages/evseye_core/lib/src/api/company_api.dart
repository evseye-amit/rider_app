import '../l10n/active_locale.dart';
import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';
import 'legal_api.dart';
import 'pre_login_error_codes.g.dart';

class CompanyDto {
  const CompanyDto({required this.code, required this.name});

  factory CompanyDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> client = jsonMap(json['client']);
    return CompanyDto(code: jsonText(client['companyCode']), name: jsonText(client['displayName']));
  }

  final String code;
  final String name;
}

class CompanyApi {
  const CompanyApi(this._client);

  final ApiClient _client;

  static const String _unknownWorkspace = 'Workspace unavailable.';

  Future<Result<CompanyDto>> resolve({required String code, required LegalAudience audience}) async {
    final Result<CompanyDto> result = await _client.get<CompanyDto>(
      '/public/app/bootstrap',
      query: {'companyCode': code, 'appCode': audience.appCode, 'role': audience.role},
      parse: (data) => CompanyDto.fromJson(jsonMap(data)),
    );
    return switch (result) {
      Ok<CompanyDto>(:final value) when value.code.isNotEmpty => result,
      Ok<CompanyDto>() => Result.err(ValidationFailure(ActiveLocale.strings.companyNotFound)),
      Err<CompanyDto>(failure: ValidationFailure(:final serverCode)) => Result.err(
        ValidationFailure(ActiveLocale.strings.companyNotFound, serverCode: serverCode),
      ),
      Err<CompanyDto>(failure: NotFoundFailure(:final message, :final serverCode)) => Result.err(
        ValidationFailure(
          switch (serverCode) {
            'WORKSPACE_NOT_FOUND' => ActiveLocale.strings.companyNotFound,
            'WORKSPACE_HOST_MISMATCH' => 'This workspace does not match the current hostname.',
            'WORKSPACE_UNAVAILABLE' => ActiveLocale.strings.companyNotReady,
            'WORKSPACE_PENDING_APPROVAL' => 'This workspace is pending approval.',
            'WORKSPACE_SUSPENDED' => 'This workspace is suspended.',
            'WORKSPACE_INACTIVE' => 'This workspace is inactive.',
            'UNSUPPORTED_APP_ROLE' => 'This app is not available for your role.',
            _ when serverCode != null && !preLoginErrorCodes.contains(serverCode) => message == _unknownWorkspace ? ActiveLocale.strings.companyNotFound : ActiveLocale.strings.companyNotReady,
            _ => message == _unknownWorkspace ? ActiveLocale.strings.companyNotFound : ActiveLocale.strings.companyNotReady,
          },
          serverCode: serverCode,
        ),
      ),
      Err<CompanyDto>() => result,
    };
  }
}
