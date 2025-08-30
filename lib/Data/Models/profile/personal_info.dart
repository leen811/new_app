import 'package:equatable/equatable.dart';

class PersonalInfo extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String employeeNo;
  final String role;
  final String dept;
  final String manager;
  final String city;
  final String country;
  final String address;
  final String joinDate;
  final int level;
  final int coins;
  final String? avatarUrl;
  final Map<String, num>? kpis;
  final bool notificationsEmail;
  final String language;
  const PersonalInfo({required this.id, required this.fullName, required this.email, required this.phone, required this.employeeNo, required this.role, required this.dept, required this.manager, required this.city, required this.country, required this.address, required this.joinDate, required this.level, required this.coins, this.avatarUrl, this.notificationsEmail=false, this.language='العربية', this.kpis});
  factory PersonalInfo.fromJson(Map<String, dynamic> j) => PersonalInfo(
        id: j['id'] as String,
        fullName: j['fullName'] as String,
        email: j['email'] as String,
        phone: j['phone'] as String,
        employeeNo: j['employeeNo'] as String,
        role: j['role'] as String,
        dept: j['dept'] as String,
        manager: j['manager'] as String,
        city: j['city'] as String,
        country: j['country'] as String,
        address: j['address'] as String,
        joinDate: j['joinDate'] as String,
        level: (j['level'] as num).toInt(),
        coins: (j['coins'] as num).toInt(),
        avatarUrl: j['avatarUrl'] as String?,
        notificationsEmail: (j['notificationsEmail'] as bool?) ?? false,
        language: (j['language'] as String?) ?? 'العربية',
        kpis: (j['kpis'] as Map?)?.cast<String, num>(),
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'employeeNo': employeeNo,
        'role': role,
        'dept': dept,
        'manager': manager,
        'city': city,
        'country': country,
        'address': address,
        'joinDate': joinDate,
        'level': level,
        'coins': coins,
        'avatarUrl': avatarUrl,
        'notificationsEmail': notificationsEmail,
        'language': language,
        'kpis': kpis,
      };
  @override
  List<Object?> get props => [id, fullName, email, phone, employeeNo, role, dept, manager, city, country, address, joinDate, level, coins, avatarUrl, notificationsEmail, language, kpis];
}


