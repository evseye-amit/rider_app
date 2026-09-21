import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/intro_slide.dart';
import '../domain/intro_repository.dart';

class IntroRepositoryImpl implements IntroRepository {
  const IntroRepositoryImpl(this._config);

  final UiConfigService _config;

  @override
  Future<Result<List<IntroSlide>>> getSlides() async {
    try {
      final Map<String, dynamic> doc = await _config.loadRaw('intro_slides');
      final Map<String, dynamic> meta = Map<String, dynamic>.from(doc['meta'] as Map? ?? const {});
      final List<dynamic> raw = meta['slides'] as List<dynamic>? ?? const [];

      final List<IntroSlide> slides = raw
          .map((e) => Map<String, dynamic>.from(e as Map))
          .map(
            (m) => IntroSlide(
              key: m['key'] as String? ?? '',
              icon: m['icon'] as String? ?? 'info',
              tone: m['tone'] as String? ?? 'primary',
              title: m['title'] as String? ?? '',
              body: m['body'] as String? ?? '',
              highlights: (m['highlights'] as List<dynamic>? ?? const [])
                  .map((e) => e.toString())
                  .toList(growable: false),
            ),
          )
          .toList(growable: false);

      return Result.ok(slides);
    } on Object catch (e) {
      return Result.err(ServerFailure('Could not load the intro slides. ($e)'));
    }
  }
}
