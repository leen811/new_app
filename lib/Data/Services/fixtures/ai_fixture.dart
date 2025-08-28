class AiFixture {
  static Map<String, dynamic> suggest = {
    'welcome': 'مرحبًا! أنا مساعدك الذكي، يمكنني مساعدتك في إدارة مهامك، متابعة أدائك، والإجابة على استفساراتك.',
    'actions': ['جدول اليوم', 'تقرير الأداء', 'الإشعارات', 'وقت الاستراحة'],
  };

  static Map<String, dynamic> reply(String prompt) => {
        'text': 'تلقيت: "$prompt" — إليك إجابة مبدئية ومحاور ذات صلة.'
      };

  static Map<String, dynamic> executed(String action) => {
        'ok': true,
        'action': action,
      };
}


