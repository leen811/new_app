import 'package:equatable/equatable.dart';

abstract class ChallengesEvent extends Equatable {
  const ChallengesEvent();
  @override
  List<Object?> get props => [];
}

class ChallengesFetch extends ChallengesEvent {}
class ChallengesRefresh extends ChallengesEvent {}


