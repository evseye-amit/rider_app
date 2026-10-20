import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../utils/formatters.dart';
import 'buttons.dart';

class ThreadEntry {
  const ThreadEntry.message({required this.id, required this.mine, required this.at, required String this.text})
    : attachmentId = null,
      isPdf = false;

  const ThreadEntry.attachment({
    required this.id,
    required this.mine,
    required this.at,
    required String this.attachmentId,
    this.isPdf = false,
  }) : text = null;

  final String id;
  final bool mine;
  final DateTime at;
  final String? text;
  final String? attachmentId;
  final bool isPdf;

  bool get isAttachment => attachmentId != null;
}

class SupportThreadView extends StatelessWidget {
  const SupportThreadView({
    required this.entries,
    required this.mineLabel,
    required this.theirsLabel,
    required this.resolveUrl,
    required this.onOpenAttachment,
    this.header,
    this.onRefresh,
    super.key,
  });

  final List<ThreadEntry> entries;
  final String mineLabel;
  final String theirsLabel;
  final Future<String?> Function(String attachmentId) resolveUrl;
  final void Function(ThreadEntry entry) onOpenAttachment;
  final Widget? header;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final Widget list = Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(Insets.gutter, Insets.md, Insets.gutter, Insets.xl),
        itemCount: entries.length + (header == null ? 0 : 1),
        itemBuilder: (context, index) {
          if (header != null && index == entries.length) return header!;
          final int at = entries.length - 1 - index;
          final ThreadEntry entry = entries[at];
          final bool showAuthor = at == 0 || entries[at - 1].mine != entry.mine;
          return Padding(
            padding: EdgeInsets.only(top: showAuthor ? Insets.lg : Insets.xs),
            child: _EntryBubble(
              entry: entry,
              author: showAuthor ? (entry.mine ? mineLabel : theirsLabel) : null,
              resolveUrl: resolveUrl,
              onOpen: () => onOpenAttachment(entry),
            ),
          );
        },
      ),
    );
    return onRefresh == null ? list : RefreshIndicator(onRefresh: onRefresh!, color: AppColors.primary, child: list);
  }
}

class _EntryBubble extends StatelessWidget {
  const _EntryBubble({required this.entry, required this.author, required this.resolveUrl, required this.onOpen});

  final ThreadEntry entry;
  final String? author;
  final Future<String?> Function(String attachmentId) resolveUrl;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final bool mine = entry.mine;
    return Column(
      crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (author != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
            child: Text(author!, style: AppText.label.copyWith(fontSize: 11, color: AppColors.textMuted)),
          ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
          child: entry.isAttachment
              ? _AttachmentBubble(entry: entry, resolveUrl: resolveUrl, onOpen: onOpen)
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm + 2),
                  decoration: BoxDecoration(
                    color: mine ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(mine ? 16 : 4),
                      bottomRight: Radius.circular(mine ? 4 : 16),
                    ),
                    border: mine ? null : Border.all(color: AppColors.stroke),
                  ),
                  child: Text(
                    entry.text ?? '',
                    style: AppText.bodyMedium.copyWith(
                      height: 1.45,
                      color: mine ? AppColors.textOnPrimary : AppColors.textPrimary,
                    ),
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3, left: 4, right: 4),
          child: Text(Fmt.dateTime(entry.at), style: AppText.bodySmall.copyWith(fontSize: 10.5)),
        ),
      ],
    );
  }
}

class _AttachmentBubble extends StatefulWidget {
  const _AttachmentBubble({required this.entry, required this.resolveUrl, required this.onOpen});

  final ThreadEntry entry;
  final Future<String?> Function(String attachmentId) resolveUrl;
  final VoidCallback onOpen;

  @override
  State<_AttachmentBubble> createState() => _AttachmentBubbleState();
}

class _AttachmentBubbleState extends State<_AttachmentBubble> {
  late final Future<String?> _url = widget.entry.isPdf
      ? Future<String?>.value()
      : widget.resolveUrl(widget.entry.attachmentId!);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onOpen,
      child: ClipRRect(
        borderRadius: Corners.brLg,
        child: Container(
          width: 200,
          height: widget.entry.isPdf ? 64 : 150,
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            border: Border.all(color: AppColors.stroke),
            borderRadius: Corners.brLg,
          ),
          child: widget.entry.isPdf
              ? Row(
                  children: [
                    const SizedBox(width: Insets.md),
                    const Icon(Icons.picture_as_pdf_rounded, color: AppColors.danger),
                    const SizedBox(width: Insets.sm),
                    Expanded(child: Text(context.l10n.supportPdfAttachment, style: AppText.titleSmall)),
                  ],
                )
              : FutureBuilder<String?>(
                  future: _url,
                  builder: (context, snapshot) {
                    final String? url = snapshot.data;
                    if (url == null || url.isEmpty) {
                      return Center(
                        child: snapshot.connectionState == ConnectionState.done
                            ? const Icon(Icons.image_not_supported_rounded, color: AppColors.textMuted)
                            : const SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                              ),
                      );
                    }
                    return Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Center(child: Icon(Icons.image_not_supported_rounded, color: AppColors.textMuted)),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class SupportComposer extends StatefulWidget {
  const SupportComposer({required this.onSend, this.onAttach, this.hint, super.key});

  final Future<bool> Function(String text) onSend;
  final Future<void> Function()? onAttach;
  final String? hint;

  @override
  State<SupportComposer> createState() => _SupportComposerState();
}

class _SupportComposerState extends State<SupportComposer> {
  final TextEditingController _text = TextEditingController();
  bool _sending = false;
  bool _attaching = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final String message = _text.text.trim();
    if (message.isEmpty || _sending) return;
    setState(() => _sending = true);
    final bool sent = await widget.onSend(message);
    if (!mounted) return;
    setState(() => _sending = false);
    if (sent) _text.clear();
  }

  Future<void> _attach() async {
    final Future<void> Function()? attach = widget.onAttach;
    if (attach == null || _attaching) return;
    setState(() => _attaching = true);
    await attach();
    if (mounted) setState(() => _attaching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.onAttach != null) ...[
          _RoundAction(icon: Icons.add_photo_alternate_rounded, busy: _attaching, filled: false, onTap: _attach),
          const SizedBox(width: Insets.sm),
        ],
        Expanded(
          child: TextField(
            controller: _text,
            minLines: 1,
            maxLines: 5,
            maxLength: 10000,
            textCapitalization: TextCapitalization.sentences,
            style: AppText.bodyMedium,
            decoration: InputDecoration(
              hintText: widget.hint ?? context.l10n.supportWriteMessage,
              counterText: '',
              isDense: true,
              filled: true,
              fillColor: AppColors.surfaceMuted,
              contentPadding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm + 2),
              border: OutlineInputBorder(borderRadius: Corners.brLg, borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(width: Insets.sm),
        _RoundAction(icon: Icons.send_rounded, busy: _sending, filled: true, onTap: _send),
      ],
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon, required this.busy, required this.filled, required this.onTap});

  final IconData icon;
  final bool busy;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color tone = filled ? AppColors.textOnPrimary : AppColors.primary;
    return Material(
      color: filled ? AppColors.primary : AppColors.primaryWash,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: busy ? null : onTap,
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: busy
                ? SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2, color: tone))
                : Icon(icon, size: 20, color: tone),
          ),
        ),
      ),
    );
  }
}

abstract final class PhotoViewer {
  static Future<void> show(BuildContext context, String url) => showImage(context, NetworkImage(url));

  static Future<void> showImage(BuildContext context, ImageProvider image) => showDialog<void>(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) => Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              maxScale: 5,
              child: Center(
                child: Image(
                  image: image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported_rounded, color: Colors.white54),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  static Future<T?> card<T>(
    BuildContext context,
    String url, {
    String? title,
    List<PhotoCardAction<T>> actions = const [],
  }) => showDialog<T>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => _PhotoCard<T>(url: url, title: title, actions: actions),
  );

  const PhotoViewer._();
}

class PhotoCardAction<T> {
  const PhotoCardAction({required this.label, required this.value, this.icon, this.color, this.primary = false});

  final String label;
  final T value;
  final IconData? icon;
  final Color? color;
  final bool primary;
}

class _PhotoCard<T> extends StatelessWidget {
  const _PhotoCard({required this.url, required this.actions, this.title});

  final String url;
  final String? title;
  final List<PhotoCardAction<T>> actions;

  static const double _placeholderHeight = 280;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: Insets.gutter, vertical: Insets.x4l),
      shape: const RoundedRectangleBorder(borderRadius: Corners.brXl),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.xs, Insets.xs, Insets.xs),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(fontSize: 14.5),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textSecondary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Insets.md, 0, Insets.md, Insets.md),
              child: ClipRRect(
                borderRadius: Corners.brLg,
                child: ColoredBox(
                  color: AppColors.surfaceMuted,
                  child: InteractiveViewer(
                    maxScale: 4,
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) => progress == null
                          ? child
                          : const SizedBox(
                              height: _placeholderHeight,
                              child: Center(
                                child: SizedBox.square(
                                  dimension: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
                                ),
                              ),
                            ),
                      errorBuilder: (_, _, _) => const SizedBox(
                        height: _placeholderHeight,
                        child: Center(
                          child: Icon(Icons.image_not_supported_rounded, size: 32, color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (actions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(Insets.md, 0, Insets.md, Insets.md),
              child: Row(
                children: [
                  for (final (int i, PhotoCardAction<T> action) in actions.indexed) ...[
                    if (i > 0) const SizedBox(width: Insets.sm),
                    Expanded(
                      child: action.primary
                          ? PrimaryButton(
                              label: action.label,
                              icon: action.icon,
                              size: AppButtonSize.medium,
                              fillColor: action.color,
                              onPressed: () => Navigator.of(context).pop(action.value),
                            )
                          : SecondaryButton(
                              label: action.label,
                              icon: action.icon,
                              size: AppButtonSize.medium,
                              color: action.color,
                              onPressed: () => Navigator.of(context).pop(action.value),
                            ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
