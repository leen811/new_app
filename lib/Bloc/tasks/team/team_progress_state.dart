import 'package:equatable/equatable.dart';
import '../../../Data/Models/team_progress_item.dart';

abstract class TeamProgressState extends Equatable {
  const TeamProgressState();
  @override
  List<Object?> get props => [];
}

class TeamProgressInitial extends TeamProgressState {}
class TeamProgressLoading extends TeamProgressState {}
class TeamProgressEmpty extends TeamProgressState {}
class TeamProgressError extends TeamProgressState { final String message; const TeamProgressError(this.message); @override List<Object?> get props => [message]; }
class TeamProgressSuccess extends TeamProgressState { final List<TeamProgressItem> items; const TeamProgressSuccess(this.items); @override List<Object?> get props => [items]; }


