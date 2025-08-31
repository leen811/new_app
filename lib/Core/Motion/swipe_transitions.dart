import 'package:flutter/material.dart';
import 'app_motion.dart';

/// إنشاء مسار انتقال بالسحب
Route<T> swipeRoute<T>({
  required Widget page, 
  AxisDirection direction = AxisDirection.left,
}) {
  // لا تستخدم CupertinoPageRoute ولا أي Dismissible/Wrapper حتى لا يصبح الرجوع تفاعلي
  return PageRouteBuilder<T>(
    transitionDuration: AppMotion.inDuration,
    reverseTransitionDuration: AppMotion.outDuration,
    fullscreenDialog: false,
    opaque: true,
    barrierColor: null,
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (AppMotion.reduce(context)) return child;
      
      final begin = direction == AxisDirection.left 
          ? const Offset(1.0, 0.0)  // من اليمين
          : const Offset(-1.0, 0.0); // من اليسار
      
      final tween = Tween<Offset>(
        begin: begin, 
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      
      return SlideTransition(
        position: animation.drive(tween), 
        child: child,
      );
    },
  );
}

/// امتدادات للتنقل بالسحب
extension SwipeNav on BuildContext {
  /// الانتقال لصفحة جديدة بالسحب
  Future<T?> pushSwipe<T>(
    Widget page, {
    AxisDirection direction = AxisDirection.left,
  }) =>
      Navigator.of(this).push(swipeRoute(
        page: page, 
        direction: direction,
      ));
  
  /// استبدال الصفحة الحالية بصفحة جديدة بالسحب
  Future<T?> replaceWithSwipe<T>(
    Widget page, {
    AxisDirection direction = AxisDirection.left,
  }) =>
      Navigator.of(this).pushReplacement(swipeRoute(
        page: page, 
        direction: direction,
      ));
}
