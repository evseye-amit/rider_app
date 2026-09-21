import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/intro_slide.dart';
import '../../domain/usecases/get_intro_slides.dart';

enum IntroStatus { initial, loading, ready, failure }

class IntroState extends Equatable {
  const IntroState({
    this.status = IntroStatus.initial,
    this.slides = const [],
    this.page = 0,
    this.message,
  });

  final IntroStatus status;
  final List<IntroSlide> slides;
  final int page;
  final String? message;

  bool get isLoading => status == IntroStatus.loading || status == IntroStatus.initial;
  bool get isLastPage => slides.isEmpty || page >= slides.length - 1;

  IntroState copyWith({
    IntroStatus? status,
    List<IntroSlide>? slides,
    int? page,
    String? message,
  }) =>
      IntroState(
        status: status ?? this.status,
        slides: slides ?? this.slides,
        page: page ?? this.page,
        message: message,
      );

  @override
  List<Object?> get props => [status, slides, page, message];
}

class IntroCubit extends Cubit<IntroState> {
  IntroCubit(this._getSlides) : super(const IntroState());

  final GetIntroSlides _getSlides;

  Future<void> load() async {
    emit(state.copyWith(status: IntroStatus.loading));
    final Result<List<IntroSlide>> result = await _getSlides(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: IntroStatus.failure, message: failure.message)),
      (slides) => emit(state.copyWith(status: IntroStatus.ready, slides: slides)),
    );
  }

  void setPage(int page) => emit(state.copyWith(page: page));
}
