import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/damaged_item.dart';

class DamagedItemsNotifier extends Notifier<List<DamagedItem>> {
  DamagedItemsNotifier(this.submissionId);

  final String submissionId;

  @override
  List<DamagedItem> build() => const [];

  void save(DamagedItem item) {
    final bool exists = state.any((entry) => entry.part.id == item.part.id);
    state = exists
        ? [for (final DamagedItem entry in state) entry.part.id == item.part.id ? item : entry]
        : [...state, item];
  }

  void remove(String partId) => state = [
    for (final DamagedItem entry in state)
      if (entry.part.id != partId) entry,
  ];

  void clear() => state = const [];
}

final damagedItemsProvider = NotifierProvider.family<DamagedItemsNotifier, List<DamagedItem>, String>(
  DamagedItemsNotifier.new,
);
