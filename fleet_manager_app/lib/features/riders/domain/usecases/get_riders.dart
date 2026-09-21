import 'package:evseye_core/evseye_core.dart';

import '../entities/rider.dart';
import '../riders_repository.dart';

class GetRiders extends UseCase<List<Rider>, NoParams> {
  const GetRiders(this._repository);

  final RidersRepository _repository;

  @override
  Future<Result<List<Rider>>> call(NoParams params) => _repository.getRiders();
}
