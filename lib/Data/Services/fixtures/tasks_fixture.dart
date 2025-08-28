class TasksTabFixture {
  static Map<String, dynamic> kpiOverview = {
    'achievementPct': 85,
    'workMinutes': 0,
    'activeChallenges': 3,
    'tasksTodayDone': 1,
    'tasksTodayTotal': 4,
  };

  static List<Map<String, dynamic>> dailyTasks = [
    {
      'id': 't1',
      'title': 'مراجعة كود الواجهة الجديدة',
      'desc': 'فحص وتحسين أداء مكوّنات React',
      'priority': 'عالية',
      'tags': ['تطوير', 'مراجعة'],
      'estimatedMin': 120,
      'intlTimeLabel': '١٤:٣٢ م',
      'category': 'عمل',
      'done': false,
      'timerSeconds': 0,
    },
    {
      'id': 't2',
      'title': 'تحديث وثائق API',
      'desc': '',
      'priority': 'متوسطة',
      'tags': ['توثيق'],
      'estimatedMin': 90,
      'intlTimeLabel': '١٤:٣٢ م',
      'category': 'توثيق',
      'done': false,
      'timerSeconds': 0,
    },
    {
      'id': 't3',
      'title': '',
      'desc': '',
      'priority': 'منخفضة',
      'tags': [],
      'estimatedMin': 0,
      'intlTimeLabel': '',
      'category': '',
      'done': false,
      'timerSeconds': 0,
    },
  ];

  static List<Map<String, dynamic>> challengesGroup = [
    {
      'id': 'c1',
      'title': 'تحدي الإنتاجية الشهري',
      'desc': 'أكمل 50 مهمة خلال شهر فبراير',
      'teamProgress': 42,
      'total': 50,
      'meProgress': 65,
      'deadlineLabel': 'حتى 1445/8/19 هـ',
      'participants': 24,
    },
    {
      'id': 'c2',
      'title': 'سباق الابتكار',
      'desc': 'اقترح أفكار جديدة لتحسين المنتج',
      'teamProgress': 3,
      'total': 5,
      'meProgress': 80,
      'deadlineLabel': 'حتى 1445/8/18 هـ',
      'participants': 18,
    },
  ];

  static List<Map<String, dynamic>> teamProgress = [
    {
      'id': 'p1',
      'title': 'تحدي الإنتاجية الشهري',
      'percent': 65,
      'deadlineLabel': 'حتى 1445/8/19 هـ',
      'participants': 24,
    },
    {
      'id': 'p2',
      'title': 'سباق الابتكار',
      'percent': 80,
      'deadlineLabel': 'حتى 1445/8/18 هـ',
      'participants': 18,
    },
    {
      'id': 'p3',
      'title': 'مهمة التعاون الجماعي',
      'percent': 45,
      'deadlineLabel': 'حتى 1445/8/20 هـ',
      'participants': 32,
    },
  ];
}

class TasksFixture {
  static List<Map<String, dynamic>> tasks = [
    {'id': 1, 'title': 'مهمة 1', 'done': false},
    {'id': 2, 'title': 'مهمة 2', 'done': true},
    {'id': 3, 'title': 'مهمة 3', 'done': false},
  ];
}


