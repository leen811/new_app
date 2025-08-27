import 'dart:ui';
import 'package:flutter/material.dart';

// Timings and curves
const Duration kInDuration = Duration(milliseconds: 220);
const Duration kOutDuration = Duration(milliseconds: 180);
const Curve kInCurve = Curves.easeOutCubic;
const Curve kOutCurve = Curves.easeInCubic;

bool reduceMotion(BuildContext ctx) {
  final mq = MediaQuery.maybeOf(ctx);
  if (mq == null) return false;
  return mq.disableAnimations == true || mq.accessibleNavigation == true;
}

class FadeScaleIn extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  const FadeScaleIn({super.key, required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool reduced = reduceMotion(context);
    if (reduced) {
      return FadeTransition(opacity: animation, child: child);
    }
    final scaleTween = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.015), weight: 80),
      TweenSequenceItem(tween: Tween(begin: 1.015, end: 1.0), weight: 20),
    ]);
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(scale: animation.drive(scaleTween), child: child),
    );
  }
}

class ScrimBlur extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final bool useBlur;
  const ScrimBlur({super.key, required this.animation, required this.child, this.useBlur = true});

  @override
  Widget build(BuildContext context) {
    final bool reduced = reduceMotion(context);
    if (reduced || !useBlur) {
      return AnimatedBuilder(
        animation: animation,
        builder: (_, __) => ColoredBox(
          color: Colors.black.withOpacity(0.4 * animation.value),
          child: child,
        ),
      );
    }
    return AnimatedBuilder(
      animation: animation,
      builder: (ctx, __) {
        final sigma = 20.0 * animation.value;
        final opacity = 0.4 * animation.value;
        return ColoredBox(
          color: Colors.black.withOpacity(opacity),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: child,
          ),
        );
      },
    );
  }
}

class SlideUpIn extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  const SlideUpIn({super.key, required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool reduced = reduceMotion(context);
    if (reduced) {
      return FadeTransition(opacity: animation, child: child);
    }
    final offsetTween = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero);
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(position: animation.drive(offsetTween), child: child),
    );
  }
}


