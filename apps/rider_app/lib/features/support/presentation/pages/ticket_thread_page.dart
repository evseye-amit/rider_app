import 'dart:async';
import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/support_ticket.dart';
import '../../domain/usecases/ticket_actions.dart';
import '../../support_dependencies.dart';
import '../providers/support_tickets_provider.dart';
import '../widgets/ticket_status.dart';

class TicketThreadPage extends ConsumerStatefulWidget {
  const TicketThreadPage({required this.ticketId, super.key});

  final String ticketId;

  @override
  ConsumerState<TicketThreadPage> createState() => _TicketThreadPageState();
}

class _TicketThreadPageState extends ConsumerState<TicketThreadPage> {
  static const Duration _pollEvery = Duration(seconds: 30);

  Timer? _poll;

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
      ref.refresh(supportTicketProvider(widget.ticketId).future).then<void>((_) {}, onError: (_) {});

  Future<bool> _send(String text) async {
    final TicketStatus? before = ref.read(supportTicketProvider(widget.ticketId)).value?.ticket.status;
    final Result<TicketStatus> result = await ref.read(replyToTicketProvider)(
      TicketReplyParams(id: widget.ticketId, message: text),
    );
    if (!mounted) return false;
    switch (result) {
      case Ok<TicketStatus>(:final value):
        if (before == TicketStatus.resolved && value != TicketStatus.resolved) {
          AppSnack.info(context, context.l10n.supportTicketReopened);
        }
        await _refresh();
        return true;
      case Err<TicketStatus>(:final failure):
        AppSnack.error(context, failure.message);
        return false;
    }
  }

  Future<void> _attach() async {
    final File? file = await PhotoSourceSheet.pick(context);
    if (file == null || !mounted) return;
    final Result<void> result = await ref.read(attachToTicketProvider)(
      TicketPhotoParams(id: widget.ticketId, photo: file),
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

  Future<String?> _resolveUrl(String attachmentId) async => (await ref.read(getTicketAttachmentUrlProvider)(
    TicketAttachmentParams(id: widget.ticketId, attachmentId: attachmentId),
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

  List<ThreadEntry> _entries(TicketThread thread) => [
    for (final TicketMessage message in thread.messages)
      ThreadEntry.message(id: message.id, mine: message.fromRider, at: message.at, text: message.body),
    for (final TicketAttachment attachment in thread.attachments)
      ThreadEntry.attachment(
        id: attachment.id,
        mine: attachment.fromRider,
        at: attachment.at,
        attachmentId: attachment.id,
        isPdf: attachment.isPdf,
      ),
  ]..sort((a, b) => a.at.compareTo(b.at));

  @override
  Widget build(BuildContext context) {
    final AsyncValue<TicketThread> thread = ref.watch(supportTicketProvider(widget.ticketId));
    final TicketThread? value = thread.value;
    final TicketStatusStyle? style = value == null ? null : TicketStatusStyle.of(context, value.ticket.status);

    return AppScaffold(
      title: value?.ticket.subject ?? context.l10n.supportTicket,
      subtitle: value == null ? null : context.l10n.supportRaisedOn(Fmt.date(value.ticket.createdAt)),
      actions: [
        if (style != null)
          Padding(
            padding: const EdgeInsets.only(right: Insets.sm),
            child: StatusChip(label: style.label, tone: style.tone, dense: true),
          ),
      ],
      footer: value == null
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (value.ticket.status == TicketStatus.resolved) ...[
                  Text(
                    context.l10n.supportResolvedReplyToReopen,
                    style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const Gap.sm(),
                ],
                SupportComposer(onSend: _send, onAttach: _attach),
              ],
            ),
      body: switch (thread) {
        _ when value != null => SupportThreadView(
          entries: _entries(value),
          mineLabel: context.l10n.supportYou,
          theirsLabel: context.l10n.supportTeam,
          resolveUrl: _resolveUrl,
          onOpenAttachment: _open,
          onRefresh: _refresh,
        ),
        AsyncError() => EmptyState(
          title: context.l10n.supportCouldNotLoadTicket,
          message: thread.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(supportTicketProvider(widget.ticketId)),
        ),
        _ => const _ThreadSkeleton(),
      },
    );
  }
}

class _ThreadSkeleton extends StatelessWidget {
  const _ThreadSkeleton();

  @override
  Widget build(BuildContext context) {
    return const PageBody(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ShimmerBox(height: 64, width: 240, borderRadius: Corners.brLg),
        ),
        Gap.lg(),
        Align(
          alignment: Alignment.centerLeft,
          child: ShimmerBox(height: 84, width: 260, borderRadius: Corners.brLg),
        ),
        Gap.lg(),
        Align(
          alignment: Alignment.centerRight,
          child: ShimmerBox(height: 48, width: 200, borderRadius: Corners.brLg),
        ),
      ],
    );
  }
}
