class GeofencesFixture {
  static List<Map<String, dynamic>> list = [
    {
      'id': 'A',
      'name': 'المكتب الرئيسي',
      'type': 'circle',
      'center': {'lat': 24.7136, 'lng': 46.6753},
      'radiusM': 150
    },
    {
      'id': 'B',
      'name': 'مستودع',
      'type': 'polygon',
      'polygon': [
        {'lat': 24.714, 'lng': 46.675},
        {'lat': 24.715, 'lng': 46.678},
        {'lat': 24.713, 'lng': 46.679},
      ]
    }
  ];
}


