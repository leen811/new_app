import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// استورد bloc/state الحقيقيين عندي:
import '../../Bloc/attendance/attendance_bloc.dart';
import '../../Bloc/attendance/attendance_event.dart';
import '../../Bloc/attendance/attendance_state.dart';

class AttendanceFABs extends StatefulWidget {
  const AttendanceFABs({super.key});

  @override
  State<AttendanceFABs> createState() => _AttendanceFABsState();
}

class _AttendanceFABsState extends State<AttendanceFABs>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bobbingAnimation;
  
  Offset _mainFabPosition = const Offset(24, 24); // أسفل يسار (RTL)
  Offset _breakFabPosition = const Offset(24, 24); // أسفل يسار (RTL)
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    
    _bobbingAnimation = Tween<double>(
      begin: 0,
      end: 3,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_animationController);
    
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bool keyboardOpen = media.viewInsets.bottom > 0;
    final screenSize = media.size;
    final safeArea = media.padding;

    return BlocBuilder<AttendanceBloc, AttendanceState>(
      buildWhen: (p, n) =>
          p.isCheckedIn != n.isCheckedIn || p.isOnBreak != n.isOnBreak,
      builder: (context, state) {
        final bool isCheckedIn = state.isCheckedIn == true;
        final bool isOnBreak = state.isOnBreak == true;

        // إخفاء الزرين عند فتح الكيبورد
        final double opacity = keyboardOpen ? 0.0 : 1.0;

        return IgnorePointer(
          ignoring: keyboardOpen,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: opacity,
            child: Stack(
              children: [
                // زر البريك (يظهر فقط بعد الحضور)
                if (isCheckedIn) ...[
                  Positioned(
                    left: _breakFabPosition.dx,
                    bottom: _breakFabPosition.dy + 80, // فوق الزر الرئيسي بـ 10px + حجم الزر
                    child: AnimatedBuilder(
                      animation: _bobbingAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, sin(_bobbingAnimation.value) * 3),
                          child: Draggable(
                            feedback: _buildBreakFAB(isOnBreak),
                            childWhenDragging: _buildBreakFAB(isOnBreak, opacity: 0.5),
                            onDragEnd: (details) {
                              final newPosition = details.offset;
                              final constrainedPosition = _constrainPosition(
                                newPosition,
                                screenSize,
                                safeArea,
                                isBreak: true,
                              );
                              setState(() {
                                _breakFabPosition = constrainedPosition;
                              });
                            },
                            child: _buildBreakFAB(isOnBreak),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                
                // الزر الرئيسي (البصمة)
                Positioned(
                  left: _mainFabPosition.dx,
                  bottom: _mainFabPosition.dy,
                  child: AnimatedBuilder(
                    animation: _bobbingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, sin(_bobbingAnimation.value) * 3),
                        child: Draggable(
                          feedback: _buildMainFAB(isCheckedIn),
                          childWhenDragging: _buildMainFAB(isCheckedIn, opacity: 0.5),
                          onDragEnd: (details) {
                            final newPosition = details.offset;
                            final constrainedPosition = _constrainPosition(
                              newPosition,
                              screenSize,
                              safeArea,
                              isBreak: false,
                            );
                            setState(() {
                              _mainFabPosition = constrainedPosition;
                            });
                          },
                          child: _buildMainFAB(isCheckedIn),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainFAB(bool isCheckedIn, {double opacity = 1.0}) {
    final primary = isCheckedIn ? const Color(0xFFDC2626) : const Color(0xFF1E3A8A);
    
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: () {
          // تنفيذ العملية مباشرة بدون التنقل
          final bloc = context.read<AttendanceBloc>();
          print('🔵 Attendance FAB pressed - isCheckedIn: $isCheckedIn');
          
          // تأكد من أن BLoC موجود
          if (bloc.isClosed) {
            print('❌ BLoC is closed, cannot add event');
            return;
          }
          
          if (isCheckedIn) {
            print('🔴 Sending CheckOutRequested event');
            bloc.add(CheckOutRequested());
          } else {
            print('🟢 Sending CheckInRequested event');
            bloc.add(CheckInRequested());
          }
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.fingerprint_rounded,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBreakFAB(bool isOnBreak, {double opacity = 1.0}) {
    final breakColor = isOnBreak ? const Color(0xFFC2410C) : const Color(0xFFEA580C);
    
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: () {
          final bloc = context.read<AttendanceBloc>();
          print('☕ Break FAB pressed - isOnBreak: $isOnBreak');
          if (isOnBreak) {
            print('⏰ Sending BreakEndRequested event');
            bloc.add(BreakEndRequested());
          } else {
            print('☕ Sending BreakStartRequested event');
            bloc.add(BreakStartRequested());
          }
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: breakColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            isOnBreak ? Icons.timer_off_rounded : Icons.local_cafe_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Offset _constrainPosition(Offset position, Size screenSize, EdgeInsets safeArea, {required bool isBreak}) {
    final fabSize = isBreak ? 40.0 : 56.0; // حجم الزر
    final margin = 16.0; // هامش من الحواف
    
    // حدود السحب
    final minX = margin;
    final maxX = screenSize.width - fabSize - margin;
    final minY = safeArea.top + margin;
    final maxY = screenSize.height - fabSize - safeArea.bottom - margin;
    
    return Offset(
      position.dx.clamp(minX, maxX),
      position.dy.clamp(minY, maxY),
    );
  }
}