import 'package:evseye_core/evseye_core.dart';

import '../entities/rider_profile.dart';
import '../profile_repository.dart';

class GetRiderProfile extends UseCase<RiderProfile, NoParams> {
  const GetRiderProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Result<RiderProfile>> call(NoParams params) => _repository.getProfile();
}
