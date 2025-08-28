class ChatDetailFixture {
  static List<Map<String, dynamic>> page({required DateTime from, required bool older}) {
    final base = <Map<String, dynamic>>[
      {
        'id': 'm1',
        'authorId': '2',
        'authorName': 'أحمد محمد',
        'isMe': false,
        'text': 'مرحبًا، كيف الحال؟',
        'createdAt': from.subtract(const Duration(minutes: 4)).toIso8601String(),
      },
      {
        'id': 'm2',
        'authorId': 'me',
        'authorName': 'أنا',
        'isMe': true,
        'text': 'بخير، هل أنهيت المهمة الجديدة؟',
        'createdAt': from.subtract(const Duration(minutes: 2)).toIso8601String(),
      },
    ];
    if (older) {
      return base.map((e) => {
            ...e,
            'id': 'old-${e['id']}',
            'createdAt': DateTime.parse(e['createdAt'] as String).subtract(const Duration(hours: 6)).toIso8601String(),
          }).toList();
    }
    return base;
  }

  static Map<String, dynamic> sendOk() => {
        'ok': true,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'at': DateTime.now().toIso8601String(),
      };
}


