import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/auth/auth_bloc.dart';
import '../../../Bloc/auth/auth_state.dart';
import '../../../Data/Models/role.dart';
import '../../Common/press_fx.dart';
import '../../Dashboard/TeamLead/team_lead_dashboard_page.dart';

class TeamDashboardEntryButton extends StatelessWidget {
  const TeamDashboardEntryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthRoleState) {
          final canAccess = state.role == Role.teamLeader || state.role == Role.sysAdmin;
          if (!canAccess) {
            return const SizedBox.shrink();
          }
        }
        
        return Container(
          margin: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.dashboard_customize_rounded, size: 18),
            label: const Text('لوحة القيادة'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            onPressed: () => _openTeamLeadDashboard(context),
          ).withPressFX(),
        );
      },
    );
  }
  
  void _openTeamLeadDashboard(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthRoleState) {
      final canAccess = authState.role == Role.teamLeader || authState.role == Role.sysAdmin;
      if (canAccess) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const TeamLeadDashboardPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('هذه اللوحة متاحة لقادة الفرق فقط.'),
          ),
        );
      }
    }
  }
}
