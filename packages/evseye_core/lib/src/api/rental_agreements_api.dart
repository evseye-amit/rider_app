import '../utils/result.dart';
import 'api_client.dart';

class RentalAgreementDto {
  const RentalAgreementDto({
    required this.id,
    required this.agreementNumber,
    required this.status,
    required this.recurringAmount,
    this.rentalPeriodType,
    this.currentVehicleId,
    this.vehicleModel,
    this.vehicleVariant,
    this.startDate,
  });

  factory RentalAgreementDto.fromJson(Map<String, dynamic> json) {
    final Object? vehicle = json['vehicle'];
    final String start = json['startDate']?.toString() ?? '';
    return RentalAgreementDto(
      id: json['id']?.toString() ?? '',
      agreementNumber: json['agreementNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      recurringAmount: num.tryParse(json['recurringAmount']?.toString() ?? '') ?? 0,
      rentalPeriodType: json['rentalPeriodType']?.toString(),
      currentVehicleId: json['currentVehicleId']?.toString(),
      vehicleModel: vehicle is Map ? vehicle['modelName']?.toString() : null,
      vehicleVariant: vehicle is Map ? vehicle['variantName']?.toString() : null,
      startDate: start.length < 10 ? null : DateTime.tryParse(start.substring(0, 10)),
    );
  }

  final String id;
  final String agreementNumber;
  final String status;
  final num recurringAmount;
  final String? rentalPeriodType;
  final String? currentVehicleId;
  final String? vehicleModel;
  final String? vehicleVariant;
  final DateTime? startDate;

  bool get isActive => status == 'ACTIVE';
}

class RentalAgreementsApi {
  const RentalAgreementsApi(this._client);

  final ApiClient _client;

  Future<Result<List<RentalAgreementDto>>> list() => _client.get<List<RentalAgreementDto>>(
    '/rider-app/rental-agreements',
    parse: (data) => [
      for (final Object? item in data as List<dynamic>? ?? const [])
        if (item is Map) RentalAgreementDto.fromJson(Map<String, dynamic>.from(item)),
    ],
  );
}
