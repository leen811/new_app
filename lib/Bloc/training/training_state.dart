import 'package:equatable/equatable.dart';
import '../../Data/Models/training_alert.dart';
import '../../Data/Models/skill_progress.dart';

abstract class TrainingState extends Equatable {
  const TrainingState();
  @override
  List<Object?> get props => [];
}

class TrainingLoading extends TrainingState {}
class TrainingError extends TrainingState { final String message; const TrainingError(this.message); @override List<Object?> get props => [message]; }
class TrainingSuccess extends TrainingState {
  final List<TrainingAlert> alerts;
  final List<SkillProgress> skills;
  const TrainingSuccess({required this.alerts, required this.skills});
  @override
  List<Object?> get props => [alerts, skills];
}


