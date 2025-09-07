import 'package:equatable/equatable.dart';
import '../../Data/Models/store_models.dart';

abstract class StoreAdminState extends Equatable {
  const StoreAdminState();
  @override
  List<Object?> get props => [];
}

class StoreLoading extends StoreAdminState { const StoreLoading(); }

class StoreError extends StoreAdminState {
  final String msg; const StoreError(this.msg);
  @override
  List<Object?> get props => [msg];
}

class StoreLoaded extends StoreAdminState {
  final List<StoreProduct> items;
  final String query;
  final bool saving;
  final String? uploadingUrl;

  const StoreLoaded({required this.items, required this.query, required this.saving, required this.uploadingUrl});

  StoreLoaded copyWith({List<StoreProduct>? items, String? query, bool? saving, String? uploadingUrl}) => StoreLoaded(
        items: items ?? this.items,
        query: query ?? this.query,
        saving: saving ?? this.saving,
        uploadingUrl: uploadingUrl ?? this.uploadingUrl,
      );

  @override
  List<Object?> get props => [items, query, saving, uploadingUrl];
}


