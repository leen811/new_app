import 'package:equatable/equatable.dart';

class LoadPresence extends Equatable {
  final String? query;
  final String? department;
  final String presence; // 'all' | 'present' | 'absent'
  const LoadPresence({this.query, this.department, this.presence = 'all'});
  @override
  List<Object?> get props => [query, department, presence];
}


