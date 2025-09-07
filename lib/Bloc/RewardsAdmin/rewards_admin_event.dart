import 'package:equatable/equatable.dart';

abstract class RewardsAdminEvent extends Equatable {
  const RewardsAdminEvent();
  @override
  List<Object?> get props => [];
}

class RewardsLoad extends RewardsAdminEvent {}

class RewardsChangeTab extends RewardsAdminEvent {
  final int index;
  const RewardsChangeTab(this.index);
  @override
  List<Object?> get props => [index];
}

class RewardsSearchChanged extends RewardsAdminEvent {
  final String query;
  const RewardsSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class RewardsGrantSubmit extends RewardsAdminEvent {
  final String employeeId;
  final int amount;
  final String reason;
  final bool deduct;
  const RewardsGrantSubmit({
    required this.employeeId,
    required this.amount,
    required this.reason,
    this.deduct = false,
  });
  @override
  List<Object?> get props => [employeeId, amount, reason, deduct];
}

class RewardsQuickAmount extends RewardsAdminEvent {
  final int value;
  const RewardsQuickAmount(this.value);
  @override
  List<Object?> get props => [value];
}

class RewardsSelectReason extends RewardsAdminEvent {
  final String reasonId;
  const RewardsSelectReason(this.reasonId);
  @override
  List<Object?> get props => [reasonId];
}

class RewardsGrantGroup extends RewardsAdminEvent {
  final String reasonId;
  const RewardsGrantGroup(this.reasonId);
  @override
  List<Object?> get props => [reasonId];
}


