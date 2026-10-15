import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/ride_return.dart';
import '../providers/ride_returns_providers.dart';
import '../widgets/return_widgets.dart';

class ReturnsPage extends ConsumerStatefulWidget {
  const ReturnsPage({super.key});

  @override
  ConsumerState<ReturnsPage> createState() => _ReturnsPageState();
}

class _ReturnsPageState extends ConsumerState<ReturnsPage> {
  bool _loadingMore = false;

  Future<void> _request() async {
    final String? id = await context.push<String>(Routes.rideReturnRequest);
    if (!mounted) return;
    await ref.read(rideReturnsProvider.notifier).reload();
    if (id != null && mounted) await _open(id);
  }

  Future<void> _open(String id) async {
    await context.push(Uri(path: Routes.rideReturnDetail, queryParameters: {'id': id}).toString());
    if (mounted) await ref.read(rideReturnsProvider.notifier).reload();
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    final bool loaded = await ref.read(rideReturnsProvider.notifier).loadMore();
    if (!mounted) return;
    setState(() => _loadingMore = false);
    if (!loaded) AppSnack.error(context, context.l10n.commonSomethingWentWrongPleaseTry);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ReturnPage> returns = ref.watch(rideReturnsProvider);
    final ReturnPage? page = returns.value;

    return AppScaffold(
      title: context.l10n.returnsTitle,
      subtitle: context.l10n.returnsSubtitle,
      body: page == null
          ? returns.hasError
                ? EmptyState(
                    title: context.l10n.returnsCouldNotLoad,
                    message: returns.failureMessage,
                    icon: Icons.cloud_off_rounded,
                    tone: AppColors.danger,
                    actionLabel: context.l10n.commonTryAgain,
                    onAction: () => ref.invalidate(rideReturnsProvider),
                  )
                : const PageBody(
                    children: [
                      ShimmerBox(height: 150, borderRadius: Corners.brXl),
                      Gap.lg(),
                      ShimmerBox(height: 96, borderRadius: Corners.brXl),
                      Gap.md(),
                      ShimmerBox(height: 96, borderRadius: Corners.brXl),
                    ],
                  )
          : RefreshIndicator(
              onRefresh: () => ref.read(rideReturnsProvider.notifier).reload(),
              color: AppColors.primary,
              child: PageBody(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  if (!page.returns.any((item) => item.status == ReturnStatus.requested)) ...[
                    _RequestCard(onRequest: _request),
                    const Gap.xl(),
                  ],
                  if (page.returns.isEmpty)
                    EmptyState(
                      compact: true,
                      title: context.l10n.returnsNone,
                      message: context.l10n.returnsNoneBody,
                      icon: Icons.assignment_return_outlined,
                    )
                  else ...[
                    SectionHeader(title: context.l10n.returnsYourReturns),
                    const Gap.lg(),
                    for (final RideReturn item in page.returns) ...[
                      ReturnTile(item: item, onOpen: () => _open(item.id)),
                      const Gap.md(),
                    ],
                    if (page.hasMore)
                      Center(
                        child: _loadingMore
                            ? const SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                              )
                            : GhostButton(label: context.l10n.commonLoadMore, onPressed: _loadMore),
                      ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.onRequest});

  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: context.l10n.returnsEndRentalTitle,
      leading: const IconTile(icon: Icons.assignment_return_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.returnsEndRentalBody, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5)),
          const Gap.lg(),
          PrimaryButton(
            label: context.l10n.returnsRequestReturn,
            icon: Icons.assignment_return_rounded,
            onPressed: onRequest,
          ),
        ],
      ),
    );
  }
}
