# PressFX - تأثير الضغط الموحد للأزرار

## الوصف
`PressFX` هو ويدجت بسيط يوفر تأثير ضغط موحد لجميع الأزرار والعناصر القابلة للنقر في التطبيق.

## الميزات
- **تأثير بصري موحد**: تصغير خفيف (0.97) وشفافية خفيفة (0.95) عند الضغط
- **احترام Reduce Motion**: لا يعمل أي أنيميشن إذا كان مفعلاً على الجهاز
- **سهولة الاستخدام**: امتداد `.withPressFX()` يمكن تطبيقه على أي Widget
- **لا يؤثر على onPressed**: يحافظ على الوظائف الأصلية للأزرار

## الاستخدام

### الطريقة الأولى: استخدام الامتداد (مفضلة)
```dart
// قبل
ElevatedButton(onPressed: save, child: Text("حفظ"))

// بعد
ElevatedButton(onPressed: save, child: Text("حفظ")).withPressFX()
```

### الطريقة الثانية: استخدام الويدجت مباشرة
```dart
PressFX(
  child: ElevatedButton(onPressed: save, child: Text("حفظ")),
  scaleDown: 0.97,
  pressedOpacity: 0.95,
  duration: Duration(milliseconds: 120),
)
```

## المعاملات
- `scaleDown`: نسبة التصغير عند الضغط (افتراضي: 0.97)
- `pressedOpacity`: مستوى الشفافية عند الضغط (افتراضي: 0.95)
- `duration`: مدة الأنيميشن (افتراضي: 120ms)

## أمثلة التطبيق

### أزرار عادية
```dart
ElevatedButton(onPressed: save, child: Text("حفظ")).withPressFX()
TextButton(onPressed: cancel, child: Text("إلغاء")).withPressFX()
```

### أزرار أيقونات
```dart
IconButton(onPressed: back, icon: Icon(Icons.arrow_back)).withPressFX()
```

### أزرار مخصصة
```dart
Container(
  child: Text("زر مخصص"),
  onTap: () => print("تم الضغط"),
).withPressFX()
```

### تخصيص المعاملات
```dart
ElevatedButton(onPressed: save, child: Text("حفظ"))
  .withPressFX(
    scaleDown: 0.95,
    pressedOpacity: 0.9,
    duration: Duration(milliseconds: 150),
  )
```

## ملاحظات مهمة
1. **لا تغيّر onPressed**: الويدجت يضيف تأثير بصري فقط
2. **احترام Reduce Motion**: إذا كان مفعلاً، لا يظهر أي أنيميشن
3. **أداء ممتاز**: يستخدم `AnimatedScale` و `AnimatedOpacity` المحسّنة
4. **سهولة التطبيق**: يمكن تطبيقه على أي ويدجت موجود

## التطبيق في المشروع
تم تطبيق `PressFX` على الأزرار الأساسية التالية:
- `AppButton` - الأزرار الرئيسية
- أزرار `ElevatedButton` في صفحات متعددة
- أزرار `TextButton` في الإعدادات والملفات الشخصية
- أزرار `IconButton` في شريط الدردشة
- أزرار التنقل والروابط

## التطوير المستقبلي
- إضافة تأثيرات صوتية (اختياري)
- دعم تأثيرات مخصصة إضافية
- تحسين الأداء للقوائم الطويلة
