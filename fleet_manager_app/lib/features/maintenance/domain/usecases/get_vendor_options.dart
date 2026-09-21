import 'package:evseye_core/evseye_core.dart';

import '../entities/vendor_option.dart';
import '../maintenance_repository.dart';

class GetVendorOptions extends UseCase<List<VendorOption>, NoParams> {
  const GetVendorOptions(this._repository);

  final MaintenanceRepository _repository;

  @override
  Future<Result<List<VendorOption>>> call(NoParams params) => _repository.getVendorOptions();
}
