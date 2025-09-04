import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// دالة آمنة لإغلاق الشاشة الحالية
/// 
/// هذه الدالة تحل مشكلة GoError: "There is nothing to pop" التي تحدث
/// عندما يحاول المستخدم العودة من شاشة تم فتحها باستخدام go/goNamed
/// بدلاً من push/pushNamed.
/// 
/// السلوك:
/// - إذا كان يمكن pop (يوجد شاشة سابقة) → ينفذ pop
/// - إذا لا يوجد ما يُـpop → ينتقل إلى المسار الاحتياطي
/// 
/// الاستخدام:
/// ```dart
/// safeClose(context, fallbackRoute: RoutesConstants.kRolesRoute);
/// ```
void safeClose(BuildContext context, {required String fallbackRoute}) {
  final router = GoRouter.of(context);
  if (router.canPop()) {
    router.pop();
  } else {
    router.go(fallbackRoute);
  }
}
