import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';
import '../entities/allocation_board.dart';

class GetAllocationBoard extends UseCase<AllocationBoard, NoParams> {
  const GetAllocationBoard(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<AllocationBoard>> call(NoParams params) => _repository.getBoard();
}
