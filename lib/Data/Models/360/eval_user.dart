import 'package:equatable/equatable.dart';

class EvalUser extends Equatable {
  final String id;
  final String name;
  final String role;
  final String dept;
  final String? avatarUrl;
  const EvalUser({required this.id, required this.name, required this.role, required this.dept, this.avatarUrl});
  factory EvalUser.fromJson(Map<String, dynamic> j) => EvalUser(
        id: j['id'] as String? ?? 'me',
        name: j['name'] as String,
        role: j['role'] as String,
        dept: j['dept'] as String,
        avatarUrl: j['avatarUrl'] as String?,
      );
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'role': role, 'dept': dept, 'avatarUrl': avatarUrl};
  @override
  List<Object?> get props => [id, name, role, dept, avatarUrl];
}


