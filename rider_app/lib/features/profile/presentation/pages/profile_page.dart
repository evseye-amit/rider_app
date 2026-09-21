import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/session/session_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final SessionController session = sl<SessionController>();
    final Map<String, Object?> r = session.profile;

    final String name = r['name']?.toString() ?? 'Rider';
    final String riderCode = r['riderCode']?.toString() ?? '—';
    final num rating = (r['rating'] as num?) ?? 0;
    final DateTime? joinedOn = DateTime.tryParse(
      r['joinedOn']?.toString() ?? '',
    );
    return HeroScaffold(
      bottomPadding: Insets.x4l,
      band: _Band(
        name: name,
        riderCode: riderCode,
        rating: rating,
      ),
      children: [
        _SectionCard(
          icon: Icons.badge_rounded,
          tone: AppColors.primary,
          title: 'Personal details',
          rows: [
            _DetailRow(label: 'Full name', value: name),
            _DetailRow(
              label: 'Mobile',
              value: Fmt.phone(r['mobile']?.toString() ?? ''),
            ),

            _DetailRow(label: 'Email', value: r['email']?.toString() ?? '—'),
            _DetailRow(
              label: 'Joined on',
              value: joinedOn == null ? '—' : Fmt.date(joinedOn),
            ),
          ],
        ),
        const Gap.lg(),

        _SectionCard(
          icon: Icons.location_on_rounded,
          tone: AppColors.primary,
          title: 'Address & hub',
          rows: [
            _DetailRow(label: 'City', value: r['city']?.toString() ?? '—'),
            _DetailRow(label: 'Hub', value: r['hub']?.toString() ?? '—'),
            _DetailRow(
              label: 'Hub code',
              value: r['hubCode']?.toString() ?? '—',
            ),
          ],
        ),
        const Gap.lg(),

        ModuleCard(
          title: 'Team lead',
          child: Row(
            children: [
              AppAvatar(name: r['teamLead']?.toString() ?? '?', size: 44),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r['teamLead']?.toString() ?? '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleSmall.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Fmt.phone(r['teamLeadMobile']?.toString() ?? ''),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySmall.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Insets.sm),
              CircleIconButton(
                icon: Icons.call_rounded,
                size: 40,
                iconSize: 18,
                background: AppColors.primaryWash,
                foreground: AppColors.primary,
                borderColor: Colors.transparent,
                onTap: () =>
                    AppSnack.success(context, 'Calling ${r['teamLead']}…'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({
    required this.name,
    required this.riderCode,
    required this.rating,
  });

  final String name;
  final String riderCode;
  final num rating;

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
            Text(
              'Profile',
              style: AppText.titleLarge.copyWith(
                fontSize: 17,
                color: AppColors.onInk,
              ),
            ),
            const Spacer(),

            const SizedBox(width: 40),
          ],
        ),
        const Gap.xl(),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.white24, width: 1.4),
                    ),
                  ),
                  child: AppAvatar(name: name, size: 72),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: const BoxDecoration(
                      color: AppColors.ink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_rounded,
                      size: 20,
                      color: AppColors.mint,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: Insets.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.displaySmall.copyWith(
                      fontSize: 21,
                      color: AppColors.onInk,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    riderCode,
                    style: AppText.code.copyWith(
                      fontSize: 11.5,
                      letterSpacing: 1.2,
                      color: AppColors.onInkSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${rating.toStringAsFixed(1)} rating',
                        style: AppText.bodySmall.copyWith(
                          fontSize: 12,
                          color: AppColors.onInkSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.tone,
    required this.title,
    required this.rows,
  });

  final IconData icon;
  final Color tone;
  final String title;
  final List<_DetailRow> rows;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: title,
      leading: IconTile(icon: icon, tone: tone, size: 34, solid: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: AppText.bodySmall.copyWith(fontSize: 13)),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyMedium.copyWith(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
