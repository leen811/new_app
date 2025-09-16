# لوحة قائد الفريق - Team Lead Dashboard

## نظرة عامة
تم إنشاء لوحة قائد الفريق بنفس ستايل لوحة الموارد البشرية في التطبيق، مع دعم RTL و Material3 و GoogleFonts.cairo.

## الميزات المنجزة

### ✅ 1. نظام الأدوار (Core/auth/user_role.dart)
- `enum UserRole` مع دعم `teamLead`
- `RoleService` abstract class
- `MockRoleService` للاختبار
- `AuthBlocRoleService` للربط مع AuthBloc
- `TeamLeadGate` widget لإظهار المحتوى للمسموح لهم فقط
- `openTeamLeadDashboardIfAllowed` function للتحقق من الصلاحيات

### ✅ 2. الموديلات (Data/Models/team_lead_models.dart)
- `KpiValue` - مؤشرات الأداء الرئيسية
- `SectionLink` - روابط الأقسام
- `MemberPerf` - أداء أعضاء الفريق
- `TeamLeadDashboardData` - البيانات الرئيسية للوحة

### ✅ 3. الريبوزيتوري (Data/Repositories/team_lead_repository.dart)
- `TeamLeadRepository` abstract class
- `MockTeamLeadRepository` مع بيانات تجريبية مطابقة للسكرينات
- `DioTeamLeadRepository` للربط مع API (غير مطبق بعد)

### ✅ 4. BLoC (Bloc/TeamLead/)
- **Events**: `TLLoad`, `TLChangeQuickTab`
- **States**: `TLInitial`, `TLLoading`, `TLLoaded`, `TLError`
- **Bloc**: `TeamLeadBloc` مع منطق إدارة الحالة

### ✅ 5. الواجهة (Ui/Dashboard/TeamLead/)
- **الصفحة الرئيسية**: `team_lead_dashboard_page.dart`
- **الهيدر**: `tl_header_hero.dart` مع 👑 ونص متعدد الأسطر
- **التبويبات**: `tl_quick_tabs.dart` - Segmented tabs
- **بطاقات KPI**: `tl_kpi_card.dart` - شبكة 2×2
- **بطاقات الأقسام**: `tl_section_tile.dart` - أقسام كبيرة
- **أداء الفريق**: `tl_team_performance.dart` - قائمة أعضاء الفريق

### ✅ 6. زر الدخول (Ui/Team/Home/)
- `team_dashboard_entry_button.dart` - زر "لوحة القيادة"
- يظهر فقط لقادة الفريق والمديرين
- محمي بـ `TeamLeadGate`

### ✅ 7. التكامل مع الصفحة الرئيسية
- `home_team_page.dart` - صفحة رئيسية مخصصة للفريق
- `home_factory.dart` - تحديث ليدعم `Role.teamLeader`
- ربط زر لوحة القيادة بالصفحة الرئيسية

## البيانات التجريبية

### مؤشرات الأداء (KPIs)
- **المهام المكتملة**: 89% (+5%)
- **أعضاء الفريق**: 12 (+2)
- **الاجتماعات هذا الأسبوع**: 8 (+1)
- **متوسط الأداء**: 94% (+3%)

### الأقسام
1. إدارة الفريق
2. تقييم الأداء
3. إدارة المهام
4. الاجتماعات
5. التقارير
6. التدريب والتطوير

### أداء أعضاء الفريق
- **سارة أحمد** (مطور أول): 96% - ممتاز
- **محمد علي** (مصمم UI/UX): 92% - جيد جدًا
- **فاطمة محمد** (محلل بيانات): 88% - جيد
- **خالد الأحمد** (مطور تطبيقات): 94% - ممتاز

## التصميم والستايل

### الألوان
- **أزرق أساسي**: `#2563EB`
- **أخضر**: `#10B981`
- **برتقالي**: `#FF6D00`
- **بنفسجي**: `#7C3AED`
- **رمادي**: `#6B7280`

### الخطوط
- **GoogleFonts.cairo** لجميع النصوص
- **أوزان مختلفة**: w600, w700, w800

### التأثيرات
- **PressFX** لجميع الأزرار والبطاقات
- **أنيميشن** للتبويبات (240ms)
- **ظلال خفيفة** للبطاقات

## الاستخدام

### للوصول للوحة
1. تسجيل الدخول بدور `teamLead` أو `admin`
2. الانتقال للصفحة الرئيسية
3. الضغط على زر "لوحة القيادة"

### التنقل
- **التبويبات**: التقارير / تحليلات الذكاء الاصطناعي
- **الأقسام**: الضغط على أي قسم (يعرض "قريبًا" حالياً)
- **العودة**: زر الرجوع في AppBar

## الملفات المنجزة

```
lib/
├── Core/auth/
│   └── user_role.dart
├── Data/
│   ├── Models/team_lead_models.dart
│   └── Repositories/team_lead_repository.dart
├── Bloc/TeamLead/
│   ├── team_lead_event.dart
│   ├── team_lead_state.dart
│   └── team_lead_bloc.dart
├── Ui/
│   ├── Dashboard/TeamLead/
│   │   ├── team_lead_dashboard_page.dart
│   │   └── _widgets/
│   │       ├── tl_header_hero.dart
│   │       ├── tl_quick_tabs.dart
│   │       ├── tl_kpi_card.dart
│   │       ├── tl_section_tile.dart
│   │       └── tl_team_performance.dart
│   ├── Team/Home/
│   │   └── team_dashboard_entry_button.dart
│   └── Home/
│       ├── home_team_page.dart
│       └── home_factory.dart (محدث)
```

## الخطوات التالية

1. **ربط API**: استبدال `MockTeamLeadRepository` بـ `DioTeamLeadRepository`
2. **ربط AuthBloc**: تحديث `AuthBlocRoleService` للعمل مع AuthBloc الحقيقي
3. **إضافة وظائف**: تطبيق وظائف الأقسام المختلفة
4. **تحسينات UI**: إضافة المزيد من التفاعلات والأنيميشن
5. **اختبارات**: إضافة unit tests و widget tests

## ملاحظات

- جميع الملفات خالية من الأخطاء (Linter errors: 0)
- التصميم متوافق مع Material3
- دعم كامل للغة العربية (RTL)
- استخدام GoogleFonts.cairo للخطوط
- تأثيرات الضغط موحدة عبر التطبيق
