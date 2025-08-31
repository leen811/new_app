import 'package:flutter/material.dart';

/// إعدادات الحركة الموحدة للتطبيق
class AppMotion {
  /// مدة الانتقال للدخول
  static const inDuration = Duration(milliseconds: 280);
  
  /// مدة الانتقال للخروج
  static const outDuration = Duration(milliseconds: 220);
  
  /// التحقق من إيقاف الحركة (Reduce Motion)
  static bool reduce(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations == true;
}
