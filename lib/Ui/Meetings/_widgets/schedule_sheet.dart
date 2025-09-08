import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Bloc/Meetings/meetings_bloc.dart';
import '../../../Bloc/Meetings/meetings_event.dart';
import '../../../Bloc/Meetings/meetings_state.dart';
import '../../Meetings/_widgets/availability_badge.dart';
import '../../Meetings/_widgets/suggestions_sheet.dart';
import '../../../Data/Models/meetings_models.dart';

/// فتح الشيت + عرض SnackBar بأمان بعد الإغلاق
Future<void> showScheduleMeetingSheet(BuildContext context) async {
  MeetingsBloc? parentBloc;
  try {
    parentBloc = context.read<MeetingsBloc>()..add(const ScheduleInit());
  } catch (_) {}

  final ok = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      if (parentBloc != null) {
        return BlocProvider.value(value: parentBloc, child: const _ScheduleSheet());
      }
      return const _ScheduleSheet();
    },
  );

  if (ok == true) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم جدولة الاجتماع')),
    );
  }
}

class _ScheduleSheet extends StatefulWidget {
  const _ScheduleSheet();
  @override
  State<_ScheduleSheet> createState() => _ScheduleSheetState();
}

class _ScheduleSheetState extends State<_ScheduleSheet> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _duration = TextEditingController();
  final _placeOrLink = TextEditingController();

  MeetingPriority _priority = MeetingPriority.medium;
  MeetingType _type = MeetingType.online;
  String _platform = 'Google Meet';

  DateTime _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 0);

  final Set<String> _participants = {'u1', 'u2'};
  final Set<String> _departments = {'tech'};
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _duration.dispose();
    _placeOrLink.dispose();
    super.dispose();
  }

  DateTime get _combinedDateTime =>
      DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

  // يدعم أرقام عربية وهجينة
  int _parseMinutes(String s) {
    const map = {'٠':'0','١':'1','٢':'2','٣':'3','٤':'4','٥':'5','٦':'6','٧':'7','٨':'8','٩':'9'};
    final latin = s.trim().split('').map((ch) => map[ch] ?? ch).join();
    return int.tryParse(latin) ?? 0;
  }

  /// يبعث حساب التوافر فقط عندما الشروط متحققة
  void _notifyScheduleChanged({required bool requireRoomSelected}) {
    final dur = _parseMinutes(_duration.text);
    if (dur <= 0) return;

    if (requireRoomSelected) {
      final st = context.read<MeetingsBloc>().state;
      final hasRoom = st is MeetingsWithSchedule && st.selectedRoomId != null;
      if (!hasRoom) return; // لا ترسل شيء قبل تحديد القاعة
    }
    context.read<MeetingsBloc>().add(ScheduleDateTimeChanged(_combinedDateTime, dur));
  }

  @override
  Widget build(BuildContext context) {
    final needsRoom = _type != MeetingType.online;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final f = FocusScope.of(context);
        if (!f.hasPrimaryFocus && f.focusedChild != null) f.unfocus();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Color(0xFFE6E9F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Color(0xFFE6E9F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Color(0xFF2563EB), width: 2),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    const Expanded(
                      child: Text('جدولة اجتماع جديد',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context, false), icon: const Icon(Icons.close)),
                  ]),
                  const SizedBox(height: 12),

                  TextField(controller: _title, decoration: const InputDecoration(hintText: 'عنوان الاجتماع')),
                  const SizedBox(height: 8),

                  TextField(controller: _desc, maxLines: 3, decoration: const InputDecoration(hintText: 'الوصف')),
                  const SizedBox(height: 8),

                  Row(children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            initialDate: _date,
                          );
                          if (picked != null) {
                            setState(() => _date = picked);
                            _notifyScheduleChanged(requireRoomSelected: needsRoom);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(hintText: 'التاريخ'),
                          child: Text(MaterialLocalizations.of(context).formatMediumDate(_date)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final picked = await showTimePicker(context: context, initialTime: _time);
                          if (picked != null) {
                            setState(() => _time = picked);
                            _notifyScheduleChanged(requireRoomSelected: needsRoom);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(hintText: 'الوقت'),
                          child: Text(
                            MaterialLocalizations.of(context)
                                .formatTimeOfDay(_time, alwaysUse24HourFormat: true),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _duration,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'المدة (دقائق)'),
                    onChanged: (v) => _notifyScheduleChanged(requireRoomSelected: needsRoom),
                  ),
                  const SizedBox(height: 8),

                  // نوع الاجتماع مع تحميل القاعات عند التحول إلى في الموقع
                  DropdownButtonFormField<MeetingType>(
                    value: _type,
                    items: const [
                      DropdownMenuItem(value: MeetingType.online, child: Text('عن بُعد')),
                      DropdownMenuItem(value: MeetingType.onsite, child: Text('في الموقع')),
                    ],
                    onChanged: (v) {
                      final next = v ?? _type;
                      setState(() => _type = next);

                      if (next == MeetingType.onsite) {
                        // حمّل القاعات، لكن لا تحسب التوافر قبل اختيار القاعة
                        try { context.read<MeetingsBloc>().add(const ScheduleInit()); } catch (_) {}
                      } else {
                        // Online: احسب التوافر فورًا (لا يحتاج قاعة)
                        _notifyScheduleChanged(requireRoomSelected: false);
                      }
                    },
                    decoration: const InputDecoration(hintText: 'نوع الاجتماع'),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _placeOrLink,
                    decoration: InputDecoration(
                      hintText: _type == MeetingType.online ? 'الرابط' : 'المكان',
                    ),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _platform,
                    items: const [
                      DropdownMenuItem(value: 'Google Meet', child: Text('Google Meet')),
                      DropdownMenuItem(value: 'Zoom', child: Text('Zoom')),
                      DropdownMenuItem(value: 'Teams', child: Text('Teams')),
                    ],
                    onChanged: (v) => setState(() => _platform = v ?? _platform),
                    decoration: const InputDecoration(hintText: 'المنصة'),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<MeetingPriority>(
                    value: _priority,
                    items: const [
                      DropdownMenuItem(value: MeetingPriority.low, child: Text('منخفضة')),
                      DropdownMenuItem(value: MeetingPriority.medium, child: Text('متوسطة')),
                      DropdownMenuItem(value: MeetingPriority.high, child: Text('عالية')),
                    ],
                    onChanged: (v) => setState(() => _priority = v ?? _priority),
                    decoration: const InputDecoration(hintText: 'الأولوية'),
                  ),
                  const SizedBox(height: 8),

                  // --- القاعة بالقائمة المنسدلة (آمنة ضد الكراش) ---
                  if (_type != MeetingType.online)
                    BlocBuilder<MeetingsBloc, MeetingsState>(
                      builder: (context, state) {
                        final sched = state is MeetingsWithSchedule ? state : null;
                        final rooms = sched?.rooms ?? const <dynamic>[];
                        final selectedRoomId = sched?.selectedRoomId;

                        // مرّر value فقط إذا كانت موجودة ضمن items
                        final String? safeValue =
                            (selectedRoomId != null && rooms.any((r) => r.id == selectedRoomId))
                                ? selectedRoomId
                                : null;

                        if (rooms.isEmpty) {
                          return const TextField(
                            enabled: false,
                            decoration: InputDecoration(hintText: 'قاعة الاجتماع (جاري التحميل...)'),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<String>(
                              key: ValueKey('room_dd_${rooms.length}_${safeValue ?? 'none'}'),
                              value: safeValue,
                              items: [
                                for (final r in rooms)
                                  DropdownMenuItem(
                                    value: (r.id as String),
                                    child: Text(r.name as String),
                                  ),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  context.read<MeetingsBloc>().add(ScheduleRoomChanged(v));
                                  // عند اختيار القاعة احسب التوافر فورًا إن كانت المدة > 0
                                  _notifyScheduleChanged(requireRoomSelected: true);
                                }
                              },
                              decoration: const InputDecoration(hintText: 'قاعة الاجتماع'),
                            ),
                            const SizedBox(height: 8),
                            Row(children: [
                              AvailabilityBadge(
                                availability: sched?.availability,
                                checking: ((sched?.checking) ?? false),
                              ),
                              const SizedBox(width: 8),
                              if ((sched?.availability != null) && !(sched!.availability!.isFree))
                                OutlinedButton(
                                  onPressed: (sched?.suggesting ?? false)
                                      ? null
                                      : () async {
                                          context.read<MeetingsBloc>().add(const ScheduleRequestSuggestions());
                                          final stAny = await context.read<MeetingsBloc>().stream.firstWhere(
                                            (s) => s is MeetingsWithSchedule && !(s as MeetingsWithSchedule).suggesting,
                                          );
                                          final st = stAny as MeetingsWithSchedule;
                                          final picked = await showSuggestionsSheet(context, st.suggestions);
                                          if (picked != null) {
                                            final dur = picked.end.difference(picked.start).inMinutes;
                                            setState(() {
                                              _date = DateTime(picked.start.year, picked.start.month, picked.start.day);
                                              _time = TimeOfDay.fromDateTime(picked.start);
                                              _duration.text = '$dur';
                                            });
                                            // بعد اختيار اقتراح نعيد الحساب (لدينا قاعة مختارة الآن)
                                            context.read<MeetingsBloc>().add(
                                              ScheduleDateTimeChanged(picked.start, dur),
                                            );
                                          }
                                        },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    side: const BorderSide(color: Color(0xFFE6E9F0)),
                                  ),
                                  child: const Text('عرض الأوقات المتاحة'),
                                ),
                            ]),
                          ],
                        );
                      },
                    ),

                  const SizedBox(height: 12),
                  const Text('المشاركون', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (final u in const ['u1: سارة', 'u2: محمد', 'u3: فاطمة', 'u4: خالد'])
                        FilterChip(
                          label: Text(u.split(': ')[1]),
                          selected: _participants.contains(u.split(': ')[0]),
                          onSelected: (sel) => setState(() {
                            final id = u.split(': ')[0];
                            if (sel) {
                              _participants.add(id);
                            } else {
                              _participants.remove(id);
                            }
                          }),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Text('الأقسام', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (final d in const ['tech: التقنية', 'hr: الموارد البشرية', 'marketing: التسويق'])
                        FilterChip(
                          label: Text(d.split(': ')[1]),
                          selected: _departments.contains(d.split(': ')[0]),
                          onSelected: (sel) => setState(() {
                            final id = d.split(': ')[0];
                            if (sel) {
                              _departments.add(id);
                            } else {
                              _departments.remove(id);
                            }
                          }),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  if (_saving)
                    const LinearProgressIndicator(
                      minHeight: 2,
                      backgroundColor: Color(0xFFE6EAF2),
                      color: Color(0xFF2F56D9),
                    ),
                  const SizedBox(height: 8),

                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: Color(0xFFE6E9F0)),
                          foregroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _saving ? null : () => Navigator.pop(context, false),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _saving ? null : () async {
                            final title = _title.text.trim();
                            final desc = _desc.text.trim();
                            final dur = _parseMinutes(_duration.text);

                            if (title.isEmpty || dur <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('يرجى إدخال عنوان ومدة صحيحة')),
                              );
                              return;
                            }

                            // تحقق القاعة إذا Onsite/Hybrid
                            if (_type != MeetingType.online) {
                              final s0 = context.read<MeetingsBloc>().state;
                              final sched = s0 is MeetingsWithSchedule ? s0 : null;
                              final roomId = sched?.selectedRoomId;
                              final avail = sched?.availability;

                              if (roomId == null || avail == null || !avail.isFree) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('يرجى اختيار قاعة متاحة')),
                                );
                                return;
                              }
                              // (للتوافق مع الموك الحالي لديك) خزّني معرف القاعة في placeOrLink
                              _placeOrLink.text = roomId;
                            }

                            setState(() => _saving = true);

                            final draft = Meeting(
                              id: 'draft',
                              title: title,
                              description: desc,
                              date: _combinedDateTime,
                              durationMinutes: dur,
                              priority: _priority,
                              type: _type,
                              placeOrLink: _placeOrLink.text.trim().isEmpty ? null : _placeOrLink.text.trim(),
                              participantIds: _participants.toList(),
                              departmentIds: _departments.toList(),
                              status: MeetingStatus.upcoming,
                              platform: _platform,
                            );

                            context.read<MeetingsBloc>().add(MeetingCreateSubmitted(draft));
                            await Future<void>.delayed(const Duration(milliseconds: 250));

                            if (mounted) {
                              Navigator.pop(context, true);
                            }
                          },
                          child: const Text('جدولة الاجتماع'),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
