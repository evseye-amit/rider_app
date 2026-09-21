import 'package:evseye_core/evseye_core.dart';

import 'entities/rider.dart';

abstract interface class RidersRepository {
  Future<Result<List<Rider>>> getRiders();
}
