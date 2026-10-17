import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/ride_return.dart';

class ReturnStatusStyle {
  const ReturnStatusStyle._(this.label, this.tone, this.icon);

  factory ReturnStatusStyle.of(AppL10n l10n, RideReturn item) {
    final ReturnCharges? charges = item.charges;
    if (item.usesCheckIn && item.status != ReturnStatus.cancelled) {
      return switch (item.checkIn) {
        CheckInStage.none when item.status == ReturnStatus.returned => ReturnStatusStyle._(
          l10n.returnsStatusClosed,
          StatusTone.success,
          Icons.check_circle_rounded,
        ),
        CheckInStage.none => ReturnStatusStyle._(
          l10n.returnsStatusRequested,
          StatusTone.info,
          Icons.event_available_rounded,
        ),
        CheckInStage.inProgress => ReturnStatusStyle._(
          l10n.returnsStatusCheckingIn,
          StatusTone.warning,
          Icons.fact_check_rounded,
        ),
        CheckInStage.finalChecks => ReturnStatusStyle._(
          l10n.returnsStatusFinalChecks,
          StatusTone.info,
          Icons.build_circle_rounded,
        ),
        CheckInStage.done => ReturnStatusStyle._(
          l10n.returnsStatusClosed,
          StatusTone.success,
          Icons.check_circle_rounded,
        ),
      };
    }
    return switch (item.status) {
      ReturnStatus.cancelled => ReturnStatusStyle._(
        l10n.returnsStatusCancelled,
        StatusTone.neutral,
        Icons.cancel_outlined,
      ),
      ReturnStatus.requested => ReturnStatusStyle._(
        l10n.returnsStatusRequested,
        StatusTone.info,
        Icons.event_available_rounded,
      ),
      ReturnStatus.returned => switch (charges?.stage) {
        ChargesStage.awaitingYou => ReturnStatusStyle._(
          l10n.returnsStatusNeedsYou,
          StatusTone.warning,
          Icons.touch_app_rounded,
        ),
        ChargesStage.awaitingManager => ReturnStatusStyle._(
          l10n.returnsStatusAwaitingManager,
          StatusTone.info,
          Icons.hourglass_top_rounded,
        ),
        ChargesStage.disputed => ReturnStatusStyle._(
          l10n.returnsStatusDisputed,
          StatusTone.danger,
          Icons.gavel_rounded,
        ),
        ChargesStage.settled => ReturnStatusStyle._(
          l10n.returnsStatusClosed,
          StatusTone.success,
          Icons.check_circle_rounded,
        ),
        ChargesStage.reviewing ||
        null => ReturnStatusStyle._(l10n.returnsStatusInspecting, StatusTone.info, Icons.fact_check_rounded),
      },
    };
  }

  final String label;
  final StatusTone tone;
  final IconData icon;
}

String returnNote(AppL10n l10n, RideReturn item) {
  final ReturnCharges? charges = item.charges;
  if (item.usesCheckIn && item.status != ReturnStatus.cancelled) {
    return switch (item.checkIn) {
      CheckInStage.none when item.status == ReturnStatus.returned => l10n.returnsNoteCheckInDone,
      CheckInStage.none => l10n.returnsNoteRequested(Fmt.date(item.plannedDate)),
      CheckInStage.inProgress => l10n.returnsNoteCheckingIn,
      CheckInStage.finalChecks => l10n.returnsNoteFinalChecks,
      CheckInStage.done => l10n.returnsNoteCheckInDone,
    };
  }
  return switch (item.status) {
    ReturnStatus.cancelled => l10n.returnsNoteCancelled,
    ReturnStatus.requested => l10n.returnsNoteRequested(Fmt.date(item.plannedDate)),
    ReturnStatus.returned => switch (charges?.stage) {
      ChargesStage.awaitingYou => l10n.returnsNoteNeedsYou,
      ChargesStage.awaitingManager =>
        charges!.approvedByAdmin && !charges.approvedByYou
            ? l10n.returnsNoteAdminApproved
            : l10n.returnsNoteYouApproved,
      ChargesStage.disputed => l10n.returnsNoteDisputed,
      ChargesStage.settled =>
        charges!.total > 0 ? l10n.returnsNoteSettled(Fmt.money(charges.total)) : l10n.returnsNoteNoCharges,
      ChargesStage.reviewing || null => l10n.returnsNoteInspecting,
    },
  };
}

class ReturnTile extends StatelessWidget {
  const ReturnTile({required this.item, required this.onOpen, super.key});

  final RideReturn item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final ReturnStatusStyle style = ReturnStatusStyle.of(context.l10n, item);
    return Pressable(
      onTap: onOpen,
      scale: 0.99,
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.md),
        tint: item.needsYou ? AppColors.primaryWash : null,
        borderColor: item.needsYou ? AppColors.primary.withValues(alpha: 0.35) : null,
        child: Row(
          children: [
            IconTile(icon: style.icon, tone: style.tone.color, size: 42),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    returnReasonLabel(context.l10n, item.reasonCode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    context.l10n.returnsPlannedFor(Fmt.date(item.plannedDate)),
                    style: AppText.bodySmall.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: Insets.sm),
                  StatusChip(label: style.label, tone: style.tone, dense: true),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class ReturnStatusCard extends StatelessWidget {
  const ReturnStatusCard({required this.item, super.key});

  final RideReturn item;

  @override
  Widget build(BuildContext context) {
    final ReturnStatusStyle style = ReturnStatusStyle.of(context.l10n, item);
    return AccentCard(
      accent: style.tone.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusChip(label: style.label, tone: style.tone, dense: true, solid: true),
          const Gap.md(),
          Text(returnNote(context.l10n, item), style: AppText.bodyMedium.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}

class ReturnTimeline extends StatelessWidget {
  const ReturnTimeline({required this.item, super.key});

  final RideReturn item;

  List<(String, bool, bool, String?)> _checkInSteps(AppL10n l10n) {
    final DateTime? receivedAt = item.receivedAt;
    final CheckInStage stage = item.checkIn;
    final bool confirmed = stage == CheckInStage.finalChecks || stage == CheckInStage.done;
    final bool closed = stage == CheckInStage.done;
    return [
      (l10n.returnsStepRequested, true, false, Fmt.date(item.createdAt)),
      (l10n.returnsStepCheckIn, confirmed, !confirmed, receivedAt == null ? null : Fmt.date(receivedAt)),
      (l10n.returnsStepFinalChecks, closed, confirmed && !closed, null),
      (l10n.returnsStepClosed, closed, false, null),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? receivedAt = item.receivedAt;
    final bool received = receivedAt != null || item.status == ReturnStatus.returned;
    final bool settled = item.charges?.stage == ChargesStage.settled;
    final DateTime? settledAt = item.charges?.postedAt;
    final List<(String, bool, bool, String?)> steps = item.usesCheckIn
        ? _checkInSteps(context.l10n)
        : [
            (context.l10n.returnsStepRequested, true, false, Fmt.date(item.createdAt)),
            (context.l10n.returnsStepHandedOver, received, !received, receivedAt == null ? null : Fmt.date(receivedAt)),
            (context.l10n.returnsStepInspection, settled, received && !settled, null),
            (context.l10n.returnsStepClosed, settled, false, settledAt == null ? null : Fmt.date(settledAt)),
          ];
    return ModuleCard(
      title: context.l10n.returnsProgress,
      leading: const IconTile(icon: Icons.timeline_rounded, solid: true, size: 28),
      child: Column(
        children: [
          for (final (int i, (String title, bool done, bool current, String? time)) in steps.indexed)
            TimelineRow(
              title: title,
              done: done,
              current: current,
              isLast: i == steps.length - 1,
              time: current ? null : time,
              currentLabel: context.l10n.commonNow,
            ),
        ],
      ),
    );
  }
}

class ChargesCard extends StatelessWidget {
  const ChargesCard({
    required this.charges,
    required this.busy,
    required this.onApprove,
    required this.onDispute,
    super.key,
  });

  final ReturnCharges charges;
  final bool busy;
  final VoidCallback onApprove;
  final VoidCallback onDispute;

  @override
  Widget build(BuildContext context) {
    final String? disputeReason = charges.disputeReason;
    return ModuleCard(
      title: context.l10n.returnsCharges,
      leading: const IconTile(icon: Icons.receipt_long_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (charges.items.isEmpty)
            Text(
              charges.stage == ChargesStage.reviewing
                  ? context.l10n.returnsChargesPending
                  : context.l10n.returnsNoCharges,
              style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
            )
          else ...[
            for (final ReturnCharge charge in charges.items) ...[
              _ChargeRow(charge: charge),
              if (charge != charges.items.last) Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
            ],
            const Gap.sm(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm + 2),
              decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: Corners.brMd),
              child: Row(
                children: [
                  Expanded(child: Text(context.l10n.commonTotal, style: AppText.titleSmall)),
                  Text(Fmt.money(charges.total, paise: true), style: AppText.numeric.copyWith(fontSize: 17)),
                ],
              ),
            ),
          ],
          if (disputeReason != null && charges.stage == ChargesStage.disputed) ...[
            const Gap.md(),
            KeyValueRow(label: context.l10n.returnsYourDispute, value: disputeReason, icon: Icons.gavel_rounded),
          ],
          if (charges.canRespond) ...[
            const Gap.lg(),
            PrimaryButton(
              label: context.l10n.returnsApproveCharges,
              icon: Icons.verified_rounded,
              loading: busy,
              onPressed: busy ? null : onApprove,
            ),
          ],
          if (charges.canDispute) ...[
            const Gap.sm(),
            GhostButton(
              label: context.l10n.returnsDisputeCharges,
              icon: Icons.report_gmailerrorred_rounded,
              color: AppColors.danger,
              onPressed: busy ? null : onDispute,
            ),
          ],
        ],
      ),
    );
  }
}

class _ChargeRow extends StatelessWidget {
  const _ChargeRow({required this.charge});

  final ReturnCharge charge;

  @override
  Widget build(BuildContext context) {
    final num? amount = charge.amount;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            icon: charge.kind == ChargeKind.missingItem ? Icons.inventory_2_rounded : Icons.car_crash_rounded,
            tone: charge.kind == ChargeKind.missingItem ? AppColors.amber : AppColors.danger,
            size: 34,
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(charge.description, style: AppText.titleSmall.copyWith(fontSize: 13.5)),
                if (charge.details.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(charge.details, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.4)),
                ],
                const SizedBox(height: 4),
                Text(
                  [
                    charge.kind == ChargeKind.missingItem
                        ? context.l10n.returnsKindMissing
                        : context.l10n.returnsKindDamage,
                    context.l10n.returnsEvidenceCount(charge.evidenceCount),
                  ].join(' · '),
                  style: AppText.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          if (amount != null) ...[
            const SizedBox(width: Insets.sm),
            Text(Fmt.money(amount, paise: true), style: AppText.titleSmall.copyWith(fontSize: 13.5)),
          ],
        ],
      ),
    );
  }
}

class ApprovalCodeSheet extends StatefulWidget {
  const ApprovalCodeSheet({required this.total, required this.onResend, required this.onVerify, super.key});

  final num total;
  final Future<String?> Function() onResend;
  final Future<String?> Function(String code) onVerify;

  static Future<bool> show(
    BuildContext context, {
    required num total,
    required Future<String?> Function() onResend,
    required Future<String?> Function(String code) onVerify,
  }) async {
    final bool? approved = await AppSheet.show<bool>(
      context,
      title: context.l10n.returnsApproveTitle,
      subtitle: context.l10n.returnsApproveSubtitle(Fmt.money(total, paise: true)),
      isDismissible: false,
      child: ApprovalCodeSheet(total: total, onResend: onResend, onVerify: onVerify),
    );
    return approved ?? false;
  }

  @override
  State<ApprovalCodeSheet> createState() => _ApprovalCodeSheetState();
}

class _ApprovalCodeSheetState extends State<ApprovalCodeSheet> {
  static const int _resendAfter = 30;

  String _code = '';
  String? _error;
  bool _verifying = false;
  bool _resending = false;
  int _wait = _resendAfter;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_wait > 0) setState(() => _wait--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_code.length != 6 || _verifying) return;
    setState(() {
      _verifying = true;
      _error = null;
    });
    final String? problem = await widget.onVerify(_code);
    if (!mounted) return;
    if (problem == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _verifying = false;
      _error = problem;
    });
  }

  Future<void> _resend() async {
    setState(() => _resending = true);
    final String? problem = await widget.onResend();
    if (!mounted) return;
    setState(() {
      _resending = false;
      _error = problem;
      if (problem == null) _wait = _resendAfter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OtpInput(
            hasError: _error != null,
            onChanged: (value) => setState(() {
              _code = value;
              _error = null;
            }),
            onCompleted: (value) {
              _code = value;
              _verify();
            },
          ),
          if (_error != null) ...[
            const Gap.sm(),
            Text(_error!, style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12.5)),
          ],
          const Gap.lg(),
          PrimaryButton(
            label: context.l10n.returnsApproveCharges,
            icon: Icons.verified_rounded,
            loading: _verifying,
            onPressed: _code.length == 6 && !_verifying ? _verify : null,
          ),
          const Gap.sm(),
          Row(
            children: [
              Expanded(
                child: GhostButton(
                  label: _wait > 0
                      ? context.l10n.authResendCodeIn('0:${_wait.toString().padLeft(2, '0')}')
                      : context.l10n.authResendCode,
                  onPressed: _wait > 0 || _resending ? null : _resend,
                ),
              ),
              Expanded(
                child: GhostButton(
                  label: context.l10n.commonCancel,
                  color: AppColors.textSecondary,
                  onPressed: _verifying ? null : () => Navigator.of(context).pop(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
