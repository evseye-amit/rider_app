import 'package:evseye_core/evseye_core.dart';

import 'entities/home_summary.dart';

abstract interface class HomeRepository {
  Future<Result<HomeSummary>> getSummary();
}
