class TrainingFixture {
  static List<Map<String, dynamic>> alerts = [
    {'id': 'a1', 'title': 'إدارة المشاريع', 'severity': 'عالي', 'body': 'انخفاض في درجات تقييم إدارة المشاريع بنسبة 15% خلال الشهر الماضي', 'ctaLabel': 'عرض الكورسات', 'recommend': 'ننصحك بأخذ دورة متقدمة في إدارة المشاريع'},
    {'id': 'a2', 'title': 'التحليل البياني', 'severity': 'متوسط', 'body': 'فجوة في مهارات التحليل البياني مقارنة بأقرانك في نفس المستوى', 'ctaLabel': 'عرض الكورسات', 'recommend': 'دورة تدريبية Excel المتقدم أو Power BI'},
    {'id': 'a3', 'title': 'الذكاء الاصطناعي', 'severity': 'منخفض', 'body': 'مهارات جديدة مطلوبة في قسمك: الذكاء الاصطناعي وتعلم الآلة', 'ctaLabel': 'عرض الكورسات', 'recommend': 'دورات مبدئية متقدمة في الذكاء الاصطناعي'},
  ];

  static List<Map<String, dynamic>> skills = [
    {'skillName': 'إدارة المشاريع', 'currentPct': 90, 'targetPct': 75},
    {'skillName': 'التحليل البياني', 'currentPct': 80, 'targetPct': 60},
    {'skillName': 'مهارات التواصل', 'currentPct': 90, 'targetPct': 85},
    {'skillName': 'القيادة', 'currentPct': 85, 'targetPct': 70},
    {'skillName': 'الذكاء الاصطناعي', 'currentPct': 50, 'targetPct': 30},
  ];

  static Map<String, dynamic> page({required String category, required int page}) {
    final all = [
      {'id': 'c1', 'title': 'تحليل البيانات باستخدام Excel', 'provider': 'معهد التقنية الحديثة', 'priceLabel': 'ريال 299', 'hours': 25, 'level': 'متوسط', 'rating': 4.6, 'ratingCount': 3200, 'matchPct': 88, 'tags': ['Excel', 'تحليل البيانات', 'إعداد التقارير'], 'reason': 'سبب الاقتراح: لسدّ الفجوة في مهارات التحليل البياني', 'startHijri': '١٤٤٥/٠٩/١٥', 'imageUrl': 'assets/mock/excel.jpg', 'isBookmarked': false, 'cat': 'technology'},
      {'id': 'c2', 'title': 'إدارة المشاريع المتقدمة', 'provider': 'أكاديمية المهارات الرقمية', 'priceLabel': 'مجانا', 'hours': 40, 'level': 'متقدم', 'rating': 4.8, 'ratingCount': 2150, 'matchPct': 95, 'tags': ['إدارة المشاريع', 'التخطيط الاستراتيجي'], 'reason': 'بناءً على انخفاض أدائك في إدارة المشاريع مؤخرًا', 'startHijri': '١٤٤٥/٠٩/١٥', 'imageUrl': 'assets/mock/pm.jpg', 'isBookmarked': true, 'cat': 'management'},
      {'id': 'c3', 'title': 'مهارات التواصل والعرض', 'provider': 'أكاديمية الاتصال المهني', 'priceLabel': 'ريال 199', 'hours': 20, 'level': 'متوسط', 'rating': 4.7, 'ratingCount': 2800, 'matchPct': 75, 'tags': ['التواصل', 'العرض والتقديم', 'التفاوض'], 'reason': 'سبب الاقتراح: لتحسين مهارات العرض والتواصل مع الفريق', 'startHijri': '١٤٤٥/٠٨/١٣', 'imageUrl': 'assets/mock/comm.jpg', 'isBookmarked': false, 'cat': 'soft'},
      {'id': 'c4', 'title': 'أساسيات الذكاء الاصطناعي', 'provider': 'جامعة الملك عبدالعزيز', 'priceLabel': 'مجانا', 'hours': 30, 'level': 'مبتدئ', 'rating': 4.9, 'ratingCount': 1800, 'matchPct': 82, 'tags': ['الذكاء الاصطناعي', 'تعلم الآلة', 'البرمجة'], 'reason': 'سبب الاقتراح: مهارة مطلوبة حديثًا في قسمك', 'startHijri': '١٤٤٥/٠٨/٢٨', 'imageUrl': 'assets/mock/ai.jpg', 'isBookmarked': false, 'cat': 'technology'},
      {'id': 'c5', 'title': 'إدارة الوقت والإنتاجية', 'provider': 'مركز التطوير المهني', 'priceLabel': 'ريال 149', 'hours': 18, 'level': 'مبتدئ', 'rating': 4.6, 'ratingCount': 1490, 'matchPct': 70, 'tags': ['الإنتاجية', 'الوقت'], 'reason': 'سبب الاقتراح: رفع كفاءة إدارة الوقت لديك', 'startHijri': '١٤٤٥/٠٧/٢٠', 'imageUrl': 'assets/mock/time.jpg', 'isBookmarked': false, 'cat': 'productivity'},
    ];
    final filtered = category == 'all' ? all : all.where((e) => e['cat'] == category).toList();
    final pageSize = 6;
    final start = (page - 1) * pageSize;
    final slice = start >= filtered.length ? <Map<String, dynamic>>[] : filtered.sublist(start, (start + pageSize).clamp(0, filtered.length));
    final hasMore = start + pageSize < filtered.length;
    return {
      'items': slice.map((e) => Map<String, dynamic>.from(e)..remove('cat')).toList(),
      'nextPage': hasMore ? page + 1 : null,
    };
  }
}


