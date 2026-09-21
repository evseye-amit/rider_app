import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../../../app/di/injector.dart';

class _RiderDoc {
  const _RiderDoc({
    required this.label,
    required this.state,
    this.uploadedOn,
    this.expiresOn,
    this.rejectReason,
  });

  final String label;
  final UploadState state;
  final DateTime? uploadedOn;
  final DateTime? expiresOn;
  final String? rejectReason;
}

class _VehicleDoc {
  const _VehicleDoc({
    required this.label,
    required this.validTill,
    required this.status,
  });

  final String label;
  final DateTime validTill;
  final String status;
}

/// Every document that gates the rider's account — KYC on the rider, then
/// registration paperwork on the vehicle allocated to them. Grouped under
/// icon-led section headers so the two very different kinds of paperwork
/// (yours vs. the vehicle's) read as distinct groups rather than one long list.
class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  // Rider KYC has no dedicated JSON in this build; it is authored here from
  // the same onboarding facts `rider_profile.json` implies (Aadhaar, PAN,
  // licence and bank all cleared before allocation was granted).
  static final List<_RiderDoc> _riderDocs = [
    _RiderDoc(
      label: 'Aadhaar card',
      state: UploadState.uploaded,
      uploadedOn: DateTime(2025, 3, 12),
    ),
    _RiderDoc(
      label: 'PAN card',
      state: UploadState.uploaded,
      uploadedOn: DateTime(2025, 3, 12),
    ),
    _RiderDoc(
      label: 'Driving licence',
      state: UploadState.uploaded,
      uploadedOn: DateTime(2025, 3, 13),
      expiresOn: DateTime(2031, 6, 4),
    ),
    _RiderDoc(
      label: 'Bank account proof',
      state: UploadState.rejected,
      uploadedOn: DateTime(2025, 3, 14),
      rejectReason: 'Cancelled cheque was blurry — reupload a clear photo',
    ),
    _RiderDoc(
      label: 'Address proof',
      state: UploadState.uploaded,
      uploadedOn: DateTime(2025, 3, 14),
    ),
    _RiderDoc(
      label: 'Profile photo',
      state: UploadState.uploaded,
      uploadedOn: DateTime(2025, 3, 12),
    ),
  ];

  late final Future<List<_VehicleDoc>> _vehicleDocs = _loadVehicleDocs();

  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  int _filterIndex = 0;
  static const List<String> _filters = ['All', 'Needs attention'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _riderMatches(_RiderDoc d) {
    final bool matchesQuery = _query.isEmpty || d.label.toLowerCase().contains(_query);
    final bool matchesFilter = _filterIndex == 0 || d.state == UploadState.rejected;
    return matchesQuery && matchesFilter;
  }

  bool _vehicleMatches(_VehicleDoc d) {
    final bool matchesQuery = _query.isEmpty || d.label.toLowerCase().contains(_query);
    final bool matchesFilter = _filterIndex == 0 || d.status == 'expiring';
    return matchesQuery && matchesFilter;
  }

  Future<List<_VehicleDoc>> _loadVehicleDocs() async {
    final Map<String, dynamic> data = await sl<UiConfigService>().loadRaw(
      'scooter_data',
    );
    return (data['documents'] as List<dynamic>? ?? const [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .map(
          (m) => _VehicleDoc(
            label: m['label'] as String? ?? '',
            validTill:
                DateTime.tryParse(m['validTill']?.toString() ?? '') ??
                DateTime.now(),
            status: m['status'] as String? ?? 'valid',
          ),
        )
        .toList();
  }

  Future<void> _preview(
    BuildContext context,
    String label, {
    DateTime? expiresOn,
  }) {
    return AppSheet.show<void>(
      context,
      title: label,
      subtitle: expiresOn == null
          ? 'Document preview'
          : 'Valid till ${Fmt.date(expiresOn)}',
      footer: Row(
        children: [
          Expanded(
            child: SecondaryButton(
              label: 'Replace',
              icon: Icons.autorenew_rounded,
              onPressed: () {
                Navigator.of(context).pop();
                AppSnack.info(context, 'Pick a new photo or PDF for $label.');
              },
            ),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: PrimaryButton(
              label: 'Download',
              icon: Icons.download_rounded,
              onPressed: () {
                Navigator.of(context).pop();
                AppSnack.success(context, '$label saved to your downloads.');
              },
            ),
          ),
        ],
      ),
      child: Container(
        height: 200,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: Corners.brLg,
          border: Border.all(color: AppColors.stroke),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.description_rounded,
              size: 40,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: Insets.md),
            Text(
              'Preview not available offline',
              style: AppText.bodySmall.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'My documents',
      subtitle: 'KYC on you, and paperwork on your scooter',
      body: PageBody(
        children: [
          AppSearchField(
            hint: 'Search documents',
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
          ),
          const Gap.md(),
          FilterChipBar(
            items: _filters,
            selectedIndex: _filterIndex,
            onChanged: (i) => setState(() => _filterIndex = i),
            padding: EdgeInsets.zero,
          ),
          const Gap.lg(),

          Builder(
            builder: (context) {
              final List<_RiderDoc> riderDocs =
                  _riderDocs.where(_riderMatches).toList();
              if (riderDocs.isEmpty) return const SizedBox.shrink();
              return ModuleCard(
                leading: const IconTile(
                  icon: Icons.badge_rounded,
                  tone: AppColors.primary,
                  size: 34,
                  solid: true,
                ),
                title: 'Your KYC',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verified once, before your first allocation',
                      style: AppText.bodySmall.copyWith(fontSize: 12),
                    ),
                    const Gap.lg(),
                    for (final doc in riderDocs) ...[
                      UploadTile(
                        label: doc.label,
                        state: doc.state,
                        fileName: doc.uploadedOn == null
                            ? null
                            : 'Uploaded ${Fmt.date(doc.uploadedOn!)}',
                        rejectReason: doc.rejectReason,
                        required: true,
                        onTap: () => doc.state == UploadState.rejected
                            ? AppSnack.warning(
                                context,
                                'Upload a fresh photo of your ${doc.label.toLowerCase()}.',
                              )
                            : _preview(context, doc.label, expiresOn: doc.expiresOn),
                      ),
                      if (doc.expiresOn != null &&
                          doc.state == UploadState.uploaded) ...[
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: Insets.md + 2),
                          child: Text(
                            'Expires ${Fmt.date(doc.expiresOn!)}',
                            style: AppText.bodySmall.copyWith(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                      if (doc != riderDocs.last) const Gap.md(),
                    ],
                  ],
                ),
              );
            },
          ),
          const Gap.lg(),

          FutureBuilder<List<_VehicleDoc>>(
            future: _vehicleDocs,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return ModuleCard(
                  leading: const IconTile(
                    icon: Icons.two_wheeler_rounded,
                    tone: AppColors.primary,
                    size: 34,
                    solid: true,
                  ),
                  title: 'Vehicle documents',
                  child: Column(
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: EdgeInsets.only(bottom: i == 2 ? 0 : Insets.md),
                        child: const ShimmerBox(
                          height: 76,
                          borderRadius: Corners.brMd,
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return ModuleCard(
                  leading: const IconTile(
                    icon: Icons.two_wheeler_rounded,
                    tone: AppColors.primary,
                    size: 34,
                    solid: true,
                  ),
                  title: 'Vehicle documents',
                  child: const EmptyState(
                    compact: true,
                    title: 'Vehicle documents unavailable',
                    icon: Icons.description_outlined,
                  ),
                );
              }
              final List<_VehicleDoc> docs =
                  snapshot.data!.where(_vehicleMatches).toList();
              if (docs.isEmpty) return const SizedBox.shrink();
              final bool anyExpiring = docs.any((d) => d.status == 'expiring');
              return ModuleCard(
                leading: const IconTile(
                  icon: Icons.two_wheeler_rounded,
                  tone: AppColors.primary,
                  size: 34,
                  solid: true,
                ),
                title: 'Vehicle documents',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registration paperwork on the scooter allocated to you',
                      style: AppText.bodySmall.copyWith(fontSize: 12),
                    ),
                    const Gap.lg(),
                    if (anyExpiring) ...[
                      const _ExpiringBanner(),
                      const Gap.md(),
                    ],
                    for (final doc in docs) ...[
                      _VehicleDocRow(
                        doc: doc,
                        onTap: () => _preview(
                          context,
                          doc.label,
                          expiresOn: doc.validTill,
                        ),
                      ),
                      if (doc != docs.last) const Gap.md(),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// A loud banner above the vehicle documents whenever one of them needs
/// attention soon — the failure mode being fixed is a warning that reads no
/// differently from a plain "valid" row.
class _ExpiringBanner extends StatelessWidget {
  const _ExpiringBanner();

  @override
  Widget build(BuildContext context) {
    return AccentCard(
      accent: AppColors.warning,
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: AppColors.warning,
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Text(
              'One document is expiring soon — renew it to keep your vehicle roadworthy.',
              style: AppText.bodySmall.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.warning,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleDocRow extends StatelessWidget {
  const _VehicleDocRow({required this.doc, required this.onTap});

  final _VehicleDoc doc;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool expiring = doc.status == 'expiring';
    final Color tone = expiring ? AppColors.warning : AppColors.success;

    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.all(Insets.md + 2),
        decoration: BoxDecoration(
          color: expiring ? AppColors.washFor(tone) : AppColors.surfaceMuted,
          borderRadius: Corners.brLg,
          border: expiring
              ? Border.all(color: tone.withValues(alpha: 0.4), width: 1.4)
              : null,
        ),
        child: Row(
          children: [
            IconTile(
              icon: expiring
                  ? Icons.warning_amber_rounded
                  : Icons.assignment_turned_in_rounded,
              // A solid fill needs the saturated accent, not the text-tuned
              // `warning` — that goes muddy brown when it fills a whole tile.
              tone: expiring ? AppColors.amber : tone,
              size: 42,
              solid: expiring,
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(fontSize: 13.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    expiring
                        ? 'Renew before ${Fmt.date(doc.validTill)}'
                        : 'Valid till ${Fmt.date(doc.validTill)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(
                      fontSize: 11.5,
                      color: expiring
                          ? AppColors.warning
                          : AppColors.textSecondary,
                      fontWeight: expiring ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            StatusChip(
              label: expiring ? 'Expiring' : 'Valid',
              tone: expiring ? StatusTone.warning : StatusTone.success,
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}
