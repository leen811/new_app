import 'package:equatable/equatable.dart';

abstract class TeamProgressEvent extends Equatable {
  const TeamProgressEvent();
  @override
  List<Object?> get props => [];
}

class TeamProgressFetch extends TeamProgressEvent {}
class TeamProgressRefresh extends TeamProgressEvent {}


