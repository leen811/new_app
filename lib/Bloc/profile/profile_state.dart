import 'package:equatable/equatable.dart';
import '../../Data/Models/profile_user.dart';
import '../../Data/Models/performance_overview.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfileSuccess extends ProfileState {
  final ProfileUser user;
  final PerformanceOverview perf;
  const ProfileSuccess({required this.user, required this.perf});
  @override
  List<Object?> get props => [user, perf];
}


