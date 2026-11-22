import '../flavor/flavor_config.dart';

abstract final class ApiEnv {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.staging.evseye.com/api/v1',
  );

  //http://localhost:3000/api/v1
  //https://api.staging.evseye.com/api/v1

  static String companyCode = FlavorConfig.companyCode;

  static String get healthUrl {
    final Uri base = Uri.parse(baseUrl);
    return base.replace(path: '/health').toString();
  }
}
