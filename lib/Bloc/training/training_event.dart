import 'package:equatable/equatable.dart';

abstract class TrainingEvent extends Equatable {
  const TrainingEvent();
  @override
  List<Object?> get props => [];
}

class TrainingOpened extends TrainingEvent {}
class TrainingRefreshed extends TrainingEvent {}


