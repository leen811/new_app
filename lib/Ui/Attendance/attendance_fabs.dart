import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/attendance/attendance_bloc.dart';
import '../../Bloc/attendance/attendance_event.dart';
import '../../Bloc/attendance/attendance_state.dart';

class AttendanceFabs extends StatefulWidget {
  const AttendanceFabs({super.key});

  @override
  State<AttendanceFabs> createState() => _AttendanceFabsState();
}

class _AttendanceFabsState extends State<AttendanceFabs> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (keyboardOpen) return const SizedBox.shrink();
    return Positioned(
      left: 16,
      bottom: 24,
      child: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          final canCheck = state.canCheckIn;
          final disabled = (!canCheck && state.status == AttendanceStatus.ready) || state.status == AttendanceStatus.checkedOut;

          Color mainBg() {
            // أزرق غامق شفاف قليلاً في وضع الاستعداد، وأخضر شفاف عند الحضور
            if (state.status == AttendanceStatus.checkedIn) {
              return Colors.green.shade600.withOpacity(0.75);
            }
            const blueDeep = Color(0xFF1E3A8A); // أزرق غامق
            return blueDeep.withOpacity(0.75);
          }

          IconData mainIcon = state.status == AttendanceStatus.checkedIn ? Icons.logout : Icons.fingerprint;

          final bob = Tween<double>(begin: 0, end: -4).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

          final children = <Widget>[
            AnimatedBuilder(
              animation: bob,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, bob.value),
                child: child,
              ),
              child: FloatingActionButton(
                heroTag: 'fab_attendance',
                tooltip: disabled ? 'خارج النطاق' : null,
                onPressed: disabled ? null : () => context.read<AttendanceBloc>().add(AttendanceFabPressed()),
                backgroundColor: mainBg(),
                foregroundColor: Colors.white,
                elevation: 10,
                shape: const CircleBorder(),
                child: Icon(mainIcon),
              ),
            ),
          ];

          if (state.status == AttendanceStatus.checkedIn) {
            children.add(const SizedBox(height: 12));
            children.add(
              AnimatedBuilder(
                animation: bob,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, -bob.value),
                  child: child,
                ),
                child: FloatingActionButton(
                  heroTag: 'fab_break',
                  onPressed: () => context.read<AttendanceBloc>().add(BreakFabPressed()),
                  backgroundColor: (state.breakStatus == BreakStatus.none
                          ? Colors.orange
                          : Colors.blue)
                      .withOpacity(0.75),
                  foregroundColor: Colors.white,
                  elevation: 10,
                  shape: const CircleBorder(),
                  child: Icon(state.breakStatus == BreakStatus.none ? Icons.local_cafe : Icons.local_cafe),
                ),
              ),
            );
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
        },
      ),
    );
  }
}


