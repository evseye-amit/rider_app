import 'dart:async';
import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/session/fleet_session_provider.dart';
import '../../domain/entities/desk_ticket.dart';
import '../../domain/usecases/support_desk_usecases.dart';
import '../../support_desk_dependencies.dart';
import '../providers/support_desk_providers.dart';
import '../widgets/desk_widgets.dart';

class DeskTicketPage extends ConsumerStatefulWidget {
  const DeskTicketPage({required this.ticketId, super.key});

  final String ticketId;

  @override
  ConsumerState<DeskTicketPage> createState() => _DeskTicketPageState();
}

class _DeskTicketPageState extends ConsumerState<DeskTicketPage> {
  static const Duration _pollEvery = Duration(seconds: 30);

  Timer? _poll;
  TicketStatus? _updating;

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(_pollEvery, (_) => _refresh());
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _refresh() =>
      ref.refresh(deskTicketProvider(widget.ticketId).future).then<void>((_) {}, onError: (_) {});

  Future<bool> _send(String text) async {
    final Result<void> result = await ref.read(replyToDeskTicketProvider)(
      DeskReplyParams(id: widget.ticketId, message: text),
    );
    if (!mounted) return false;
    switch (result) {
      case Ok<void>():
        await _refresh();
        return true;
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
        return false;
    }
  }

  Future<void> _attach() async {
    final File? file = await PhotoSourceSheet.pick(context);
    if (file == null || !mounted) return;
    final Result<void> result = await ref.read(attachToDeskTicketProvider)(
      DeskPhotoParams(id: widget.ticketId, photo: file),
    );
    if (!mounted) return;
    switch (result) {
      case Ok<void>():
        AppSnack.success(context, context.l10n.commonUploaded);
        await _refresh();
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  Future<void> _setStatus(TicketStatus next) async {
    if (next == TicketStatus.resolved) {
      final bool confirmed = await AppDialog.confirm(
        context,
        title: context.l10n.supportResolveTitle,
        message: context.l10n.supportResolveBody,
        confirmLabel: context.l10n.supportMarkResolved,
        icon: Icons.check_circle_rounded,
        tone: AppColors.success,
      );
      if (!confirmed || !mounted) return;
    }
    setState(() => _updating = next);
    final Result<void> result = await ref.read(setDeskTicketStatusProvider)(
      DeskStatusParams(id: widget.ticketId, status: next),
    );
    if (!mounted) return;
    switch (result) {
      case Ok<void>():
        await _refresh();
        if (!mounted) return;
        setState(() => _updating = null);
        AppSnack.success(context, context.l10n.supportStatusUpdated);
      case Err<void>(:final failure):
        setState(() => _updating = null);
        AppSnack.error(context, failure.message);
    }
  }

  Future<void> _call(String mobile) async {
    final bool opened = await launchUrl(Uri(scheme: 'tel', path: mobile));
    if (!opened && mounted) AppSnack.error(context, context.l10n.commonSomethingWentWrongPleaseTry);
  }

  Future<String?> _resolveUrl(String attachmentId) async => (await ref.read(getDeskAttachmentUrlProvider)(
    DeskAttachmentParams(id: widget.ticketId, attachmentId: attachmentId),
  )).valueOrNull;

  Future<void> _open(ThreadEntry entry) async {
    final String? url = await _resolveUrl(entry.attachmentId!);
    if (!mounted) return;
    if (url == null || url.isEmpty) {
      AppSnack.error(context, context.l10n.commonCouldNotOpenDocumentTry);
      return;
    }
    if (!entry.isPdf) {
      await PhotoViewer.show(context, url);
      return;
    }
    final bool opened = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!opened && mounted) AppSnack.error(context, context.l10n.commonCouldNotOpenDocumentTry);
  }

  List<ThreadEntry> _entries(DeskThread thread) => [
    for (final DeskMessage message in thread.messages)
      ThreadEntry.message(id: message.id, mine: !message.fromRider, at: message.at, text: message.body),
    for (final DeskAttachment attachment in thread.attachments)
      ThreadEntry.attachment(
        id: attachment.id,
        mine: !attachment.fromRider,
        at: attachment.at,
        attachmentId: attachment.id,
        isPdf: attachment.isPdf,
      ),
  ]..sort((a, b) => a.at.compareTo(b.at));

  @override
  Widget build(BuildContext context) {
    final AsyncValue<DeskThread> thread = ref.watch(deskTicketProvider(widget.ticketId));
    final DeskThread? value = thread.value;
    final DeskStatusStyle? style = value == null ? null : DeskStatusStyle.of(context, value.ticket.status);
    final String? hubName = value == null
        ? null
        : ref
              .watch(fleetSessionProvider.select((session) => session.hubs))
              .where((hub) => hub.id == value.ticket.hubId)
              .firstOrNull
              ?.name;

    return AppScaffold(
      title: value?.ticket.subject ?? context.l10n.supportTicket,
      subtitle: value?.ticket.riderName,
      actions: [
        if (style != null)
          Padding(
            padding: const EdgeInsets.only(right: Insets.sm),
            child: StatusChip(label: style.label, tone: style.tone, dense: true),
          ),
      ],
      footer: value == null ? null : SupportComposer(onSend: _send, onAttach: _attach),
      body: switch (thread) {
        _ when value != null => SupportThreadView(
          entries: _entries(value),
          mineLabel: context.l10n.supportTeam,
          theirsLabel: value.ticket.riderName,
          resolveUrl: _resolveUrl,
          onOpenAttachment: _open,
          onRefresh: _refresh,
          header: _TicketHeader(
            thread: value,
            hubName: hubName,
            updating: _updating,
            onStatus: _setStatus,
            onCall: _call,
          ),
        ),
        AsyncError() => EmptyState(
          title: context.l10n.supportCouldNotLoadTicket,
          message: thread.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(deskTicketProvider(widget.ticketId)),
        ),
        _ => const PageBody(
          children: [
            ShimmerBox(height: 170, borderRadius: Corners.brXl),
            Gap.lg(),
            ShimmerBox(height: 64, width: 240, borderRadius: Corners.brLg),
            Gap.md(),
            ShimmerBox(height: 84, width: 260, borderRadius: Corners.brLg),
          ],
        ),
      },
    );
  }
}

class _TicketHeader extends StatelessWidget {
  const _TicketHeader({
    required this.thread,
    required this.hubName,
    required this.updating,
    required this.onStatus,
    required this.onCall,
  });

  final DeskThread thread;
  final String? hubName;
  final TicketStatus? updating;
  final ValueChanged<TicketStatus> onStatus;
  final ValueChanged<String> onCall;

  @override
  Widget build(BuildContext context) {
    final DeskTicket ticket = thread.ticket;
    final String? mobile = ticket.riderMobile;
    final DateTime? resolvedAt = ticket.resolvedAt;
    return ModuleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppAvatar(name: ticket.riderName, size: 44),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.riderName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleMedium.copyWith(fontSize: 15.5),
                    ),
                    if (mobile != null) ...[
                      const SizedBox(height: 2),
                      Text(Fmt.phone(mobile), style: AppText.bodySmall.copyWith(fontSize: 12.5)),
                    ],
                  ],
                ),
              ),
              if (mobile != null)
                CircleIconButton(
                  icon: Icons.call_rounded,
                  background: AppColors.primaryWash,
                  foreground: AppColors.primary,
                  onTap: () => onCall(mobile),
                ),
            ],
          ),
          const Gap.md(),
          if (thread.vehicleNumber != null)
            KeyValueRow(
              label: context.l10n.commonVehicle,
              value: thread.vehicleNumber!,
              icon: Icons.electric_moped_rounded,
              dense: true,
            ),
          if (hubName != null)
            KeyValueRow(label: context.l10n.supportHub, value: hubName!, icon: Icons.store_rounded, dense: true),
          KeyValueRow(
            label: context.l10n.commonRaised,
            value: Fmt.dateTime(ticket.createdAt),
            icon: Icons.schedule_rounded,
            dense: true,
          ),
          if (resolvedAt != null && ticket.status == TicketStatus.resolved)
            KeyValueRow(
              label: context.l10n.supportResolved,
              value: Fmt.dateTime(resolvedAt),
              icon: Icons.check_circle_outline_rounded,
              dense: true,
            ),
          const Gap.md(),
          _StatusActions(status: ticket.status, updating: updating, onStatus: onStatus),
        ],
      ),
    );
  }
}

class _StatusActions extends StatelessWidget {
  const _StatusActions({required this.status, required this.updating, required this.onStatus});

  final TicketStatus status;
  final TicketStatus? updating;
  final ValueChanged<TicketStatus> onStatus;

  @override
  Widget build(BuildContext context) {
    final bool busy = updating != null;
    final Widget resolve = PrimaryButton(
      label: context.l10n.supportMarkResolved,
      icon: Icons.check_rounded,
      size: AppButtonSize.medium,
      fillColor: AppColors.success,
      loading: updating == TicketStatus.resolved,
      onPressed: busy ? null : () => onStatus(TicketStatus.resolved),
    );
    return switch (status) {
      TicketStatus.open => Row(
        children: [
          Expanded(
            child: SecondaryButton(
              label: context.l10n.supportStartWorking,
              icon: Icons.play_arrow_rounded,
              size: AppButtonSize.medium,
              onPressed: busy ? null : () => onStatus(TicketStatus.inProgress),
            ),
          ),
          const SizedBox(width: Insets.md),
          Expanded(child: resolve),
        ],
      ),
      TicketStatus.inProgress => resolve,
      TicketStatus.resolved => SecondaryButton(
        label: context.l10n.supportReopen,
        icon: Icons.replay_rounded,
        size: AppButtonSize.medium,
        onPressed: busy ? null : () => onStatus(TicketStatus.open),
      ),
    };
  }
}
