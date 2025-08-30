import 'package:bloc/bloc.dart';
import 'training_event.dart';
import 'training_state.dart';
import '../../Data/Repositories/training_repository.dart';
import '../../Data/Models/training_alert.dart';
import '../../Data/Models/skill_progress.dart';

class TrainingBloc extends Bloc<TrainingEvent, TrainingState> {
  final ITrainingRepository repository;
  TrainingBloc(this.repository) : super(TrainingLoading()) {
    on<TrainingOpened>(_load);
    on<TrainingRefreshed>(_load);
  }

  Future<void> _load(TrainingEvent event, Emitter<TrainingState> emit) async {
    if (event is! TrainingRefreshed) emit(TrainingLoading());
    try {
      final results = await Future.wait([
        repository.alerts(),
        repository.skills(),
      ]);
      final alerts = List<Map<String, dynamic>>.from(results[0] as List).map((e) => TrainingAlert.fromJson(e)).toList();
      final skills = List<Map<String, dynamic>>.from(results[1] as List).map((e) => SkillProgress.fromJson(e)).toList();
      emit(TrainingSuccess(alerts: alerts, skills: skills));
    } catch (_) {
      emit(const TrainingError('تعذر تحميل بيانات التدريب'));
    }
  }
}


