class SettingsFixture {
  static const Map<String, dynamic> general = {
    'language': 'العربية',
    'theme': 'تلقائي',
    'region': {
      'calendar': 'هجري/ميلادي',
      'timeFormat': '24 ساعة',
      'weekStart': 'السبت',
    },
    'data': {
      'backgroundRefresh': true,
      'useCellularData': false,
      'cacheSizeMB': 64,
    },
    'privacy': {
      'shareAnonymousAnalytics': true,
    },
    'security': {
      'mfaEnabled': false,
    },
    'about': {
      'version': '1.0.0',
      'build': 100,
    },
  };
}


