import 'package:evseye_core/evseye_core.dart';

import 'entities/swap_station.dart';

abstract interface class SwapStationsRepository {
  Future<Result<List<SwapStation>>> all();
}
