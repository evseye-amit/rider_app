import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/exchange_case.dart';
import '../providers/exchange_case_providers.dart';
import '../widgets/exchange_case_widgets.dart';

class ExchangeCasesPage extends ConsumerWidget {
  const ExchangeCasesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ExchangeCase>> cases = ref.watch(exchangeCasesProvider);
    final List<ExchangeCase>? items = cases.value;

    if (items == null) {
      return AppScaffold(
        title: context.l10n.exchangeTitle,
        subtitle: context.l10n.exchangeDeskSubtitle,
        body: cases.hasError
            ? EmptyState(
                title: context.l10n.exchangeCouldNotLoad,
                message: cases.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(exchangeCasesProvider),
              )
            : const PageBody(
                children: [
                  ShimmerBox(height: 110, borderRadius: Corners.brLg),
                  Gap.md(),
                  ShimmerBox(height: 110, borderRadius: Corners.brLg),
                ],
              ),
      );
    }

    final List<ExchangeCase> action = [...items.where((item) => item.needsStaff)];
    final List<ExchangeCase> waiting = [...items.where((item) => item.status.isOpen && !item.needsStaff)];
    final List<ExchangeCase> closed = [...items.where((item) => !item.status.isOpen)];

    Widget section(String title, List<ExchangeCase> list) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: title),
        const Gap.lg(),
        for (final ExchangeCase exchange in list) ...[
          ExchangeCaseTile(
            exchange: exchange,
            onOpen: () => context.push('${Routes.exchangeDetail}?id=${exchange.id}'),
          ),
          const Gap.md(),
        ],
        const Gap.lg(),
      ],
    );

    return AppScaffold(
      title: context.l10n.exchangeTitle,
      subtitle: context.l10n.exchangeDeskSubtitle,
      body: RefreshIndicator(
        onRefresh: () => ref.refreshQuietly(exchangeCasesProvider),
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: items.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Insets.xl),
                    child: EmptyState(
                      title: context.l10n.exchangeNone,
                      message: context.l10n.exchangeDeskEmptyBody,
                      icon: Icons.swap_horiz_rounded,
                    ),
                  ),
                ]
              : [
                  if (action.isNotEmpty) section(context.l10n.exchangeDeskNeedsAction, action),
                  if (waiting.isNotEmpty) section(context.l10n.exchangeDeskWithRider, waiting),
                  if (closed.isNotEmpty) section(context.l10n.exchangePast, closed),
                ],
        ),
      ),
    );
  }
}
