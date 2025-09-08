import 'package:equatable/equatable.dart';
import '../../Data/Models/team_models.dart';

abstract class TeamState extends Equatable {
  const TeamState();
  @override
  List<Object?> get props => [];
}

class TeamInitial extends TeamState {
  const TeamInitial();
}

class TeamLoading extends TeamState {
  const TeamLoading();
}

class TeamLoaded extends TeamState {
  final TeamKpis kpis;
  final List<TeamMember> members;
  final String query;

  const TeamLoaded({
    required this.kpis,
    required this.members,
    required this.query,
  });

  TeamLoaded copyWith({
    TeamKpis? kpis,
    List<TeamMember>? members,
    String? query,
  }) {
    return TeamLoaded(
      kpis: kpis ?? this.kpis,
      members: members ?? this.members,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [kpis, members, query];
}

class TeamError extends TeamState {
  final String message;
  const TeamError(this.message);
  @override
  List<Object?> get props => [message];
}


