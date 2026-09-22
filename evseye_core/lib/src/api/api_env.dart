abstract final class ApiEnv {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  static const String companyCode = String.fromEnvironment(
    'COMPANY_CODE',
    defaultValue: 'yogmaya',
  );

  static String get healthUrl {
    final Uri base = Uri.parse(baseUrl);
    return base.replace(path: '/health').toString();
  }
}
