import 'package:equatable/equatable.dart';

class LoadPresence extends Equatable {
  final String? query;
  final String? department;
  const LoadPresence({this.query, this.department});
  @override
  List<Object?> get props => [query, department];
}


