import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../providers/fleet_search_providers.dart';
import '../widgets/fleet_search_widgets.dart';

class FleetSearchPage extends StatefulWidget {
  const FleetSearchPage({super.key});

  @override
  State<FleetSearchPage> createState() => _FleetSearchPageState();
}

class _FleetSearchPageState extends State<FleetSearchPage> {
  static const int _minLength = 2;

  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final String next = value.trim();
      if (mounted && next != _query) setState(() => _query = next);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    if (_query.isNotEmpty) setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.fleetSearchTitle,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.gutter, Insets.sm, Insets.gutter, Insets.md),
            child: AppSearchField(
              hint: context.l10n.fleetSearchHint,
              controller: _controller,
              autofocus: true,
              onChanged: _onChanged,
              trailing: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) => _controller.text.isEmpty
                    ? const SizedBox.shrink()
                    : Pressable(
                        onTap: _clear,
                        child: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                      ),
              ),
            ),
          ),
          Expanded(
            child: _query.length < _minLength
                ? _Centered(
                    child: ArtBlock(
                      art: BrandArt.scooter,
                      artSize: 112,
                      title: context.l10n.fleetSearchStartTitle,
                      message: context.l10n.fleetSearchStartMessage,
                    ),
                  )
                : _Results(query: _query),
          ),
        ],
      ),
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GlobalFleetPage> results = ref.watch(scooterSearchProvider(query));
    final GlobalFleetPage? page = results.value;

    if (page == null) {
      if (results.hasError) {
        return _Centered(
          child: EmptyState(
            title: context.l10n.fleetSearchCouldNotLoad,
            message: results.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(scooterSearchProvider(query)),
            compact: true,
          ),
        );
      }
      return const _ResultsSkeleton();
    }

    if (page.items.isEmpty) {
      return _Centered(
        child: ArtBlock(
          art: BrandArt.empty,
          artSize: 112,
          title: context.l10n.fleetSearchEmptyTitle,
          message: context.l10n.fleetSearchEmptyMessage,
        ),
      );
    }

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        Insets.gutter,
        Insets.xs,
        Insets.gutter,
        MediaQuery.paddingOf(context).bottom + Insets.xl,
      ),
      children: [
        for (final GlobalFleetDto fleet in page.items) ...[
          ScooterResultTile(fleet: fleet, onTap: () => context.push('${Routes.fleetSearchScooter}?id=${fleet.id}')),
          const Gap.md(),
        ],
        if (page.hasMore) LoadMoreTile(onLoad: () => ref.read(scooterSearchProvider(query).notifier).loadMore()),
      ],
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _ResultsSkeleton extends StatelessWidget {
  const _ResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(Insets.gutter, Insets.xs, Insets.gutter, Insets.xl),
      children: const [
        ShimmerBox(height: 96, borderRadius: Corners.brLg),
        Gap.md(),
        ShimmerBox(height: 96, borderRadius: Corners.brLg),
        Gap.md(),
        ShimmerBox(height: 96, borderRadius: Corners.brLg),
      ],
    );
  }
}
