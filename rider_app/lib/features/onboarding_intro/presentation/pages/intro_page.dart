import 'dart:math' as math;

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/intro_slide.dart';
import '../providers/intro_slides_provider.dart';

const Map<String, BrandArt> _slideArt = {
  'earn': BrandArt.introEarnings,
  'vehicle': BrandArt.introRide,
  'support': BrandArt.introSupport,
};

const Color _slideTone = AppColors.primary;

const double _artFraction = 0.52;

class IntroPage extends ConsumerStatefulWidget {
  const IntroPage({super.key});

  @override
  ConsumerState<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isLastPage(List<IntroSlide> slides) => slides.isEmpty || _page >= slides.length - 1;

  void _next(List<IntroSlide> slides) {
    if (_isLastPage(slides)) {
      context.go(Routes.login);
      return;
    }
    _controller.nextPage(duration: Motion.normal, curve: Motion.enter);
  }

  @override
  Widget build(BuildContext context) {
    final List<IntroSlide>? slides = ref.watch(introSlidesProvider).value;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: slides == null || slides.isEmpty ? const _IntroSkeleton() : _slides(context, slides),
    );
  }

  Widget _slides(BuildContext context, List<IntroSlide> slides) {
    final bool lastPage = _isLastPage(slides);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
              child: Align(
                alignment: Alignment.centerRight,
                child: lastPage
                    ? null
                    : GhostButton(
                        label: context.l10n.commonSkip,
                        color: AppColors.textMuted,
                        onPressed: () => context.go(Routes.login),
                      ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: slides.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => _Slide(slide: slides[i]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Insets.gutter,
              Insets.md,
              Insets.gutter,
              Insets.lg + MediaQuery.paddingOf(context).bottom,
            ),
            child: OnboardingFooter(
              count: slides.length,
              index: _page,
              label: lastPage ? context.l10n.onboardingIntroGetStarted : context.l10n.onboardingIntroNext,
              onNext: () => _next(slides),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.slide});

  final IntroSlide slide;

  @override
  Widget build(BuildContext context) {
    final BrandArt art = _slideArt[slide.key] ?? BrandArt.introRide;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double artHeight = constraints.maxHeight * _artFraction;
        final double discSize = constraints.maxWidth * 0.84;
        final double artWidth = math.min(constraints.maxWidth * 0.52, artHeight * 0.62 / art.aspect);

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: artHeight,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: discSize,
                        height: discSize,
                        decoration: BoxDecoration(color: AppColors.washFor(_slideTone), shape: BoxShape.circle),
                      ),
                      BrandIllustration(art: art, size: artWidth),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(Insets.gutter, Insets.xl, Insets.gutter, Insets.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        slide.titleFor(context.l10n),
                        style: AppText.displayLarge.copyWith(fontSize: 31, height: 1.12),
                      ),
                      const Gap.md(),
                      Text(
                        slide.bodyFor(context.l10n),
                        style: AppText.bodyLarge.copyWith(fontSize: 14.5, height: 1.6, color: AppColors.textSecondary),
                      ),
                      const Gap.lg(),
                      Wrap(
                        spacing: Insets.sm,
                        runSpacing: Insets.sm,
                        children: [
                          for (final String highlight in slide.highlightsFor(context.l10n))
                            _HighlightChip(label: highlight),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HighlightChip extends StatelessWidget {
  const _HighlightChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.washFor(_slideTone),
          borderRadius: Corners.pill,
          border: Border.all(color: _slideTone.withValues(alpha: 0.22)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_rounded, size: 13, color: _slideTone),
            const SizedBox(width: Insets.xs + 2),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodySmall.copyWith(fontWeight: FontWeight.w700, fontSize: 12, color: _slideTone),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroSkeleton extends StatelessWidget {
  const _IntroSkeleton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Insets.gutter, Insets.x4l, Insets.gutter, Insets.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(child: ShimmerBox(borderRadius: Corners.brXxl)),
            const Gap.xl(),
            const ShimmerBox(height: 32, width: 230),
            const Gap.sm(),
            const ShimmerBox(height: 32, width: 170),
            const Gap.md(),
            const ShimmerBox(height: 52),
            const Gap.xl(),
            Row(
              children: [
                const ShimmerBox(height: 8, width: 60, borderRadius: Corners.pill),
                const Spacer(),
                ShimmerBox(height: 46, width: 130, borderRadius: Corners.pill),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
