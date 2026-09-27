import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/intro_slide.dart';
import '../../intro_dependencies.dart';

final introSlidesProvider = FutureProvider.autoDispose<List<IntroSlide>>(
  (ref) async => (await ref.watch(getIntroSlidesProvider)(const NoParams())).getOrThrow(),
);
