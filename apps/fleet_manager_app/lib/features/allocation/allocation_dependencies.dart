import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/allocation_repository_impl.dart';
import 'data/rider_verification_repository_impl.dart';
import 'domain/allocation_repository.dart';
import 'domain/rider_verification_repository.dart';
import 'domain/usecases/allocate_vehicle.dart';
import 'domain/usecases/ask_payment.dart';
import 'domain/usecases/evidence_photo_usecases.dart';
import 'domain/usecases/get_allocation_board.dart';
import 'domain/usecases/get_allocation_evidence.dart';
import 'domain/usecases/get_deployment_request.dart';
import 'domain/usecases/get_eligible_fleets.dart';
import 'domain/usecases/get_pending_rider.dart';
import 'domain/usecases/request_fleet.dart';
import 'domain/usecases/rider_verification_usecases.dart';
import 'domain/usecases/start_return.dart';
import 'domain/usecases/submit_pdi.dart';
import 'domain/usecases/verify_payment.dart';

final allocationRepositoryProvider = Provider<AllocationRepository>(
  (ref) => AllocationRepositoryImpl(
    ref.watch(apiClientProvider),
    ref.watch(deploymentApiProvider),
    ref.watch(mediaApiProvider),
    ref.watch(vehicleSubmissionApiProvider),
  ),
);

final riderVerificationRepositoryProvider = Provider<RiderVerificationRepository>(
  (ref) => RiderVerificationRepositoryImpl(ref.watch(apiClientProvider)),
);

final getVerificationRiderProvider = Provider<GetVerificationRider>(
  (ref) => GetVerificationRider(ref.watch(riderVerificationRepositoryProvider)),
);

final getRiderDocumentsProvider = Provider<GetRiderDocuments>(
  (ref) => GetRiderDocuments(ref.watch(riderVerificationRepositoryProvider)),
);

final reviewRiderDocumentProvider = Provider<ReviewRiderDocument>(
  (ref) => ReviewRiderDocument(ref.watch(riderVerificationRepositoryProvider)),
);

final getRiderReferencesProvider = Provider<GetRiderReferences>(
  (ref) => GetRiderReferences(ref.watch(riderVerificationRepositoryProvider)),
);

final reviewRiderReferenceProvider = Provider<ReviewRiderReference>(
  (ref) => ReviewRiderReference(ref.watch(riderVerificationRepositoryProvider)),
);

final uploadEvidencePhotoProvider = Provider<UploadEvidencePhoto>(
  (ref) => UploadEvidencePhoto(ref.watch(allocationRepositoryProvider)),
);

final getPhotoUrlProvider = Provider<GetPhotoUrl>((ref) => GetPhotoUrl(ref.watch(allocationRepositoryProvider)));

final getAllocationBoardProvider = Provider<GetAllocationBoard>(
  (ref) => GetAllocationBoard(ref.watch(allocationRepositoryProvider)),
);

final getPendingRiderProvider = Provider<GetPendingRider>(
  (ref) => GetPendingRider(ref.watch(allocationRepositoryProvider)),
);

final getEligibleFleetsProvider = Provider<GetEligibleFleets>(
  (ref) => GetEligibleFleets(ref.watch(allocationRepositoryProvider)),
);

final allocateVehicleProvider = Provider<AllocateVehicle>(
  (ref) => AllocateVehicle(ref.watch(allocationRepositoryProvider)),
);

final getDeploymentRequestProvider = Provider<GetDeploymentRequest>(
  (ref) => GetDeploymentRequest(ref.watch(allocationRepositoryProvider)),
);

final getAllocationEvidenceProvider = Provider<GetAllocationEvidence>(
  (ref) => GetAllocationEvidence(ref.watch(allocationRepositoryProvider)),
);

final requestFleetProvider = Provider<RequestFleet>((ref) => RequestFleet(ref.watch(allocationRepositoryProvider)));

final askPaymentProvider = Provider<AskPayment>((ref) => AskPayment(ref.watch(allocationRepositoryProvider)));

final verifyPaymentProvider = Provider<VerifyPayment>((ref) => VerifyPayment(ref.watch(allocationRepositoryProvider)));

final submitPdiProvider = Provider<SubmitPdi>((ref) => SubmitPdi(ref.watch(allocationRepositoryProvider)));

final startReturnProvider = Provider<StartReturn>((ref) => StartReturn(ref.watch(allocationRepositoryProvider)));
