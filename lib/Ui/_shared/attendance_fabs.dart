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
  bool _mainFabPressed = false;
  bool _breakFabPressed = false;
  
  // مقدار الشفافية للزرّين
  static const double _fabOpacity = 0.85;

  // مجال السحب العمودي (px) حول موقع الزر الأساسي
  static const double _dragRangeUp = 56;   // لفوق
  static const double _dragRangeDown = 40; // لتحت

  late double _mainHomeBottom;
  late double _breakHomeBottom;
  
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
      begin: -3,
      end: 3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _mainFabPressed = false;
    _breakFabPressed = false;
    
    _mainHomeBottom = _mainFabPosition.dy;   // 24 افتراضياً
    _breakHomeBottom = _breakFabPosition.dy; // 24 افتراضياً
    
    _animationController.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final enabled = TickerMode.of(context);
    if (enabled) {
      if (!_animationController.isAnimating) {
        _animationController.repeat(reverse: true);
      }
    } else {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // تحكّم عام بالسحب العمودي (نقيس من "bottom")
  double _clampVertical({
    required double currentBottom,
    required double deltaDy,
    required double homeBottom,
  }) {
    // ملاحظة: deltaDy موجب = إصبع نازل => لازم ننقص bottom
    final tentative = currentBottom - deltaDy;
    final min = (homeBottom - _dragRangeDown).clamp(0.0, double.infinity);
    final max = homeBottom + _dragRangeUp;
    return tentative.clamp(min, max);
  }
  
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bool keyboardOpen = media.viewInsets.bottom > 0;


    return BlocBuilder<AttendanceBloc, AttendanceState>(
      buildWhen: (p, n) =>
          p.isCheckedIn != n.isCheckedIn || p.isOnBreak != n.isOnBreak,
      builder: (context, state) {
        final bool isCheckedIn = state.isCheckedIn;
        final bool isOnBreak = state.isOnBreak;

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
                    bottom: _breakFabPosition.dy + 66, // 56 + 10 = 66px
                    child: AnimatedBuilder(
                      animation: _bobbingAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, sin(_bobbingAnimation.value) * 3),
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              if (!mounted) return;
                              setState(() {
                                final newBottom = _clampVertical(
                                  currentBottom: _breakFabPosition.dy,
                                  deltaDy: details.delta.dy,
                                  homeBottom: _breakHomeBottom,
                                );
                                // ثبّت المحور X (ما في سحب أفقي)
                                _breakFabPosition = Offset(_breakFabPosition.dx, newBottom);
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
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            if (!mounted) return;
                            setState(() {
                              final newBottom = _clampVertical(
                                currentBottom: _mainFabPosition.dy,
                                deltaDy: details.delta.dy,
                                homeBottom: _mainHomeBottom,
                              );
                              // ثبّت المحور X (ما في سحب أفقي)
                              _mainFabPosition = Offset(_mainFabPosition.dx, newBottom);
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
        onTapDown: (_) {
          if (!mounted) return;
          setState(() => _mainFabPressed = true);
        },
        onTapUp: (_) {
          if (!mounted) return;
          setState(() => _mainFabPressed = false);
        },
        onTapCancel: () {
          if (!mounted) return;
          setState(() => _mainFabPressed = false);
        },
        onTap: () {
          try {
            final bloc = context.read<AttendanceBloc>();
            print('🔵 Attendance FAB pressed - isCheckedIn: $isCheckedIn');
            
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
          } catch (e) {
            print('❌ Error in attendance FAB: $e');
          }
        },
        child: AnimatedScale(
          scale: _mainFabPressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: primary.withOpacity(_fabOpacity), // << شفافية خفيفة
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
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
      ),
    );
  }

  Widget _buildBreakFAB(bool isOnBreak, {double opacity = 1.0}) {
    final breakColor = isOnBreak ? const Color(0xFFC2410C) : const Color(0xFFEA580C);
    
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTapDown: (_) {
          if (!mounted) return;
          setState(() => _breakFabPressed = true);
        },
        onTapUp: (_) {
          if (!mounted) return;
          setState(() => _breakFabPressed = false);
        },
        onTapCancel: () {
          if (!mounted) return;
          setState(() => _breakFabPressed = false);
        },
        onTap: () {
          try {
            final bloc = context.read<AttendanceBloc>();
            print('☕ Break FAB pressed - isOnBreak: $isOnBreak');
            
            if (bloc.isClosed) {
              print('❌ BLoC is closed, cannot add break event');
              return;
            }
            
            if (isOnBreak) {
              print('⏰ Sending BreakEndRequested event');
              bloc.add(BreakEndRequested());
            } else {
              print('☕ Sending BreakStartRequested event');
              bloc.add(BreakStartRequested());
            }
          } catch (e) {
            print('❌ Error in break FAB: $e');
          }
        },
        child: AnimatedScale(
          scale: _breakFabPressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: breakColor.withOpacity(_fabOpacity), // << شفافية خفيفة
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_cafe_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }


}