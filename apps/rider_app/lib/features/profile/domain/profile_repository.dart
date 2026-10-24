import 'package:evseye_core/evseye_core.dart';

import 'entities/rider_profile.dart';

abstract interface class ProfileRepository {
  Future<Result<RiderProfile>> getProfile();
}
