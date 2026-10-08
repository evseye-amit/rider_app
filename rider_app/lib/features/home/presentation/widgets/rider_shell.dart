import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RiderShell extends StatelessWidget {
  const RiderShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: RiderBottomBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
      ),
    );
  }
}

enum RiderTab {
  home(Icons.dashboard_rounded, Icons.dashboard_outlined),
  batterySwap(Icons.battery_charging_full_rounded, Icons.battery_charging_full_outlined),
  scooter(Icons.electric_scooter_rounded, Icons.electric_scooter_outlined),
  nearbyHubs(Icons.hub_rounded, Icons.hub_outlined),
  referEarn(Icons.card_giftcard_rounded, Icons.card_giftcard_outlined);

  const RiderTab(this.activeIcon, this.icon);

  String label(AppL10n l10n) => switch (this) {
    RiderTab.home => l10n.hubHome,
    RiderTab.batterySwap => l10n.navBatterySwap,
    RiderTab.scooter => l10n.navScooterDetails,
    RiderTab.nearbyHubs => l10n.navNearbyHubs,
    RiderTab.referEarn => l10n.navReferEarn,
  };

  final IconData activeIcon;
  final IconData icon;
}

class RiderBottomBar extends StatelessWidget {
  const RiderBottomBar({required this.currentIndex, required this.onTap, super.key});

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
        boxShadow: [BoxShadow(color: Color(0x14122C52), blurRadius: 16, offset: Offset(0, -4))],
      ),
      child: Row(
        children: [
          for (final RiderTab tab in RiderTab.values)
            _BarItem(tab: tab, active: currentIndex == tab.index, onTap: () => onTap(tab.index)),
        ],
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({required this.tab, required this.active, required this.onTap});

  final RiderTab tab;
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
                size: 23,
                color: active ? AppColors.primary : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AnimatedDefaultTextStyle(
                  duration: Motion.fast,
                  style: AppText.bodySmall.copyWith(
                    fontSize: 10.5,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    color: active ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                  child: Text(tab.label(context.l10n), maxLines: 1),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
