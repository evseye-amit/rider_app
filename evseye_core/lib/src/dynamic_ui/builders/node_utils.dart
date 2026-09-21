import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_gradients.dart';
import '../../theme/app_typography.dart';
import '../models/ui_node.dart';
import '../registry/dynamic_ui_scope.dart';

abstract final class NodeTokens {
  static Color color(String? name, {Color fallback = AppColors.textPrimary}) {
    if (name == null) return fallback;
    if (name.startsWith('#')) {
      final String hex = name.substring(1);
      final int? v = int.tryParse(hex.length == 6 ? 'FF$hex' : hex, radix: 16);
      if (v != null) return Color(v);
    }
    return switch (name) {
      'primary' => AppColors.primary,
      'primaryBright' => AppColors.primaryBright,
      'primaryDeep' => AppColors.primaryDeep,
      'cyan' => AppColors.cyan,
      'mint' => AppColors.mint,
      'success' => AppColors.success,
      'danger' => AppColors.danger,
      'warning' => AppColors.warning,
      'info' => AppColors.info,
      'text' => AppColors.textPrimary,
      'textSecondary' => AppColors.textSecondary,
      'muted' => AppColors.textMuted,
      'surface' => AppColors.surface,
      'white' => Colors.white,
      _ => fallback,
    };
  }

  static TextStyle textStyle(String? name) => switch (name) {
        'displayLarge' => AppText.displayLarge,
        'displayMedium' => AppText.displayMedium,
        'displaySmall' => AppText.displaySmall,
        'titleLarge' => AppText.titleLarge,
        'titleMedium' => AppText.titleMedium,
        'titleSmall' => AppText.titleSmall,
        'bodyLarge' => AppText.bodyLarge,
        'bodySmall' => AppText.bodySmall,
        'label' => AppText.label,
        'overline' => AppText.overline,
        'numeric' => AppText.numeric,
        'numericLarge' => AppText.numericLarge,
        'code' => AppText.code,
        _ => AppText.bodyMedium,
      };

  static Color fill(String? name) => switch (name) {
        'heroWash' => AppGradients.heroWash,
        _ => AppGradients.iris,
      };

  static TextAlign textAlign(String? name) => switch (name) {
        'center' => TextAlign.center,
        'right' => TextAlign.right,
        'justify' => TextAlign.justify,
        _ => TextAlign.left,
      };

  static CrossAxisAlignment crossAxis(String? name) => switch (name) {
        'center' => CrossAxisAlignment.center,
        'end' => CrossAxisAlignment.end,
        'stretch' => CrossAxisAlignment.stretch,
        _ => CrossAxisAlignment.start,
      };

  static MainAxisAlignment mainAxis(String? name) => switch (name) {
        'center' => MainAxisAlignment.center,
        'end' => MainAxisAlignment.end,
        'spaceBetween' => MainAxisAlignment.spaceBetween,
        'spaceAround' => MainAxisAlignment.spaceAround,
        'spaceEvenly' => MainAxisAlignment.spaceEvenly,
        _ => MainAxisAlignment.start,
      };

  static IconData icon(String? name, {IconData fallback = Icons.circle_outlined}) =>
      _icons[name] ?? fallback;

  static const Map<String, IconData> _icons = {
    'person': Icons.person_rounded,
    'personOutline': Icons.person_outline_rounded,
    'badge': Icons.badge_rounded,
    'home': Icons.home_rounded,
    'scooter': Icons.electric_scooter_rounded,
    'moped': Icons.moped_rounded,
    'wallet': Icons.account_balance_wallet_rounded,
    'bank': Icons.account_balance_rounded,
    'rupee': Icons.currency_rupee_rounded,
    'support': Icons.support_agent_rounded,
    'help': Icons.help_outline_rounded,
    'power': Icons.power_settings_new_rounded,
    'bolt': Icons.bolt_rounded,
    'battery': Icons.battery_charging_full_rounded,
    'camera': Icons.photo_camera_rounded,
    'upload': Icons.cloud_upload_rounded,
    'document': Icons.description_rounded,
    'shield': Icons.verified_user_rounded,
    'verified': Icons.verified_rounded,
    'check': Icons.check_circle_rounded,
    'close': Icons.cancel_rounded,
    'warning': Icons.warning_amber_rounded,
    'info': Icons.info_outline_rounded,
    'clock': Icons.schedule_rounded,
    'calendar': Icons.calendar_today_rounded,
    'location': Icons.location_on_rounded,
    'map': Icons.map_rounded,
    'phone': Icons.phone_rounded,
    'mail': Icons.mail_rounded,
    'lock': Icons.lock_rounded,
    'key': Icons.vpn_key_rounded,
    'star': Icons.star_rounded,
    'trophy': Icons.emoji_events_rounded,
    'gift': Icons.card_giftcard_rounded,
    'trending': Icons.trending_up_rounded,
    'chart': Icons.bar_chart_rounded,
    'list': Icons.list_alt_rounded,
    'settings': Icons.settings_rounded,
    'logout': Icons.logout_rounded,
    'bell': Icons.notifications_rounded,
    'signature': Icons.draw_rounded,
    'medical': Icons.medical_services_rounded,
    'family': Icons.family_restroom_rounded,
    'school': Icons.school_rounded,
    'build': Icons.build_rounded,
    'assignment': Icons.assignment_turned_in_rounded,
    'hub': Icons.hub_rounded,
    'group': Icons.groups_rounded,
    'qr': Icons.qr_code_scanner_rounded,
    'bluetooth': Icons.bluetooth_rounded,
    'iot': Icons.sensors_rounded,
    'face': Icons.face_retouching_natural_rounded,
    'card': Icons.credit_card_rounded,
    'receipt': Icons.receipt_long_rounded,
    'route': Icons.route_rounded,
    'speed': Icons.speed_rounded,
    'eye': Icons.remove_red_eye_rounded,
    'arrowForward': Icons.arrow_forward_rounded,
    'arrowBack': Icons.arrow_back_rounded,
    'checklist': Icons.checklist_rounded,
  };

  const NodeTokens._();
}

extension NodeText on UiNode {
  String text(DynamicUiScope scope, String key, [String fallback = '']) {
    final Object? raw = props[key];
    if (raw == null) return fallback;
    return scope.interpolate(raw.toString());
  }
}

List<Widget> spaced(List<Widget> children, double gap, {Axis axis = Axis.vertical}) {
  if (children.length < 2 || gap <= 0) return children;
  final List<Widget> out = [];
  for (var i = 0; i < children.length; i++) {
    out.add(children[i]);
    if (i != children.length - 1) {
      out.add(axis == Axis.vertical ? SizedBox(height: gap) : SizedBox(width: gap));
    }
  }
  return out;
}

double gapOf(UiNode node, [double fallback = Insets.md]) =>
    (node.props['gap'] as num?)?.toDouble() ?? fallback;
