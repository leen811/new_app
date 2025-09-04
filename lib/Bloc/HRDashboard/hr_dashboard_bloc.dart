import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repositories/hr_dashboard_repository.dart';
import 'hr_dashboard_event.dart';
import 'hr_dashboard_state.dart';

/// BLoC لإدارة حالة لوحة تحكم الموارد البشرية
class HrDashboardBloc extends Bloc<HrDashboardEvent, HrDashboardState> {
  final HrDashboardRepository repository;
  
  HrDashboardBloc(this.repository) : super(const HRInitial()) {
    on<HRLoad>(_onLoad);
    on<HRChangeQuickTab>(_onChangeQuickTab);
  }
  
  /// معالج حدث تحميل البيانات
  Future<void> _onLoad(HRLoad event, Emitter<HrDashboardState> emit) async {
    emit(const HRLoading());
    
    try {
      final data = await repository.fetch();
      emit(HRLoaded(data: data, quickTab: 0));
    } catch (e) {
      emit(HRError('حدث خطأ أثناء تحميل البيانات: ${e.toString()}'));
    }
  }
  
  /// معالج حدث تغيير التبويب السريع
  void _onChangeQuickTab(HRChangeQuickTab event, Emitter<HrDashboardState> emit) {
    if (state is HRLoaded) {
      final currentState = state as HRLoaded;
      emit(currentState.copyWith(quickTab: event.index));
    }
  }
}
