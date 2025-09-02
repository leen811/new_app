import '../Models/employee_home_models.dart';

abstract class IEmployeeHomeRepository {
  Future<EmployeeSnapshot> fetch();
}

class EmployeeHomeRepository implements IEmployeeHomeRepository {
  @override
  Future<EmployeeSnapshot> fetch() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 800));
    
    // البيانات الوهمية المطابقة للسكرينات
    return const EmployeeSnapshot(
      coins: 1247,
      energyPct: 85,
      performancePct: 93,
      performanceBadge: 'ممتاز',
      todayActivities: [
        TodayActivity(
          title: 'تسجيل الحضور',
          time: '09:00',
          status: ActivityStatus.completed,
        ),
        TodayActivity(
          title: 'اجتماع الفريق',
          time: '10:30',
          status: ActivityStatus.completed,
        ),
        TodayActivity(
          title: 'مراجعة التقارير',
          time: '14:00',
          status: ActivityStatus.upcoming,
        ),
        TodayActivity(
          title: 'متابعة المشاريع',
          time: '16:00',
          status: ActivityStatus.upcoming,
        ),
      ],
      achievements: [
        Achievement(
          title: 'نجم الأسبوع',
          description: 'حققت أفضل أداء هذا الأسبوع',
          iconName: 'star',
        ),
        Achievement(
          title: 'الموظف المثالي',
          description: 'لم تتغيب يوماً واحداً هذا الشهر',
          iconName: 'emoji_events',
        ),
        Achievement(
          title: 'روح الفريق',
          description: 'ساعدت زملاءك في 5 مهام',
          iconName: 'handshake',
        ),
        Achievement(
          title: 'مطوّر المهارات',
          description: 'أكملت 3 دورات تدريبية',
          iconName: 'school',
        ),
      ],
    );
  }
}
