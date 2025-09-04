import 'package:equatable/equatable.dart';
import '../../Data/Models/team_lead_models.dart';

abstract class TeamLeadState extends Equatable {
  const TeamLeadState();
  
  @override
  List<Object?> get props => [];
}

class TLInitial extends TeamLeadState {
  const TLInitial();
}

class TLLoading extends TeamLeadState {
  const TLLoading();
}

class TLLoaded extends TeamLeadState {
  final TeamLeadDashboardData data;
  final int quickTab;
  
  const TLLoaded({
    required this.data,
    this.quickTab = 0,
  });
  
  @override
  List<Object?> get props => [data, quickTab];
}

class TLError extends TeamLeadState {
  final String message;
  
  const TLError(this.message);
  
  @override
  List<Object?> get props => [message];
}
