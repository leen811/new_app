import 'package:bloc/bloc.dart';
import '../../Data/Repositories/profile_repository.dart';
import '../../Data/Models/profile_user.dart';
import '../../Data/Models/performance_overview.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IProfileRepository repository;
  ProfileBloc(this.repository) : super(ProfileLoading()) {
    on<ProfileOpened>(_onLoad);
    on<ProfileRefreshed>(_onLoad);
  }

  Future<void> _onLoad(ProfileEvent event, Emitter<ProfileState> emit) async {
    if (state is! ProfileSuccess) emit(ProfileLoading());
    await Future<void>.delayed(const Duration(milliseconds: 600));
    try {
      final userMap = await repository.me();
      final perfMap = await repository.performance();
      emit(ProfileSuccess(user: ProfileUser.fromJson(userMap), perf: PerformanceOverview.fromJson(perfMap)));
    } catch (e) {
      emit(const ProfileError('تعذر تحميل الملف الشخصي'));
    }
  }
}


