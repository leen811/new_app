import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../Bloc/attendance/attendance_bloc.dart';
import '../../Bloc/attendance/attendance_event.dart';
import '../../Bloc/attendance/attendance_state.dart';
import '../../Data/Repositories/attendance_repository.dart';
import '../../Data/Repositories/geofence_repository.dart';
import '../../Data/Repositories/policy_repository.dart';
import '../../Data/Repositories/location_source.dart';
import '../_shared/attendance_fabs.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => AttendanceBloc(
        attendanceRepository: ctx.read<IAttendanceRepository>(),
        geofenceRepository: ctx.read<IGeofenceRepository>(),
        policyRepository: ctx.read<IPolicyRepository>(),
        locationSource: ctx.read<ILocationSource>(),
      )..add(AttendanceInitRequested()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F8FA),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
            onPressed: () => context.go('/'),
          ),
          title: const Text(
            'الحضور والانصراف',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<AttendanceBloc, AttendanceState>(
          builder: (context, state) {
            // عرض رسالة الخطأ إذا وُجدت
            if (state.errorMessage == 'OUT_OF_GEOFENCE') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('لا يمكنك تسجيل الحضور خارج موقع العمل'),
                    backgroundColor: Colors.red[600],
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                  ),
                );
              });
            }
            
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // الهيدر مع الوقت والتاريخ
                  _buildHeader(context, state),
                  const SizedBox(height: 16),
                  
                  // البطاقة الرئيسية الرمادية
                  _buildMainCard(context, state),
                  const SizedBox(height: 16),
                  
                  // التبويبات
                  _buildTabsSection(context, state),
                  const SizedBox(height: 16),
                  
                  // الحضور الأسبوعي
                  _buildWeeklyAttendance(context),
                  const SizedBox(height: 100), // مساحة للأزرار العائمة
                ],
              ),
            );
          },
        ),
        floatingActionButton: const AttendanceFABs(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AttendanceState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الوقت الكبير
          Text(
            '12:02 م',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 4),
          // التاريخ الهجري
          Text(
            'الثلاثاء، ١٠ ربيع الأول ١٤٤٧ هـ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          // الشارات
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'لم يتم تسجيل الحضور',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'عدد ساعات العمل: 00:00',
                  style: TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // عرض الموقع إذا كان مسجل حضور
          if (state.isCheckedIn && state.lastPosition != null) ...[
            Row(
              children: [
                Icon(Icons.place_rounded, color: Colors.blue[600], size: 16),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    state.lastAddress ?? '${state.lastPosition!.latitude.toStringAsFixed(5)}, ${state.lastPosition!.longitude.toStringAsFixed(5)}',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, AttendanceState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // حالة الحضور
          Row(
            children: [
              Icon(Icons.access_time_rounded, color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              Text(
                state.isCheckedIn ? 'مسجل حضور' : 'لم تسجل الحضور بعد',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // صفان من مربعات الوقت
          Row(
            children: [
              Expanded(
                child: _buildTimeCard(
                  context,
                  'إجمالي ساعات العمل',
                  _formatDuration(state.totalWorkDuration),
                  Icons.work_outline_rounded,
                  state.isCheckedIn ? 'جاري العمل' : 'سجل الحضور لبدء العداد',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimeCard(
                  context,
                  'وقت الاستراحة',
                  _formatDuration(state.breakDuration),
                  Icons.local_cafe_outlined,
                  state.isOnBreak ? 'في استراحة حالياً' : 'إجمالي وقت الاستراحة',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // صف مصغر لثلاث قيم
          Row(
            children: [
              Expanded(
                child: _buildSmallInfoCard(context, 'بداية العمل', state.checkInAt != null ? 
                  '${state.checkInAt!.hour.toString().padLeft(2, '0')}:${state.checkInAt!.minute.toString().padLeft(2, '0')}' : '--:--'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSmallInfoCard(context, 'ساعات العمل الفعلية', _formatDuration(state.pureWorkDuration)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSmallInfoCard(context, 'نهاية العمل', '--:--'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // سطر ملاحظة
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: Colors.amber[600], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'استخدم الزر الأزرق العائم لتسجيل الحضور وبدء العداد',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context, String title, String time, IconData icon, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInfoCard(BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF64748B),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsSection(BuildContext context, AttendanceState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              labelColor: const Color(0xFF1E3A8A),
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: const Color(0xFF1E3A8A),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              tabs: const [
                Tab(text: 'نظرة عامة'),
                Tab(text: 'الموقع'),
                Tab(text: 'الجهاز'),
                Tab(text: 'الإحصائيات'),
              ],
            ),
            SizedBox(
              height: 240,
              child: TabBarView(
                children: [
                  _buildOverviewTab(context, state),
                  _buildLocationTab(context, state),
                  _buildDeviceTab(context),
                  _buildStatisticsTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, AttendanceState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // بطاقتان صغيرتان
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'وقت الحضور',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '--:--',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'وقت الانصراف',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '--:--',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // ملخص اليوم
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ملخص اليوم',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('إجمالي ساعات العمل:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text(_formatDuration(state.totalWorkDuration), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ساعات العمل الفعلية:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text(_formatDuration(state.pureWorkDuration), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('وقت الاستراحة:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text(_formatDuration(state.breakDuration), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الحالة الحالية:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text(
                      state.isCheckedIn ? 'حاضر' : 'غير حاضر',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: state.isCheckedIn ? Colors.green[600] : Colors.orange[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // الطقس اليوم
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.public_rounded, color: Colors.blue[600], size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'الطقس اليوم',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الحرارة:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    const Text('26°C', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الحالة:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    const Text('مشمس', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الرطوبة:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    const Text('58%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTab(BuildContext context, AttendanceState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات الموقع',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المدينة: غير محدد',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'العنوان: غير متاح',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ملاحظات: تأكد من تفعيل الموقع للسماح بتسجيل الحضور',
                    style: TextStyle(color: Colors.amber[800], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'بيانات الجهاز',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('نوع الجهاز: Android', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 8),
                Text('إصدار النظام: 13.0', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 8),
                Text('معرف الجهاز: ABC123', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإحصائيات',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'لا توجد إحصائيات متاحة بعد',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyAttendance(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline_rounded, color: Colors.grey[600], size: 16),
              const SizedBox(width: 6),
              Text(
                'الحضور الأسبوعي',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // قائمة أيام الأسبوع
          ...List.generate(7, (index) {
            final days = ['السبت', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'];
            final times = ['08:00 - 16:30', '08:15 - 16:15', '07:45 - 17:00', '08:10 - 16:25', '08:20 - 16:05', '--:-- - --:--', '--:-- - --:--'];
            final durations = ['ساعة 8.5', 'ساعة 8', 'ساعة 9.2', 'ساعة 8', 'ساعة 7.8', '--', '--'];
            final isPresent = index < 5;
            
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            days[index],
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            times[index],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            durations[index],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isPresent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'حاضر',
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'غائب',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                if (index < 6) const Divider(height: 20, thickness: 0.5),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}