import '../config/feature_flags.dart';
import '../utils/result.dart';
import 'api_client.dart';

class ClientModule {
  const ClientModule({
    required this.code,
    required this.name,
    required this.category,
    required this.enabled,
    required this.source,
  });

  factory ClientModule.fromJson(Map<String, dynamic> json) => ClientModule(
        code: json['code']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        enabled: json['enabled'] == true,
        source: json['source']?.toString() ?? 'PACKAGE',
      );

  final String code;
  final String name;
  final String category;
  final bool enabled;

  final String source;
}

class ClientConfig {
  const ClientConfig({
    required this.clientCode,
    required this.clientName,
    required this.packageName,
    required this.flags,
    required this.modules,
  });

  factory ClientConfig.fromJson(Map<String, dynamic> json) {
    final Map<String, bool> features = {};
    (json['features'] as Map?)?.forEach((k, v) => features[k.toString()] = v == true);

    return ClientConfig(
      clientCode: json['clientCode']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? '',
      packageName: json['packageName']?.toString() ?? '',
      flags: FeatureFlags(
        flags: features,

        settings: Map<String, dynamic>.from(json['settings'] as Map? ?? const {}),
        packageName: json['packageName']?.toString() ?? '',
        clientCode: json['clientCode']?.toString() ?? '',
      ),
      modules: (json['modules'] as List<dynamic>? ?? const [])
          .map((e) => ClientModule.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(growable: false),
    );
  }

  final String clientCode;
  final String clientName;
  final String packageName;

  final FeatureFlags flags;

  final List<ClientModule> modules;

  bool get isEmpty => modules.isEmpty;
}

class ConfigApi {
  const ConfigApi(this._client);

  final ApiClient _client;

  Future<Result<ClientConfig>> fetch(String clientId) {
    if (clientId.isEmpty) {
      return Future.value(
        const Result.err(
          UnauthorizedFailure('Sign in before reading the client configuration.'),
        ),
      );
    }
    return _client.get<ClientConfig>(
      '/platform/clients/$clientId/entitlements',
      parse: (data) => ClientConfig.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }
}
