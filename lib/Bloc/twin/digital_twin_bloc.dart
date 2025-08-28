import 'package:bloc/bloc.dart';
import 'digital_twin_event.dart';
import 'digital_twin_state.dart';
import '../../Data/Repositories/digital_twin_repository.dart';
import '../../Data/Models/twin_overview.dart';
import '../../Data/Models/twin_recommendation.dart';
import '../../Data/Models/twin_weekly_point.dart';
import '../../Data/Models/twin_daily_point.dart';

class DigitalTwinBloc extends Bloc<DigitalTwinEvent, DigitalTwinState> {
  final IDigitalTwinRepository repository;
  DigitalTwinBloc(this.repository) : super(TwinLoading()) {
    on<TwinOpened>(_onLoad);
    on<TwinRefreshed>(_onLoad);
    on<TwinTabChanged>((e, emit) {
      final s = state;
      if (s is TwinSuccess) emit(s.copyWith(tabIndex: e.index));
    });
  }

  Future<void> _onLoad(DigitalTwinEvent event, Emitter<DigitalTwinState> emit) async {
    final isRefresh = event is TwinRefreshed && state is TwinSuccess;
    if (!isRefresh) {
      emit(TwinLoading());
    } else {
      final s = state as TwinSuccess;
      emit(s.copyWith(refreshing: true));
    }
    try {
      final results = await Future.wait([
        repository.overview(),
        repository.recommendations(),
        repository.weekly(),
        repository.daily(),
      ]);
      final overview = TwinOverview.fromJson(results[0] as Map<String, dynamic>);
      final recs = (results[1] as List<Map<String, dynamic>>).map((e) => TwinRecommendation.fromJson(e)).toList();
      final weekly = (results[2] as List<Map<String, dynamic>>).map((e) => TwinWeeklyPoint.fromJson(e)).toList();
      final daily = (results[3] as List<Map<String, dynamic>>).map((e) => TwinDailyPoint.fromJson(e)).toList();
      final currentTab = state is TwinSuccess ? (state as TwinSuccess).tabIndex : 0;
      emit(TwinSuccess(overview: overview, recs: recs, weekly: weekly, daily: daily, tabIndex: currentTab, refreshing: false));
    } catch (e) {
      emit(const TwinError('تعذر تحميل التوأم الرقمي'));
    }
  }
}


