import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/submission_usecases.dart';
import '../../submission_dependencies.dart';
import '../providers/submission_providers.dart';
import '../widgets/submission_widgets.dart';

const int _resendAfterSeconds = 30;

class _Party {
  final TextEditingController reason = TextEditingController();

  String? requestId;
  String? phone;
  String? deliveryError;
  DateTime? sentAt;
  String code = '';
  String? codeError;
  bool verifying = false;
  bool bypass = false;

  int get waitSeconds {
    final DateTime? sent = sentAt;
    if (sent == null) return 0;
    final int left = _resendAfterSeconds - DateTime.now().difference(sent).inSeconds;
    return left > 0 ? left : 0;
  }
}

class SubmissionConfirmPage extends ConsumerStatefulWidget {
  const SubmissionConfirmPage({required this.submissionId, super.key});

  final String submissionId;

  @override
  ConsumerState<SubmissionConfirmPage> createState() => _SubmissionConfirmPageState();
}

class _SubmissionConfirmPageState extends ConsumerState<SubmissionConfirmPage> {
  final Map<SubmissionParty, _Party> _parties = {
    for (final SubmissionParty party in SubmissionParty.values) party: _Party(),
  };

  Timer? _ticker;
  bool _sending = false;
  bool _confirming = false;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_parties.values.any((party) => party.waitSeconds > 0)) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    for (final _Party party in _parties.values) {
      party.reason.dispose();
    }
    super.dispose();
  }

  bool _verified(SubmissionReportDto report, SubmissionParty party) =>
      party == SubmissionParty.rider ? report.riderVerified : report.teamLeadVerified;

  Future<void> _send(SubmissionReportDto report, {SubmissionParty? only}) async {
    final List<SubmissionParty> pending = [
      for (final SubmissionParty party in SubmissionParty.values)
        if (!_verified(report, party) && (only == null || only == party)) party,
    ];
    if (pending.isEmpty) return;
    setState(() => _sending = true);
    final Result<SubmissionOtpDispatch> result = await ref.read(requestSubmissionOtpsProvider)(
      RequestOtpParams(reportId: report.id, party: pending.length == 1 ? pending.single : null),
    );
    if (!mounted) return;
    setState(() {
      _sending = false;
      if (result case Ok<SubmissionOtpDispatch>(:final value)) {
        for (final SubmissionParty party in pending) {
          final SubmissionOtpRecipient? recipient = value.recipient(party);
          final _Party state = _parties[party]!;
          state.phone = recipient?.phone ?? state.phone;
          state.deliveryError = recipient == null || recipient.sent ? null : recipient.error ?? recipient.message;
          if (recipient != null && recipient.sent) {
            state.requestId = recipient.otpRequestId;
            state.sentAt = DateTime.now();
            state.codeError = null;
          }
        }
      }
    });
    switch (result) {
      case Ok<SubmissionOtpDispatch>(:final value) when value.recipients.any((recipient) => recipient.sent):
        AppSnack.success(context, context.l10n.submissionCodesSent);
      case Ok<SubmissionOtpDispatch>():
        AppSnack.warning(context, context.l10n.submissionCodeNotSent);
      case Err<SubmissionOtpDispatch>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  Future<void> _verify(SubmissionReportDto report, SubmissionParty party) async {
    final _Party state = _parties[party]!;
    final String? requestId = state.requestId;
    if (requestId == null || state.code.length != 6 || state.verifying) return;
    setState(() {
      state.verifying = true;
      state.codeError = null;
    });
    final Result<void> result = await ref.read(verifySubmissionOtpProvider)(
      VerifyOtpParams(reportId: report.id, party: party, otpRequestId: requestId, code: state.code),
    );
    if (!mounted) return;
    setState(() {
      state.verifying = false;
      state.codeError = result.failureOrNull?.message;
    });
    if (result.isOk) {
      await ref.refresh(submissionProvider(widget.submissionId).future).then<void>((_) {}, onError: (_) {});
    }
  }

  Future<void> _confirm(SubmissionReportDto report) async {
    FocusManager.instance.primaryFocus?.unfocus();
    String? bypassFor(SubmissionParty party) {
      final _Party state = _parties[party]!;
      return !_verified(report, party) && state.bypass ? state.reason.text.trim() : null;
    }

    setState(() => _confirming = true);
    final Result<void> result = await ref.read(confirmSubmissionReportProvider)(
      ConfirmReportParams(
        reportId: report.id,
        riderBypassReason: bypassFor(SubmissionParty.rider),
        teamLeadBypassReason: bypassFor(SubmissionParty.teamLead),
      ),
    );
    if (!mounted) return;
    setState(() => _confirming = false);
    switch (result) {
      case Ok<void>():
        AppSnack.success(context, context.l10n.submissionConfirmed);
        context.pop(true);
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
        await ref.refresh(submissionProvider(widget.submissionId).future).then<void>((_) {}, onError: (_) {});
    }
  }

  bool _ready(SubmissionReportDto report) => SubmissionParty.values.every((party) {
    final _Party state = _parties[party]!;
    return _verified(report, party) || (state.bypass && state.reason.text.trim().isNotEmpty);
  });

  @override
  Widget build(BuildContext context) {
    final AsyncValue<VehicleSubmissionDto> detail = ref.watch(submissionProvider(widget.submissionId));
    final VehicleSubmissionDto? submission = detail.value;
    final SubmissionReportDto? report = submission?.reports
        .where((item) => item.status == SubmissionReportStatus.submitted)
        .lastOrNull;

    return AppScaffold(
      title: context.l10n.submissionConfirmTitle,
      subtitle: submission?.assets.vehicleNumber,
      footer: report == null
          ? null
          : PrimaryButton(
              label: context.l10n.submissionConfirm,
              icon: Icons.task_alt_rounded,
              loading: _confirming,
              onPressed: _confirming || !_ready(report) ? null : () => _confirm(report),
            ),
      body: switch (submission) {
        null when detail.hasError => EmptyState(
          title: context.l10n.submissionCouldNotLoad,
          message: detail.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(submissionProvider(widget.submissionId)),
        ),
        null => const PageBody(
          children: [
            ShimmerBox(height: 200, borderRadius: Corners.brXl),
            Gap.lg(),
            ShimmerBox(height: 180, borderRadius: Corners.brXl),
          ],
        ),
        VehicleSubmissionDto() when report == null => EmptyState(
          title: context.l10n.submissionNothingToConfirm,
          message: context.l10n.submissionNothingToConfirmBody,
          icon: Icons.task_alt_rounded,
          actionLabel: context.l10n.allocationBack,
          onAction: () => context.pop(),
        ),
        VehicleSubmissionDto() => _body(report),
      },
    );
  }

  Widget _body(SubmissionReportDto report) {
    final bool anySent = _parties.values.any((party) => party.requestId != null);
    final bool allVerified = SubmissionParty.values.every((party) => _verified(report, party));
    return PageBody(
      children: [
        SubmissionReportCard(report: report),
        const Gap.lg(),
        AccentCard(
          accent: AppColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.submissionConfirmHint, style: AppText.bodyMedium.copyWith(height: 1.5)),
              if (!allVerified) ...[
                const Gap.md(),
                PrimaryButton(
                  label: anySent ? context.l10n.submissionResendAll : context.l10n.submissionSendCodes,
                  icon: Icons.sms_rounded,
                  size: AppButtonSize.medium,
                  loading: _sending,
                  onPressed: _sending || _parties.values.any((party) => party.waitSeconds > 0)
                      ? null
                      : () => _send(report),
                ),
              ],
            ],
          ),
        ),
        const Gap.lg(),
        for (final SubmissionParty party in SubmissionParty.values) ...[
          _PartyCard(
            party: party,
            state: _parties[party]!,
            verified: _verified(report, party),
            sending: _sending,
            onChanged: () => setState(() {}),
            onVerify: () => _verify(report, party),
            onResend: () => _send(report, only: party),
          ),
          const Gap.lg(),
        ],
      ],
    );
  }
}

class _PartyCard extends StatelessWidget {
  const _PartyCard({
    required this.party,
    required this.state,
    required this.verified,
    required this.sending,
    required this.onChanged,
    required this.onVerify,
    required this.onResend,
  });

  final SubmissionParty party;
  final _Party state;
  final bool verified;
  final bool sending;
  final VoidCallback onChanged;
  final VoidCallback onVerify;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final bool rider = party == SubmissionParty.rider;
    final String? phone = state.phone;
    final String? deliveryError = state.deliveryError;
    final int wait = state.waitSeconds;
    final (String label, StatusTone tone) = verified
        ? (context.l10n.checkInStatusPosted, StatusTone.success)
        : state.bypass
        ? (context.l10n.submissionBypassing, StatusTone.warning)
        : state.requestId != null
        ? (context.l10n.submissionCodeSent, StatusTone.info)
        : (context.l10n.submissionCodePending, StatusTone.neutral);

    return ModuleCard(
      title: rider ? context.l10n.submissionPartyRider : context.l10n.submissionPartyTeamLead,
      leading: IconTile(
        icon: rider ? Icons.person_rounded : Icons.supervisor_account_rounded,
        tone: verified ? AppColors.success : AppColors.primary,
        solid: true,
        size: 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: StatusChip(label: label, tone: tone, dense: true),
          ),
          const Gap.md(),
          if (verified)
            Text(
              rider ? context.l10n.submissionVerifiedRider : context.l10n.submissionVerifiedTeamLead,
              style: AppText.bodySmall.copyWith(fontSize: 12.5),
            )
          else if (state.bypass) ...[
            AppTextField(
              label: context.l10n.submissionBypassReason,
              required: true,
              controller: state.reason,
              maxLines: 3,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => onChanged(),
            ),
            GhostButton(
              label: context.l10n.submissionUseCode,
              icon: Icons.pin_rounded,
              dense: true,
              onPressed: () {
                state.bypass = false;
                onChanged();
              },
            ),
          ] else ...[
            if (phone != null && state.requestId != null)
              Text(context.l10n.submissionCodeSentTo(phone), style: AppText.bodySmall.copyWith(fontSize: 12.5)),
            if (deliveryError != null) ...[
              const Gap.xs(),
              Text(deliveryError, style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.danger)),
            ],
            if (state.requestId != null) ...[
              const Gap.md(),
              OtpInput(
                autofocus: false,
                hasError: state.codeError != null,
                onChanged: (value) {
                  state.code = value;
                  state.codeError = null;
                  onChanged();
                },
                onCompleted: (value) {
                  state.code = value;
                  onVerify();
                },
              ),
              if (state.codeError != null) ...[
                const Gap.sm(),
                Text(state.codeError!, style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12.5)),
              ],
              const Gap.md(),
              PrimaryButton(
                label: context.l10n.submissionVerify,
                icon: Icons.verified_rounded,
                size: AppButtonSize.medium,
                loading: state.verifying,
                onPressed: state.code.length == 6 && !state.verifying ? onVerify : null,
              ),
            ],
            const Gap.sm(),
            Row(
              children: [
                if (state.requestId != null || deliveryError != null)
                  Expanded(
                    child: GhostButton(
                      label: wait > 0
                          ? context.l10n.authResendCodeIn('0:${wait.toString().padLeft(2, '0')}')
                          : context.l10n.authResendCode,
                      dense: true,
                      onPressed: wait > 0 || sending ? null : onResend,
                    ),
                  ),
                Expanded(
                  child: GhostButton(
                    label: context.l10n.submissionBypass,
                    color: AppColors.textSecondary,
                    dense: true,
                    onPressed: () {
                      state.bypass = true;
                      onChanged();
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
