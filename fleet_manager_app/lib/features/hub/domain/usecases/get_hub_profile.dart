import 'package:evseye_core/evseye_core.dart';

import '../entities/hub_profile.dart';
import '../hub_repository.dart';

class GetHubProfile extends UseCase<HubProfile, String> {
  const GetHubProfile(this._repository);

  final HubRepository _repository;

  @override

  Future<Result<HubProfile>> call(String params) => _repository.getProfile(params);
}
