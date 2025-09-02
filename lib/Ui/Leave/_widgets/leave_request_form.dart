import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Data/Models/leave_models.dart';
import '../../../Bloc/leave/leave_bloc.dart';
import '../../../Bloc/leave/leave_event.dart';
import '../../../Bloc/leave/leave_state.dart';

class LeaveRequestForm extends StatefulWidget {
  const LeaveRequestForm({super.key});

  @override
  State<LeaveRequestForm> createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // نموذج طلب الإجازة
  LeaveType _selectedLeaveType = LeaveType.annual;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _leaveReasonController = TextEditingController();
  
  // نموذج طلب الاستئذان
  PermissionType _selectedPermissionType = PermissionType.earlyLeave;
  DateTime? _permissionDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  final TextEditingController _permissionReasonController = TextEditingController();
  
  final _leaveFormKey = GlobalKey<FormState>();
  final _permissionFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _leaveReasonController.dispose();
    _permissionReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ترويسة الكارد
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.assignment_turned_in_rounded,
                    size: 18,
                    color: Color(0xFF2E3A8C),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'الاستئذان وطلب الإجازات',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          // التبويبات
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              tabAlignment: TabAlignment.fill,
              dividerColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 0,
              indicatorPadding: const EdgeInsets.all(4),
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: const Color(0xFF2E3A8C),
              unselectedLabelColor: const Color(0xFF666666),
              labelStyle: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'طلب إجازة'),
                Tab(text: 'طلب استئذان'),
              ],
            ),
          ),
          // محتوى التبويبات
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildLeaveRequestTab(),
                _buildPermissionRequestTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Form(
        key: _leaveFormKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // نوع الإجازة
            DropdownButtonFormField<LeaveType>(
              initialValue: _selectedLeaveType,
              decoration: InputDecoration(
                labelText: 'نوع الإجازة',
                labelStyle: GoogleFonts.cairo(
                  color: const Color(0xFF666666),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E3A8C), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                ),
                filled: true,
                fillColor: const Color(0xFFF8F8F8),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: LeaveType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName, style: GoogleFonts.cairo()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLeaveType = value!;
                });
              },
              validator: (value) {
                if (value == null) return 'يرجى اختيار نوع الإجازة';
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // تاريخ البداية
            InkWell(
              onTap: () => _selectDate(context, true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFFAFAFA),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF1E3A8A), size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _startDate != null
                          ? '${_startDate!.year}/${_startDate!.month.toString().padLeft(2, '0')}/${_startDate!.day.toString().padLeft(2, '0')}'
                          : 'تاريخ البداية',
                      style: GoogleFonts.cairo(
                        color: _startDate != null ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // تاريخ النهاية
            InkWell(
              onTap: () => _selectDate(context, false),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFFAFAFA),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF1E3A8A), size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _endDate != null
                          ? '${_endDate!.year}/${_endDate!.month.toString().padLeft(2, '0')}/${_endDate!.day.toString().padLeft(2, '0')}'
                          : 'تاريخ النهاية',
                      style: GoogleFonts.cairo(
                        color: _endDate != null ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // سبب الإجازة
            TextFormField(
              controller: _leaveReasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'سبب الإجازة',
                labelStyle: GoogleFonts.cairo(
                  color: const Color(0xFF666666),
                  fontSize: 14,
                ),
                hintText: 'اكتب سبب طلب الإجازة...',
                hintStyle: GoogleFonts.cairo(
                  color: const Color(0xFF94A3B8),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E3A8C), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                ),
                filled: true,
                fillColor: const Color(0xFFF8F8F8),
                contentPadding: const EdgeInsets.all(16),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى كتابة سبب الإجازة';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // زر الإرسال
            BlocConsumer<LeaveBloc, LeaveState>(
              listener: (context, state) {
                if (state is LeaveReady) {
                  if (state.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.successMessage!),
                        backgroundColor: const Color(0xFF2E3A8C),
                      ),
                    );
                    _resetLeaveForm();
                  }
                  if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: const Color(0xFFEF4444),
                      ),
                    );
                  }
                }
              },
              builder: (context, state) {
                final isLoading = state is LeaveReady && state.isSubmittingLeave;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitLeaveRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A3FA0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.send_rounded, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'إرسال طلب الإجازة',
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionRequestTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Form(
        key: _permissionFormKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // نوع الاستئذان
            DropdownButtonFormField<PermissionType>(
              initialValue: _selectedPermissionType,
              decoration: InputDecoration(
                labelText: 'نوع الاستئذان',
                labelStyle: GoogleFonts.cairo(
                  color: const Color(0xFF666666),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E3A8C), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                ),
                filled: true,
                fillColor: const Color(0xFFF8F8F8),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: PermissionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName, style: GoogleFonts.cairo()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPermissionType = value!;
                });
              },
              validator: (value) {
                if (value == null) return 'يرجى اختيار نوع الاستئذان';
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // التاريخ
            InkWell(
              onTap: () => _selectPermissionDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFFAFAFA),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF1E3A8A), size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _permissionDate != null
                          ? '${_permissionDate!.year}/${_permissionDate!.month.toString().padLeft(2, '0')}/${_permissionDate!.day.toString().padLeft(2, '0')}'
                          : 'التاريخ',
                      style: GoogleFonts.cairo(
                        color: _permissionDate != null ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // من وإلى
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFFAFAFA),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Color(0xFF1E3A8A), size: 20),
                          const SizedBox(width: 12),
                          Text(
                            _fromTime != null
                                ? '${_fromTime!.hour.toString().padLeft(2, '0')}:${_fromTime!.minute.toString().padLeft(2, '0')}'
                                : 'من',
                            style: GoogleFonts.cairo(
                              color: _fromTime != null ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFFAFAFA),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Color(0xFF1E3A8A), size: 20),
                          const SizedBox(width: 12),
                          Text(
                            _toTime != null
                                ? '${_toTime!.hour.toString().padLeft(2, '0')}:${_toTime!.minute.toString().padLeft(2, '0')}'
                                : 'إلى',
                            style: GoogleFonts.cairo(
                              color: _toTime != null ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // عرض المدة المحسوبة
            if (_fromTime != null && _toTime != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, color: Color(0xFF0EA5E9), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'المدة: ${_calculateDuration()}',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0EA5E9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // سبب الاستئذان
            TextFormField(
              controller: _permissionReasonController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'سبب الاستئذان',
                labelStyle: GoogleFonts.cairo(
                  color: const Color(0xFF666666),
                  fontSize: 14,
                ),
                hintText: 'اكتب سبب الاستئذان...',
                hintStyle: GoogleFonts.cairo(
                  color: const Color(0xFF94A3B8),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E3A8C), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                ),
                filled: true,
                fillColor: const Color(0xFFF8F8F8),
                contentPadding: const EdgeInsets.all(16),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى كتابة سبب الاستئذان';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // زر الإرسال
            BlocConsumer<LeaveBloc, LeaveState>(
              listener: (context, state) {
                if (state is LeaveReady) {
                  if (state.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.successMessage!),
                        backgroundColor: const Color(0xFF2E3A8C),
                      ),
                    );
                    _resetPermissionForm();
                  }
                  if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: const Color(0xFFEF4444),
                      ),
                    );
                  }
                }
              },
              builder: (context, state) {
                final isLoading = state is LeaveReady && state.isSubmittingPermission;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitPermissionRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF76B1C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.send_rounded, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'إرسال طلب الاستئذان',
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // إذا كان تاريخ النهاية قبل تاريخ البداية، امسحه
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectPermissionDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _permissionDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _permissionDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isFromTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isFromTime 
          ? (_fromTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (_toTime ?? const TimeOfDay(hour: 17, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isFromTime) {
          _fromTime = picked;
        } else {
          _toTime = picked;
        }
      });
    }
  }

  String _calculateDuration() {
    if (_fromTime == null || _toTime == null) return '--';
    
    final fromMinutes = _fromTime!.hour * 60 + _fromTime!.minute;
    final toMinutes = _toTime!.hour * 60 + _toTime!.minute;
    final diffMinutes = toMinutes - fromMinutes;
    
    if (diffMinutes <= 0) return '--';
    
    final hours = diffMinutes ~/ 60;
    final minutes = diffMinutes % 60;
    return '$hoursس $minutesد';
  }

  void _submitLeaveRequest() {
    if (!_leaveFormKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار تاريخ البداية والنهاية'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }
    
    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تاريخ النهاية يجب أن يكون بعد تاريخ البداية'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final request = LeaveRequest(
      type: _selectedLeaveType,
      startDate: _startDate!,
      endDate: _endDate!,
      reason: _leaveReasonController.text.trim(),
    );

    context.read<LeaveBloc>().add(LeaveRequestSubmitted(request));
  }

  void _submitPermissionRequest() {
    if (!_permissionFormKey.currentState!.validate()) return;
    if (_permissionDate == null || _fromTime == null || _toTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار التاريخ والوقت'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }
    
    final fromMinutes = _fromTime!.hour * 60 + _fromTime!.minute;
    final toMinutes = _toTime!.hour * 60 + _toTime!.minute;
    final diffMinutes = toMinutes - fromMinutes;
    
    if (diffMinutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('وقت النهاية يجب أن يكون بعد وقت البداية'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // التحقق من الحد الأقصى (4 ساعات)
    if (diffMinutes > 240) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('المدة تتجاوز الحد المسموح (4 ساعات)'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final request = PermissionRequest(
      type: _selectedPermissionType,
      date: _permissionDate!,
      from: _fromTime!,
      to: _toTime!,
      reason: _permissionReasonController.text.trim(),
    );

    context.read<LeaveBloc>().add(PermissionRequestSubmitted(request));
  }

  void _resetLeaveForm() {
    setState(() {
      _selectedLeaveType = LeaveType.annual;
      _startDate = null;
      _endDate = null;
      _leaveReasonController.clear();
    });
  }

  void _resetPermissionForm() {
    setState(() {
      _selectedPermissionType = PermissionType.earlyLeave;
      _permissionDate = null;
      _fromTime = null;
      _toTime = null;
      _permissionReasonController.clear();
    });
  }
}
