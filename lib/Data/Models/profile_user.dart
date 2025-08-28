import 'package:equatable/equatable.dart';

class ProfileUser extends Equatable {
  final String id;
  final String name;
  final String role;
  final String dept;
  final double tenureYears;
  final int level;
  final int coins;
  final String avatarEmoji;
  final bool online;

  const ProfileUser({
    required this.id,
    required this.name,
    required this.role,
    required this.dept,
    required this.tenureYears,
    required this.level,
    required this.coins,
    required this.avatarEmoji,
    required this.online,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) => ProfileUser(
        id: json['id']?.toString() ?? 'u1',
        name: json['name'] as String,
        role: json['role'] as String,
        dept: json['dept'] as String,
        tenureYears: (json['tenureYears'] as num).toDouble(),
        level: (json['level'] as num).toInt(),
        coins: (json['coins'] as num).toInt(),
        avatarEmoji: json['avatarEmoji'] as String? ?? '👤',
        online: json['online'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [id, name, role, dept, tenureYears, level, coins, avatarEmoji, online];
}


