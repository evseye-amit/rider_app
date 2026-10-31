import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../allocation_dependencies.dart';

final workPartnersProvider = FutureProvider.autoDispose<List<WorkPartnerOption>>(
  (ref) async => (await ref.watch(getWorkPartnersProvider)(const NoParams())).getOrThrow(),
);

String workPartnerCategoryLabel(AppL10n l10n, String? category) => switch (category) {
  'FOOD_DELIVERY' => l10n.workPartnerFoodDelivery,
  'QUICK_COMMERCE' => l10n.workPartnerQuickCommerce,
  'ECOMMERCE' => l10n.workPartnerEcommerce,
  'PARCEL_LOGISTICS' => l10n.workPartnerParcelLogistics,
  'ON_DEMAND_LOGISTICS' => l10n.workPartnerOnDemandLogistics,
  'PHARMACY_HEALTHCARE' => l10n.workPartnerPharmacy,
  'SPECIALTY_DELIVERY' => l10n.workPartnerSpecialtyDelivery,
  final String value when value != null && value.isNotEmpty =>
    value
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' '),
  _ => l10n.commonOther,
};

class WorkPartnerPicker extends ConsumerStatefulWidget {
  const WorkPartnerPicker({this.selectedId, super.key});

  final String? selectedId;

  static Future<WorkPartnerOption?> show(BuildContext context, {String? selectedId}) =>
      AppSheet.show<WorkPartnerOption>(
        context,
        title: context.l10n.allocationChooseWorkPartner,
        subtitle: context.l10n.allocationWorkPartnerHelper,
        maxHeightFactor: 0.85,
        child: WorkPartnerPicker(selectedId: selectedId),
      );

  @override
  ConsumerState<WorkPartnerPicker> createState() => _WorkPartnerPickerState();
}

class _WorkPartnerPickerState extends ConsumerState<WorkPartnerPicker> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<WorkPartnerOption>> partners = ref.watch(workPartnersProvider);
    final List<WorkPartnerOption>? all = partners.value;
    final String query = _search.toLowerCase();
    final List<WorkPartnerOption>? items = all
        ?.where((partner) => query.isEmpty || partner.name.toLowerCase().contains(query))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSearchField(
          hint: context.l10n.allocationSearchWorkPartner,
          onChanged: (value) => setState(() => _search = value.trim()),
        ),
        const Gap.lg(),
        if (all == null && partners.hasError)
          EmptyState(
            title: context.l10n.allocationCouldNotLoadWorkPartners,
            message: partners.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(workPartnersProvider),
            compact: true,
          )
        else if (items == null)
          for (int i = 0; i < 4; i++) ...[const ShimmerBox(height: 60, borderRadius: Corners.brLg), const Gap.sm()]
        else if (items.isEmpty)
          EmptyState(
            title: context.l10n.allocationNoWorkPartners,
            message: context.l10n.allocationNoWorkPartnersMessage,
            icon: Icons.storefront_rounded,
            compact: true,
          )
        else
          for (final WorkPartnerOption partner in items) ...[
            AppRadioTile(
              selected: partner.id == widget.selectedId,
              onTap: () => Navigator.of(context).pop(partner),
              title: partner.name,
              subtitle: workPartnerCategoryLabel(context.l10n, partner.category),
              leading: AppAvatar(name: partner.name, size: 38),
            ),
            const Gap.sm(),
          ],
        const Gap.sm(),
      ],
    );
  }
}
