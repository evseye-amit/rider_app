import 'package:evseye_core/evseye_core.dart';

import 'entities/intro_slide.dart';

abstract interface class IntroRepository {
  Future<Result<List<IntroSlide>>> getSlides();
}
