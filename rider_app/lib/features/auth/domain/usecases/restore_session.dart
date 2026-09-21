import 'package:evseye_core/evseye_core.dart';

import '../auth_repository.dart';

class RestoreSession extends UseCase<AuthUser, NoParams> {
  const RestoreSession(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AuthUser>> call(NoParams params) => _repository.currentUser();
}
