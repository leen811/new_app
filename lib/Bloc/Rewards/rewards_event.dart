import 'package:equatable/equatable.dart';

abstract class RewardsEvent extends Equatable {
  const RewardsEvent();
  
  @override
  List<Object?> get props => [];
}

class RewardsLoad extends RewardsEvent {
  const RewardsLoad();
}

class RewardsChangeCategory extends RewardsEvent {
  final int index;
  
  const RewardsChangeCategory(this.index);
  
  @override
  List<Object?> get props => [index];
}
