import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/router/app_routes.dart';
import '../../allocation_dependencies.dart';
import '../../domain/entities/rider_verification.dart';
import '../../domain/usecases/rider_verification_usecases.dart';
import '../providers/rider_verification_providers.dart';
import '../widgets/allocation_widgets.dart';
import '../widgets/rider_verification_widgets.dart';

class RiderVerificationPage extends ConsumerStatefulWidget {
  const RiderVerificationPage({required this.riderId, super.key});

  final String riderId;

  @override
  ConsumerState<RiderVerificationPage> createState() => _RiderVerificationPageState();
}

class _RiderVerificationPageState extends ConsumerState<RiderVerificationPage> {
  String? _busyId;

  Future<void> _refresh() => Future.wait([
    ref.refreshQuietly(riderDocumentsProvider(widget.riderId)),
    ref.refreshQuietly(riderReferencesProvider(widget.riderId)),
  ]);

  Future<void> _view(RiderDocument document) async {
    final String? photoId = document.photoId;
    if (photoId == null || _busyId != null) return;
    setState(() => _busyId = document.id);
    final Result<String> result = await ref.read(getPhotoUrlProvider)(photoId);
    if (!mounted) return;
    setState(() => _busyId = null);
    switch (result) {
      case Ok<String>(:final value) when value.isNotEmpty:
        if (!document.isPdf) {
          final bool? approve = await PhotoViewer.card<bool>(
            context,
            value,
            title: document.title,
            actions: document.status == ReviewStatus.pending
                ? [
                    PhotoCardAction(
                      label: context.l10n.verifyReject,
                      value: false,
                      icon: Icons.close_rounded,
                      color: AppColors.danger,
                    ),
                    PhotoCardAction(
                      label: context.l10n.verifyApprove,
                      value: true,
                      icon: Icons.check_rounded,
                      color: AppColors.success,
                      primary: true,
                    ),
                  ]
                : const [],
          );
          if (approve != null && mounted) {
            await _review(
              id: document.id,
              name: document.title,
              approve: approve,
              document: true,
              confirmApprove: false,
            );
          }
          return;
        }
        final bool opened = await launchUrl(Uri.parse(value), mode: LaunchMode.externalApplication);
        if (!opened && mounted) AppSnack.error(context, context.l10n.commonCouldNotOpenDocumentTry);
      case Ok<String>():
        AppSnack.error(context, context.l10n.commonCouldNotOpenDocumentTry);
      case Err<String>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  Future<void> _call(RiderReference reference) async {
    final bool opened = await launchUrl(Uri(scheme: 'tel', path: reference.mobile));
    if (!opened && mounted) AppSnack.error(context, context.l10n.verifyCouldNotCall);
  }

  Future<void> _review({
    required String id,
    required String name,
    required bool approve,
    required bool document,
    bool confirmApprove = true,
  }) async {
    String? reason;
    if (approve) {
      if (confirmApprove) {
        final bool confirmed = await AppDialog.confirm(
          context,
          title: document ? context.l10n.verifyApproveDocument : context.l10n.verifyApproveReference,
          message: context.l10n.verifyApproveMessage(name),
          confirmLabel: context.l10n.verifyApprove,
          icon: Icons.verified_rounded,
          tone: AppColors.success,
        );
        if (!confirmed) return;
      }
    } else {
      reason = await RejectReasonSheet.show(context, name: name);
      if (reason == null) return;
    }
    if (!mounted) return;

    setState(() => _busyId = id);
    final ReviewParams params = ReviewParams(id: id, approve: approve, reason: reason);
    final Result<void> result = document
        ? await ref.read(reviewRiderDocumentProvider)(params)
        : await ref.read(reviewRiderReferenceProvider)(params);
    if (!mounted) return;
    setState(() => _busyId = null);

    if (document) {
      ref.invalidate(riderDocumentsProvider(widget.riderId));
    } else {
      ref.invalidate(riderReferencesProvider(widget.riderId));
    }
    switch (result) {
      case Ok<void>():
        AppSnack.success(context, switch ((document, approve)) {
          (true, true) => context.l10n.verifyDocumentApproved,
          (true, false) => context.l10n.verifyDocumentRejected,
          (false, true) => context.l10n.verifyReferenceApproved,
          (false, false) => context.l10n.verifyReferenceRejected,
        });
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final VerificationRider? rider = ref.watch(verificationRiderProvider(widget.riderId)).value;
    final AsyncValue<List<RiderDocument>> documents = ref.watch(riderDocumentsProvider(widget.riderId));
    final AsyncValue<List<RiderReference>> references = ref.watch(riderReferencesProvider(widget.riderId));

    final List<RiderDocument>? loaded = documents.value;
    final bool waitingOnDocuments = loaded != null && loaded.any((d) => d.status != ReviewStatus.approved);
    final bool canContinue = !waitingOnDocuments && (loaded != null || documents.hasError);

    return HeroScaffold(
      bandColor: AppColors.ink,
      bottomPadding: 150,
      onRefresh: _refresh,
      band: _Band(rider: rider),
      bottomNavigationBar: _Footer(
        blockedMessage: waitingOnDocuments ? context.l10n.verifyApproveAllFirst : null,
        onContinue: canContinue ? () => context.push('${Routes.assignVehicle}?rider=${widget.riderId}') : null,
      ),
      children: [
        OverlapModuleCard(
          title: context.l10n.verifyDocuments,
          child: _Documents(
            documents: documents,
            busyId: _busyId,
            onRetry: () => ref.invalidate(riderDocumentsProvider(widget.riderId)),
            onView: _view,
            onReview: (document, approve) =>
                _review(id: document.id, name: document.title, approve: approve, document: true),
          ),
        ),
        const Gap.lg(),
        ModuleCard(
          title: context.l10n.verifyReferences,
          leading: const IconTile(icon: Icons.contact_phone_rounded, solid: true, size: 28),
          child: _References(
            references: references,
            busyId: _busyId,
            onRetry: () => ref.invalidate(riderReferencesProvider(widget.riderId)),
            onCall: _call,
            onReview: (reference, approve) =>
                _review(id: reference.id, name: reference.name, approve: approve, document: false),
          ),
        ),
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.rider});

  final VerificationRider? rider;

  @override
  Widget build(BuildContext context) {
    final VerificationRider? current = rider;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) =>
              InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
        ),
        const Gap.lg(),
        PhotoPanel(
          photo: BrandPhoto.rider,
          height: 132,
          title: context.l10n.verifyTitle,
          subtitle: current == null
              ? '—'
              : [
                  current.name,
                  if ((current.riderCode ?? '').isNotEmpty) current.riderCode!,
                  if (current.mobile.isNotEmpty) Fmt.phone(current.mobile),
                ].join(' · '),
        ),
      ],
    );
  }
}

class _Documents extends StatelessWidget {
  const _Documents({
    required this.documents,
    required this.busyId,
    required this.onRetry,
    required this.onView,
    required this.onReview,
  });

  final AsyncValue<List<RiderDocument>> documents;
  final String? busyId;
  final VoidCallback onRetry;
  final ValueChanged<RiderDocument> onView;
  final void Function(RiderDocument document, bool approve) onReview;

  @override
  Widget build(BuildContext context) {
    final List<RiderDocument>? value = documents.value;
    final Widget body = switch (documents) {
      _ when value != null && value.isEmpty => VerificationNote(
        icon: Icons.description_outlined,
        message: context.l10n.verifyNoDocuments,
      ),
      _ when value != null => Column(
        children: [
          for (final RiderDocument document in value) ...[
            DocumentReviewTile(
              document: document,
              busy: busyId == document.id,
              onView: () => onView(document),
              onApprove: () => onReview(document, true),
              onReject: () => onReview(document, false),
            ),
            if (document != value.last) const Gap.md(),
          ],
        ],
      ),
      AsyncError(:final error) when error is ForbiddenFailure => VerificationNote(
        icon: Icons.lock_outline_rounded,
        message: context.l10n.verifyDocumentsLocked,
      ),
      AsyncError() => VerificationNote(
        icon: Icons.cloud_off_rounded,
        message: documents.failureMessage ?? context.l10n.verifyCouldNotLoad,
        actionLabel: context.l10n.commonTryAgain,
        onAction: onRetry,
      ),
      _ => const _Loading(),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.verifyDocumentsHint,
          style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45, color: AppColors.textMuted),
        ),
        const Gap.md(),
        body,
      ],
    );
  }
}

class _References extends StatelessWidget {
  const _References({
    required this.references,
    required this.busyId,
    required this.onRetry,
    required this.onCall,
    required this.onReview,
  });

  final AsyncValue<List<RiderReference>> references;
  final String? busyId;
  final VoidCallback onRetry;
  final ValueChanged<RiderReference> onCall;
  final void Function(RiderReference reference, bool approve) onReview;

  @override
  Widget build(BuildContext context) {
    final List<RiderReference>? value = references.value;
    final Widget body = switch (references) {
      _ when value != null && value.isEmpty => VerificationNote(
        icon: Icons.person_search_rounded,
        message: context.l10n.verifyNoReferences,
      ),
      _ when value != null => Column(
        children: [
          for (final RiderReference reference in value) ...[
            ReferenceReviewTile(
              reference: reference,
              busy: busyId == reference.id,
              onCall: () => onCall(reference),
              onApprove: () => onReview(reference, true),
              onReject: () => onReview(reference, false),
            ),
            if (reference != value.last) const Gap.md(),
          ],
        ],
      ),
      AsyncError() => VerificationNote(
        icon: Icons.cloud_off_rounded,
        message: references.failureMessage ?? context.l10n.verifyCouldNotLoad,
        actionLabel: context.l10n.commonTryAgain,
        onAction: onRetry,
      ),
      _ => const _Loading(),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.verifyReferencesHint,
          style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45, color: AppColors.textMuted),
        ),
        const Gap.md(),
        body,
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(height: 116, borderRadius: Corners.brLg),
        Gap.md(),
        ShimmerBox(height: 116, borderRadius: Corners.brLg),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.blockedMessage, required this.onContinue});

  final String? blockedMessage;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Insets.gutter,
        Insets.md,
        Insets.gutter,
        MediaQuery.paddingOf(context).bottom + Insets.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(top: BorderSide(color: AppColors.stroke)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (blockedMessage != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.textMuted),
                const SizedBox(width: Insets.sm - 2),
                Flexible(
                  child: Text(
                    blockedMessage!,
                    textAlign: TextAlign.center,
                    style: AppText.bodySmall.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
            const Gap.sm(),
          ],
          PrimaryButton(
            label: context.l10n.verifyContinue,
            trailingIcon: Icons.arrow_forward_rounded,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}
