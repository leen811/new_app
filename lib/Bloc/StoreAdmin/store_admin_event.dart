import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../Data/Models/store_models.dart';

abstract class StoreAdminEvent extends Equatable {
  const StoreAdminEvent();
  @override
  List<Object?> get props => [];
}

class StoreLoad extends StoreAdminEvent {
  final String query;
  const StoreLoad({this.query = ''});
  @override
  List<Object?> get props => [query];
}

class StoreSearchChanged extends StoreAdminEvent {
  final String q;
  const StoreSearchChanged(this.q);
  @override
  List<Object?> get props => [q];
}

class StoreCreateRequested extends StoreAdminEvent {}
class StoreEditRequested extends StoreAdminEvent { final StoreProduct p; const StoreEditRequested(this.p); @override List<Object?> get props => [p]; }
class StoreDeleteRequested extends StoreAdminEvent { final String id; const StoreDeleteRequested(this.id); @override List<Object?> get props => [id]; }
class StoreToggleActive extends StoreAdminEvent { final String id; final bool active; const StoreToggleActive(this.id, this.active); @override List<Object?> get props => [id, active]; }

class StoreSaveSubmitted extends StoreAdminEvent {
  final String? id; final String name; final int tokenPrice; final String imageUrl; final bool featured;
  const StoreSaveSubmitted({this.id, required this.name, required this.tokenPrice, required this.imageUrl, this.featured = false});
  @override
  List<Object?> get props => [id, name, tokenPrice, imageUrl, featured];
}

class StoreImagePicked extends StoreAdminEvent {
  final Uint8List bytes; final String filename;
  const StoreImagePicked(this.bytes, this.filename);
  @override
  List<Object?> get props => [bytes, filename];
}


