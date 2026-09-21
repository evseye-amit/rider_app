import 'package:equatable/equatable.dart';

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
