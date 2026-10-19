import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/fleet_session_provider.dart';
import '../../../hub/domain/entities/hub_profile.dart';
import '../../domain/usecases/submission_usecases.dart';
import '../../submission_dependencies.dart';
import '../providers/submission_providers.dart';
import '../widgets/submission_widgets.dart';

class SubmissionsPage extends ConsumerStatefulWidget {
  const SubmissionsPage({super.key});

  @override
  ConsumerState<SubmissionsPage> createState() => _SubmissionsPageState();
}

class _SubmissionsPageState extends ConsumerState<SubmissionsPage> {
  static const List<SubmissionSource> _sources = [SubmissionSource.returns, SubmissionSource.exchange];
  static const List<SubmissionPhase> _phases = [SubmissionPhase.scheduled, SubmissionPhase.checks, SubmissionPhase.all];

  int _source = 0;
  int _phase = 0;

  SubmissionQueueKey get _key => (source: _sources[_source], phase: _phases[_phase]);

  Future<void> _refresh() async {
    ref.invalidate(submissionQueueProvider);
    await ref.read(submissionQueueProvider(_key).future).then<void>((_) {}, onError: (_) {});
  }

  Future<void> _open(SubmissionRequestDto request) async {
    final SubmissionSummaryDto? submission = request.submission;
    if (submission != null) {
      await context.push('${Routes.submission}?id=${submission.id}');
    } else {
      final String? id = await _StartSheet.show(context, request);
      if (id == null || !mounted) return;
      await context.push('${Routes.submission}?id=$id');
    }
    if (mounted) ref.invalidate(submissionQueueProvider);
  }

  @override
  Widget build(BuildContext context) {
    final SubmissionQueuePage? returns = ref
        .watch(submissionQueueProvider((source: SubmissionSource.returns, phase: SubmissionPhase.scheduled)))
        .value;
    final SubmissionQueuePage? exchanges = ref
        .watch(submissionQueueProvider((source: SubmissionSource.exchange, phase: SubmissionPhase.scheduled)))
        .value;
    final AsyncValue<SubmissionQueuePage> queue = ref.watch(submissionQueueProvider(_key));
    final FleetSession session = ref.watch(fleetSessionProvider);
    final Map<String, String> hubNames = {for (final HubProfile hub in session.hubs) hub.id: hub.name};

    return HeroScaffold(
      bottomPadding: 120,
      onRefresh: _refresh,
      band: _Band(returns: returns, exchanges: exchanges),
      children: [
        Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brXl, boxShadow: Shadows.floating),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedTabs(
                items: [context.l10n.submissionsReturns, context.l10n.submissionsExchanges],
                selectedIndex: _source,
                onChanged: (i) => setState(() => _source = i),
              ),
              const Gap.md(),
              FilterChipBar(
                items: [
                  context.l10n.submissionsScheduled,
                  context.l10n.submissionsInChecks,
                  context.l10n.submissionsAll,
                ],
                selectedIndex: _phase,
                onChanged: (i) => setState(() => _phase = i),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        const Gap.xl(),
        _QueueList(
          queue: queue,
          phase: _phases[_phase],
          hubNames: hubNames,
          onRetry: () => ref.invalidate(submissionQueueProvider(_key)),
          onLoadMore: () => ref.read(submissionQueueProvider(_key).notifier).loadMore(),
          onOpen: _open,
        ),
      ],
    );
  }
}

class _QueueList extends StatelessWidget {
  const _QueueList({
    required this.queue,
    required this.phase,
    required this.hubNames,
    required this.onRetry,
    required this.onLoadMore,
    required this.onOpen,
  });

  final AsyncValue<SubmissionQueuePage> queue;
  final SubmissionPhase phase;
  final Map<String, String> hubNames;
  final VoidCallback onRetry;
  final Future<bool> Function() onLoadMore;
  final ValueChanged<SubmissionRequestDto> onOpen;

  @override
  Widget build(BuildContext context) {
    final SubmissionQueuePage? page = queue.value;
    if (page == null) {
      return queue.hasError
          ? EmptyState(
              compact: true,
              title: context.l10n.submissionsCouldNotLoad,
              message: queue.failureMessage,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: context.l10n.commonTryAgain,
              onAction: onRetry,
            )
          : Column(
              children: [
                for (int i = 0; i < 3; i++) ...[
                  const ShimmerBox(height: 116, borderRadius: Corners.brLg),
                  const Gap.md(),
                ],
              ],
            );
    }
    if (page.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.lg),
        child: ArtBlock(
          art: BrandArt.empty,
          artSize: 112,
          title: context.l10n.submissionsEmptyTitle,
          message: switch (phase) {
            SubmissionPhase.scheduled => context.l10n.submissionsEmptyScheduled,
            SubmissionPhase.checks => context.l10n.submissionsEmptyChecks,
            SubmissionPhase.all => context.l10n.submissionsEmptyAll,
          },
        ),
      );
    }
    return Column(
      children: [
        for (final SubmissionRequestDto request in page.items) ...[
          SubmissionRequestTile(
            request: request,
            hubName: hubNames[request.submission?.hubId ?? request.plannedHubId],
            onOpen: () => onOpen(request),
          ),
          const Gap.md(),
        ],
        if (page.hasMore) LoadMoreTile(onLoad: onLoadMore),
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.returns, required this.exchanges});

  final SubmissionQueuePage? returns;
  final SubmissionQueuePage? exchanges;

  static String _count(SubmissionQueuePage? page) =>
      page == null ? '—' : '${page.items.length}${page.hasMore ? '+' : ''}';

  @override
  Widget build(BuildContext context) {
    final bool returnsWaiting = (returns?.items.length ?? 0) > 0;
    final bool exchangesWaiting = (exchanges?.items.length ?? 0) > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const IconTile(icon: Icons.assignment_return_rounded, tone: AppColors.primaryBright, solid: true, size: 46),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                context.l10n.submissionsTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.displaySmall.copyWith(fontSize: 24, color: AppColors.onInk),
              ),
            ),
          ],
        ),
        const Gap.sm(),
        Text(
          context.l10n.submissionsSubtitle,
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
                  label: context.l10n.submissionsReturnsDue,
                  value: _count(returns),
                  icon: Icons.assignment_return_rounded,
                  valueColor: returnsWaiting ? AppColors.onInkAmber : null,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.submissionsExchangesDue,
                  value: _count(exchanges),
                  icon: Icons.published_with_changes_rounded,
                  valueColor: exchangesWaiting ? AppColors.onInkAmber : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StartSheet extends ConsumerStatefulWidget {
  const _StartSheet({required this.request});

  final SubmissionRequestDto request;

  static Future<String?> show(BuildContext context, SubmissionRequestDto request) => AppSheet.show<String>(
    context,
    title: request.source == SubmissionSource.exchange
        ? context.l10n.submissionStartExchange
        : context.l10n.submissionStartTitle,
    subtitle: request.riderName,
    child: _StartSheet(request: request),
  );

  @override
  ConsumerState<_StartSheet> createState() => _StartSheetState();
}

class _StartSheetState extends ConsumerState<_StartSheet> {
  String? _hubId;
  bool _starting = false;

  Future<void> _start(String? hubId) async {
    setState(() => _starting = true);
    final Result<String> result = await ref.read(startSubmissionProvider)(
      StartSubmissionParams(source: widget.request.source, requestId: widget.request.id, hubId: hubId),
    );
    if (!mounted) return;
    setState(() => _starting = false);
    switch (result) {
      case Ok<String>(:final value):
        AppSnack.success(
          context,
          widget.request.source == SubmissionSource.exchange
              ? context.l10n.submissionExchangeStarted
              : context.l10n.submissionStarted,
        );
        Navigator.of(context).pop(value);
      case Err<String>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SubmissionRequestDto request = widget.request;
    final List<HubProfile> hubs = ref.watch(fleetSessionProvider.select((session) => session.hubs));
    final String? planned = hubs.any((hub) => hub.id == request.plannedHubId) ? request.plannedHubId : null;
    final String? selected = _hubId ?? planned ?? hubs.firstOrNull?.id;
    final DateTime? date = request.plannedDate;
    final String? notes = request.notes;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KeyValueRow(
          label: request.source == SubmissionSource.returns
              ? context.l10n.submissionsReturns
              : context.l10n.submissionsExchanges,
          value: submissionReasonLabel(context.l10n, request),
          icon: Icons.help_outline_rounded,
        ),
        if (request.riderMobile.isNotEmpty)
          KeyValueRow(
            label: context.l10n.commonMobile,
            value: Fmt.phone(request.riderMobile),
            icon: Icons.call_rounded,
          ),
        if (date != null)
          KeyValueRow(label: context.l10n.submissionsDropOffDate, value: Fmt.date(date), icon: Icons.event_rounded),
        if (notes != null && notes.isNotEmpty)
          KeyValueRow(label: context.l10n.submissionRiderNote, value: notes, icon: Icons.notes_rounded),
        const Gap.md(),
        Text(
          request.source == SubmissionSource.exchange
              ? context.l10n.submissionStartBodyExchange
              : context.l10n.submissionStartBody,
          style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
        ),
        if (hubs.length > 1) ...[
          const Gap.lg(),
          GroupLabel(context.l10n.submissionReceivingHub),
          const Gap.sm(),
          for (final HubProfile hub in hubs) ...[
            AppRadioTile(
              selected: hub.id == selected,
              onTap: () => setState(() => _hubId = hub.id),
              title: hub.name,
              subtitle: hub.code,
            ),
            const Gap.sm(),
          ],
        ],
        const Gap.lg(),
        PrimaryButton(
          label: request.source == SubmissionSource.exchange
              ? context.l10n.submissionStartExchange
              : context.l10n.submissionStart,
          icon: Icons.play_arrow_rounded,
          loading: _starting,
          onPressed: _starting ? null : () => _start(selected),
        ),
        const Gap.md(),
      ],
    );
  }
}
