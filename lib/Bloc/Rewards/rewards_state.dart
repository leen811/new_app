import 'package:equatable/equatable.dart';
import '../../Data/Models/rewards_models.dart';

abstract class RewardsState extends Equatable {
  const RewardsState();
  
  @override
  List<Object?> get props => [];
}

class RewardsInitial extends RewardsState {
  const RewardsInitial();
}

class RewardsLoading extends RewardsState {
  const RewardsLoading();
}

class RewardsLoaded extends RewardsState {
  final Balance balance;
  final Map<RewardCategory, List<RewardItem>> items;
  final List<ActivityItem> activity;
  final int currentIndex;
  
  const RewardsLoaded({
    required this.balance,
    required this.items,
    required this.activity,
    required this.currentIndex,
  });
  
  @override
  List<Object?> get props => [balance, items, activity, currentIndex];
}

class RewardsError extends RewardsState {
  final String message;
  
  const RewardsError(this.message);
  
  @override
  List<Object?> get props => [message];
}
