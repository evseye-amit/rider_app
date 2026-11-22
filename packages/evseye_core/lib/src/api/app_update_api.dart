import 'package:equatable/equatable.dart';

import '../app_update/app_release.dart';
import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';

class AppUpdateDecision extends Equatable {
  const AppUpdateDecision({
    required this.decision,
    required this.cacheMaxAgeSeconds,
    this.clientId,
    this.policyRevision,
    this.installedVersion,
    this.minimumVersion,
    this.title,
    this.message,
    this.releaseNotes,
    this.storeUrl,
  });

  factory AppUpdateDecision.fromJson(Map<String, dynamic> json) => AppUpdateDecision(
    decision: jsonText(json['decision']),
    cacheMaxAgeSeconds: jsonIntOrNull(json['cacheMaxAgeSeconds']) ?? 300,
    clientId: jsonTextOrNull(json['clientId']),
    policyRevision: jsonIntOrNull(json['policyRevision']),
    installedVersion: jsonTextOrNull(jsonMap(json['installed'])['version']),
    minimumVersion: jsonTextOrNull(jsonMap(json['minimum'])['version']),
    title: jsonTextOrNull(json['title']),
    message: jsonTextOrNull(json['message']),
    releaseNotes: jsonTextOrNull(json['releaseNotes']),
    storeUrl: jsonTextOrNull(json['storeUrl']),
  );

  final String decision;
  final int cacheMaxAgeSeconds;
  final String? clientId;
  final int? policyRevision;
  final String? installedVersion;
  final String? minimumVersion;
  final String? title;
  final String? message;
  final String? releaseNotes;
  final String? storeUrl;

  bool get isRequired => decision == 'required_update';

  bool get isOptional => decision == 'optional_update';

  Map<String, Object?> toJson() => {
    'decision': decision,
    'cacheMaxAgeSeconds': cacheMaxAgeSeconds,
    'clientId': clientId,
    'policyRevision': policyRevision,
    'installed': {'version': installedVersion},
    'minimum': {'version': minimumVersion},
    'title': title,
    'message': message,
    'releaseNotes': releaseNotes,
    'storeUrl': storeUrl,
  };

  @override
  List<Object?> get props => [
    decision,
    cacheMaxAgeSeconds,
    clientId,
    policyRevision,
    installedVersion,
    minimumVersion,
    title,
    message,
    releaseNotes,
    storeUrl,
  ];
}

class AppUpdateApi {
  const AppUpdateApi(this._client);

  final ApiClient _client;

  Future<Result<AppUpdateDecision>> checkBeforeLogin(AppRelease release, String companyCode) =>
      _client.post<AppUpdateDecision>(
        '/public/app-updates/check',
        body: {'companyCode': companyCode, ...release.body},
        skipAuth: true,
        parse: (data) => AppUpdateDecision.fromJson(jsonMap(data)),
      );

  Future<Result<AppUpdateDecision>> check(AppRelease release) => _client.post<AppUpdateDecision>(
    '/app-updates/check',
    body: release.body,
    parse: (data) => AppUpdateDecision.fromJson(jsonMap(data)),
  );
}
