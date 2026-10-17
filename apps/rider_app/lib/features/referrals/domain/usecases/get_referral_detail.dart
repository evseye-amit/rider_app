import 'package:evseye_core/evseye_core.dart';

import '../entities/referral.dart';
import '../referral_repository.dart';

class GetReferralDetail extends UseCase<ReferralDetail, String> {
  const GetReferralDetail(this._repository);

  final ReferralRepository _repository;

  @override
  Future<Result<ReferralDetail>> call(String params) => _repository.detail(params);
}
