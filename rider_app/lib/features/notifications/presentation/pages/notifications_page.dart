import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

class _NotificationItem {
  _NotificationItem({
    required this.id,
    required this.tone,
    required this.icon,
    required this.title,
    required this.message,
    required this.at,
    required this.read,
  });

  final String id;
  final String tone;
  final String icon;
  final String title;
  final String message;
  final DateTime at;
  bool read;
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<_NotificationItem>? _items;
  String? _error;

  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  int _filterIndex = 0;
  static const List<String> _filters = ['All', 'Unread'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _items = const []);
  }

  void _dismiss(_NotificationItem item) {
    setState(() => _items?.removeWhere((n) => n.id == item.id));
  }

  void _markAllRead() {
    setState(() {
      for (final item in _items ?? const <_NotificationItem>[]) {
        item.read = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return AppScaffold(
        title: 'Notifications',
        body: EmptyState(
          title: 'Could not load notifications',
          message: _error,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: 'Try again',
          onAction: () {
            setState(() => _error = null);
            _load();
          },
        ),
      );
    }
    if (_items == null) {
      return const AppScaffold(
        title: 'Notifications',
        body: _NotificationsSkeleton(),
      );
    }

    final int unread = _items!.where((n) => !n.read).length;
    final DateTime now = DateTime.now();

    final String query = _query.trim().toLowerCase();
    final List<_NotificationItem> visible = _items!.where((n) {
      final bool matchesFilter = _filterIndex == 0 || !n.read;
      final bool matchesQuery = query.isEmpty ||
          n.title.toLowerCase().contains(query) ||
          n.message.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();
    final List<_NotificationItem> today =
        visible.where((n) => _isSameDay(n.at, now)).toList();
    final List<_NotificationItem> earlier =
        visible.where((n) => !_isSameDay(n.at, now)).toList();

    return HeroScaffold(
      band: _Band(
        total: _items!.length,
        unread: unread,
        onMarkAllRead: unread == 0 ? null : _markAllRead,
      ),
      children: _items!.isEmpty
          ? [
              ModuleCard(
                padding: const EdgeInsets.symmetric(vertical: Insets.x3l),
                child: const Center(
                  child: ArtBlock(
                    art: BrandArt.empty,
                    title: 'All clear',
                    message:
                        'New earnings, reminders and alerts will show up here.',
                  ),
                ),
              ),
            ]
          : [
              AppSearchField(
                hint: 'Search notifications',
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
              ),
              const Gap.md(),
              FilterChipBar(
                items: _filters,
                selectedIndex: _filterIndex,
                onChanged: (i) => setState(() => _filterIndex = i),
                padding: EdgeInsets.zero,
              ),
              const Gap.lg(),
              if (visible.isEmpty)
                const ModuleCard(
                  padding: EdgeInsets.symmetric(vertical: Insets.xxl),
                  child: EmptyState(
                    compact: true,
                    title: 'No matching notifications',
                    icon: Icons.search_off_rounded,
                  ),
                ),
              if (today.isNotEmpty) ...[
                ModuleCard(
                  title: 'Today',
                  child: Column(
                    children: [
                      for (final item in today) ...[
                        _NotificationRow(
                          item: item,
                          onDismiss: () => _dismiss(item),
                        ),
                        if (item != today.last) const Gap.md(),
                      ],
                    ],
                  ),
                ),
                const Gap.lg(),
              ],
              if (earlier.isNotEmpty)
                ModuleCard(
                  title: 'Earlier',
                  child: Column(
                    children: [
                      for (final item in earlier) ...[
                        _NotificationRow(
                          item: item,
                          onDismiss: () => _dismiss(item),
                        ),
                        if (item != earlier.last) const Gap.md(),
                      ],
                    ],
                  ),
                ),
            ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _Band extends StatelessWidget {
  const _Band({
    required this.total,
    required this.unread,
    required this.onMarkAllRead,
  });

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
              builder: (context) => InkCircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                'Notifications',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.titleLarge.copyWith(
                  fontSize: 17,
                  color: AppColors.onInk,
                ),
              ),
            ),
            if (onMarkAllRead != null)
              InkCircleButton(
                icon: Icons.done_all_rounded,
                onTap: onMarkAllRead,
              ),
          ],
        ),
        const Gap.xl(),

        Text(
          unread == 0 ? 'You are all caught up' : '$unread unread',
          style: AppText.displaySmall.copyWith(
            fontSize: 26,
            color: AppColors.onInk,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          unread == 0
              ? 'Nothing new needs your attention'
              : '$total notifications in your inbox',
          style: AppText.bodySmall.copyWith(color: AppColors.onInkSecondary),
        ),
      ],
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item, required this.onDismiss});

  final _NotificationItem item;
  final VoidCallback onDismiss;

  static Color _solidTone(Color tone) => switch (tone) {
        AppColors.warning => AppColors.amber,
        AppColors.danger => AppColors.coral,
        AppColors.success => AppColors.mint,
        _ => tone,
      };

  @override
  Widget build(BuildContext context) {
    final Color tone = NodeTokens.color(item.tone, fallback: AppColors.primary);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        decoration: BoxDecoration(
          color: AppColors.dangerWash,
          borderRadius: Corners.brLg,
          border: Border.all(color: AppColors.danger.withValues(alpha: 0.28)),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.danger,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(Insets.md + 2),
        decoration: BoxDecoration(
          color: item.read ? AppColors.surfaceMuted : AppColors.washFor(tone),
          borderRadius: Corners.brLg,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTile(
              icon: NodeTokens.icon(item.icon),
              tone: item.read ? tone : _solidTone(tone),
              size: 40,
              solid: !item.read,
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
                            fontWeight: item.read
                                ? FontWeight.w600
                                : FontWeight.w800,
                          ),
                        ),
                      ),
                      if (!item.read) ...[
                        const SizedBox(width: Insets.sm),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.cyan,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: StatusChip(
                      label: Fmt.relative(item.at),
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
