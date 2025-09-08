import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repositories/meetings_repository.dart';
import '../../Data/Repositories/profile_repository.dart';
import '../../Bloc/EmployeeMeetings/employee_meetings_bloc.dart';
import '../../Bloc/EmployeeMeetings/employee_meetings_event.dart';
import '../../Bloc/EmployeeMeetings/employee_meetings_state.dart';
import '../../Data/Models/meetings_models.dart';
import 'package:url_launcher/url_launcher.dart';
import '_widgets/my_meetings_summary.dart';
import '_widgets/segmented_tabs.dart';
import '_widgets/filters_bar.dart' as filters;
import '_widgets/my_meeting_card.dart';
import '_widgets/skeleton_my_meetings.dart';

class EmployeeMeetingsPage extends StatefulWidget {
  const EmployeeMeetingsPage({super.key});

  @override
  State<EmployeeMeetingsPage> createState() => _EmployeeMeetingsPageState();
}

class _EmployeeMeetingsPageState extends State<EmployeeMeetingsPage> with AutomaticKeepAliveClientMixin {
  MyMeetingsBloc? _bloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initBloc();
  }

  Future<void> _initBloc() async {
    final repo = context.read<MeetingsRepository>();
    String userId = 'u1';
    try {
      final me = await context.read<IProfileRepository>().me();
      userId = (me['id'] as String?)?.trim().isNotEmpty == true ? me['id'] as String : 'u1';
    } catch (_) {}
    if (!mounted) return;
    _bloc = MyMeetingsBloc(repository: repo, userId: userId)..add(const MyMeetingsLoad());
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_bloc == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: Colors.black87)),
          title: const Text('اجتماعاتي', style: TextStyle(color: Colors.black)),
        ),
        body: const SkeletonMyMeetings(),
      );
    }
    return BlocProvider.value(value: _bloc!, child: const _View());
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: Colors.black87)),
        title: const Text('اجتماعاتي', style: TextStyle(color: Colors.black)),
      ),
      body: BlocBuilder<MyMeetingsBloc, MyMeetingsState>(
        builder: (context, state) {
          if (state is MyMeetingsLoading || state is MyMeetingsInitial) {
            return const SkeletonMyMeetings();
          }
          if (state is MyMeetingsError) {
            return Center(child: Text(state.message));
          }
          final s = state as MyMeetingsLoaded;
          final tabs = [
            'اليوم (${s.todayCount})',
            'القادمة (${s.kpis.scheduled})',
            'المكتملة (${s.kpis.completed})',
          ];
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: MyMeetingsSummary(kpis: s.kpis, todayCount: s.todayCount)),
              SliverPersistentHeader(
                pinned: true,
                delegate: MySegmentedTabsDelegate(
                  height: 70,
                  tabs: tabs,
                  currentIndex: s.currentTab,
                  onChanged: (i) => context.read<MyMeetingsBloc>().add(MyMeetingsChangeTab(i)),
                ),
              ),
              SliverToBoxAdapter(
                child: filters.FiltersBar(
                  query: s.query,
                  onQuery: (q) => context.read<MyMeetingsBloc>().add(MyMeetingsSearchChanged(q)),
                  onPlatform: (_) {},
                  onPriority: (_) {},
                  onRange: (_) {},
                ),
              ),
              SliverList.builder(
                itemCount: s.items.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: MyMeetingCard(
                    item: s.items[i],
                    onJoin: (m) => _join(context, m),
                    onAddCalendar: (m) => _addToCalendar(context, m),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }

  Future<void> _join(BuildContext context, Meeting m) async {
    final link = m.placeOrLink;
    if (link != null && (link.startsWith('http://') || link.startsWith('https://'))) {
      final uri = Uri.parse(link);
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر فتح الرابط')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم فتح منصة الاجتماع')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(link ?? 'الموقع: غير محدد')));
    }
  }

  Future<void> _addToCalendar(BuildContext context, Meeting m) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('قريبًا: إضافة إلى التقويم')));
  }
}


