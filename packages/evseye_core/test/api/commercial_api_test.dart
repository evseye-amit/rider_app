import 'package:dio/dio.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('quotes and submits a rental plan for the same selected partner', () async {
    SharedPreferences.setMockInitialValues({});
    final calls = <RequestOptions>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            calls.add(request);
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: 200,
                data: {
                  'data': request.method == 'GET'
                      ? {
                          'workPartners': [
                            {'id': 'partner-1', 'name': 'Delivery One'},
                          ],
                          'items': [
                            {
                              'selection': {
                                'rateCardVersionId': 'version-1',
                                'workPartnerId': 'partner-1',
                              },
                            },
                          ],
                        }
                      : <String, dynamic>{},
                },
              ),
            );
          },
        ),
      );
    final api = CommercialApi(
      ApiClient(
        tokens: TokenStore(await SharedPreferences.getInstance()),
        dio: dio,
        logRequests: false,
      ),
    );

    final result = await api.plans('allocation', workPartnerId: 'partner-1');
    final plans = (result as Ok<RentalPlanList>).value;
    expect(plans.workPartners?.single.name, 'Delivery One');
    expect(calls.single.queryParameters['workPartnerId'], 'partner-1');

    expect(
      await api.selectPlan('allocation', plans.items.single, idempotencyKey: 'selection-1'),
      isA<Ok<AllocationCommercial>>(),
    );
    expect(calls.last.data, containsPair('workPartnerId', 'partner-1'));
    expect(RentalPlanList.fromJson({}).workPartners, isNull);
    expect(RentalPlanList.fromJson({'workPartners': []}).workPartners, isEmpty);
  });

  test('reads the locked partner on the inspection workflow', () {
    final workflow = DeploymentWorkflow.fromJson({
      'clientWorkPartnerId': 'partner-1',
      'workPartnerName': 'Delivery One',
    });
    expect(workflow.workPartnerId, 'partner-1');
    expect(workflow.workPartnerName, 'Delivery One');
  });
}
