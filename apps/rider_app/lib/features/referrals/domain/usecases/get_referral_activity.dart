import 'package:evseye_core/evseye_core.dart';

import '../entities/referral.dart';
import '../referral_repository.dart';

class GetReferralActivity extends UseCase<List<ReferralActivity>, NoParams> {
  const GetReferralActivity(this._repository);

  final ReferralRepository _repository;

  @override
  Future<Result<List<ReferralActivity>>> call(NoParams params) => _repository.activity();
}
