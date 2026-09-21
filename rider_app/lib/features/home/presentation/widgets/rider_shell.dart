import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../ride/presentation/widgets/vehicle_power_flash.dart';
import '../../../../core/session/session_controller.dart';

class RiderShell extends StatelessWidget {
  const RiderShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final SessionController session = sl<SessionController>();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: ListenableBuilder(
        listenable: session,
        builder: (context, _) => RiderBottomBar(
          currentIndex: navigationShell.currentIndex,
          vehicleOn: session.vehicleOn,
          canRide: session.present,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          onPowerTap: () {
            HapticFeedback.mediumImpact();

            if (!session.present) {
              AppSnack.warning(
                context,
                'Mark yourself present to switch the vehicle on.',
              );
              return;
            }
            final bool next = !session.vehicleOn;
            session.setVehicleOn(next);
            VehiclePowerFlash.show(context, on: next);
          },
        ),
      ),
    );
  }
}

enum RiderTab {
  home('Home', Icons.dashboard_rounded, Icons.dashboard_outlined),
  scooter('Scooter', Icons.electric_scooter_rounded, Icons.electric_scooter_outlined),
  wallet('Wallet', Icons.account_balance_wallet_rounded, Icons.account_balance_wallet_outlined),
  support('Support', Icons.support_agent_rounded, Icons.support_agent_outlined);

  const RiderTab(this.label, this.activeIcon, this.icon);

  final String label;
  final IconData activeIcon;
  final IconData icon;
}

class RiderBottomBar extends StatelessWidget {
  const RiderBottomBar({
    required this.currentIndex,
    required this.onTap,
    required this.onPowerTap,
    this.vehicleOn = false,
    this.canRide = false,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onPowerTap;
  final bool vehicleOn;
  final bool canRide;

  static const double _barHeight = 68;
  static const double _powerSize = 62;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: _barHeight + bottomInset + _powerSize * 0.42,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: _barHeight + bottomInset,
              padding: EdgeInsets.only(bottom: bottomInset),

              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.stroke)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14122C52),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _BarItem(
                    tab: RiderTab.home,
                    active: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _BarItem(
                    tab: RiderTab.scooter,
                    active: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  const SizedBox(width: _powerSize + 16),
                  _BarItem(
                    tab: RiderTab.support,
                    active: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  _BarItem(
                    tab: RiderTab.wallet,
                    active: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: bottomInset + _barHeight - _powerSize * 0.58,
            child: _PowerButton(
              on: vehicleOn,
              enabled: canRide,
              size: _powerSize,
              onTap: onPowerTap,
            ),
          ),
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
            AnimatedDefaultTextStyle(
              duration: Motion.fast,
              style: AppText.bodySmall.copyWith(
                fontSize: 10.5,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active ? AppColors.textPrimary : AppColors.textMuted,
              ),
              child: Text(tab.label),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _PowerButton extends StatefulWidget {
  const _PowerButton({
    required this.on,
    required this.enabled,
    required this.size,
    required this.onTap,
  });

  final bool on;
  final bool enabled;
  final double size;
  final VoidCallback onTap;

  @override
  State<_PowerButton> createState() => _PowerButtonState();
}

class _PowerButtonState extends State<_PowerButton> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    if (widget.on) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_PowerButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.on && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.on && _pulse.isAnimating) {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color tone = widget.on ? AppColors.mint : AppColors.primary;

    return Pressable(
      onTap: widget.onTap,
      scale: 0.9,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final double halo = widget.on ? 0.18 + _pulse.value * 0.14 : 0.14;
          return Container(
            width: widget.size + 12,
            height: widget.size + 12,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: AppColors.surface, width: 5),
              boxShadow: [
                BoxShadow(
                  color: tone.withValues(alpha: halo),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: child,
          );
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: widget.on ? AppColors.mint : AppColors.surface,
            border: Border.all(
              color: widget.on ? AppColors.mint : AppColors.strokeStrong,
              width: 1.4,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.power_settings_new_rounded,
                size: 23,
                color: widget.on ? Colors.white : AppColors.primary,
              ),
              const SizedBox(height: 1),
              Text(
                widget.on ? 'ON' : 'OFF',
                style: AppText.overline.copyWith(
                  fontSize: 8.5,
                  letterSpacing: 1.1,
                  color: widget.on ? Colors.white : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
