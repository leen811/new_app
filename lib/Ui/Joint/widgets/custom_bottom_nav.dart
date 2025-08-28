import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onItemSelected});

  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  static const double _barHeight = 68.0; // within 64-70px
  static const Duration _indicatorDuration = Duration(milliseconds: 200);
  static const Curve _indicatorCurve = Curves.easeOutCubic;
  static const Duration _colorDuration = Duration(milliseconds: 180);

  // Colors
  static const Color _background = Color(0xFFFFFFFF);
  static const Color _divider = Color(0xFFE9EDF4);
  static const Color _shadowColor = Color(0x0F0B1524); // 0x0F ≈ 6% opacity
  static const Color _inactiveIcon = Color(0xFF98A2B3);
  static const Color _inactiveText = Color(0xE699A2B3); // 90% alpha of 98A2B3

  static const List<_NavItemSpec> _items = [
    _NavItemSpec(label: 'الرئيسية', icon: Icons.home_outlined, activeColor: Color(0xFF2F56D9)),
    _NavItemSpec(label: 'الشات', icon: Icons.chat_bubble_outline, activeColor: Color(0xFF7C3AED)),
    _NavItemSpec(label: 'المساعد الذكي', icon: Icons.smart_toy_outlined, activeColor: Color(0xFF0EA5E9)),
    _NavItemSpec(label: 'المهام', icon: Icons.task_alt_outlined, activeColor: Color(0xFF10B981)),
    _NavItemSpec(label: 'حسابي', icon: Icons.person_outline, activeColor: Color(0xFFF97316)),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.cairoTextTheme(Theme.of(context).textTheme);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: _background,
        elevation: 0,
        child: SafeArea(
          top: false,
          bottom: true,
          child: Container(
            height: _barHeight,
            decoration: BoxDecoration(
              color: _background,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              boxShadow: const [
                BoxShadow(color: _shadowColor, blurRadius: 20, offset: Offset(0, -2)),
              ],
              border: const Border(top: BorderSide(color: _divider, width: 1)),
            ),
            child: _IndicatorWrapper(
              currentIndex: currentIndex,
              itemsCount: _items.length,
              indicatorColor: _items[currentIndex].activeColor,
              duration: _indicatorDuration,
              curve: _indicatorCurve,
              child: Row(
                children: List.generate(_items.length, (index) {
                  final item = _items[index];
                  final bool isActive = index == currentIndex;
                  return Expanded(
                    child: _NavItem(
                      label: item.label,
                      icon: item.icon,
                      isActive: isActive,
                      activeColor: item.activeColor,
                      onTap: () => onItemSelected(index),
                      textTheme: textTheme,
                      colorDuration: _colorDuration,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IndicatorWrapper extends StatelessWidget {
  const _IndicatorWrapper({
    required this.currentIndex,
    required this.itemsCount,
    required this.indicatorColor,
    required this.duration,
    required this.curve,
    required this.child,
  });

  final int currentIndex;
  final int itemsCount;
  final Color indicatorColor;
  final Duration duration;
  final Curve curve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = constraints.maxWidth / itemsCount;
        final double indicatorWidth = 32.0;
        final double indicatorHeight = 4.0;
        final double topPadding = 6.0; // 6–8px
        final double x = (itemsCount - 1 - currentIndex) * itemWidth + (itemWidth - indicatorWidth) / 2;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Content row
            child,
            // Top indicator
            AnimatedPositioned(
              duration: duration,
              curve: curve,
              top: topPadding,
              left: x,
              child: AnimatedContainer(
                duration: duration,
                curve: curve,
                width: indicatorWidth,
                height: indicatorHeight,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
    required this.textTheme,
    required this.colorDuration,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;
  final TextTheme textTheme;
  final Duration colorDuration;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isActive ? activeColor : CustomBottomNavBar._inactiveIcon;
    final Color textColor = isActive ? activeColor : CustomBottomNavBar._inactiveText;

    return InkWell(
      onTap: onTap,
      splashColor: activeColor.withOpacity(0.12),
      highlightColor: activeColor.withOpacity(0.08),
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: colorDuration,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              child: Icon(icon, key: ValueKey<bool>(isActive), size: 24, color: iconColor),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: colorDuration,
              curve: Curves.easeOut,
              style: textTheme.labelMedium!.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemSpec {
  const _NavItemSpec({required this.label, required this.icon, required this.activeColor});
  final String label;
  final IconData icon;
  final Color activeColor;
}


