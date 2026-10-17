import '../utils/result.dart';
import 'api_client.dart';
import 'api_env.dart';
import 'json_fields.dart';

enum LegalKind {
  terms('TERMS_AND_CONDITIONS'),
  privacy('PRIVACY_POLICY'),
  consent('PRIVACY_CONSENT');

  const LegalKind(this.wire);

  final String wire;
}

class LegalAudience {
  const LegalAudience({required this.appCode, required this.role});

  static const LegalAudience rider = LegalAudience(appCode: 'RIDER', role: 'RIDER');

  static const LegalAudience fleetManager = LegalAudience(appCode: 'FLEET_MANAGER', role: 'FLEET_MANAGER');

  final String appCode;
  final String role;
}

class LegalDocumentDto {
  const LegalDocumentDto({
    required this.id,
    required this.kind,
    required this.locale,
    required this.version,
    required this.title,
    required this.content,
    required this.contentHash,
    this.effectiveAt,
  });

  factory LegalDocumentDto.fromJson(Map<String, dynamic> json) => LegalDocumentDto(
    id: jsonText(json['id']),
    kind: jsonText(json['kind']),
    locale: jsonText(json['locale']),
    version: jsonText(json['version']),
    title: jsonText(json['title']),
    content: jsonText(json['content']),
    contentHash: jsonText(json['contentHash']),
    effectiveAt: jsonDate(json['effectiveAt']),
  );

  final String id;
  final String kind;
  final String locale;
  final String version;
  final String title;
  final String content;
  final String contentHash;
  final DateTime? effectiveAt;
}

class LegalApi {
  const LegalApi(this._client);

  final ApiClient _client;

  static const String fallbackLocale = 'en';

  Future<Result<LegalDocumentDto>> current({
    required LegalAudience audience,
    required LegalKind kind,
    required String locale,
  }) async {
    final Result<LegalDocumentDto> result = await _fetch(audience, kind, locale);
    if (result case Err<LegalDocumentDto>(failure: NotFoundFailure()) when locale != fallbackLocale) {
      return _fetch(audience, kind, fallbackLocale);
    }
    return result;
  }

  Future<Result<void>> accept({required String documentId, required String contentHash}) => _client.post<void>(
    '/legal/acceptances',
    body: {'documentId': documentId, 'contentHash': contentHash},
    parse: (_) {},
  );

  Future<Result<LegalDocumentDto>> _fetch(LegalAudience audience, LegalKind kind, String locale) =>
      _client.get<LegalDocumentDto>(
        '/public/legal/current',
        query: {
          'companyCode': ApiEnv.companyCode,
          'appCode': audience.appCode,
          'role': audience.role,
          'kind': kind.wire,
          'locale': locale,
        },
        parse: (data) => LegalDocumentDto.fromJson(jsonMap(data)),
      );
}
