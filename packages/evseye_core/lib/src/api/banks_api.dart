import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';

class IfscBankDetails {
  const IfscBankDetails({
    required this.ifsc,
    this.bankName,
    this.branch,
    this.address,
    this.city,
    this.district,
    this.state,
    this.micr,
  });

  factory IfscBankDetails.fromJson(Map<String, dynamic> json) => IfscBankDetails(
    ifsc: jsonText(json['ifsc']),
    bankName: jsonTextOrNull(json['bankName']),
    branch: jsonTextOrNull(json['branch']),
    address: jsonTextOrNull(json['address']),
    city: jsonTextOrNull(json['city']),
    district: jsonTextOrNull(json['district']),
    state: jsonTextOrNull(json['state']),
    micr: jsonTextOrNull(json['micr']),
  );

  final String ifsc;
  final String? bankName;
  final String? branch;
  final String? address;
  final String? city;
  final String? district;
  final String? state;
  final String? micr;
}

class BanksApi {
  const BanksApi(this._client);

  final ApiClient _client;

  Future<Result<IfscBankDetails>> lookupIfsc(String ifsc) => _client.get<IfscBankDetails>(
    '/banks/ifsc/${Uri.encodeComponent(ifsc.trim().toUpperCase())}',
    parse: (data) => IfscBankDetails.fromJson(jsonMap(data)),
  );
}
