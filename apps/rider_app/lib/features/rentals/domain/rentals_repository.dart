import 'package:evseye_core/evseye_core.dart';

import 'entities/rental.dart';

abstract interface class RentalsRepository {
  Future<Result<RentalsOverview>> getRentals();
}
