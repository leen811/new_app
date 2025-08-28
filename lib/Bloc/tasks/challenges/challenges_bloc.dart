import 'package:bloc/bloc.dart';

import '../../../Data/Repositories/tasks_repository.dart';
import 'challenges_event.dart';
import 'challenges_state.dart';

class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
  final ITasksRepository repository;
  ChallengesBloc(this.repository) : super(ChallengesInitial()) {
    on<ChallengesFetch>(_onFetch);
    on<ChallengesRefresh>(_onFetch);
  }

  Future<void> _onFetch(ChallengesEvent event, Emitter<ChallengesState> emit) async {
    emit(ChallengesLoading());
    await Future<void>.delayed(const Duration(milliseconds: 600));
    try {
      final items = await repository.fetchChallenges();
      if (items.isEmpty) emit(ChallengesEmpty()); else emit(ChallengesSuccess(items));
    } catch (e) {
      emit(const ChallengesError('تعذر تحميل التحديات'));
    }
  }
}


