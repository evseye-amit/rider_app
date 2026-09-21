import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class GetIotHealth extends UseCase<IotHealth, String> {
  const GetIotHealth(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<IotHealth>> call(String params) => _repository.getIotHealth(params);
}
