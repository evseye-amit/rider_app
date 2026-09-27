import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/intro_repository_impl.dart';
import 'domain/intro_repository.dart';
import 'domain/usecases/get_intro_slides.dart';

final introRepositoryProvider = Provider<IntroRepository>(
  (ref) => IntroRepositoryImpl(ref.watch(uiConfigServiceProvider)),
);

final getIntroSlidesProvider = Provider<GetIntroSlides>((ref) => GetIntroSlides(ref.watch(introRepositoryProvider)));
