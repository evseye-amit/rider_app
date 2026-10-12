import 'package:evseye_core/evseye_core.dart';

import '../auth_repository.dart';

class EnrollRider extends UseCase<RiderEnrollment, String> {
  const EnrollRider(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<RiderEnrollment>> call(String params) => _repository.enroll(params);
}
