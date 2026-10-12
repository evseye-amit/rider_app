import 'package:equatable/equatable.dart';

class VehicleOption extends Equatable {
  const VehicleOption({required this.number, required this.model});

  final String number;
  final String model;

  @override
  List<Object?> get props => [number, model];
}
