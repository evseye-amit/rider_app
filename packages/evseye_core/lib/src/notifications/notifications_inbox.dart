import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/notifications_api.dart';
import '../providers/core_providers.dart';
import '../utils/result.dart';

class NotificationsInbox {
  const NotificationsInbox({required this.items, this.nextCursor});

  final List<AppNotification> items;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  int get unread => items.where((item) => !item.isRead).length;
}

class NotificationsInboxNotifier extends AsyncNotifier<NotificationsInbox> {
  NotificationsApi get _api => ref.read(notificationsApiProvider);

  @override
  Future<NotificationsInbox> build() async {
    final NotificationPage page = (await ref.watch(notificationsApiProvider).inbox()).getOrThrow();
    return NotificationsInbox(items: page.items, nextCursor: page.nextCursor);
  }

  Future<bool> loadMore() async {
    final NotificationsInbox? current = state.value;
    if (current == null || !current.hasMore) return false;
    final Result<NotificationPage> next = await _api.inbox(cursor: current.nextCursor);
    if (!ref.mounted) return false;
    switch (next) {
      case Ok<NotificationPage>(:final value):
        state = AsyncData(NotificationsInbox(items: [...current.items, ...value.items], nextCursor: value.nextCursor));
        return true;
      case Err<NotificationPage>():
        return false;
    }
  }

  Future<void> markRead(AppNotification notification) async {
    if (notification.isRead) return;
    _update((item) => item.id == notification.id ? item.markedRead() : item);
    await _api.markRead(notification.id);
    if (ref.mounted) ref.invalidate(unreadNotificationsProvider);
  }

  Future<Result<void>> markAllRead() async {
    final Result<void> result = await _api.markAllRead();
    if (!ref.mounted) return result;
    if (result.isOk) _update((item) => item.markedRead());
    ref.invalidate(unreadNotificationsProvider);
    return result;
  }

  void _update(AppNotification Function(AppNotification item) change) {
    final NotificationsInbox? current = state.value;
    if (current == null) return;
    state = AsyncData(
      NotificationsInbox(items: current.items.map(change).toList(growable: false), nextCursor: current.nextCursor),
    );
  }
}

final notificationsInboxProvider = AsyncNotifierProvider.autoDispose<NotificationsInboxNotifier, NotificationsInbox>(
  NotificationsInboxNotifier.new,
);

final unreadNotificationsProvider = FutureProvider.autoDispose<int>(
  (ref) async => (await ref.watch(notificationsApiProvider).unreadCount()).valueOrNull ?? 0,
);
