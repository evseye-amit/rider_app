import 'package:evseye_core/evseye_core.dart';

import '../entities/referral_invite.dart';
import '../referral_repository.dart';

class CreateReferralInvite extends UseCase<ReferralInvite, NoParams> {
  const CreateReferralInvite(this._repository);

  final ReferralRepository _repository;

  @override
  Future<Result<ReferralInvite>> call(NoParams params) => _repository.invite();
}
