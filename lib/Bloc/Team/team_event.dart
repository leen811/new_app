import 'package:equatable/equatable.dart';
import '../../Data/Models/team_models.dart';

abstract class TeamEvent extends Equatable {
  const TeamEvent();
  @override
  List<Object?> get props => [];
}

class TeamLoad extends TeamEvent {
  const TeamLoad();
}

class TeamSearchChanged extends TeamEvent {
  final String q;
  const TeamSearchChanged(this.q);
  @override
  List<Object?> get props => [q];
}

class TeamOpenMember extends TeamEvent {
  final String id;
  const TeamOpenMember(this.id);
  @override
  List<Object?> get props => [id];
}

class TeamUpdateMember extends TeamEvent {
  final String id;
  final String? title;
  final MemberAvailability? availability;
  final List<String>? skills;
  const TeamUpdateMember(
    this.id, {
    this.title,
    this.availability,
    this.skills,
  });
  @override
  List<Object?> get props => [id, title, availability, skills];
}

class TeamAddMember extends TeamEvent {
  const TeamAddMember();
}


