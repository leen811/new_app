import 'package:bloc/bloc.dart';
import '../../Data/Repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IProfileRepository repository;
  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<ProfileLoad>(_onLoad);
  }

  Future<void> _onLoad(ProfileLoad event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    await Future<void>.delayed(const Duration(milliseconds: 600));
    try {
      final me = await repository.me();
      emit(ProfileLoaded(me));
    } catch (e) {
      emit(const ProfileError('تعذر تحميل الحساب'));
    }
  }
}


