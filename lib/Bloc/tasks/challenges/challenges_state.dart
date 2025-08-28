import 'package:equatable/equatable.dart';
import '../../../Data/Models/challenge_item.dart';

abstract class ChallengesState extends Equatable {
  const ChallengesState();
  @override
  List<Object?> get props => [];
}

class ChallengesInitial extends ChallengesState {}
class ChallengesLoading extends ChallengesState {}
class ChallengesEmpty extends ChallengesState {}
class ChallengesError extends ChallengesState { final String message; const ChallengesError(this.message); @override List<Object?> get props => [message]; }
class ChallengesSuccess extends ChallengesState { final List<ChallengeItem> items; const ChallengesSuccess(this.items); @override List<Object?> get props => [items]; }


