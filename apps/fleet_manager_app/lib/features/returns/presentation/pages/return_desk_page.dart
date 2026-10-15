import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/fleet_session_provider.dart';
import '../../domain/entities/return_case.dart';
import '../providers/return_desk_providers.dart';
import '../widgets/return_desk_widgets.dart';

class ReturnDeskPage extends ConsumerStatefulWidget {
  const ReturnDeskPage({super.key});

  @override
  ConsumerState<ReturnDeskPage> createState() => _ReturnDeskPageState();
}

class _ReturnDeskPageState extends ConsumerState<ReturnDeskPage> {
  static const List<ReturnState?> _filters = [null, ReturnState.requested, ReturnState.returned, ReturnState.cancelled];

  int _tab = 0;

  ReturnState? get _state => _filters[_tab];

  Future<void> _open(ReturnCase item) async {
    await context.push(Uri(path: Routes.returnCase, queryParameters: {'id': item.id}).toString());
    if (!mounted) return;
    for (final ReturnState? state in _filters) {
      ref.invalidate(returnCasesProvider(state));
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ReturnCasePage> cases = ref.watch(returnCasesProvider(_state));
    final Map<String, String> hubs = {
      for (final hub in ref.watch(fleetSessionProvider.select((session) => session.hubs))) hub.id: hub.name,
    };

    return AppScaffold(
      title: context.l10n.returnDeskTitle,
      subtitle: context.l10n.returnDeskSubtitle,
      body: Column(
        children: [
          const Gap.sm(),
          FilterChipBar(
            items: [
              context.l10n.supportAll,
              context.l10n.returnDeskFilterToReceive,
              context.l10n.returnDeskFilterReturned,
              context.l10n.returnsStatusCancelled,
            ],
            selectedIndex: _tab,
            onChanged: (index) => setState(() => _tab = index),
          ),
          const Gap.md(),
          Expanded(child: _body(cases, hubs)),
        ],
      ),
    );
  }

  Widget _body(AsyncValue<ReturnCasePage> cases, Map<String, String> hubs) {
    final ReturnCasePage? page = cases.value;
    if (page == null) {
      return cases.hasError
          ? EmptyState(
              title: context.l10n.returnDeskCouldNotLoad,
              message: cases.failureMessage,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: context.l10n.commonTryAgain,
              onAction: () => ref.invalidate(returnCasesProvider(_state)),
            )
          : const PageBody(
              children: [
                ShimmerBox(height: 120, borderRadius: Corners.brXl),
                Gap.md(),
                ShimmerBox(height: 120, borderRadius: Corners.brXl),
                Gap.md(),
                ShimmerBox(height: 120, borderRadius: Corners.brXl),
              ],
            );
    }

    final ReturnCasesNotifier notifier = ref.read(returnCasesProvider(_state).notifier);

    if (page.items.isEmpty) {
      return RefreshIndicator(
        onRefresh: notifier.reload,
        color: AppColors.primary,
        child: PageBody(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Insets.xl),
              child: EmptyState(
                title: context.l10n.returnDeskEmpty,
                message: context.l10n.returnDeskEmptyBody,
                icon: Icons.assignment_return_outlined,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: notifier.reload,
      color: AppColors.primary,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(Insets.gutter, 0, Insets.gutter, Insets.x4l),
        itemCount: page.items.length + (page.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Gap.md(),
        itemBuilder: (context, index) {
          if (index == page.items.length) return LoadMoreTile(onLoad: notifier.loadMore);
          final ReturnCase item = page.items[index];
          return ReturnCaseTile(
            item: item,
            hubName: hubs[item.receivedHubId ?? item.plannedHubId],
            onOpen: () => _open(item),
          );
        },
      ),
    );
  }
}
