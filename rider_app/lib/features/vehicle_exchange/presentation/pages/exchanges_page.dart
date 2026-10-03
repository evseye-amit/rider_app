import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/exchange_request.dart';
import '../providers/exchange_provider.dart';
import '../widgets/exchange_widgets.dart';

class ExchangesPage extends ConsumerWidget {
  const ExchangesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ExchangeRequest>> exchanges = ref.watch(exchangesProvider);

    if (exchanges.hasError) {
      return AppScaffold(
        title: context.l10n.exchangeTitle,
        body: EmptyState(
          title: context.l10n.exchangeCouldNotLoad,
          message: exchanges.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(exchangesProvider),
        ),
      );
    }

    final List<ExchangeRequest>? requests = exchanges.value;
    final List<ExchangeRequest> open = [...?requests?.where((request) => request.stage.isOpen)];
    final List<ExchangeRequest> past = [...?requests?.where((request) => !request.stage.isOpen)];

    return AppScaffold(
      title: context.l10n.exchangeTitle,
      subtitle: context.l10n.exchangeSubtitle,
      body: requests == null
          ? const PageBody(
              children: [
                ShimmerBox(height: 120, borderRadius: Corners.brLg),
                Gap.md(),
                ShimmerBox(height: 120, borderRadius: Corners.brLg),
              ],
            )
          : RefreshIndicator(
              onRefresh: () => ref.refreshQuietly(exchangesProvider),
              child: PageBody(
                physics: const AlwaysScrollableScrollPhysics(),
                children: requests.isEmpty
                    ? [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Insets.xl),
                          child: ArtBlock(
                            art: BrandArt.empty,
                            artSize: 140,
                            title: context.l10n.exchangeNone,
                            message: context.l10n.exchangeNoneMessage,
                          ),
                        ),
                      ]
                    : [
                        if (open.isNotEmpty) ...[
                          SectionHeader(title: context.l10n.exchangeOpen),
                          const Gap.lg(),
                          for (final ExchangeRequest request in open) ...[
                            ExchangeTile(
                              request: request,
                              onOpen: () => context.push('${Routes.vehicleExchangeDetail}?id=${request.id}'),
                            ),
                            const Gap.md(),
                          ],
                        ],
                        if (past.isNotEmpty) ...[
                          const Gap.lg(),
                          SectionHeader(title: context.l10n.exchangePast),
                          const Gap.lg(),
                          for (final ExchangeRequest request in past) ...[
                            ExchangeTile(
                              request: request,
                              onOpen: () => context.push('${Routes.vehicleExchangeDetail}?id=${request.id}'),
                            ),
                            const Gap.md(),
                          ],
                        ],
                      ],
              ),
            ),
    );
  }
}
