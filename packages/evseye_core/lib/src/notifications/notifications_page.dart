import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/notifications_api.dart';
import '../l10n/l10n.dart';
import '../providers/async_value_extensions.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../utils/formatters.dart';
import '../utils/result.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/buttons.dart';
import '../widgets/empty_state.dart';
import '../widgets/feedback.dart';
import '../widgets/hero_band.dart';
import '../widgets/illustrations.dart';
import '../widgets/inputs.dart';
import '../widgets/load_more_tile.dart';
import '../widgets/modules.dart';
import '../widgets/pressable.dart';
import '../widgets/segmented_tabs.dart';
import '../widgets/status_chip.dart';
import 'notifications_inbox.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  int _filter = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(unreadNotificationsProvider);
    await ref.refresh(notificationsInboxProvider.future).then<void>((_) {}, onError: (_) {});
  }

  Future<void> _open(AppNotification item) async {
    unawaited(ref.read(notificationsInboxProvider.notifier).markRead(item));
    await AppSheet.show<void>(
      context,
      title: item.title,
      subtitle: Fmt.dateTime(item.createdAt),
      child: Text(item.body, style: AppText.bodyMedium.copyWith(height: 1.55)),
      footer: PrimaryButton(label: context.l10n.notificationsGotIt, onPressed: () => Navigator.of(context).pop()),
    );
  }

  Future<void> _markAllRead() async {
    final Result<void> result = await ref.read(notificationsInboxProvider.notifier).markAllRead();
    if (!mounted) return;
    if (result case Err<void>(:final failure)) AppSnack.error(context, failure.message);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<NotificationsInbox> inbox = ref.watch(notificationsInboxProvider);
    final NotificationsInbox? value = inbox.value;

    if (value == null) {
      return AppScaffold(
        title: context.l10n.notificationsNotifications,
        body: inbox.hasError
            ? EmptyState(
                title: context.l10n.notificationsCouldNotLoadNotifications,
                message: inbox.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(notificationsInboxProvider),
              )
            : const _NotificationsSkeleton(),
      );
    }

    final DateTime now = DateTime.now();
    final String query = _query.trim().toLowerCase();
    final List<AppNotification> visible = value.items
        .where((item) {
          final bool matchesFilter = _filter == 0 || !item.isRead;
          final bool matchesQuery =
              query.isEmpty || item.title.toLowerCase().contains(query) || item.body.toLowerCase().contains(query);
          return matchesFilter && matchesQuery;
        })
        .toList(growable: false);
    final List<AppNotification> today = visible.where((item) => _sameDay(item.createdAt, now)).toList();
    final List<AppNotification> earlier = visible.where((item) => !_sameDay(item.createdAt, now)).toList();

    return HeroScaffold(
      onRefresh: _refresh,
      band: _Band(
        total: value.items.length,
        unread: value.unread,
        onMarkAllRead: value.unread == 0 ? null : _markAllRead,
      ),
      children: value.items.isEmpty
          ? [
              ModuleCard(
                padding: const EdgeInsets.symmetric(vertical: Insets.x3l),
                child: Center(
                  child: ArtBlock(
                    art: BrandArt.empty,
                    title: context.l10n.notificationsAllClear,
                    message: context.l10n.notificationsEmptyMessage,
                  ),
                ),
              ),
            ]
          : [
              AppSearchField(
                hint: context.l10n.notificationsSearchNotifications,
                controller: _search,
                onChanged: (text) => setState(() => _query = text),
              ),
              const Gap.md(),
              FilterChipBar(
                items: [context.l10n.notificationsAll, context.l10n.notificationsUnread],
                selectedIndex: _filter,
                onChanged: (index) => setState(() => _filter = index),
                padding: EdgeInsets.zero,
              ),
              const Gap.lg(),
              if (visible.isEmpty)
                ModuleCard(
                  padding: const EdgeInsets.symmetric(vertical: Insets.xxl),
                  child: EmptyState(
                    compact: true,
                    title: context.l10n.notificationsNoMatchingNotifications,
                    icon: Icons.search_off_rounded,
                  ),
                ),
              if (today.isNotEmpty) ...[
                _Section(title: context.l10n.notificationsToday, items: today, onOpen: _open),
                const Gap.lg(),
              ],
              if (earlier.isNotEmpty) _Section(title: context.l10n.notificationsEarlier, items: earlier, onOpen: _open),
              if (value.hasMore) ...[
                const Gap.lg(),
                LoadMoreTile(onLoad: () => ref.read(notificationsInboxProvider.notifier).loadMore()),
              ],
            ],
    );
  }

  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}

class _Band extends StatelessWidget {
  const _Band({required this.total, required this.unread, required this.onMarkAllRead});

  final int total;
  final int unread;
  final VoidCallback? onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) =>
                  InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                context.l10n.notificationsNotifications,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.titleLarge.copyWith(fontSize: 17, color: AppColors.onInk),
              ),
            ),
            if (onMarkAllRead != null) InkCircleButton(icon: Icons.done_all_rounded, onTap: onMarkAllRead),
          ],
        ),
        const Gap.xl(),
        Text(
          unread == 0 ? context.l10n.notificationsAllCaughtUp : context.l10n.notificationsUnreadCount(unread),
          style: AppText.displaySmall.copyWith(fontSize: 26, color: AppColors.onInk),
        ),
        const SizedBox(height: 4),
        Text(
          unread == 0
              ? context.l10n.notificationsNothingNewNeedsAttention
              : context.l10n.notificationsInboxCount(total),
          style: AppText.bodySmall.copyWith(color: AppColors.onInkSecondary),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items, required this.onOpen});

  final String title;
  final List<AppNotification> items;
  final ValueChanged<AppNotification> onOpen;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: title,
      child: Column(
        children: [
          for (final AppNotification item in items) ...[
            _NotificationRow(item: item, onTap: () => onOpen(item)),
            if (item != items.last) const Gap.md(),
          ],
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item, required this.onTap});

  final AppNotification item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const Color tone = AppColors.primary;
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.all(Insets.md + 2),
        decoration: BoxDecoration(
          color: item.isRead ? AppColors.surfaceMuted : AppColors.washFor(tone),
          borderRadius: Corners.brLg,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTile(
              icon: item.isBroadcast ? Icons.campaign_rounded : Icons.notifications_active_rounded,
              tone: tone,
              size: 40,
              solid: !item.isRead,
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.titleSmall.copyWith(
                            fontSize: 13.5,
                            fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                          ),
                        ),
                      ),
                      if (!item.isRead) ...[
                        const SizedBox(width: Insets.sm),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: StatusChip(
                      label: Fmt.relative(item.createdAt),
                      tone: StatusTone.neutral,
                      dense: true,
                      showDot: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsSkeleton extends StatelessWidget {
  const _NotificationsSkeleton();

  @override
  Widget build(BuildContext context) {
    return PageBody(
      children: List.generate(
        5,
        (i) => Padding(
          padding: EdgeInsets.only(bottom: i == 4 ? 0 : Insets.md),
          child: const ShimmerBox(height: 78, borderRadius: Corners.brLg),
        ),
      ),
    );
  }
}
