import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/session/session_controller.dart';

const List<String> _languages = [
  'English',
  'हिंदी (Hindi)',
  'ਪੰਜਾਬੀ (Punjabi)',
  'বাংলা (Bengali)',
];
const List<String> _navApps = ['Google Maps', 'Ola Maps', 'Waze'];

/// Real, plausible settings, grouped the way a rider actually thinks about
/// them. Nothing here is persisted — it is local state for the session, as
/// the brief calls for.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _language = _languages.first;
  String _navApp = _navApps.first;

  bool _pushEnabled = true;
  bool _smsEnabled = true;
  bool _whatsappEnabled = false;
  bool _earningsAlerts = true;
  bool _serviceReminders = true;

  bool _autoStartOnAttendance = false;
  double _lowBatteryThreshold = 20;

  bool _locationSharing = true;
  bool _appLock = false;

  Future<void> _pickLanguage() async {
    final String? picked = await AppSheet.show<String>(
      context,
      title: 'App language',
      child: Column(
        children: [
          for (final lang in _languages) ...[
            AppRadioTile(
              selected: lang == _language,
              onTap: () => Navigator.of(context).pop(lang),
              title: lang,
            ),
            if (lang != _languages.last) const Gap.sm(),
          ],
        ],
      ),
    );
    if (picked != null) setState(() => _language = picked);
  }

  Future<void> _pickNavApp() async {
    final String? picked = await AppSheet.show<String>(
      context,
      title: 'Navigation app',
      subtitle: 'Used when you tap directions to a rider or hub',
      child: Column(
        children: [
          for (final app in _navApps) ...[
            AppRadioTile(
              selected: app == _navApp,
              onTap: () => Navigator.of(context).pop(app),
              title: app,
            ),
            if (app != _navApps.last) const Gap.sm(),
          ],
        ],
      ),
    );
    if (picked != null) setState(() => _navApp = picked);
  }

  Future<void> _requestDataDownload() async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: 'Request a data download?',
      message:
          'We will email a copy of your profile, trips and payout history to your registered '
          'address within 48 hours.',
      confirmLabel: 'Request',
      icon: Icons.download_rounded,
    );
    if (!confirmed || !mounted) return;
    AppSnack.success(context, 'Your data export has been requested.');
  }

  Future<void> _changePin() async {
    await AppSheet.show<void>(
      context,
      title: 'Change app PIN',
      subtitle: 'You will need your current PIN to set a new one',
      footer: PrimaryButton(
        label: 'Update PIN',
        onPressed: () {
          Navigator.of(context).pop();
          AppSnack.success(context, 'App PIN updated.');
        },
      ),
      child: const Column(
        children: [
          AppTextField(
            label: 'Current PIN',
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
          ),
          Gap.lg(),
          AppTextField(
            label: 'New PIN',
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
          ),
          Gap.lg(),
        ],
      ),
    );
  }

  Future<void> _deactivate(BuildContext context) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: 'Deactivate your account?',
      message:
          'You will stop receiving allocations and your vehicle access ends immediately. This '
          'can be reversed by contacting your hub within 30 days.',
      confirmLabel: 'Deactivate',
      icon: Icons.no_accounts_rounded,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    AppSnack.warning(
      context,
      'Deactivation request submitted. Your hub will reach out shortly.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final SessionController session = sl<SessionController>();
    final String mobile = session.profile['mobile']?.toString() ?? '';
    final String email = session.profile['email']?.toString() ?? '';

    return AppScaffold(
      title: 'Settings',
      subtitle: 'Language, alerts, ride behaviour and privacy',
      body: PageBody(
        children: [
          ModuleCard(
            title: 'Account',
            leading: const IconTile(
              icon: Icons.badge_rounded,
              tone: AppColors.primary,
              size: 34,
              solid: true,
            ),
            child: Column(
              children: [
                AppNavTile(
                  icon: Icons.translate_rounded,
                  title: 'Language',
                  subtitle: _language,
                  onTap: _pickLanguage,
                  padding: const EdgeInsets.symmetric(vertical: Insets.md + 2),
                ),
                Divider(
                  color: AppColors.stroke.withValues(alpha: 0.5),
                  height: 1,
                ),
                AppNavTile(
                  icon: Icons.call_rounded,
                  title: 'Mobile number',
                  subtitle: mobile.isEmpty ? '—' : Fmt.phone(mobile),
                  showChevron: false,
                  padding: const EdgeInsets.symmetric(vertical: Insets.md + 2),
                ),
                Divider(
                  color: AppColors.stroke.withValues(alpha: 0.5),
                  height: 1,
                ),
                AppNavTile(
                  icon: Icons.mail_rounded,
                  title: 'Email address',
                  subtitle: email.isEmpty ? '—' : email,
                  showChevron: false,
                  padding: const EdgeInsets.symmetric(vertical: Insets.md + 2),
                ),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Notifications',
            leading: const IconTile(
              icon: Icons.notifications_active_rounded,
              tone: AppColors.primary,
              size: 34,
              solid: true,
            ),
            child: Column(
              children: [
                _SwitchRow(
                  title: 'Push notifications',
                  subtitle: 'Earnings, tickets and hub updates',
                  value: _pushEnabled,
                  onChanged: (v) => setState(() => _pushEnabled = v),
                ),
                _SwitchRow(
                  title: 'SMS alerts',
                  subtitle: 'For riders with low data usage',
                  value: _smsEnabled,
                  onChanged: (v) => setState(() => _smsEnabled = v),
                ),
                _SwitchRow(
                  title: 'WhatsApp updates',
                  subtitle: 'Daily summary at the end of your shift',
                  value: _whatsappEnabled,
                  onChanged: (v) => setState(() => _whatsappEnabled = v),
                ),
                _SwitchRow(
                  title: 'Earnings alerts',
                  subtitle: 'When a payout settles to your wallet',
                  value: _earningsAlerts,
                  onChanged: (v) => setState(() => _earningsAlerts = v),
                ),
                _SwitchRow(
                  title: 'Service reminders',
                  subtitle: 'Before your scooter is due for a check-up',
                  value: _serviceReminders,
                  onChanged: (v) => setState(() => _serviceReminders = v),
                  isLast: true,
                ),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Ride',
            leading: const IconTile(
              icon: Icons.two_wheeler_rounded,
              tone: AppColors.primary,
              size: 34,
              solid: true,
            ),
            child: Column(
              children: [
                _SwitchRow(
                  title: 'Auto-start on attendance',
                  subtitle: 'Switch the vehicle on the moment you mark present',
                  value: _autoStartOnAttendance,
                  onChanged: (v) => setState(() => _autoStartOnAttendance = v),
                  isLast: true,
                ),
                const Divider(color: AppColors.stroke, height: Insets.xxl),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Low battery alert',
                        style: AppText.titleSmall.copyWith(fontSize: 13.5),
                      ),
                    ),
                    Text(
                      '${_lowBatteryThreshold.round()}%',
                      style: AppText.numericSmall.copyWith(
                        fontSize: 14,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'We warn you when charge drops below this',
                  style: AppText.bodySmall.copyWith(fontSize: 11.5),
                ),
                const SizedBox(height: Insets.sm),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.warning,
                    inactiveTrackColor: AppColors.surfaceSunken,
                    thumbColor: AppColors.warning,
                    overlayColor: AppColors.warning.withValues(alpha: 0.16),
                  ),
                  child: Slider(
                    value: _lowBatteryThreshold,
                    min: 5,
                    max: 40,
                    divisions: 7,
                    onChanged: (v) => setState(() => _lowBatteryThreshold = v),
                  ),
                ),
                const Divider(color: AppColors.stroke, height: Insets.xxl),
                AppNavTile(
                  icon: Icons.map_rounded,
                  title: 'Navigation app',
                  subtitle: _navApp,
                  onTap: _pickNavApp,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Privacy',
            leading: const IconTile(
              icon: Icons.privacy_tip_rounded,
              tone: AppColors.primary,
              size: 34,
              solid: true,
            ),
            child: Column(
              children: [
                _SwitchRow(
                  title: 'Location sharing',
                  subtitle:
                      'Only recorded while the vehicle is switched on, for safety and service '
                      'scheduling. Turning this off disables the vehicle.',
                  value: _locationSharing,
                  onChanged: (v) => setState(() => _locationSharing = v),
                  isLast: true,
                ),
                const Divider(color: AppColors.stroke, height: Insets.xxl),
                AppNavTile(
                  icon: Icons.download_for_offline_rounded,
                  title: 'Request a data download',
                  subtitle: 'A copy of your profile, trips and payouts by email',
                  onTap: _requestDataDownload,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Security',
            leading: const IconTile(
              icon: Icons.lock_rounded,
              tone: AppColors.primary,
              size: 34,
              solid: true,
            ),
            child: Column(
              children: [
                _SwitchRow(
                  title: 'App lock',
                  subtitle: 'Require your PIN every time you open the app',
                  value: _appLock,
                  onChanged: (v) => setState(() => _appLock = v),
                  isLast: true,
                ),
                const Divider(color: AppColors.stroke, height: Insets.xxl),
                AppNavTile(
                  icon: Icons.lock_reset_rounded,
                  title: 'Change PIN',
                  onTap: _changePin,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Legal',
            leading: const IconTile(
              icon: Icons.gavel_rounded,
              tone: AppColors.primary,
              size: 34,
              solid: true,
            ),
            child: Column(
              children: [
                AppNavTile(
                  icon: Icons.gavel_rounded,
                  title: 'Terms of service',
                  onTap: () => context.push(Routes.terms),
                  padding: const EdgeInsets.symmetric(vertical: Insets.md + 2),
                ),
                Divider(
                  color: AppColors.stroke.withValues(alpha: 0.5),
                  height: 1,
                ),
                AppNavTile(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy policy',
                  onTap: () => context.push(Routes.privacy),
                  padding: const EdgeInsets.symmetric(vertical: Insets.md + 2),
                ),
              ],
            ),
          ),
          const Gap.lg(),

          // Danger zone: a solid tone-on-wash card rather than a ModuleCard —
          // it must read as dangerous, not as another neutral module.
          Container(
            padding: const EdgeInsets.all(Insets.lg),
            decoration: BoxDecoration(
              color: AppColors.dangerWash,
              borderRadius: Corners.brXl,
              border: Border.all(
                color: AppColors.danger.withValues(alpha: 0.38),
                width: 1.4,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 15,
                      color: AppColors.danger,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'DANGER ZONE',
                      style: AppText.overline.copyWith(
                        color: AppColors.danger,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.lg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IconTile(
                      // A solid fill needs the saturated accent — `danger`
                      // is tuned for text and goes muddy when it fills a
                      // whole tile; the border, label and button below stay
                      // `danger` for the destructive semantic.
                      icon: Icons.no_accounts_rounded,
                      tone: AppColors.coral,
                      size: 38,
                      solid: true,
                    ),
                    const SizedBox(width: Insets.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deactivate account',
                            style: AppText.titleSmall.copyWith(
                              fontSize: 14.5,
                              color: AppColors.danger,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ends your vehicle access and future allocations immediately. Your data is '
                            'retained as required by law even after deactivation.',
                            style: AppText.bodySmall.copyWith(
                              fontSize: 11.5,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.lg),
                PrimaryButton(
                  label: 'Deactivate account',
                  icon: Icons.no_accounts_rounded,
                  fillColor: AppColors.danger,
                  size: AppButtonSize.medium,
                  onPressed: () => _deactivate(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.isLast = false,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.titleSmall.copyWith(fontSize: 13.5),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: AppText.bodySmall.copyWith(
                        fontSize: 11.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: Insets.md),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.primary,
              inactiveThumbColor: AppColors.textMuted,
              inactiveTrackColor: AppColors.surfaceSunken,
            ),
          ],
        ),
        if (!isLast) const Divider(color: AppColors.stroke, height: Insets.xxl),
      ],
    );
  }
}
