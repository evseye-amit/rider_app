import 'package:evseye_core/evseye_core.dart';

import '../entities/rental.dart';
import '../rentals_repository.dart';

class GetRentalsOverview extends UseCase<RentalsOverview, NoParams> {
  const GetRentalsOverview(this._repository);

  final RentalsRepository _repository;

  @override
  Future<Result<RentalsOverview>> call(NoParams params) =>
      _repository.getRentals();
}
