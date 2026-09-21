import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/maintenance_board.dart';
import '../domain/entities/maintenance_job.dart';
import '../domain/entities/maintenance_summary.dart';
import '../domain/entities/raise_job_input.dart';
import '../domain/entities/vehicle_option.dart';
import '../domain/entities/vendor_option.dart';
import '../domain/maintenance_repository.dart';

class MaintenanceRepositoryImpl implements MaintenanceRepository {
  const MaintenanceRepositoryImpl(this._api);

  final ApiClient _api;

  static const int _maxPageSize = 100;

  @override
  Future<Result<MaintenanceBoard>> getBoard() async {
    final List<MaintenanceJob> jobs = _jobs();
    return Result.ok(
      MaintenanceBoard(
        summary: MaintenanceSummary(
          open: jobs.where((j) => j.status == 'open').length,
          overdue: jobs.where((j) => j.status == 'overdue').length,
          inProgress: jobs.where((j) => j.status == 'inProgress').length,
          closedThisWeek: jobs.where((j) => j.status == 'closed').length,
          averageCloseHours: 19,
        ),
        jobs: jobs,
      ),
    );
  }

  @override
  Future<Result<MaintenanceJob>> getJob(String id) async {
    for (final job in _jobs()) {
      if (job.id == id) return Result.ok(job);
    }
    return const Result.err(NotFoundFailure('That job is no longer on the board.'));
  }

  static List<MaintenanceJob> _jobs() {
    final DateTime now = DateTime.now();
    DateTime days(int n) => now.add(Duration(days: n));

    return [
      MaintenanceJob(
        id: 'JOB-2318',
        vehicleNumber: 'DL1SCA4471',
        model: 'Ather 450X Gen 3',
        type: 'Brakes',
        priority: 'high',
        status: 'overdue',
        openedOn: days(-4),
        dueOn: days(-1),
        odometerKm: 9120,
        issue: 'Rear brake bites late and squeals under load.',
        assignedTo: 'Sharma Auto Works',
        rider: 'Neha Bansal',
        bay: 'Bay 3',
        notes: const ['Pads measured at 1.2 mm', 'Replacement set ordered'],
      ),
      MaintenanceJob(
        id: 'JOB-2325',
        vehicleNumber: 'DL1SCB2290',
        model: 'Ather 450X Gen 3',
        type: 'Battery',
        priority: 'high',
        status: 'inProgress',
        openedOn: days(-1),
        dueOn: days(1),
        odometerKm: 7460,
        issue: 'Charge holds to 62% then drops to 40% within a kilometre.',
        assignedTo: 'Sharma Auto Works',
        rider: 'Farhan Sheikh',
        bay: 'Bay 1',
        notes: const ['Cell balance test booked for this afternoon'],
      ),
      MaintenanceJob(
        id: 'JOB-2331',
        vehicleNumber: 'DL1SCE5521',
        model: 'Ather 450X Gen 3',
        type: 'Tyres',
        priority: 'normal',
        status: 'open',
        openedOn: days(-1),
        dueOn: days(3),
        odometerKm: 11380,
        issue: 'Front tyre worn past the wear bar.',
        rider: 'Anjali Desai',
        notes: const [],
      ),
      MaintenanceJob(
        id: 'JOB-2333',
        vehicleNumber: 'DL1SCA4390',
        model: 'Ather 450X Gen 3',
        type: 'IoT',
        priority: 'normal',
        status: 'open',
        openedOn: now,
        dueOn: days(2),
        odometerKm: 5210,
        issue: 'Tracker drops off between Okhla and Jasola.',
        rider: 'Vikas Rana',
        notes: const [],
      ),
      MaintenanceJob(
        id: 'JOB-2309',
        vehicleNumber: 'DL1SCD9015',
        model: 'Ather 450X Gen 3',
        type: 'Body',
        priority: 'low',
        status: 'closed',
        openedOn: days(-6),
        dueOn: days(-3),
        closedOn: days(-3),
        odometerKm: 6890,
        issue: 'Scuffed side panel after a parking knock.',
        assignedTo: 'Gurgaon Motor Care',
        bay: 'Bay 2',
        notes: const ['Panel resprayed and refitted'],
      ),
    ];
  }

  @override
  Future<Result<List<VehicleOption>>> getVehicleOptions() {
    return _api.get<List<VehicleOption>>(
      '/fleets',
      query: {'pageSize': _maxPageSize},
      parse: (data) {
        final List<dynamic> rows = data is Map
            ? (data['items'] as List<dynamic>? ?? const [])
            : data as List<dynamic>;
        return rows.map((e) {
          final Map<String, dynamic> row = Map<String, dynamic>.from(e as Map);
          return VehicleOption(
            number: row['vehicleNumber']?.toString() ?? '—',
            model: row['modelName']?.toString() ?? '',
          );
        }).toList(growable: false);
      },
    );
  }

  @override
  Future<Result<List<VendorOption>>> getVendorOptions() async => const Result.ok(<VendorOption>[
        VendorOption(id: 'vendor_sharma', name: 'Sharma Auto Works', type: 'Two-wheeler workshop', rating: 4.6),
        VendorOption(id: 'vendor_gurgaon', name: 'Gurgaon Motor Care', type: 'Body and paint', rating: 4.3),
        VendorOption(id: 'vendor_voltcare', name: 'VoltCare EV Service', type: 'Battery specialist', rating: 4.8),
      ]);

  @override
  Future<Result<String>> raiseJob(RaiseJobInput input) async => const Result.err(
        ServerFailure('Raising a maintenance job needs an API that does not exist yet.'),
      );
}
