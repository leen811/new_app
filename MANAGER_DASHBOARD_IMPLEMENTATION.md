# تنفيذ لوحة تحكّم الإدارة

## نظرة عامة
تم إنشاء لوحة تحكّم الإدارة بنفس النمط والقياسات المستخدمة في لوحتي الموارد البشرية وقائد الفريق في المشروع.

## الملفات المُنشأة

### 1. النماذج (Models)
- `lib/Data/Models/manager_dashboard_models.dart`
  - `KpiValue`: نموذج مؤشر الأداء الرئيسي
  - `SectionLink`: نموذج رابط القسم
  - `ActivityItem`: نموذج النشاط الحديث
  - `ManagerDashboardData`: نموذج بيانات اللوحة الرئيسية

### 2. المستودعات (Repositories)
- `lib/Data/Repositories/manager_dashboard_repository.dart`
  - `IManagerDashboardRepository`: واجهة المستودع
  - `MockManagerDashboardRepository`: تنفيذ وهمي للبيانات

### 3. BLoC
- `lib/Bloc/Manager/manager_dashboard_bloc.dart`
- `lib/Bloc/Manager/manager_dashboard_event.dart`
- `lib/Bloc/Manager/manager_dashboard_state.dart`

### 4. واجهة المستخدم
- `lib/Ui/Dashboard/Manager/manager_dashboard_page.dart`: الصفحة الرئيسية
- `lib/Ui/Dashboard/Manager/_widgets/manager_header_hero.dart`: رأس اللوحة
- `lib/Ui/Dashboard/Manager/_widgets/manager_kpi_card.dart`: بطاقات مؤشرات الأداء
- `lib/Ui/Dashboard/Manager/_widgets/manager_section_tile.dart`: بلاطات الأقسام
- `lib/Ui/Dashboard/Manager/_widgets/manager_quick_tabs.dart`: التبويبات السريعة
- `lib/Ui/Dashboard/Manager/_widgets/manager_activity_feed.dart`: قائمة النشاطات

### 5. زر الدخول
- `lib/Ui/Manager/Home/manager_dashboard_entry_button.dart`: زر الدخول من الرئيسية
- `lib/Ui/Home/home_manager_page.dart`: صفحة الرئيسية المخصصة للمدير

### 6. التحديثات
- `lib/Ui/Home/home_factory.dart`: تحديث لاستخدام الصفحة المخصصة للمدير

## الميزات المُنفّذة

### 1. لوحة تحكّم الإدارة
- **AppBar**: العنوان "لوحة تحكّم الإدارة" مع زر العودة وقائمة الإجراءات
- **Header**: أيقونة `Icons.grid_view_rounded` مع العنوان متعدد الأسطر والوصف
- **QuickTabs**: تبويبات "التقارير" و "تحليلات الذكاء الاصطناعي"
- **KPI Cards**: 4 مؤشرات أداء رئيسية:
  - إجمالي الموظفين: 247 (12+)
  - الحاضرين اليوم: 198 (5+)
  - طلبات الإجازة: 23 (3+)
  - إجمالي الرواتب: 2.4M (8+)
- **Section Tiles**: 6 أقسام رئيسية:
  - إدارة الموظفين
  - إدارة الرواتب
  - التقارير والإحصائيات
  - إدارة المكافآت
  - مركز الإشعارات
  - إشعارات البريد
- **Activity Feed**: النشاطات الأخيرة مع تفاصيل الوقت

### 2. حراسة الدور
- الزر يظهر فقط للمدير (`Role.manager`) أو الإدارة (`Role.sysAdmin`)
- رسالة خطأ عند محاولة الوصول بدون صلاحية
- استخدام `AuthBloc` للتحقق من الدور الحالي

### 3. التصميم والقياسات
- نفس النمط المستخدم في لوحتي HR و TeamLead
- نفس القياسات: `childAspectRatio: 1.4`, `radius: 16`, `border: #E6E9F0`
- نفس الظلال والحدود والألوان
- اتجاه RTL مع خط Cairo
- خلفية بيضاء مع AppBar أبيض

## كيفية الاستخدام

1. **تسجيل الدخول كمدير**: اختر دور "مدير" في صفحة تسجيل الدخول
2. **الوصول للوحة**: اضغط على زر "لوحة القيادة" في الصفحة الرئيسية
3. **التنقل**: استخدم الأقسام المختلفة للوصول للميزات المطلوبة

## الملاحظات التقنية

- استخدام BLoC pattern لإدارة الحالة
- فصل البيانات في Repository منفصل
- إعادة استخدام الويجتات المشتركة من المشروع
- تطبيق نفس معايير التصميم المستخدمة في اللوحات الأخرى
- دعم RTL والخطوط العربية
- معالجة حالات التحميل والأخطاء

## التطوير المستقبلي

- إضافة المزيد من الأقسام حسب الحاجة
- ربط البيانات الحقيقية بدلاً من البيانات الوهمية
- إضافة المزيد من التفاعلات والأنيميشن
- تطوير نظام الإشعارات
- إضافة المزيد من التقارير والإحصائيات
