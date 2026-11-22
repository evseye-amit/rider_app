import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/entities/auto_pay.dart';
import '../providers/auto_recharges_provider.dart';

class AutoRechargesPage extends ConsumerStatefulWidget {
  const AutoRechargesPage({super.key});

  @override
  ConsumerState<AutoRechargesPage> createState() => _AutoRechargesPageState();
}

class _AutoRechargesPageState extends ConsumerState<AutoRechargesPage> {
  bool _loadingMore = false;

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    final bool loaded = await ref.read(autoRechargesProvider.notifier).loadMore();
    if (!mounted) return;
    setState(() => _loadingMore = false);
    if (!loaded) AppSnack.error(context, context.l10n.commonSomethingWentWrongPleaseTry);
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final AsyncValue<AutoRechargePage> recharges = ref.watch(autoRechargesProvider);
    final AutoRechargePage? page = recharges.value;

    return AppScaffold(
      title: l10n.ledgerAutoPayRecent,
      body: page == null
          ? recharges.hasError
                ? EmptyState(
                    title: l10n.ledgerAutoPayHistoryError,
                    message: recharges.failureMessage,
                    icon: Icons.cloud_off_rounded,
                    tone: AppColors.danger,
                    actionLabel: l10n.commonTryAgain,
                    onAction: () => ref.invalidate(autoRechargesProvider),
                  )
                : const PageBody(
                    children: [
                      ShimmerBox(height: 72, borderRadius: Corners.brXl),
                      Gap.md(),
                      ShimmerBox(height: 72, borderRadius: Corners.brXl),
                      Gap.md(),
                      ShimmerBox(height: 72, borderRadius: Corners.brXl),
                    ],
                  )
          : RefreshIndicator(
              onRefresh: () => ref.read(autoRechargesProvider.notifier).reload(),
              color: AppColors.primary,
              child: PageBody(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  if (page.items.isEmpty)
                    EmptyState(
                      compact: true,
                      title: l10n.ledgerAutoPayNoRecharges,
                      message: l10n.ledgerAutoPayNoRechargesHint,
                      icon: Icons.autorenew_rounded,
                    )
                  else
                    ModuleCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final (int index, AutoRecharge item) in page.items.indexed) ...[
                            if (index > 0) Divider(color: AppColors.stroke.withValues(alpha: 0.7), height: 1),
                            _RechargeRow(request: item),
                          ],
                        ],
                      ),
                    ),
                  if (page.hasMore) ...[
                    const Gap.lg(),
                    Center(
                      child: _loadingMore
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.primary),
                            )
                          : GhostButton(label: l10n.commonLoadMore, onPressed: _loadMore),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _RechargeRow extends StatelessWidget {
  const _RechargeRow({required this.request});

  final AutoRecharge request;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final DateTime? scheduled = request.scheduledAt;
    final DateTime? stamp = request.completedAt ?? request.createdAt;
    final String? when = request.state.isAwaitingBank && scheduled != null
        ? l10n.ledgerAutoPayEarliestDebit(Fmt.dateTime(scheduled))
        : stamp == null
        ? null
        : Fmt.dateTime(stamp);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Fmt.money(request.amount), style: AppText.titleSmall.copyWith(fontSize: 13.5)),
                if (when != null)
                  Text(when, style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted)),
              ],
            ),
          ),
          StatusChip(label: _label(l10n, request.state), tone: _tone(request.state), dense: true),
        ],
      ),
    );
  }

  static String _label(AppL10n l10n, AutoRechargeState state) => switch (state) {
    AutoRechargeState.creating => l10n.ledgerAutoPayStatusPreparing,
    AutoRechargeState.pending => l10n.ledgerAutoPayStatusPending,
    AutoRechargeState.unknown => l10n.ledgerAutoPayStatusConfirming,
    AutoRechargeState.review => l10n.ledgerAutoPayStatusReview,
    AutoRechargeState.success => l10n.ledgerAutoPayStatusAdded,
    AutoRechargeState.failed => l10n.ledgerStateFailed,
    AutoRechargeState.cancelled => l10n.ledgerAutoPayStatusStopped,
  };

  static StatusTone _tone(AutoRechargeState state) => switch (state) {
    AutoRechargeState.success => StatusTone.success,
    AutoRechargeState.failed => StatusTone.danger,
    AutoRechargeState.cancelled => StatusTone.neutral,
    _ => StatusTone.warning,
  };
}
