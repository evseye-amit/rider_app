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
    final DateTime? uploaded = document.uploadedAt;
    final bool canView = !busy && document.photoId != null;
    return _ReviewCard(
      leading: Pressable(
        onTap: canView ? onView : null,
        scale: 0.96,
        child: IconTile(
          icon: document.isPdf ? Icons.picture_as_pdf_rounded : Icons.description_rounded,
          tone: AppColors.primary,
          size: 40,
        ),
      ),
      title: document.title,
      subtitle: uploaded == null ? null : context.l10n.verifyUploadedOn(Fmt.date(uploaded)),
      status: document.status,
      reason: document.status == ReviewStatus.rejected ? document.rejectionReason : null,
      actions: [
        _ReviewAction(
          icon: Icons.visibility_rounded,
          label: context.l10n.verifyView,
          color: AppColors.primary,
          onTap: canView ? onView : null,
        ),
        if (document.status == ReviewStatus.pending) ..._decisions(context, busy, onApprove, onReject),
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
    final String details = [
      reference.relation,
      Fmt.phone(reference.mobile),
    ].where((part) => part.isNotEmpty).join(' · ');
    return _ReviewCard(
      leading: AppAvatar(name: reference.name, size: 40),
      title: reference.name,
      subtitle: details.isEmpty ? null : details,
      note: reviewer != null && reviewer.isNotEmpty && reference.status != ReviewStatus.pending
          ? context.l10n.verifyReviewedBy(reviewer)
          : null,
      status: reference.status,
      reason: reference.status == ReviewStatus.rejected ? reference.rejectionReason : null,
      actions: [
        _ReviewAction(
          icon: Icons.call_rounded,
          label: context.l10n.ridersCall,
          color: AppColors.primary,
          onTap: reference.mobile.isEmpty ? null : onCall,
        ),
        if (reference.status == ReviewStatus.pending) ..._decisions(context, busy, onApprove, onReject),
      ],
    );
  }
}

List<Widget> _decisions(BuildContext context, bool busy, VoidCallback onApprove, VoidCallback onReject) => [
  _ReviewAction(
    icon: Icons.close_rounded,
    label: context.l10n.verifyReject,
    color: AppColors.danger,
    onTap: busy ? null : onReject,
  ),
  _ReviewAction(
    icon: Icons.check_rounded,
    label: context.l10n.verifyApprove,
    color: AppColors.success,
    loading: busy,
    onTap: busy ? null : onApprove,
  ),
];

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.leading,
    required this.title,
    required this.status,
    required this.actions,
    this.subtitle,
    this.note,
    this.reason,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final String? note;
  final ReviewStatus status;
  final String? reason;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final String? subtitle = this.subtitle;
    final String? note = this.note;
    final String? reason = this.reason;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.brLg,
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(Insets.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    leading,
                    const SizedBox(width: Insets.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.titleSmall.copyWith(fontSize: 14),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                          if (note != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              note,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: Insets.sm),
                    ReviewStatusChip(status: status),
                  ],
                ),
                if (reason != null && reason.isNotEmpty) ...[const Gap.sm(), _ReasonNote(reason: reason)],
              ],
            ),
          ),
          DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.stroke)),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  for (int i = 0; i < actions.length; i++) ...[
                    if (i > 0) const VerticalDivider(width: 1, thickness: 1, color: AppColors.stroke),
                    Expanded(child: actions[i]),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewAction extends StatelessWidget {
  const _ReviewAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.loading = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final Color tone = onTap == null && !loading ? AppColors.textMuted : color;
    return Pressable(
      onTap: onTap,
      scale: 0.97,
      child: Container(
        height: 44,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: Insets.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2, color: tone))
            else
              Icon(icon, size: 17, color: tone),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.titleSmall.copyWith(fontSize: 13, color: tone),
              ),
            ),
          ],
        ),
      ),
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
