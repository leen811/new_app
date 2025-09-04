import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/auth/auth_bloc.dart';
import '../../../Bloc/auth/auth_state.dart';
import '../../../Data/Models/role.dart';
import '../../Common/press_fx.dart';
import '../../Dashboard/HR/hr_dashboard_page.dart';

/// زر الدخول إلى لوحة تحكم الموارد البشرية
class HrDashboardEntryButton extends StatelessWidget {
  const HrDashboardEntryButton({super.key});
  
  @override
  Widget build(BuildContext context) {
    print('🔘 HrDashboardEntryButton building...');
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthRoleState) {
          final canAccess = state.role == Role.hr || state.role == Role.sysAdmin;
          if (!canAccess) {
            return const SizedBox.shrink();
          }
        }
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.dashboard_customize_rounded,
              size: 18,
            ),
            label: const Text('لوحة القيادة'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            onPressed: () => _openHrDashboard(context),
          ).withPressFX(),
        );
      },
    );
  }
  
  void _openHrDashboard(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthRoleState) {
      final canAccess = authState.role == Role.hr || authState.role == Role.sysAdmin;
      if (canAccess) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const HrDashboardPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('هذه اللوحة متاحة للموارد البشرية فقط.'),
          ),
        );
      }
    }
  }
}
