import 'package:evseye_core/evseye_core.dart';

import '../entities/hub_profile.dart';
import '../hub_repository.dart';

class ListHubs extends UseCase<List<HubProfile>, NoParams> {
  const ListHubs(this._repository);

  final HubRepository _repository;

  @override
  Future<Result<List<HubProfile>>> call(NoParams params) => _repository.listHubs();
}
