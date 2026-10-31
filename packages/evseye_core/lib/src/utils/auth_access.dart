import 'result.dart';

enum AuthAccessReason { inactiveClient, pendingApproval, suspendedClient, inactiveUser, unsupportedAppRole }

AuthAccessReason? authAccessReason(Failure failure) => switch (failure.serverCode) {
  'CLIENT_INACTIVE' => AuthAccessReason.inactiveClient,
  'CLIENT_PENDING_APPROVAL' => AuthAccessReason.pendingApproval,
  'CLIENT_SUSPENDED' => AuthAccessReason.suspendedClient,
  'USER_INACTIVE' => AuthAccessReason.inactiveUser,
  'UNSUPPORTED_APP_ROLE' => AuthAccessReason.unsupportedAppRole,
  _ => null,
};
