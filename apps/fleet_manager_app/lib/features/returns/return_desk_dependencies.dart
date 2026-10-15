import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/session/fleet_session_provider.dart';
import 'data/return_desk_repository_impl.dart';
import 'domain/return_desk_repository.dart';
import 'domain/usecases/return_desk_usecases.dart';

final returnDeskRepositoryProvider = Provider<ReturnDeskRepository>((ref) {
  ref.watch(fleetSessionProvider.select((session) => session.user?.id));
  return ReturnDeskRepositoryImpl(
    ref.watch(returnDeskApiProvider),
    ref.watch(mediaApiProvider),
    ref.watch(apiClientProvider),
  );
});

final getReturnCasesProvider = Provider<GetReturnCases>(
  (ref) => GetReturnCases(ref.watch(returnDeskRepositoryProvider)),
);

final getReturnCaseProvider = Provider<GetReturnCase>((ref) => GetReturnCase(ref.watch(returnDeskRepositoryProvider)));

final receiveReturnProvider = Provider<ReceiveReturn>((ref) => ReceiveReturn(ref.watch(returnDeskRepositoryProvider)));

final getInspectionSheetProvider = Provider<GetInspectionSheet>(
  (ref) => GetInspectionSheet(ref.watch(returnDeskRepositoryProvider)),
);

final uploadInspectionPhotoProvider = Provider<UploadInspectionPhoto>(
  (ref) => UploadInspectionPhoto(ref.watch(returnDeskRepositoryProvider)),
);

final completeReturnInspectionProvider = Provider<CompleteReturnInspection>(
  (ref) => CompleteReturnInspection(ref.watch(returnDeskRepositoryProvider)),
);

final getPenaltyPricesProvider = Provider<GetPenaltyPrices>(
  (ref) => GetPenaltyPrices(ref.watch(returnDeskRepositoryProvider)),
);

final saveReturnChargesProvider = Provider<SaveReturnCharges>(
  (ref) => SaveReturnCharges(ref.watch(returnDeskRepositoryProvider)),
);

final submitReturnChargesProvider = Provider<SubmitReturnCharges>(
  (ref) => SubmitReturnCharges(ref.watch(returnDeskRepositoryProvider)),
);

final approveReturnChargesProvider = Provider<ApproveReturnCharges>(
  (ref) => ApproveReturnCharges(ref.watch(returnDeskRepositoryProvider)),
);

final overrideRiderApprovalProvider = Provider<OverrideRiderApproval>(
  (ref) => OverrideRiderApproval(ref.watch(returnDeskRepositoryProvider)),
);
