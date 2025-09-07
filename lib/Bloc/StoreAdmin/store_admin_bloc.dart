import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/store_repository.dart';
import 'store_admin_event.dart';
import 'store_admin_state.dart';

class StoreAdminBloc extends Bloc<StoreAdminEvent, StoreAdminState> {
  final StoreRepository repository;
  StoreAdminBloc(this.repository) : super(const StoreLoading()) {
    on<StoreLoad>(_onLoad);
    on<StoreSearchChanged>(_onSearch);
    on<StoreToggleActive>(_onToggle);
    on<StoreDeleteRequested>(_onDelete);
    on<StoreImagePicked>(_onImagePicked);
    on<StoreSaveSubmitted>(_onSaveSubmitted);
  }

  Future<void> _onLoad(StoreLoad e, Emitter<StoreAdminState> emit) async {
    emit(const StoreLoading());
    try {
      final list = await repository.list(query: e.query);
      emit(StoreLoaded(items: list, query: e.query, saving: false, uploadingUrl: null));
    } catch (err) {
      emit(StoreError(err.toString()));
    }
  }

  Future<void> _onSearch(StoreSearchChanged e, Emitter<StoreAdminState> emit) async {
    final list = await repository.list(query: e.q);
    emit(StoreLoaded(items: list, query: e.q, saving: false, uploadingUrl: null));
  }

  Future<void> _onToggle(StoreToggleActive e, Emitter<StoreAdminState> emit) async {
    final s = state;
    if (s is StoreLoaded) {
      final optimistic = s.items.map((p) => p.id == e.id ? p.copyWith(active: e.active) : p).toList();
      emit(s.copyWith(items: optimistic));
      await repository.update(e.id, active: e.active);
      final refreshed = await repository.list(query: s.query);
      emit(s.copyWith(items: refreshed));
    }
  }

  Future<void> _onDelete(StoreDeleteRequested e, Emitter<StoreAdminState> emit) async {
    final s = state;
    if (s is StoreLoaded) {
      await repository.delete(e.id);
      final refreshed = await repository.list(query: s.query);
      emit(s.copyWith(items: refreshed));
    }
  }

  Future<void> _onImagePicked(StoreImagePicked e, Emitter<StoreAdminState> emit) async {
    final s = state;
    if (s is StoreLoaded) {
      final url = await repository.uploadImage(e.bytes, filename: e.filename);
      emit(s.copyWith(uploadingUrl: url));
    }
  }

  Future<void> _onSaveSubmitted(StoreSaveSubmitted e, Emitter<StoreAdminState> emit) async {
    final s = state;
    if (s is StoreLoaded) {
      emit(s.copyWith(saving: true));
      if (e.id == null) {
        await repository.create(name: e.name, tokenPrice: e.tokenPrice, imageUrl: e.imageUrl, featured: e.featured);
      } else {
        await repository.update(e.id!, name: e.name, tokenPrice: e.tokenPrice, imageUrl: e.imageUrl, featured: e.featured);
      }
      final refreshed = await repository.list(query: s.query);
      emit(s.copyWith(items: refreshed, saving: false, uploadingUrl: null));
    }
  }
}


