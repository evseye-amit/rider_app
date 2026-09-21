import 'package:evseye_core/evseye_core.dart';

import '../entities/maintenance_board.dart';
import '../maintenance_repository.dart';

class GetMaintenanceBoard extends UseCase<MaintenanceBoard, NoParams> {
  const GetMaintenanceBoard(this._repository);

  final MaintenanceRepository _repository;

  @override
  Future<Result<MaintenanceBoard>> call(NoParams params) => _repository.getBoard();
}
