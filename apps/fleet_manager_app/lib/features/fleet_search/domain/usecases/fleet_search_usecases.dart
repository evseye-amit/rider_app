import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../fleet_search_repository.dart';

class ScooterSearchQuery extends Equatable {
  const ScooterSearchQuery({required this.text, this.page = 1});

  final String text;
  final int page;

  @override
  List<Object?> get props => [text, page];
}

class SearchScooters extends UseCase<GlobalFleetPage, ScooterSearchQuery> {
  const SearchScooters(this._repository);

  final FleetSearchRepository _repository;

  @override
  Future<Result<GlobalFleetPage>> call(ScooterSearchQuery query) => _repository.search(query);
}

class GetScooter extends UseCase<GlobalFleetDetailDto, String> {
  const GetScooter(this._repository);

  final FleetSearchRepository _repository;

  @override
  Future<Result<GlobalFleetDetailDto>> call(String fleetId) => _repository.scooter(fleetId);
}

class GetScooterRiders extends UseCase<List<GlobalFleetRiderDto>, String> {
  const GetScooterRiders(this._repository);

  final FleetSearchRepository _repository;

  @override
  Future<Result<List<GlobalFleetRiderDto>>> call(String fleetId) => _repository.riders(fleetId);
}
