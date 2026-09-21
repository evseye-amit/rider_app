import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rider_app/features/deployment/domain/deployment_repository.dart';
import 'package:rider_app/features/deployment/domain/usecases/accept_pdi.dart';
import 'package:rider_app/features/deployment/presentation/cubit/pdi_cubit.dart';

void main() {
  const List<PdiChecklistItem> items = [
    PdiChecklistItem(code: 'BRAKES', label: 'Brakes', mandatory: true),
    PdiChecklistItem(code: 'TYRES', label: 'Tyres', mandatory: true),
    PdiChecklistItem(code: 'LIGHTS', label: 'Lights and indicators', mandatory: false),
  ];

  late _FakeDeploymentRepository repository;
  late PdiCubit cubit;

  setUp(() {
    repository = _FakeDeploymentRepository();
    cubit = PdiCubit(items: items, acceptPdi: AcceptPdi(repository), allocationId: 'alloc-1');
  });

  tearDown(() => cubit.close());

  test('starts with nothing checked and cannot submit', () {
    expect(cubit.state.total, 3);
    expect(cubit.state.checked, 0);
    expect(cubit.state.allChecked, isFalse);
  });

  test('a verdict advances the count and a rejection keeps its note', () {
    cubit.setVerdict('BRAKES', CheckState.pass);
    expect(cubit.state.checked, 1);

    cubit.setVerdict('TYRES', CheckState.fail);
    cubit.setNote('TYRES', 'Rear tyre worn');
    expect(cubit.state.checked, 2);
    expect(cubit.state.anyFailed, isTrue);
    expect(cubit.state.notes['TYRES'], 'Rear tyre worn');
  });

  test('submit refuses until every item is answered', () async {
    cubit.setVerdict('BRAKES', CheckState.pass);
    cubit.setVerdict('TYRES', CheckState.pass);
    expect(await cubit.submit(), isFalse);
    expect(repository.accepted, isNull, reason: 'nothing must reach the API with an item unanswered');
  });

  test('submit sends one answer per item, in the API shape', () async {
    cubit.setVerdict('BRAKES', CheckState.pass);
    cubit.setVerdict('TYRES', CheckState.fail);
    cubit.setNote('TYRES', 'Rear tyre worn');
    cubit.setVerdict('LIGHTS', CheckState.pass);

    expect(await cubit.submit(), isTrue);
    expect(cubit.state.status, PdiStatus.submitted);

    final List<Map<String, dynamic>> sent = repository.accepted!.map((r) => r.toJson()).toList();
    expect(sent, [
      {'code': 'BRAKES', 'accepted': true},
      {'code': 'TYRES', 'accepted': false, 'remarksText': 'Rear tyre worn'},
      {'code': 'LIGHTS', 'accepted': true},
    ]);
  });

  test('a server refusal is surfaced and leaves the answers in place', () async {
    repository.failWith = const ValidationFailure('A text or voice remark is required for rejected PDI item TYRES.');
    for (final item in items) {
      cubit.setVerdict(item.code, CheckState.pass);
    }
    expect(await cubit.submit(), isFalse);
    expect(cubit.state.status, PdiStatus.failure);
    expect(cubit.state.message, contains('TYRES'));
    expect(cubit.state.checked, 3);
  });
}

class _FakeDeploymentRepository implements DeploymentRepository {
  List<PdiItemResponse>? accepted;
  Failure? failWith;

  @override
  Future<Result<DeploymentWorkflow>> acceptPdi(String allocationId, List<PdiItemResponse> items) async {
    if (failWith != null) return Result.err(failWith!);
    accepted = items;
    return Result.ok(
      const DeploymentWorkflow(
        id: 'wf-1',
        allocationId: 'alloc-1',
        status: DeploymentStatus.trainingPending,
        pdiChecklist: [],
        trainingViewedContentCodes: [],
      ),
    );
  }

  @override
  Future<Result<RiderDeployment>> current() => throw UnimplementedError();
  @override
  Future<Result<RiderWallet>> wallet() => throw UnimplementedError();
  @override
  Future<Result<DeploymentPayment>> payment(String allocationId) => throw UnimplementedError();
  @override
  Future<Result<DeploymentPayment>> submitPayment(String allocationId, {required String provider, required String reference}) =>
      throw UnimplementedError();
  @override
  Future<Result<List<TrainingItem>>> training(String allocationId) => throw UnimplementedError();
  @override
  Future<Result<DeploymentWorkflow>> markTrainingViewed(String allocationId, String contentCode) => throw UnimplementedError();
  @override
  Future<Result<DeploymentWorkflow>> completeTraining(String allocationId) => throw UnimplementedError();
  @override
  Future<Result<DeploymentWorkflow>> pair(String allocationId, String deviceNumber) => throw UnimplementedError();
}
