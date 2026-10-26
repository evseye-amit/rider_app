import '../utils/result.dart';
import 'api_client.dart';

class PushDevicesApi {
  const PushDevicesApi(this._client);

  final ApiClient _client;

  Future<Result<void>> register({
    required String installationId,
    required String appCode,
    required String platform,
    required String token,
  }) => _client.put<void>(
    '/app/push-devices',
    body: {'installationId': installationId, 'appCode': appCode, 'platform': platform, 'token': token},
    parse: (_) {},
  );

  Future<Result<void>> unregister(String installationId) =>
      _client.delete<void>('/app/push-devices/$installationId', parse: (_) {});
}
