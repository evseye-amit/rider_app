import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import 'buttons.dart';

class LoadMoreTile extends StatefulWidget {
  const LoadMoreTile({required this.onLoad, super.key});

  final Future<bool> Function() onLoad;

  @override
  State<LoadMoreTile> createState() => _LoadMoreTileState();
}

class _LoadMoreTileState extends State<LoadMoreTile> {
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    if (_failed) setState(() => _failed = false);
    final bool loaded = await widget.onLoad();
    if (!loaded && mounted) setState(() => _failed = true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.md),
      child: Center(
        child: _failed
            ? GhostButton(label: context.l10n.commonRetry, icon: Icons.refresh_rounded, onPressed: _load)
            : const SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              ),
      ),
    );
  }
}
