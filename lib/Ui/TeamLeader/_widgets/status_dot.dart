import 'package:flutter/material.dart';
import '../../../Data/Models/team_models.dart';

class StatusDot extends StatelessWidget {
  final MemberAvailability availability;
  const StatusDot({super.key, required this.availability});

  @override
  Widget build(BuildContext context) {
    final Color color = switch (availability) {
      MemberAvailability.available => const Color(0xFF16A34A),
      MemberAvailability.busy => const Color(0xFFF97316),
      MemberAvailability.offline => const Color(0xFF9CA3AF),
    };
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}


