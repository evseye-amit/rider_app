import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/rider_profile.dart';
import '../domain/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._api);

  final RiderAppApi _api;

  @override
  Future<Result<RiderProfile>> getProfile() async => (await _api.profile()).map(_profile);

  RiderProfile _profile(RiderProfileDto dto) => RiderProfile(
    name: dto.name,
    mobile: dto.mobile,
    photoUrl: dto.photoUrl,
    riderCode: dto.riderCode,
    dateOfBirth: dto.dateOfBirth,
    currentAddress: _address(dto.currentAddress),
    permanentAddress: _address(dto.permanentAddress),
    sameAsCurrentAddress: dto.sameAsCurrentAddress,
    emergencyContactName: dto.emergencyContactName,
    emergencyContactMobile: dto.emergencyContactMobile,
  );

  RiderAddress _address(RiderAddressDto dto) {
    final String lines = [?dto.addressLine1, ?dto.addressLine2].join(', ');
    return RiderAddress(
      address: dto.address ?? (lines.isEmpty ? null : lines),
      city: dto.city,
      state: dto.state,
      postalCode: dto.postalCode,
    );
  }
}
