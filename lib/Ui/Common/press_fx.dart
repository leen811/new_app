import 'package:flutter/material.dart';

class PressFX extends StatefulWidget {
  final Widget child;
  final double scaleDown;     // 0.97 افتراضي
  final double pressedOpacity;// 0.95 افتراضي
  final Duration duration;    // 120ms
  const PressFX({
    super.key,
    required this.child,
    this.scaleDown = .97,
    this.pressedOpacity = .95,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<PressFX> createState() => _PressFXState();
}

class _PressFXState extends State<PressFX> {
  bool _pressed = false;

  bool _reduceMotion(BuildContext c) =>
      MediaQuery.maybeOf(c)?.disableAnimations == true;

  void _down(_) {
    if (mounted) {
      setState(() => _pressed = true);
    }
  }
  
  void _up(_) {
    if (mounted) {
      setState(() => _pressed = false);
    }
  }

  @override
  void dispose() {
    _pressed = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // التأكد من أن الـ widget لا يزال في الشجرة
    if (!mounted) {
      return const SizedBox.shrink();
    }
    
    final reduce = _reduceMotion(context);
    final scale  = _pressed && !reduce ? widget.scaleDown : 1.0;
    final alpha  = _pressed && !reduce ? widget.pressedOpacity : 1.0;

    // Listener يقرأ اللمس فقط ولا يغيّر onPressed داخل الزر
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _down,
      onPointerUp: _up,
      onPointerCancel: _up,
      child: AnimatedScale(
        scale: scale,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: alpha,
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

// امتداد مختصر
extension PressFXExt on Widget {
  Widget withPressFX({
    double scaleDown = .97,
    double pressedOpacity = .95,
    Duration duration = const Duration(milliseconds: 120),
  }) => PressFX(child: this, scaleDown: scaleDown, pressedOpacity: pressedOpacity, duration: duration);
}
