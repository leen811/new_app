import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../../Common/press_fx.dart';
// Using built-in Material Icons to avoid symbol font rendering issues

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
  // static const Color _inactiveText = Color(0xE699A2B3); // label removed

  static final List<_NavItemSpec> _items = [
    _NavItemSpec(label: 'الرئيسية', icon: Icons.home_max_outlined, activeColor: Color(0xFF2F56D9)),
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

class _NavItem extends StatefulWidget {
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
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with TickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final AnimationController _bumpCtrl;
  late final Animation<double> _bumpAnim;

  static const double _activeScale = 1.12;
  static const double _overshootPeak = 1.16 / _activeScale; // relative bump over base

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120))..value = 1.0;
    _bumpCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 220));
    _bumpAnim = _bumpCtrl.drive(
      TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: _overshootPeak).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 70),
        TweenSequenceItem(tween: Tween(begin: _overshootPeak, end: 1.0).chain(CurveTween(curve: Curves.easeInCubic)), weight: 30),
      ]),
    );
  }

  @override
  void didUpdateWidget(covariant _NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    final reduced = MediaQuery.of(context).accessibleNavigation;
    if (!oldWidget.isActive && widget.isActive && !reduced) {
      _bumpCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _bumpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool reduced = MediaQuery.of(context).accessibleNavigation;
    final Color iconColor = widget.isActive ? widget.activeColor : CustomBottomNavBar._inactiveIcon;

    final Duration baseDuration = const Duration(milliseconds: 200);
    final Curve baseCurve = widget.isActive ? Curves.easeOutCubic : Curves.easeInCubic;

    // Press pulse: 0.96 -> 1.0 when controller runs, idle at 1.0
    final double pressFactor = reduced ? 1.0 : (1.0 - 0.04 * (1.0 - _pressCtrl.value));
    final double bumpFactor = reduced || !widget.isActive ? 1.0 : _bumpAnim.value;
    final double baseScale = reduced ? 1.0 : (widget.isActive ? _activeScale : 1.0);
    final double finalScale = baseScale * bumpFactor * pressFactor;
    final Offset targetOffset = reduced ? Offset.zero : (widget.isActive ? const Offset(0, -0.06) : Offset.zero);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (!reduced) {
          _pressCtrl
            ..value = 0.0
            ..forward();
        }
        widget.onTap();
      },
      child: SizedBox(
        height: double.infinity,
        child: Center(
          child: AnimatedSlide(
            offset: targetOffset,
            curve: baseCurve,
            duration: baseDuration,
            child: AnimatedScale(
              scale: finalScale,
              curve: baseCurve,
              duration: baseDuration,
              child: SizedBox(
                width: 28,
                height: 28,
                child: AnimatedSwitcher(
                  duration: widget.colorDuration,
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeOut,
                  child: Semantics(
                    key: ValueKey<bool>(widget.isActive),
                    label: widget.label,
                    button: true,
                    child: IconTheme(
                      data: IconThemeData(color: iconColor, size: 26),
                      child: Icon(widget.icon),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ).withPressFX(),
    );
  }
}

class _NavItemSpec {
  _NavItemSpec({required this.label, required this.icon, required this.activeColor});
  final String label;
  final IconData icon;
  final Color activeColor;
}


