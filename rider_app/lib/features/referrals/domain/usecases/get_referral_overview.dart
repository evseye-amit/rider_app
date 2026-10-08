import 'package:evseye_core/evseye_core.dart';

import '../entities/referral_overview.dart';
import '../referral_repository.dart';

class GetReferralOverview extends UseCase<ReferralOverview, NoParams> {
  const GetReferralOverview(this._repository);

  final ReferralRepository _repository;

  @override
  Future<Result<ReferralOverview>> call(NoParams params) => _repository.overview();
}
