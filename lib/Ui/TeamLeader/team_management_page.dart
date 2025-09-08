import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Team/team_bloc.dart';
import '../../Bloc/Team/team_event.dart';
import '../../Bloc/Team/team_state.dart';
import '../../Data/Repositories/team_repository.dart';
import '../../Data/Repositories/employees_repository.dart';
import '../../Data/Models/employee_models.dart';
import '_widgets/leader_top_actions.dart';
import '_widgets/kpi_color_bars.dart';
import '_widgets/member_card.dart';
import '_widgets/member_details_sheet.dart';
import '_widgets/skeleton_team.dart';

class TeamManagementPage extends StatelessWidget {
  const TeamManagementPage({super.key});

  Future<void> _openAddMember(BuildContext context) async {
    final searchController = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        final repo = MockEmployeesRepository();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('إضافة عضو من موظفي الشركة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'ابحث بالاسم أو القسم…',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
                        ),
                      ),
                      onChanged: (_) => (ctx as Element).markNeedsBuild(),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<(EmployeesSummary, List<Employee>)>(
                      future: repo.fetch(query: searchController.text),
                      builder: (c, snap) {
                        final list = snap.data?.$2 ?? const <Employee>[];
                        if (!snap.hasData) {
                          return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                        }
                        return ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 360),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: list.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE6E9F0)),
                            itemBuilder: (_, i) {
                              final e = list[i];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                leading: CircleAvatar(backgroundImage: e.avatarUrl != null ? NetworkImage(e.avatarUrl!) : null, child: e.avatarUrl == null ? Text(e.name.characters.first) : null),
                                title: Text(e.name, textAlign: TextAlign.right),
                                subtitle: Text(e.roleTitle, textAlign: TextAlign.right),
                                onTap: () async {
                                  await context.read<TeamBloc>().repository.createMember(name: e.name, title: e.roleTitle);
                                  if (ctx.mounted) Navigator.pop(ctx);
                                  // ignore: use_build_context_synchronously
                                  context.read<TeamBloc>().add(const TeamLoad());
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamBloc(MockTeamRepository())..add(const TeamLoad()),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: LeaderTopActions(onAdd: () => _openAddMember(context)),
        ),
        backgroundColor: Colors.white,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: BlocBuilder<TeamBloc, TeamState>(builder: (ctx, st) {
              if (st is TeamLoading || st is TeamInitial) return const TeamSkeleton();
              if (st is TeamError) return Center(child: Text(st.message));
              final s = st as TeamLoaded;
              return CustomScrollView(slivers: [
                SliverToBoxAdapter(
                  child: KpiColorBars(
                    total: s.kpis.totalMembers,
                    active: s.kpis.activeMembers,
                    avgPerf: s.kpis.avgPerformancePct,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'ابحث عن عضو…',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
                        ),
                      ),
                      onChanged: (q) => ctx.read<TeamBloc>().add(TeamSearchChanged(q)),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                SliverList.separated(
                  itemCount: s.members.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => MemberCard(
                    data: s.members[i],
                    onTap: () => showMemberDetailsSheet(
                      context: ctx,
                      member: s.members[i],
                      onSave: (title, av, skills) => ctx.read<TeamBloc>().add(
                            TeamUpdateMember(
                              s.members[i].id,
                              title: title,
                              availability: av,
                              skills: skills,
                            ),
                          ),
                    ),
                    onEdit: () => showMemberDetailsSheet(
                      context: ctx,
                      member: s.members[i],
                      onSave: (title, av, skills) => ctx.read<TeamBloc>().add(
                            TeamUpdateMember(
                              s.members[i].id,
                              title: title,
                              availability: av,
                              skills: skills,
                            ),
                          ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ]);
            }),
          ),
        ),
      ),
    );
  }
}


