import 'package:equatable/equatable.dart';

abstract class CoursesEvent extends Equatable {
  const CoursesEvent();
  @override
  List<Object?> get props => [];
}

class CoursesOpened extends CoursesEvent { final String category; const CoursesOpened(this.category); @override List<Object?> get props => [category]; }
class FilterChanged extends CoursesEvent { final String category; const FilterChanged(this.category); @override List<Object?> get props => [category]; }
class LoadMore extends CoursesEvent {}
class BookmarkToggled extends CoursesEvent { final String id; const BookmarkToggled(this.id); @override List<Object?> get props => [id]; }


