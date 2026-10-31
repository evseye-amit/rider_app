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

  String _messageFor(String? serverCode, String message) {
    if (serverCode == 'WORKSPACE_NOT_FOUND') return ActiveLocale.strings.companyNotFound;
    if (serverCode != null && preLoginUnavailableCodes.contains(serverCode)) return ActiveLocale.strings.companyNotReady;
    return message == _unknownWorkspace ? ActiveLocale.strings.companyNotFound : ActiveLocale.strings.companyNotReady;
  }

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
          _messageFor(serverCode, message),
          serverCode: serverCode,
        ),
      ),
      Err<CompanyDto>() => result,
    };
  }
}
