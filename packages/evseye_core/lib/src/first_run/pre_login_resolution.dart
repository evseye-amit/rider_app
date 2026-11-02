import '../utils/result.dart';
import '../api/pre_login_error_codes.g.dart';

enum PreLoginResolutionStatus { idle, resolving, resolved, offline, failed }

class PreLoginResolutionState {
  const PreLoginResolutionState({this.status = PreLoginResolutionStatus.idle, this.failure, this.serverCode});

  final PreLoginResolutionStatus status;
  final Failure? failure;
  final String? serverCode;

  bool get canRetry => status == PreLoginResolutionStatus.offline || status == PreLoginResolutionStatus.failed;

  PreLoginResolutionState resolving() => const PreLoginResolutionState(status: PreLoginResolutionStatus.resolving);
  PreLoginResolutionState success() => const PreLoginResolutionState(status: PreLoginResolutionStatus.resolved);
  PreLoginResolutionState error(Failure value) => PreLoginResolutionState(
        status: value is NetworkFailure ? PreLoginResolutionStatus.offline : PreLoginResolutionStatus.failed,
        failure: value,
        serverCode: value.serverCode != null && preLoginErrorCodes.contains(value.serverCode) ? value.serverCode : null,
      );
}
