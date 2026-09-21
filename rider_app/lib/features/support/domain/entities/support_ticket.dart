import 'package:equatable/equatable.dart';

enum TicketStatus { open, resolved }

class SupportTicket extends Equatable {
  const SupportTicket({
    required this.id,
    required this.categoryKey,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.messageCount,
    this.repairCost = 0,
    this.costBorneByRider = false,
  });

  final String id;
  final String categoryKey;
  final String title;
  final TicketStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int messageCount;
  final num repairCost;
  final bool costBorneByRider;

  SupportTicket copyWith({
    TicketStatus? status,
    DateTime? updatedAt,
    int? messageCount,
  }) => SupportTicket(
    id: id,
    categoryKey: categoryKey,
    title: title,
    status: status ?? this.status,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    messageCount: messageCount ?? this.messageCount,
    repairCost: repairCost,
    costBorneByRider: costBorneByRider,
  );

  @override
  List<Object?> get props => [
    id,
    categoryKey,
    title,
    status,
    createdAt,
    updatedAt,
    messageCount,
    repairCost,
    costBorneByRider,
  ];
}
