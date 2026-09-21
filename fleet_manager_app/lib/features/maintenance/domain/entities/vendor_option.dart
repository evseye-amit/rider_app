import 'package:equatable/equatable.dart';

class VendorOption extends Equatable {
  const VendorOption({
    required this.id,
    required this.name,
    required this.type,
    required this.rating,
  });

  final String id;
  final String name;
  final String type;
  final double rating;

  @override
  List<Object?> get props => [id, name, type, rating];
}
