class DigitalTwinFixture {
  static Map<String, dynamic> overview = {
    'focusPct': 82,
    'energyPct': 78,
    'weeklyProdPct': 86,
    'lifeBalancePct': 75,
    'idealHours': 6.5,
    'stressPct': 24,
  };

  static List<Map<String, dynamic>> recommendations = [
    {
      'id': 'r1',
      'priority': 'عالي',
      'title': 'أوقات العمل المثالية',
      'body': 'أفضل أوقاتك للإنتاجية هي بين 10:00–11:30 صباحًا و 3:00–4:30 عصرًا.',
      'ctas': [
        {'label': 'جدولة المهام المهمة', 'icon': 'event'}
      ]
    },
    {
      'id': 'r2',
      'priority': 'متوسط',
      'title': 'توقيت الاستراحة الأمثل',
      'body': 'أنصحك بأخذ استراحة 15 دقيقة في 12:30 ظهرًا لزيادة تركيزك بعد الظهر.',
      'ctas': [
        {'label': 'جدولة الاستراحة', 'icon': 'timer'}
      ]
    },
    {
      'id': 'r3',
      'priority': 'متوسط',
      'title': 'أوقات الاجتماعات المفضلة',
      'body': 'تكون أكثر فاعلية في الاجتماعات صباحًا بين 9:00–11:00.',
      'ctas': [
        {'label': 'تنظيم الاجتماعات', 'icon': 'groups'}
      ]
    },
    {
      'id': 'r4',
      'priority': 'عالي',
      'title': 'توزيع الأعباء',
      'body': 'ننصح بتوزيع المهام الثقيلة على الثلاثاء والأربعاء عند ذروة أدائك.',
      'ctas': [
        {'label': 'جدولة المهام', 'icon': 'task'}
      ]
    },
  ];

  static List<Map<String, dynamic>> weekly() {
    final days = ['السبت','الأحد','الاثنين','الثلاثاء','الأربعاء','الخميس','الجمعة'];
    final energy = [92, 98, 70, 85, 96, 80, 68];
    final prod = [90, 95, 68, 88, 97, 82, 75];
    return List.generate(days.length, (i) => {'dayAr': days[i], 'energy': energy[i], 'productivity': prod[i]});
  }

  static List<Map<String, dynamic>> daily() {
    final times = ['08:00','09:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00','17:00'];
    final values = [70, 88, 98, 94, 60, 42, 80, 88, 86, 72];
    return List.generate(times.length, (i) => {'timeLabel': times[i], 'value': values[i]});
  }
}


