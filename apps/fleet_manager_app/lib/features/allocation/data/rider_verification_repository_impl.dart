import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/rider_verification.dart';
import '../domain/rider_verification_repository.dart';

class RiderVerificationRepositoryImpl implements RiderVerificationRepository {
  const RiderVerificationRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<Result<VerificationRider>> rider(String riderId) => _api.get<VerificationRider>(
    '/riders/$riderId',
    parse: (data) {
      final Map<String, dynamic> json = Map<String, dynamic>.from(data as Map);
      return VerificationRider(
        id: json['id']?.toString() ?? riderId,
        name: json['name']?.toString() ?? '',
        mobile: json['mobile']?.toString() ?? '',
        riderCode: json['riderCode']?.toString(),
        userId: json['userId']?.toString(),
      );
    },
  );

  @override
  Future<Result<List<RiderDocument>>> documents(VerificationRider rider) => _api.get<List<RiderDocument>>(
    '/rider-documents',
    query: {'search': _lastTenDigits(rider.mobile)},
    parse: (data) => [
      for (final Map<String, dynamic> row in _rows(data))
        if (_belongsTo(row, rider)) _document(row),
    ],
  );

  @override
  Future<Result<void>> reviewDocument(String documentId, {required bool approve, String? reason}) => _api.post<void>(
    '/rider-documents/$documentId/${approve ? 'approve' : 'reject'}',
    body: approve ? null : {'rejectionReason': reason ?? ''},
    parse: (_) {},
  );

  @override
  Future<Result<List<RiderReference>>> references(String riderId) => _api.get<List<RiderReference>>(
    '/riders/$riderId/references',
    parse: (data) => [for (final Map<String, dynamic> row in _rows(data)) _reference(row)],
  );

  @override
  Future<Result<void>> reviewReference(String referenceId, {required bool approve, String? reason}) => _api.post<void>(
    '/rider-references/$referenceId/${approve ? 'approve' : 'reject'}',
    body: approve ? null : {'rejectionReason': reason ?? ''},
    parse: (_) {},
  );

  static List<Map<String, dynamic>> _rows(dynamic data) =>
      (data as List<dynamic>? ?? const []).whereType<Map>().map(Map<String, dynamic>.from).toList(growable: false);

  static bool _belongsTo(Map<String, dynamic> row, VerificationRider rider) {
    final Object? owner = row['rider'];
    if (owner is Map && owner['id']?.toString() == rider.id) return true;
    final Object? user = row['user'];
    return user is Map && rider.userId != null && user['id']?.toString() == rider.userId;
  }

  static RiderDocument _document(Map<String, dynamic> row) {
    final Map<String, dynamic> feature = Map<String, dynamic>.from(row['feature'] as Map? ?? const {});
    final Map<String, dynamic> photo = Map<String, dynamic>.from(row['photo'] as Map? ?? const {});
    final String fieldLabel = _humanize(row['fieldCode']?.toString() ?? '');
    final String featureName = feature['name']?.toString().trim() ?? '';
    return RiderDocument(
      id: row['id']?.toString() ?? '',
      title: featureName.isEmpty ? fieldLabel : featureName,
      fieldLabel: fieldLabel,
      status: ReviewStatus.parse(row['status']),
      rejectionReason: row['rejectionReason']?.toString(),
      photoId: photo['id']?.toString(),
      mimeType: photo['mimeType']?.toString(),
      uploadedAt: DateTime.tryParse(photo['uploadedAt']?.toString() ?? '')?.toLocal(),
    );
  }

  static RiderReference _reference(Map<String, dynamic> row) {
    final Object? reviewer = row['reviewedBy'];
    return RiderReference(
      id: row['id']?.toString() ?? '',
      name: row['name']?.toString() ?? '',
      mobile: row['mobile']?.toString() ?? '',
      relation: row['relation']?.toString() ?? '',
      status: ReviewStatus.parse(row['status']),
      rejectionReason: row['rejectionReason']?.toString(),
      reviewedBy: reviewer is Map ? reviewer['name']?.toString() : null,
    );
  }

  static String _humanize(String code) {
    final String spaced = code.replaceAll('_', ' ').trim().toLowerCase();
    return spaced.isEmpty ? code : '${spaced[0].toUpperCase()}${spaced.substring(1)}';
  }

  static String _lastTenDigits(String mobile) {
    final String digits = mobile.replaceAll(RegExp(r'\D'), '');
    return digits.length > 10 ? digits.substring(digits.length - 10) : digits;
  }
}
