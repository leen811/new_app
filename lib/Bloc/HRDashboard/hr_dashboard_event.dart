import 'package:equatable/equatable.dart';

/// أحداث لوحة تحكم الموارد البشرية
abstract class HrDashboardEvent extends Equatable {
  const HrDashboardEvent();
  
  @override
  List<Object?> get props => [];
}

/// حدث تحميل البيانات
class HRLoad extends HrDashboardEvent {
  const HRLoad();
}

/// حدث تغيير التبويب السريع
class HRChangeQuickTab extends HrDashboardEvent {
  final int index;
  
  const HRChangeQuickTab(this.index);
  
  @override
  List<Object?> get props => [index];
}
