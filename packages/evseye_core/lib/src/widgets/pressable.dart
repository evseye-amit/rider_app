import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';

class Pressable extends StatefulWidget {
  const Pressable({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scale = 0.97,
    this.duration = Motion.instant,
    this.enabled = true,
    this.behavior = HitTestBehavior.opaque,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scale;
  final Duration duration;
  final bool enabled;
  final HitTestBehavior behavior;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  bool get _active => widget.enabled && (widget.onTap != null || widget.onLongPress != null);

  void _set(bool v) {
    if (!_active || _down == v) return;
    setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: _active ? widget.onTap : null,
      onLongPress: _active ? widget.onLongPress : null,
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: widget.duration,
        curve: Motion.enter,
        child: AnimatedOpacity(
          opacity: widget.enabled ? 1 : 0.5,
          duration: Motion.fast,
          child: widget.child,
        ),
      ),
    );
  }
}
