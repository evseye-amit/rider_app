abstract final class Routes {
  static const String splash = '/';
  static const String company = '/company';
  static const String language = '/language';
  static const String login = '/login';
  static const String otp = '/otp';

  static const String home = '/home';
  static const String allocations = '/allocations';
  static const String submissions = '/submissions';
  static const String team = '/team';
  static const String maintenance = '/maintenance';

  static const String allocationDetail = '/allocations/detail';
  static const String riderVerification = '/allocations/verify';
  static const String assignVehicle = '/allocations/assign';
  static const String allocationDone = '/allocations/done';

  static const String submission = '/submissions/detail';
  static const String submissionReport = '/submissions/report';
  static const String submissionConfirm = '/submissions/confirm';

  static const String maintenanceDetail = '/maintenance/vehicle';

  static const String fleetSearch = '/search';
  static const String fleetSearchScooter = '/search/scooter';

  static const String support = '/support';
  static const String supportTicket = '/support/ticket';

  static const String notifications = '/notifications';

  const Routes._();
}
