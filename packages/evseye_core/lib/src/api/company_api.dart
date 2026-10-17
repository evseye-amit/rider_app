import '../l10n/active_locale.dart';
import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';
import 'legal_api.dart';

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
      Err<CompanyDto>(failure: ValidationFailure()) => Result.err(
        ValidationFailure(ActiveLocale.strings.companyNotFound),
      ),
      Err<CompanyDto>(failure: NotFoundFailure(:final message)) => Result.err(
        ValidationFailure(
          message == _unknownWorkspace ? ActiveLocale.strings.companyNotFound : ActiveLocale.strings.companyNotReady,
        ),
      ),
      Err<CompanyDto>() => result,
    };
  }
}
