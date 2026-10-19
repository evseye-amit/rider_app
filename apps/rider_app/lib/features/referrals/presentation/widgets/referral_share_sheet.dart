import 'dart:async';
import 'dart:ui' as ui;

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/referral/referral_qr_card.dart';
import '../../domain/entities/referral_invite.dart';
import '../../domain/entities/referral_overview.dart';

class ReferralShareSheet extends StatefulWidget {
  const ReferralShareSheet({required this.overview, required this.invite, super.key});

  final ReferralOverview overview;
  final ReferralInvite invite;

  static Future<void> show(
    BuildContext context, {
    required ReferralOverview overview,
    required ReferralInvite invite,
  }) => AppSheet.show<void>(
    context,
    title: context.l10n.referShareTitle,
    subtitle: context.l10n.referShareSubtitle,
    maxHeightFactor: 0.94,
    child: ReferralShareSheet(overview: overview, invite: invite),
  );

  @override
  State<ReferralShareSheet> createState() => _ReferralShareSheetState();
}

class _ReferralShareSheetState extends State<ReferralShareSheet> {
  final GlobalKey _card = GlobalKey();
  final GlobalKey _button = GlobalKey();
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_share()));
  }

  String _message(AppL10n l10n) {
    final num? reward = widget.overview.refereeReward;
    return [
      l10n.referShareIntro(FlavorConfig.riderAppName),
      if (reward != null && reward > 0) l10n.referShareReward(Fmt.money(reward)),
      l10n.referShareCodeLine(widget.invite.code),
    ].join('\n');
  }

  Rect? _origin() {
    final RenderObject? box = _button.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  Future<XFile?> _capture() async {
    await WidgetsBinding.instance.endOfFrame;
    final RenderObject? boundary = _card.currentContext?.findRenderObject();
    if (boundary is! RenderRepaintBoundary) return null;
    try {
      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (bytes == null) return null;
      return XFile.fromData(
        bytes.buffer.asUint8List(),
        mimeType: 'image/png',
        name: 'referral-${widget.invite.code}.png',
      );
    } on Exception {
      return null;
    }
  }

  Future<void> _share() async {
    if (_sharing || !mounted) return;
    setState(() => _sharing = true);
    final String text = _message(context.l10n);
    final String? subject = widget.overview.campaign?.title;
    final XFile? card = await _capture();
    if (!mounted) return;
    try {
      await SharePlus.instance.share(
        ShareParams(text: text, subject: subject, files: card == null ? null : [card], sharePositionOrigin: _origin()),
      );
    } on PlatformException catch (error) {
      if (mounted) AppSnack.error(context, error.message ?? context.l10n.commonSomethingWentWrongPleaseTry);
    }
    if (mounted) setState(() => _sharing = false);
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _message(context.l10n)));
    if (mounted) AppSnack.success(context, context.l10n.referMessageCopied);
  }

  @override
  Widget build(BuildContext context) {
    final ReferralInvite invite = widget.invite;
    final num? reward = widget.overview.refereeReward;
    final DateTime? expiresAt = invite.expiresAt;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: RepaintBoundary(
              key: _card,
              child: ReferralQrCard(
                code: invite.code,
                data: invite.code,
                title: widget.overview.campaign?.title,
                caption: reward != null && reward > 0 ? context.l10n.referCardReward(Fmt.money(reward)) : null,
              ),
            ),
          ),
        ),
        if (expiresAt != null) ...[
          const Gap.md(),
          Text(
            context.l10n.referInviteValidTill(Fmt.date(expiresAt)),
            textAlign: TextAlign.center,
            style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
        const Gap.lg(),
        PrimaryButton(
          key: _button,
          label: context.l10n.referShareNow,
          icon: Icons.share_rounded,
          loading: _sharing,
          onPressed: _sharing ? null : _share,
        ),
        const Gap.sm(),
        GhostButton(label: context.l10n.referCopyMessage, icon: Icons.content_copy_rounded, onPressed: _copy),
        const Gap.md(),
      ],
    );
  }
}
