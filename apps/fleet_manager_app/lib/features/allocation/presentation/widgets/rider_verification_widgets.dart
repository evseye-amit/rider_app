import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/rider_verification.dart';

StatusTone reviewTone(ReviewStatus status) => switch (status) {
  ReviewStatus.pending => StatusTone.warning,
  ReviewStatus.approved => StatusTone.success,
  ReviewStatus.rejected => StatusTone.danger,
};

class ReviewStatusChip extends StatelessWidget {
  const ReviewStatusChip({required this.status, super.key});

  final ReviewStatus status;

  @override
  Widget build(BuildContext context) {
    return StatusChip(
      label: switch (status) {
        ReviewStatus.pending => context.l10n.commonPending,
        ReviewStatus.approved => context.l10n.verifyApproved,
        ReviewStatus.rejected => context.l10n.verifyRejected,
      },
      tone: reviewTone(status),
      dense: true,
    );
  }
}

class DocumentReviewTile extends StatelessWidget {
  const DocumentReviewTile({
    required this.document,
    required this.busy,
    required this.onView,
    required this.onApprove,
    required this.onReject,
    super.key,
  });

  final RiderDocument document;
  final bool busy;
  final VoidCallback onView;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final List<String> details = [
      if (document.fieldLabel != document.title) document.fieldLabel,
      if (document.uploadedAt case final DateTime uploaded) context.l10n.verifyUploadedOn(Fmt.date(uploaded)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTile(
              icon: document.isPdf ? Icons.picture_as_pdf_rounded : Icons.badge_rounded,
              tone: reviewTone(document.status).color,
              size: 42,
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(fontSize: 14.5),
                  ),
                  if (details.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      details.join(' · '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySmall.copyWith(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            ReviewStatusChip(status: document.status),
          ],
        ),
        if (document.status == ReviewStatus.rejected && (document.rejectionReason ?? '').isNotEmpty) ...[
          const Gap.sm(),
          _ReasonNote(reason: document.rejectionReason!),
        ],
        const Gap.md(),
        _ReviewActions(
          busy: busy,
          pending: document.status == ReviewStatus.pending,
          lead: SecondaryButton(
            label: context.l10n.verifyView,
            icon: Icons.visibility_rounded,
            size: AppButtonSize.small,
            onPressed: busy || document.photoId == null ? null : onView,
          ),
          onApprove: onApprove,
          onReject: onReject,
        ),
      ],
    );
  }
}

class ReferenceReviewTile extends StatelessWidget {
  const ReferenceReviewTile({
    required this.reference,
    required this.busy,
    required this.onCall,
    required this.onApprove,
    required this.onReject,
    super.key,
  });

  final RiderReference reference;
  final bool busy;
  final VoidCallback onCall;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final String? reviewer = reference.reviewedBy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppAvatar(name: reference.name, size: 42),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reference.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(fontSize: 14.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [reference.relation, Fmt.phone(reference.mobile)].where((part) => part.isNotEmpty).join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 12),
                  ),
                  if (reviewer != null && reviewer.isNotEmpty && reference.status != ReviewStatus.pending) ...[
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.verifyReviewedBy(reviewer),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            ReviewStatusChip(status: reference.status),
          ],
        ),
        if (reference.status == ReviewStatus.rejected && (reference.rejectionReason ?? '').isNotEmpty) ...[
          const Gap.sm(),
          _ReasonNote(reason: reference.rejectionReason!),
        ],
        const Gap.md(),
        _ReviewActions(
          busy: busy,
          pending: reference.status == ReviewStatus.pending,
          lead: SecondaryButton(
            label: context.l10n.ridersCall,
            icon: Icons.call_rounded,
            size: AppButtonSize.small,
            onPressed: reference.mobile.isEmpty ? null : onCall,
          ),
          onApprove: onApprove,
          onReject: onReject,
        ),
      ],
    );
  }
}

class _ReviewActions extends StatelessWidget {
  const _ReviewActions({
    required this.busy,
    required this.pending,
    required this.lead,
    required this.onApprove,
    required this.onReject,
  });

  final bool busy;
  final bool pending;
  final Widget lead;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: lead),
        if (pending) ...[
          const SizedBox(width: Insets.sm),
          Expanded(
            child: SecondaryButton(
              label: context.l10n.verifyReject,
              icon: Icons.close_rounded,
              size: AppButtonSize.small,
              color: AppColors.danger,
              onPressed: busy ? null : onReject,
            ),
          ),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: PrimaryButton(
              label: context.l10n.verifyApprove,
              icon: Icons.check_rounded,
              size: AppButtonSize.small,
              fillColor: AppColors.success,
              loading: busy,
              onPressed: busy ? null : onApprove,
            ),
          ),
        ],
      ],
    );
  }
}

class _ReasonNote extends StatelessWidget {
  const _ReasonNote({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
      decoration: BoxDecoration(color: AppColors.washFor(AppColors.danger), borderRadius: Corners.brMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 15, color: AppColors.danger),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Text(reason, style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class VerificationNote extends StatelessWidget {
  const VerificationNote({required this.icon, required this.message, this.actionLabel, this.onAction, super.key});

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: Corners.brLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
                if (actionLabel != null && onAction != null) ...[
                  const Gap.sm(),
                  GhostButton(label: actionLabel!, icon: Icons.refresh_rounded, dense: true, onPressed: onAction),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RejectReasonSheet extends StatefulWidget {
  const RejectReasonSheet({super.key});

  static Future<String?> show(BuildContext context, {required String name}) => AppSheet.show<String>(
    context,
    title: context.l10n.verifyRejectTitle(name),
    subtitle: context.l10n.verifyRejectSubtitle,
    child: const RejectReasonSheet(),
  );

  @override
  State<RejectReasonSheet> createState() => _RejectReasonSheetState();
}

class _RejectReasonSheetState extends State<RejectReasonSheet> {
  final TextEditingController _reason = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _submit() {
    final String reason = _reason.text.trim();
    if (reason.isEmpty) {
      setState(() => _error = context.l10n.verifyReasonRequired);
      return;
    }
    Navigator.of(context).pop(reason);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: context.l10n.verifyReason,
          hint: context.l10n.verifyReasonHint,
          controller: _reason,
          maxLines: 3,
          maxLength: 1000,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          errorText: _error,
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
        ),
        const Gap.lg(),
        PrimaryButton(
          label: context.l10n.verifyReject,
          icon: Icons.close_rounded,
          fillColor: AppColors.danger,
          onPressed: _submit,
        ),
        const Gap.md(),
      ],
    );
  }
}
