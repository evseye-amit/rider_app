import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/allocation_repository_impl.dart';
import 'domain/allocation_repository.dart';
import 'domain/usecases/allocate_vehicle.dart';
import 'domain/usecases/ask_payment.dart';
import 'domain/usecases/bypass_pairing.dart';
import 'domain/usecases/complete_deallocation.dart';
import 'domain/usecases/complete_inspection.dart';
import 'domain/usecases/get_allocation_board.dart';
import 'domain/usecases/get_allocation_evidence.dart';
import 'domain/usecases/get_deallocation_request.dart';
import 'domain/usecases/get_deployment_request.dart';
import 'domain/usecases/get_eligible_fleets.dart';
import 'domain/usecases/get_iot_health.dart';
import 'domain/usecases/get_pending_rider.dart';
import 'domain/usecases/initiate_deallocation.dart';
import 'domain/usecases/request_deallocation_otp.dart';
import 'domain/usecases/request_fleet.dart';
import 'domain/usecases/submit_pdi.dart';
import 'domain/usecases/verify_deallocation_otp.dart';
import 'domain/usecases/verify_payment.dart';

final allocationRepositoryProvider = Provider<AllocationRepository>(
  (ref) => AllocationRepositoryImpl(ref.watch(apiClientProvider), ref.watch(deploymentApiProvider)),
);

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

final getIotHealthProvider = Provider<GetIotHealth>((ref) => GetIotHealth(ref.watch(allocationRepositoryProvider)));

final requestFleetProvider = Provider<RequestFleet>((ref) => RequestFleet(ref.watch(allocationRepositoryProvider)));

final askPaymentProvider = Provider<AskPayment>((ref) => AskPayment(ref.watch(allocationRepositoryProvider)));

final verifyPaymentProvider = Provider<VerifyPayment>((ref) => VerifyPayment(ref.watch(allocationRepositoryProvider)));

final submitPdiProvider = Provider<SubmitPdi>((ref) => SubmitPdi(ref.watch(allocationRepositoryProvider)));

final bypassPairingProvider = Provider<BypassPairing>((ref) => BypassPairing(ref.watch(allocationRepositoryProvider)));

final getDeallocationRequestProvider = Provider<GetDeallocationRequest>(
  (ref) => GetDeallocationRequest(ref.watch(allocationRepositoryProvider)),
);

final initiateDeallocationProvider = Provider<InitiateDeallocation>(
  (ref) => InitiateDeallocation(ref.watch(allocationRepositoryProvider)),
);

final requestDeallocationOtpProvider = Provider<RequestDeallocationOtp>(
  (ref) => RequestDeallocationOtp(ref.watch(allocationRepositoryProvider)),
);

final verifyDeallocationOtpProvider = Provider<VerifyDeallocationOtp>(
  (ref) => VerifyDeallocationOtp(ref.watch(allocationRepositoryProvider)),
);

final completeInspectionProvider = Provider<CompleteInspection>(
  (ref) => CompleteInspection(ref.watch(allocationRepositoryProvider)),
);

final completeDeallocationProvider = Provider<CompleteDeallocation>(
  (ref) => CompleteDeallocation(ref.watch(allocationRepositoryProvider)),
);
