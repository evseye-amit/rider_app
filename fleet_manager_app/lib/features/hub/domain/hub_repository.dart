import 'package:evseye_core/evseye_core.dart';

import 'entities/hub_profile.dart';
import 'entities/hub_summary.dart';

abstract interface class HubRepository {
  Future<Result<List<HubProfile>>> listHubs();

  Future<Result<HubSummary>> getSummary(String hubCode);

  Future<Result<HubProfile>> getProfile(String hubCode);
}
