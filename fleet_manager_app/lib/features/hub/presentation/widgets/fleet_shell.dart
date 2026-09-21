import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FleetShell extends StatelessWidget {
  const FleetShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: FleetBottomBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

enum FleetTab {
  home('Hub', Icons.dashboard_rounded, Icons.dashboard_outlined),
  allocations('Allocate', Icons.swap_horiz_rounded, Icons.swap_horiz_outlined),
  deallocations('Return', Icons.assignment_return_rounded, Icons.assignment_return_outlined),
  team('Team', Icons.groups_rounded, Icons.groups_outlined),
  maintenance('Service', Icons.build_rounded, Icons.build_outlined);

  const FleetTab(this.label, this.activeIcon, this.icon);

  final String label;
  final IconData activeIcon;
  final IconData icon;
}

class FleetBottomBar extends StatelessWidget {
  const FleetBottomBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double _barHeight = 68;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      height: _barHeight + bottomInset,
      padding: EdgeInsets.only(bottom: bottomInset),

      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.stroke)),
        boxShadow: [
          BoxShadow(color: Color(0x14122C52), blurRadius: 16, offset: Offset(0, -4)),
        ],
      ),
      child: Row(
        children: [
          for (final tab in FleetTab.values)
            _BarItem(
              tab: tab,
              active: currentIndex == tab.index,
              onTap: () => onTap(tab.index),
            ),
        ],
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({required this.tab, required this.active, required this.onTap});

  final FleetTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Pressable(
        onTap: onTap,
        scale: 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Motion.normal,
              curve: Motion.enter,
              width: active ? 22 : 0,
              height: 3,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(3)),
              ),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: Motion.fast,
              child: Icon(
                active ? tab.activeIcon : tab.icon,
                key: ValueKey(active),
                size: 22,
                color: active ? AppColors.primary : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: Motion.fast,
              style: AppText.bodySmall.copyWith(
                fontSize: 10,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active ? AppColors.textPrimary : AppColors.textMuted,
              ),
              child: Text(tab.label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
