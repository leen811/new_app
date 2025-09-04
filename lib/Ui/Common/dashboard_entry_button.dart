import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Bloc/auth/auth_bloc.dart';
import '../../Bloc/auth/auth_state.dart';
import '../../Data/Models/role.dart';
import '../../Presentation/Common/navigation/routes_constants.dart';

import 'press_fx.dart'; // إن وُجد الامتداد withPressFX

/// زر موحّد لفتح لوحة القيادة المناسبة حسب الدور.
/// - يظهر فقط للأدوار المسموح بها (allow) أو للأدوار الافتراضية (manager/teamLead/hr/sysAdmin).
/// - يفتح الصفحة المطابقة للدور تلقائيًا.
class DashboardEntryButton extends StatelessWidget {
  const DashboardEntryButton({
    super.key,
    this.allow,                         // لتقييد الظهور في صفحة معيّنة
    this.margin = const EdgeInsets.all(16),
    this.expanded = true,
    this.label = 'لوحة القيادة',
  });

  final Set<Role>? allow;
  final EdgeInsetsGeometry margin;
  final bool expanded;
  final String label;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, Role?>(
      selector: (s) => s is AuthRoleState ? s.role : null,
      builder: (context, role) {
        if (role == null) return const SizedBox.shrink();

        final defaultAllowed = <Role>{Role.manager, Role.teamLeader, Role.hr, Role.sysAdmin};
        final allowedSet = allow ?? defaultAllowed;
        if (!allowedSet.contains(role)) return const SizedBox.shrink();

        final btn = ElevatedButton.icon(
          icon: const Icon(Icons.dashboard_customize_rounded, size: 18),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: const Color(0xFF2563EB), // نفس لون زرّك الحالي
            foregroundColor: Colors.white,
          ),
          onPressed: () => _openDashboardForRole(context, role),
        );

        return Container(
          margin: margin,
          width: expanded ? double.infinity : null,
          child: btn.withPressFX(), // إن لم يكن الامتداد موجودًا عندك، احذف .withPressFX()
        );
      },
    );
  }

  void _openDashboardForRole(BuildContext context, Role role) {
    String? routeName;
    switch (role) {
      case Role.manager:
      case Role.sysAdmin: // بإمكانك لاحقًا تخصيص sysAdmin
        routeName = RoutesConstants.kManagerDashboardRouteName;
        break;
      case Role.teamLeader:
        routeName = RoutesConstants.kTeamLeadDashboardRouteName;
        break;
      case Role.hr:
        routeName = RoutesConstants.kHrDashboardRouteName;
        break;
      default:
        routeName = null;
    }

    if (routeName != null) {
      context.pushNamed(routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد لوحة متاحة لهذا الدور.')),
      );
    }
  }
}
