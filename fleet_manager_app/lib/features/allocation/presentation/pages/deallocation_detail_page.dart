import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../domain/entities/deallocation_request.dart';
import '../../domain/usecases/get_deallocation_request.dart';
import '../cubit/deallocation_detail_cubit.dart';
import '../widgets/allocation_widgets.dart';

class DeallocationDetailPage extends StatelessWidget {
  const DeallocationDetailPage({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeallocationDetailCubit(GetDeallocationRequest(sl()), requestId)..load(),
      child: const _DeallocationDetailView(),
    );
  }
}

class _DeallocationDetailView extends StatelessWidget {
  const _DeallocationDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeallocationDetailCubit, DeallocationDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            body: SafeArea(
              child: PageBody(children: const [
                ShimmerBox(height: 160, borderRadius: Corners.brLg),
                Gap.xl(),
                ShimmerBox(height: 140, borderRadius: Corners.brLg),
              ]),
            ),
          );
        }
        if (state.status == DeallocationDetailStatus.failure || state.request == null) {
          return AppScaffold(
            title: 'Return request',
            body: EmptyState(
              title: 'Could not load this return',
              message: state.message,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: 'Try again',
              onAction: () => context.read<DeallocationDetailCubit>().load(),
            ),
          );
        }
        return _Loaded(request: state.request!);
      },
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.request});

  final DeallocationRequest request;

  static const List<String> _handoverAngles = ['Left side', 'Right side', 'Front', 'Back'];

  @override
  Widget build(BuildContext context) {
    return HeroScaffold(
      bandColor: AppColors.ink,
      bottomPadding: 110,
      band: _Band(request: request),
      bottomNavigationBar: _Footer(
        onPressed: () => context.push('${Routes.deallocationFlow}?id=${request.id}'),
      ),
      children: [
          OverlapModuleCard(
            title: 'Rider',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KeyValueRow(
                  label: 'Mobile',
                  value: Fmt.phone(request.mobile),
                  icon: Icons.phone_rounded,
                  trailing: CircleIconButton(
                    icon: Icons.call_rounded,
                    size: 34,
                    iconSize: 16,

                    background: AppColors.primaryWash,
                    foreground: AppColors.primary,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      AppSnack.info(context, 'Calling ${Fmt.phone(request.mobile)}…');
                    },
                  ),
                ),
                KeyValueRow(label: 'Team lead', value: request.teamLead, icon: Icons.badge_rounded),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Vehicle',
            leading: const IconTile(icon: Icons.electric_scooter_rounded, tone: AppColors.primary, size: 28),
            child: Row(
              children: [
                const PhotoThumb(photo: BrandPhoto.fleet, size: 44),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.vehicleNumber, style: AppText.titleMedium.copyWith(fontSize: 15.5)),
                      const SizedBox(height: 2),
                      Text(request.model, style: AppText.bodySmall.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Return reason',
            leading: const IconTile(icon: Icons.info_outline_rounded, tone: AppColors.primary, size: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.reason, style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.45)),
                const SizedBox(height: Insets.md),
                Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
                const SizedBox(height: Insets.md),
                KeyValueRow(
                  label: 'Raised on',
                  value: Fmt.dateTime(request.raisedOn),
                  icon: Icons.schedule_rounded,
                ),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Original handover photos',
            leading: const IconTile(icon: Icons.photo_library_rounded, tone: AppColors.primary, solid: true, size: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compare the returned vehicle against this reference set',
                  style: AppText.bodySmall,
                ),
                const Gap.lg(),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: Insets.md,
                  mainAxisSpacing: Insets.md,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final angle in _handoverAngles)
                      PhotoSlot(label: angle, captured: true, onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.request});

  final DeallocationRequest request;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) => InkCircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
            const Spacer(),
            StatusChip(
              label: priorityLabel(request.priority),
              tone: priorityTone(request.priority),
              dense: true,
              solid: true,
            ),
          ],
        ),
        const Gap.xl(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppAvatar(name: request.riderName, size: 60),
            const SizedBox(width: Insets.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.riderName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.displaySmall.copyWith(fontSize: 22, color: AppColors.onInk),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${request.riderCode} · Lead ${request.teamLead}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap.lg(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: Insets.md, horizontal: Insets.sm),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkStat(
                  label: 'Vehicle',
                  value: request.vehicleNumber,
                  icon: Icons.electric_scooter_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Raised',
                  value: Fmt.relative(request.raisedOn),
                  icon: Icons.schedule_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.onPressed});

  final VoidCallback onPressed;

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
      child: PrimaryButton(
        label: 'Process return',
        icon: Icons.assignment_return_rounded,
        onPressed: onPressed,
      ),
    );
  }
}
