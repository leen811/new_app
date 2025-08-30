import 'package:bloc/bloc.dart';
import '../../Data/Repositories/digital_twin_repository.dart';
import 'dt_event.dart';
import 'dt_state.dart';

class DtBloc extends Bloc<DtEvent, DtState> {
  final IDigitalTwinRepository repository;
  DtBloc(this.repository) : super(DtInitial()) {
    on<DtFetch>(_onFetch);
  }

  Future<void> _onFetch(DtFetch event, Emitter<DtState> emit) async {
    emit(DtLoading());
    await Future<void>.delayed(const Duration(milliseconds: 600));
    try {
      final summary = await repository.overview();
      if (summary.isEmpty) {
        emit(DtEmpty());
      } else {
        emit(DtLoaded(summary));
      }
    } catch (e) {
      emit(const DtError('خطأ في تحميل البيانات'));
    }
  }
}
