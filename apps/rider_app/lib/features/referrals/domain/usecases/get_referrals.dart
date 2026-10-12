import 'package:evseye_core/evseye_core.dart';

import '../entities/referral.dart';
import '../referral_repository.dart';

class GetReferrals extends UseCase<List<Referral>, NoParams> {
  const GetReferrals(this._repository);

  final ReferralRepository _repository;

  @override
  Future<Result<List<Referral>>> call(NoParams params) => _repository.referrals();
}
