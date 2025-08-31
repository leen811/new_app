import 'package:equatable/equatable.dart';

class SettingsGeneral extends Equatable {
  const SettingsGeneral({
    required this.language,
    required this.theme,
    required this.notifications,
    required this.privacy,
    required this.security,
    required this.data,
    required this.region,
    required this.accessibility,
    required this.about,
  });

  final String language; // 'العربية' | 'English'
  final String theme; // 'فاتح' | 'داكن' | 'تلقائي'
  final NotificationsSettings notifications;
  final PrivacySettings privacy;
  final SecuritySettings security;
  final DataSettings data;
  final RegionSettings region;
  final AccessibilitySettings accessibility;
  final AboutSettings about;

  SettingsGeneral copyWith({
    String? language,
    String? theme,
    NotificationsSettings? notifications,
    PrivacySettings? privacy,
    SecuritySettings? security,
    DataSettings? data,
    RegionSettings? region,
    AccessibilitySettings? accessibility,
    AboutSettings? about,
  }) {
    return SettingsGeneral(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
      security: security ?? this.security,
      data: data ?? this.data,
      region: region ?? this.region,
      accessibility: accessibility ?? this.accessibility,
      about: about ?? this.about,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'theme': theme,
      'notifications': notifications.toJson(),
      'privacy': privacy.toJson(),
      'security': security.toJson(),
      'data': data.toJson(),
      'region': region.toJson(),
      'accessibility': accessibility.toJson(),
      'about': about.toJson(),
    };
  }

  static SettingsGeneral fromJson(Map<String, dynamic> json) {
    return SettingsGeneral(
      language: (json['language'] ?? '') as String,
      theme: (json['theme'] ?? '') as String,
      notifications: NotificationsSettings.fromJson(Map<String, dynamic>.from(json['notifications'] ?? {})),
      privacy: PrivacySettings.fromJson(Map<String, dynamic>.from(json['privacy'] ?? {})),
      security: SecuritySettings.fromJson(Map<String, dynamic>.from(json['security'] ?? {})),
      data: DataSettings.fromJson(Map<String, dynamic>.from(json['data'] ?? {})),
      region: RegionSettings.fromJson(Map<String, dynamic>.from(json['region'] ?? {})),
      accessibility: AccessibilitySettings.fromJson(Map<String, dynamic>.from(json['accessibility'] ?? {})),
      about: AboutSettings.fromJson(Map<String, dynamic>.from(json['about'] ?? {})),
    );
  }

  @override
  List<Object?> get props => [language, theme, notifications, privacy, security, data, region, accessibility, about];
}

class NotificationsSettings extends Equatable {
  const NotificationsSettings({required this.push, required this.inApp, required this.email});
  final bool push;
  final bool inApp;
  final bool email;
  NotificationsSettings copyWith({bool? push, bool? inApp, bool? email}) => NotificationsSettings(push: push ?? this.push, inApp: inApp ?? this.inApp, email: email ?? this.email);
  Map<String, dynamic> toJson() => {'push': push, 'inApp': inApp, 'email': email};
  static NotificationsSettings fromJson(Map<String, dynamic> json) => NotificationsSettings(push: (json['push'] ?? false) as bool, inApp: (json['inApp'] ?? false) as bool, email: (json['email'] ?? false) as bool);
  @override
  List<Object?> get props => [push, inApp, email];
}

class PrivacySettings extends Equatable {
  const PrivacySettings({required this.shareAnonymousAnalytics});
  final bool shareAnonymousAnalytics;
  PrivacySettings copyWith({bool? shareAnonymousAnalytics}) => PrivacySettings(shareAnonymousAnalytics: shareAnonymousAnalytics ?? this.shareAnonymousAnalytics);
  Map<String, dynamic> toJson() => {'shareAnonymousAnalytics': shareAnonymousAnalytics};
  static PrivacySettings fromJson(Map<String, dynamic> json) => PrivacySettings(shareAnonymousAnalytics: (json['shareAnonymousAnalytics'] ?? false) as bool);
  @override
  List<Object?> get props => [shareAnonymousAnalytics];
}

class SecuritySettings extends Equatable {
  const SecuritySettings({required this.mfaEnabled});
  final bool mfaEnabled;
  SecuritySettings copyWith({bool? mfaEnabled}) => SecuritySettings(mfaEnabled: mfaEnabled ?? this.mfaEnabled);
  Map<String, dynamic> toJson() => {'mfaEnabled': mfaEnabled};
  static SecuritySettings fromJson(Map<String, dynamic> json) => SecuritySettings(mfaEnabled: (json['mfaEnabled'] ?? false) as bool);
  @override
  List<Object?> get props => [mfaEnabled];
}

class DataSettings extends Equatable {
  const DataSettings({required this.backgroundRefresh, required this.useCellularData, required this.cacheSizeMB});
  final bool backgroundRefresh;
  final bool useCellularData;
  final int cacheSizeMB;
  DataSettings copyWith({bool? backgroundRefresh, bool? useCellularData, int? cacheSizeMB}) => DataSettings(
    backgroundRefresh: backgroundRefresh ?? this.backgroundRefresh,
    useCellularData: useCellularData ?? this.useCellularData,
    cacheSizeMB: cacheSizeMB ?? this.cacheSizeMB,
  );
  Map<String, dynamic> toJson() => {'backgroundRefresh': backgroundRefresh, 'useCellularData': useCellularData, 'cacheSizeMB': cacheSizeMB};
  static DataSettings fromJson(Map<String, dynamic> json) => DataSettings(
    backgroundRefresh: (json['backgroundRefresh'] ?? false) as bool,
    useCellularData: (json['useCellularData'] ?? false) as bool,
    cacheSizeMB: (json['cacheSizeMB'] ?? 0) as int,
  );
  @override
  List<Object?> get props => [backgroundRefresh, useCellularData, cacheSizeMB];
}

class RegionSettings extends Equatable {
  const RegionSettings({required this.calendar, required this.timeFormat, required this.weekStart});
  final String calendar;
  final String timeFormat;
  final String weekStart;
  RegionSettings copyWith({String? calendar, String? timeFormat, String? weekStart}) => RegionSettings(
    calendar: calendar ?? this.calendar,
    timeFormat: timeFormat ?? this.timeFormat,
    weekStart: weekStart ?? this.weekStart,
  );
  Map<String, dynamic> toJson() => {'calendar': calendar, 'timeFormat': timeFormat, 'weekStart': weekStart};
  static RegionSettings fromJson(Map<String, dynamic> json) => RegionSettings(
    calendar: (json['calendar'] ?? '') as String,
    timeFormat: (json['timeFormat'] ?? '') as String,
    weekStart: (json['weekStart'] ?? '') as String,
  );
  @override
  List<Object?> get props => [calendar, timeFormat, weekStart];
}

class AccessibilitySettings extends Equatable {
  const AccessibilitySettings({required this.reduceMotion, required this.biggerText});
  final bool reduceMotion;
  final bool biggerText;
  AccessibilitySettings copyWith({bool? reduceMotion, bool? biggerText}) => AccessibilitySettings(reduceMotion: reduceMotion ?? this.reduceMotion, biggerText: biggerText ?? this.biggerText);
  Map<String, dynamic> toJson() => {'reduceMotion': reduceMotion, 'biggerText': biggerText};
  static AccessibilitySettings fromJson(Map<String, dynamic> json) => AccessibilitySettings(reduceMotion: (json['reduceMotion'] ?? false) as bool, biggerText: (json['biggerText'] ?? false) as bool);
  @override
  List<Object?> get props => [reduceMotion, biggerText];
}

class AboutSettings extends Equatable {
  const AboutSettings({required this.version, required this.build});
  final String version;
  final int build;
  Map<String, dynamic> toJson() => {'version': version, 'build': build};
  static AboutSettings fromJson(Map<String, dynamic> json) => AboutSettings(version: (json['version'] ?? '') as String, build: (json['build'] ?? 0) as int);
  @override
  List<Object?> get props => [version, build];
}


