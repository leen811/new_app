# نظام الانتقالات بالسحب (Slide Transitions) - النسخة المحدثة

## نظرة عامة
تم تحديث نظام الانتقالات ليكون أكثر دقة ووضوحاً:
- **التبويبات الرئيسية**: بدون أي أنيميشن أو سحب (ثابتة)
- **الصفحات الداخلية**: انتقال سحب أفقي من اليمين لليسار
- **لا يوجد back-swipe تفاعلي**: على iOS أو Android
- **احترام Reduce Motion**: إيقاف الأنيميشن عند الحاجة

## الميزات
- ✅ **تبويبات البوتوم**: ثابتة بدون أنيميشن (IndexedStack)
- ✅ **صفحات داخلية**: انتقال سحب (يمين ➜ يسار)
- ✅ **لا back-swipe**: تعطيل السحب التفاعلي للرجوع
- ✅ **Reduce Motion**: إيقاف الأنيميشن عند الحاجة
- ✅ **أداء محسن**: انتقالات سريعة وموثوقة

## التبويبات الرئيسية (Top-Level)
هذه المسارات **لا تطبق عليها** انتقالات مخصصة:
```dart
'/', '/shell', '/home', '/chat', '/digital-twin', '/tasks', '/profile'
```

## الملفات

### 1. `app_motion.dart`
```dart
class AppMotion {
  static const inDuration = Duration(milliseconds: 280);
  static const outDuration = Duration(milliseconds: 220);
  static bool reduce(BuildContext context) => 
      MediaQuery.maybeOf(context)?.disableAnimations == true;
}
```

### 2. `swipe_transitions.dart`
يوفر دوال الانتقال بالسحب:
- `swipeRoute()`: إنشاء مسار انتقال بالسحب
- `context.pushSwipe()`: الانتقال لصفحة جديدة بالسحب
- `context.replaceWithSwipe()`: استبدال الصفحة الحالية

### 3. `app_routes.dart`
إدارة المسارات للتنقل الكلاسيكي:
- التبويبات الرئيسية: `MaterialPageRoute` (بدون أنيميشن)
- الصفحات الداخلية: `swipeRoute` (مع سحب)

## الاستخدام

### مع GoRouter (مفعل حالياً)
```dart
// التبويبات الرئيسية: بدون انتقال
GoRoute(
  path: '/',
  pageBuilder: (context, state) => _swipePage(const HomeShell()),
),

// الصفحات الداخلية: انتقال سحب
GoRoute(
  path: '/settings/general',
  pageBuilder: (context, state) => _swipePage(const GeneralSettingsPage()),
),
```

### مع Navigator الكلاسيكي
```dart
// استبدل
Navigator.push(context, MaterialPageRoute(builder: (_) => Page()));

// بـ
context.pushSwipe(Page());
```

### تبويبات البوتوم
```dart
// في home_shell.dart أو bottom_shell.dart
IndexedStack(index: _index, children: pages), // بدون سحب/أنيميشن

BottomNavigationBar(
  currentIndex: _index,
  onTap: (i) => setState(() => _index = i), // مباشر
),
```

## الإعدادات

### MaterialApp
```dart
MaterialApp(
  theme: ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),     // لا سحب تفاعلي
        TargetPlatform.android: ZoomPageTransitionsBuilder(), // افتراضي غير تفاعلي
      },
    ),
  ),
)
```

### Reduce Motion
النظام يحترم إعدادات Reduce Motion تلقائياً:
```dart
if (AppMotion.reduce(context)) return child;
```

## ملاحظات مهمة

1. **لا back-swipe**: تم تعطيل السحب التفاعلي للرجوع
2. **التبويبات ثابتة**: التبديل بينها فوري بدون أنيميشن
3. **الصفحات الداخلية فقط**: تنتقل بالسحب
4. **الأداء**: انتقالات سريعة وموثوقة
5. **التوافق**: لا يؤثر على BLoC/State Management

## استكشاف الأخطاء

### إذا لم تعمل الانتقالات:
1. تأكد من استخدام `context.pushSwipe()` للصفحات الداخلية
2. تحقق من أن التبويبات تستخدم `IndexedStack`
3. تأكد من إعدادات `pageTransitionsTheme`

### إذا ظهر back-swipe:
1. تأكد من عدم استخدام `CupertinoPageTransitionsBuilder`
2. تحقق من عدم استخدام `DismissiblePage`
3. تأكد من استخدام `ZoomPageTransitionsBuilder`

## التخصيص

### تغيير مدة الانتقال:
```dart
// في app_motion.dart
static const inDuration = Duration(milliseconds: 300); // مخصص
```

### تغيير منحنى الحركة:
```dart
// في swipe_transitions.dart
.chain(CurveTween(curve: Curves.easeInOut)) // مخصص
```

### تغيير اتجاه السحب:
```dart
// في swipe_transitions.dart
swipeRoute(page: page, direction: AxisDirection.right)
```
