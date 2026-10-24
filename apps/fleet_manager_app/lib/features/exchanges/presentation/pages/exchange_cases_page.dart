import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/exchange_case.dart';
import '../providers/exchange_case_providers.dart';
import '../widgets/exchange_case_widgets.dart';

class ExchangeCasesPage extends ConsumerStatefulWidget {
  const ExchangeCasesPage({super.key});

  @override
  ConsumerState<ExchangeCasesPage> createState() => _ExchangeCasesPageState();
}

class _ExchangeCasesPageState extends ConsumerState<ExchangeCasesPage> {
  int _filter = 0;

  Future<void> _open(ExchangeCase exchange) async {
    await context.push('${Routes.exchangeDetail}?id=${exchange.id}');
    if (mounted) ref.invalidate(exchangeCasesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<ExchangeCase>> cases = ref.watch(exchangeCasesProvider);
    final List<ExchangeCase>? items = cases.value;
    final List<ExchangeCase> action = [...?items?.where((item) => item.needsStaff)];
    final List<ExchangeCase> waiting = [...?items?.where((item) => item.status.isOpen && !item.needsStaff)];
    final List<ExchangeCase> closed = [...?items?.where((item) => !item.status.isOpen)];

    return HeroScaffold(
      onRefresh: () => ref.refreshQuietly(exchangeCasesProvider),
      band: _Band(action: items == null ? null : action.length, waiting: items == null ? null : waiting.length),
      children: [
        ExchangeFloatingCard(
          child: FilterChipBar(
            items: [
              context.l10n.exchangeDeskNeedsAction,
              context.l10n.exchangeDeskWithRider,
              context.l10n.exchangePast,
            ],
            selectedIndex: _filter,
            onChanged: (i) => setState(() => _filter = i),
            padding: EdgeInsets.zero,
          ),
        ),
        const Gap.xl(),
        if (items == null)
          cases.hasError
              ? EmptyState(
                  compact: true,
                  title: context.l10n.exchangeCouldNotLoad,
                  message: cases.failureMessage,
                  icon: Icons.cloud_off_rounded,
                  tone: AppColors.danger,
                  actionLabel: context.l10n.commonTryAgain,
                  onAction: () => ref.invalidate(exchangeCasesProvider),
                )
              : Column(
                  children: [
                    for (int i = 0; i < 3; i++) ...[
                      const ShimmerBox(height: 110, borderRadius: Corners.brLg),
                      const Gap.md(),
                    ],
                  ],
                )
        else
          _CaseList(
            cases: switch (_filter) {
              0 => action,
              1 => waiting,
              _ => closed,
            },
            onOpen: _open,
          ),
      ],
    );
  }
}

class _CaseList extends StatelessWidget {
  const _CaseList({required this.cases, required this.onOpen});

  final List<ExchangeCase> cases;
  final ValueChanged<ExchangeCase> onOpen;

  @override
  Widget build(BuildContext context) {
    if (cases.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.lg),
        child: ArtBlock(
          art: BrandArt.empty,
          artSize: 112,
          title: context.l10n.exchangeNone,
          message: context.l10n.exchangeDeskEmptyBody,
        ),
      );
    }
    return Column(
      children: [
        for (final ExchangeCase exchange in cases) ...[
          ExchangeCaseTile(exchange: exchange, onOpen: () => onOpen(exchange)),
          const Gap.md(),
        ],
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.action, required this.waiting});

  final int? action;
  final int? waiting;

  @override
  Widget build(BuildContext context) {
    final int? action = this.action;
    final int? waiting = this.waiting;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
        const Gap.lg(),
        Row(
          children: [
            const IconTile(
              icon: Icons.published_with_changes_rounded,
              tone: AppColors.primaryBright,
              solid: true,
              size: 46,
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                context.l10n.exchangeTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.displaySmall.copyWith(fontSize: 24, color: AppColors.onInk),
              ),
            ),
          ],
        ),
        const Gap.sm(),
        Text(
          context.l10n.exchangeDeskSubtitle,
          style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary, height: 1.4),
        ),
        const Gap.xl(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: Insets.md, horizontal: Insets.sm),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkStat(
                  label: context.l10n.exchangeDeskNeedsAction,
                  value: action?.toString() ?? '—',
                  icon: Icons.touch_app_rounded,
                  valueColor: (action ?? 0) > 0 ? AppColors.onInkAmber : null,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.exchangeDeskWithRider,
                  value: waiting?.toString() ?? '—',
                  icon: Icons.hourglass_top_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
