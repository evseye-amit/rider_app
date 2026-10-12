import 'package:evseye_core/evseye_core.dart';

import '../entities/intro_slide.dart';
import '../intro_repository.dart';

class GetIntroSlides extends UseCase<List<IntroSlide>, NoParams> {
  const GetIntroSlides(this._repository);

  final IntroRepository _repository;

  @override
  Future<Result<List<IntroSlide>>> call(NoParams params) => _repository.getSlides();
}
