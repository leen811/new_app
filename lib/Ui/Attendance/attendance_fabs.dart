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
    return Positioned(
      left: 16,
      bottom: 24,
      child: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          final canCheck = state.canCheckIn;
          final disabled = (!canCheck && state.status == AttendanceStatus.ready) || state.status == AttendanceStatus.checkedOut;

          Color bg() {
            // شفاف زجاجي
            return Colors.white.withOpacity(0.22);
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
                backgroundColor: bg(),
                foregroundColor: Colors.white,
                elevation: 6,
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
                  backgroundColor: bg(),
                  foregroundColor: Colors.white,
                  elevation: 6,
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


