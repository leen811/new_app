import 'package:equatable/equatable.dart';
import '../../../Data/Models/course_item.dart';

abstract class CoursesState extends Equatable {
  const CoursesState();
  @override
  List<Object?> get props => [];
}

class CoursesLoading extends CoursesState {}
class CoursesError extends CoursesState { final String message; const CoursesError(this.message); @override List<Object?> get props => [message]; }
class CoursesSuccess extends CoursesState {
  final List<CourseItem> items;
  final String category;
  final int? nextPage;
  final bool loadingMore;
  const CoursesSuccess({required this.items, required this.category, required this.nextPage, required this.loadingMore});
  CoursesSuccess copyWith({List<CourseItem>? items, String? category, int? nextPage, bool? loadingMore}) => CoursesSuccess(items: items ?? this.items, category: category ?? this.category, nextPage: nextPage ?? this.nextPage, loadingMore: loadingMore ?? this.loadingMore);
  @override
  List<Object?> get props => [items, category, nextPage, loadingMore];
}


