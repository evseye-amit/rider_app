import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

class IntroSlide extends Equatable {
  const IntroSlide({
    required this.key,
    required this.icon,
    required this.tone,
    required this.title,
    required this.body,
    required this.highlights,
  });

  final String key;
  final String icon;
  final String tone;
  final String title;
  final String body;
  final List<String> highlights;

  @override
  List<Object?> get props => [key, icon, tone, title, body, highlights];
}

/// The slide's text comes from the message files, keyed by [IntroSlide.key],
/// so the JSON asset only carries layout: the key, icon and tone.
extension IntroSlideL10n on IntroSlide {
  String titleFor(AppL10n l10n) => switch (key) {
    'earn' => l10n.introEarnTitle,
    'vehicle' => l10n.introVehicleTitle,
    'support' => l10n.introSupportTitle,
    _ => title,
  };

  String bodyFor(AppL10n l10n) => switch (key) {
    'earn' => l10n.introEarnBody,
    'vehicle' => l10n.introVehicleBody,
    'support' => l10n.introSupportBody,
    _ => body,
  };

  List<String> highlightsFor(AppL10n l10n) => switch (key) {
    'earn' => [l10n.introEarnHighlight1, l10n.introEarnHighlight2],
    'vehicle' => [l10n.introVehicleHighlight1, l10n.introVehicleHighlight2],
    'support' => [l10n.introSupportHighlight1, l10n.introSupportHighlight2],
    _ => highlights,
  };
}
