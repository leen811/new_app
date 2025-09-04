import 'package:equatable/equatable.dart';
import '../../Data/Models/hr_dashboard_models.dart';

/// حالات لوحة تحكم الموارد البشرية
abstract class HrDashboardState extends Equatable {
  const HrDashboardState();
  
  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class HRInitial extends HrDashboardState {
  const HRInitial();
}

/// حالة التحميل
class HRLoading extends HrDashboardState {
  const HRLoading();
}

/// حالة التحميل الناجح
class HRLoaded extends HrDashboardState {
  final HrDashboardData data;
  final int quickTab;
  
  const HRLoaded({
    required this.data,
    this.quickTab = 0,
  });
  
  @override
  List<Object?> get props => [data, quickTab];
  
  /// نسخ الحالة مع تحديث التبويب السريع
  HRLoaded copyWith({
    HrDashboardData? data,
    int? quickTab,
  }) {
    return HRLoaded(
      data: data ?? this.data,
      quickTab: quickTab ?? this.quickTab,
    );
  }
}

/// حالة الخطأ
class HRError extends HrDashboardState {
  final String message;
  
  const HRError(this.message);
  
  @override
  List<Object?> get props => [message];
}
