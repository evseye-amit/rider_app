import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../api/notification_settings_api.dart';
import '../l10n/l10n.dart';
import '../providers/async_value_extensions.dart';
import '../providers/core_providers.dart';
import '../push/push_notifications.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../utils/result.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/empty_state.dart';
import '../widgets/feedback.dart';
import '../widgets/modules.dart';
import '../widgets/section_header.dart';

class NotificationSettings extends Equatable {
  const NotificationSettings({required this.catalog, required this.preferences});

  final NotificationCatalog catalog;
  final NotificationPreferences preferences;

  bool get hasMarketing => catalog.groups.any((group) => group.categories.any((item) => item.isMarketing));

  @override
  List<Object?> get props => [catalog, preferences];
}

class NotificationSettingsNotifier extends AsyncNotifier<NotificationSettings> {
  NotificationSettingsApi get _api => ref.read(notificationSettingsApiProvider);

  String get _application => ref.read(pushAppProvider).application;

  @override
  Future<NotificationSettings> build() async {
    final NotificationSettingsApi api = ref.watch(notificationSettingsApiProvider);
    final (Result<NotificationCatalog> catalog, Result<NotificationPreferences> preferences) = await (
      api.catalog(_application),
      api.preferences(_application),
    ).wait;
    return NotificationSettings(catalog: catalog.getOrThrow(), preferences: preferences.getOrThrow());
  }

  Future<Result<void>> setMarketing(bool enabled) => _save(
    (current) => current.copyWith(marketingEnabled: enabled),
    () => _api.update(_application, marketingEnabled: enabled),
  );

  Future<Result<void>> setCategory(String code, bool enabled) => _save(
    (current) => current.copyWith(
      categories: {
        for (final MapEntry<String, NotificationCategoryPreference> entry in current.categories.entries)
          entry.key: entry.key == code ? entry.value.withPush(enabled) : entry.value,
      },
    ),
    () => _api.update(_application, categories: {code: enabled}),
  );

  Future<Result<void>> _save(
    NotificationPreferences Function(NotificationPreferences current) change,
    Future<Result<NotificationPreferences>> Function() request,
  ) async {
    final NotificationSettings? before = state.value;
    if (before == null) return const Result.ok(null);
    state = AsyncData(NotificationSettings(catalog: before.catalog, preferences: change(before.preferences)));
    final Result<NotificationPreferences> result = await request();
    if (!ref.mounted) return result;
    switch (result) {
      case Ok<NotificationPreferences>(:final value):
        state = AsyncData(NotificationSettings(catalog: before.catalog, preferences: value));
        return const Result.ok(null);
      case Err<NotificationPreferences>(:final failure):
        state = AsyncData(before);
        return Result.err(failure);
    }
  }
}

final notificationSettingsProvider =
    AsyncNotifierProvider.autoDispose<NotificationSettingsNotifier, NotificationSettings>(
      NotificationSettingsNotifier.new,
    );

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  Future<void> _setMarketing(BuildContext context, WidgetRef ref, bool enabled) async {
    if (enabled) {
      final AppL10n l10n = context.l10n;
      final bool confirmed = await AppDialog.confirm(
        context,
        title: l10n.notificationSettingsOffersConfirmTitle,
        message: l10n.notificationSettingsOffersConfirmMessage,
        confirmLabel: l10n.notificationSettingsOffersAllow,
        icon: Icons.local_offer_rounded,
      );
      if (!confirmed || !context.mounted) return;
    }
    final Result<void> result = await ref.read(notificationSettingsProvider.notifier).setMarketing(enabled);
    if (context.mounted) _report(context, result);
  }

  Future<void> _setCategory(BuildContext context, WidgetRef ref, String code, bool enabled) async {
    final Result<void> result = await ref.read(notificationSettingsProvider.notifier).setCategory(code, enabled);
    if (context.mounted) _report(context, result);
  }

  void _report(BuildContext context, Result<void> result) {
    if (result case Err<void>(:final failure)) AppSnack.error(context, failure.message);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppL10n l10n = context.l10n;
    final AsyncValue<NotificationSettings> settings = ref.watch(notificationSettingsProvider);
    final NotificationSettings? value = settings.value;

    return AppScaffold(
      title: l10n.notificationSettingsTitle,
      body: value == null
          ? settings.hasError
                ? EmptyState(
                    title: l10n.notificationSettingsLoadError,
                    message: settings.failureMessage,
                    icon: Icons.cloud_off_rounded,
                    tone: AppColors.danger,
                    actionLabel: l10n.commonTryAgain,
                    onAction: () => ref.invalidate(notificationSettingsProvider),
                  )
                : const PageBody(
                    children: [
                      ShimmerBox(height: 96, borderRadius: Corners.brXl),
                      Gap.lg(),
                      ShimmerBox(height: 180, borderRadius: Corners.brXl),
                    ],
                  )
          : RefreshIndicator(
              onRefresh: () => ref.refresh(notificationSettingsProvider.future).then<void>((_) {}, onError: (_) {}),
              color: AppColors.primary,
              child: PageBody(physics: const AlwaysScrollableScrollPhysics(), children: _content(context, ref, value)),
            ),
    );
  }

  List<Widget> _content(BuildContext context, WidgetRef ref, NotificationSettings settings) {
    final AppL10n l10n = context.l10n;
    final NotificationPreferences preferences = settings.preferences;
    final List<(NotificationGroup, List<NotificationCategory>)> groups = [
      for (final NotificationGroup group in settings.catalog.groups)
        if (group.categories.where((item) => preferences.categories.containsKey(item.code)).toList()
            case final List<NotificationCategory> items when items.isNotEmpty)
          (group, items),
    ];
    if (groups.isEmpty && !settings.hasMarketing) {
      return [EmptyState(compact: true, title: l10n.notificationSettingsEmpty, icon: Icons.notifications_off_rounded)];
    }
    return [
      if (settings.hasMarketing) ...[
        ModuleCard(
          child: _SettingRow(
            title: l10n.notificationSettingsOffersTitle,
            subtitle: l10n.notificationSettingsOffersMessage,
            value: preferences.marketingEnabled,
            onChanged: (enabled) => _setMarketing(context, ref, enabled),
          ),
        ),
        const Gap.xl(),
      ],
      for (final (int index, (NotificationGroup group, List<NotificationCategory> items)) in groups.indexed) ...[
        if (index > 0) const Gap.xl(),
        GroupLabel(group.name),
        const Gap.sm(),
        ModuleCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (int row, NotificationCategory category) in items.indexed) ...[
                if (row > 0) Divider(color: AppColors.stroke.withValues(alpha: 0.7), height: Insets.xl),
                _categoryRow(context, ref, category, preferences),
              ],
            ],
          ),
        ),
      ],
    ];
  }

  Widget _categoryRow(
    BuildContext context,
    WidgetRef ref,
    NotificationCategory category,
    NotificationPreferences preferences,
  ) {
    final AppL10n l10n = context.l10n;
    final NotificationCategoryPreference preference = preferences.categories[category.code]!;
    final bool blockedByConsent = category.isMarketing && !preferences.marketingEnabled;
    final String? hint = preference.mandatory
        ? l10n.notificationSettingsAlwaysOn
        : blockedByConsent
        ? l10n.notificationSettingsOffersHint
        : null;
    return _SettingRow(
      title: category.name.isEmpty ? category.code : category.name,
      subtitle: category.description.isEmpty ? null : category.description,
      hint: hint,
      value: preference.mandatory || (preference.pushEnabled && !blockedByConsent),
      onChanged: preference.mandatory || blockedByConsent
          ? null
          : (enabled) => _setCategory(context, ref, category.code, enabled),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.title, required this.value, required this.onChanged, this.subtitle, this.hint});

  final String title;
  final String? subtitle;
  final String? hint;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.titleSmall.copyWith(fontSize: 14)),
              if (subtitle case final String text) ...[
                const SizedBox(height: 2),
                Text(text, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.4)),
              ],
              if (hint case final String text) ...[
                const SizedBox(height: 4),
                Text(text, style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted)),
              ],
            ],
          ),
        ),
        const SizedBox(width: Insets.md),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
