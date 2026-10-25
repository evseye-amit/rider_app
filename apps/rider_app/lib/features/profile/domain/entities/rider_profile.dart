import 'package:equatable/equatable.dart';

class RiderAddress extends Equatable {
  const RiderAddress({this.address, this.city, this.state, this.postalCode});

  final String? address;
  final String? city;
  final String? state;
  final String? postalCode;

  List<String> get lines {
    final String area = [?city, ?state].join(', ');
    final String last = [if (area.isNotEmpty) area, ?postalCode].join(' ');
    return [?address, if (last.isNotEmpty) last];
  }

  bool get isEmpty => lines.isEmpty;

  @override
  List<Object?> get props => [address, city, state, postalCode];
}

class RiderProfile extends Equatable {
  const RiderProfile({
    this.name,
    this.mobile,
    this.photoUrl,
    this.riderCode,
    this.dateOfBirth,
    this.currentAddress = const RiderAddress(),
    this.permanentAddress = const RiderAddress(),
    this.sameAsCurrentAddress = false,
    this.emergencyContactName,
    this.emergencyContactMobile,
  });

  final String? name;
  final String? mobile;
  final String? photoUrl;
  final String? riderCode;
  final DateTime? dateOfBirth;
  final RiderAddress currentAddress;
  final RiderAddress permanentAddress;
  final bool sameAsCurrentAddress;
  final String? emergencyContactName;
  final String? emergencyContactMobile;

  String? get shortName => name?.split(RegExp(r'\s+')).first;

  bool get hasPersonalDetails => name != null || mobile != null || dateOfBirth != null;

  bool get showsPermanentAddress => sameAsCurrentAddress ? !currentAddress.isEmpty : !permanentAddress.isEmpty;

  bool get hasAddress => !currentAddress.isEmpty || showsPermanentAddress;

  bool get hasEmergencyContact => emergencyContactName != null || emergencyContactMobile != null;

  @override
  List<Object?> get props => [
    name,
    mobile,
    photoUrl,
    riderCode,
    dateOfBirth,
    currentAddress,
    permanentAddress,
    sameAsCurrentAddress,
    emergencyContactName,
    emergencyContactMobile,
  ];
}
