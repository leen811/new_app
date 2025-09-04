import 'package:equatable/equatable.dart';

abstract class TeamLeadEvent extends Equatable {
  const TeamLeadEvent();
  
  @override
  List<Object?> get props => [];
}

class TLLoad extends TeamLeadEvent {
  const TLLoad();
}

class TLChangeQuickTab extends TeamLeadEvent {
  final int index;
  
  const TLChangeQuickTab(this.index);
  
  @override
  List<Object?> get props => [index];
}
