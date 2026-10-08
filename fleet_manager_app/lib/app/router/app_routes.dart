abstract final class Routes {
  static const String splash = '/';
  static const String terms = '/terms';
  static const String language = '/language';
  static const String login = '/login';
  static const String otp = '/otp';

  static const String home = '/home';
  static const String allocations = '/allocations';
  static const String deallocations = '/deallocations';
  static const String team = '/team';
  static const String maintenance = '/maintenance';

  static const String allocationDetail = '/allocations/detail';
  static const String assignVehicle = '/allocations/assign';
  static const String allocationDone = '/allocations/done';

  static const String deallocationDetail = '/deallocations/detail';
  static const String deallocationFlow = '/deallocations/process';

  static const String maintenanceDetail = '/maintenance/job';
  static const String raiseMaintenance = '/maintenance/raise';

  static const String exchanges = '/exchanges';
  static const String exchangeDetail = '/exchanges/detail';
  static const String exchangeReplacement = '/exchanges/replacement';

  const Routes._();
}
