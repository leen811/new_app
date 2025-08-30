class Perf360Fixture {
  static Map<String, dynamic> summary = {
    'cycleName': 'الدورة الحالية',
    'overall': 4.2,
    'self': 4.5,
    'manager': 4.3,
    'peers': 4.0,
    'subs': 4,
    'user': {
      'id': 'me',
      'name': 'أحمد محمد السالم',
      'role': 'مطوّر واجهات أمامية',
      'dept': 'التقنية',
      'avatarUrl': null,
    }
  };

  static List<Map<String, dynamic>> pending = [
    {
      'id': 'p1',
      'kind': 'subordinate',
      'status': 'في الانتظار',
      'target': {
        'id': 'u2',
        'name': 'محمد يوسف',
        'role': 'تقني الموثّقين',
        'dept': 'التقنية',
      }
    }
  ];

  static List<Map<String, dynamic>> peers = List<Map<String, dynamic>>.generate(7, (i) => {
        'id': 'p${i + 1}',
        'name': 'زميل رقم ${i + 1}',
        'role': 'زميل عمل',
        'dept': 'التقنية',
      });

  static List<Map<String, dynamic>> results = [
    {'category': 'القيادة', 'overall': 4.2, 'self': 4.5, 'manager': 4.2, 'peers': 3.8, 'subs': 4.3},
    {'category': 'التواصل', 'overall': 4.3, 'self': 4.3, 'manager': 4.5, 'peers': 4.2, 'subs': 4.1},
    {'category': 'العمل الجماعي', 'overall': 4.1, 'self': 4.0, 'manager': 4.1, 'peers': 4.3, 'subs': 4.0},
    {'category': 'الابتكار', 'overall': 4.2, 'self': 4.7, 'manager': 4.0, 'peers': 3.9, 'subs': 4.2},
    {'category': 'حل المشكلات', 'overall': 4.2, 'self': 4.4, 'manager': 4.3, 'peers': 4.0, 'subs': 4.1},
    {'category': 'الموثوقية', 'overall': 4.4, 'self': 4.6, 'manager': 4.4, 'peers': 4.2, 'subs': 4.3},
  ];

  static Map<String, dynamic> analytics = {
    'improvementDelta': 0.3,
    'completionPct': 85,
    'improvementPoints': 3,
    'strengths': [
      'أداء ممتاز في الموثوقية والالتزام',
      'مهارات تواصل قوية مع الفريق',
      'قدرة عالية على الابتكار وحل المشكلات',
    ],
    'improvements': [
      'تطوير مهارات القيادة والتوجيه',
      'تحسين التعاون مع الفرق المختلفة',
      'زيادة المشاركة في الأنشطة الجماعية',
    ],
    'recommendations': [
      'التسجيل في برنامج تطوير القيادة',
      'المشاركة في مشاريع متعددة الأقسام',
      'حضور ورش عمل حول التعاون الفعّال',
    ],
  };
}


