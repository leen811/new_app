import 'package:flutter/material.dart';
import 'app_transitions.dart';

enum AppDialogTransition { fadeScale, slideUp }

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Duration? inDuration,
  Duration? outDuration,
  bool barrierDismissible = true,
  String barrierLabel = 'إغلاق',
  AppDialogTransition transition = AppDialogTransition.fadeScale,
  bool useBlur = true,
}) {
  final reduced = reduceMotion(context);
  final Duration inDur = reduced ? const Duration(milliseconds: 120) : (inDuration ?? kInDuration);
  // Note: showGeneralDialog does not support a separate reverse duration.
  // We still accept outDuration for API completeness, but we will ignore it here.

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: Colors.transparent,
    transitionDuration: inDur,
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (ctx, animation, secondary, child) {
      final fade = CurvedAnimation(parent: animation, curve: kInCurve, reverseCurve: kOutCurve);

      Widget dialogBody = RepaintBoundary(child: Builder(builder: builder));

      switch (transition) {
        case AppDialogTransition.fadeScale:
          dialogBody = FadeScaleIn(animation: fade, child: dialogBody);
          break;
        case AppDialogTransition.slideUp:
          dialogBody = SlideUpIn(animation: fade, child: dialogBody);
          break;
      }

      if (reduced) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(children: [
            FadeTransition(opacity: fade, child: const ColoredBox(color: Colors.black54)),
            Center(child: dialogBody),
          ]),
        );
      }

      return Directionality(
        textDirection: TextDirection.rtl,
        child: ScrimBlur(
          animation: fade,
          useBlur: useBlur,
          child: Stack(children: [
            const SizedBox.expand(),
            Center(child: dialogBody),
          ]),
        ),
      );
    },
  );
}

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String barrierLabel = 'إغلاق',
}) {
  final reduced = reduceMotion(context);
  final Duration inDur = reduced ? const Duration(milliseconds: 120) : kInDuration;
  // Note: reverse duration is not separately configurable for showGeneralDialog.

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: Colors.transparent,
    transitionDuration: inDur,
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (ctx, animation, secondary, child) {
      final fade = CurvedAnimation(parent: animation, curve: kInCurve, reverseCurve: kOutCurve);
      final sheet = Align(
        alignment: Alignment.bottomCenter,
        child: RepaintBoundary(child: Builder(builder: builder)),
      );
      if (reduced) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(children: [
            FadeTransition(opacity: fade, child: const ColoredBox(color: Colors.black54)),
            sheet,
          ]),
        );
      }
      return Directionality(
        textDirection: TextDirection.rtl,
        child: ScrimBlur(
          animation: fade,
          useBlur: true,
          child: SlideUpIn(animation: fade, child: sheet),
        ),
      );
    },
  );
}


