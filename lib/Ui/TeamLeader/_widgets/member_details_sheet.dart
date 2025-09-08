import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import '../../../Data/Models/team_models.dart';

typedef SaveMember = void Function(String? title, MemberAvailability? availability, List<String>? skills);

Future<void> showMemberDetailsSheet({
  required BuildContext context,
  required TeamMember member,
  required SaveMember onSave,
}) async {
  final titleController = TextEditingController(text: member.title);
  MemberAvailability availability = member.availability;
  final List<String> skills = List<String>.from(member.skills);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (context) {
      final dateText = DateFormat('yyyy/MM/dd', 'ar').format(member.joinedAt);
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xFFF1F5F9),
                          backgroundImage: member.avatarUrl != null ? NetworkImage(member.avatarUrl!) : null,
                          child: member.avatarUrl == null
                              ? Text(member.name.characters.first, style: const TextStyle(fontWeight: FontWeight.bold))
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16), textAlign: TextAlign.left),
                              const SizedBox(height: 4),
                              TextField(
                                controller: titleController,
                                decoration: InputDecoration(
                                  hintText: 'المسمى الوظيفي',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
                                  ),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(child: _StatCard(title: 'المهام المكتملة', value: member.tasksCount.toString())),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(title: 'معدل الأداء', value: '${member.performancePct}%')),
                    ]),
                    const SizedBox(height: 16),
                    const Text('المهارات', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (int i = 0; i < skills.length; i++) Chip(
                          label: Text(skills[i]),
                          onDeleted: () { skills.removeAt(i); (context as Element).markNeedsBuild(); },
                        ),
                        ActionChip(
                          label: const Text('+ إضافة مهارة'),
                          onPressed: () async {
                            final controller = TextEditingController();
                            final added = await showDialog<String>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('إضافة مهارة'),
                                content: TextField(controller: controller, textAlign: TextAlign.right),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
                                  FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('إضافة')),
                                ],
                              ),
                            );
                            if (added != null && added.isNotEmpty) { skills.add(added); (context as Element).markNeedsBuild(); }
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('معلومات إضافية', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'الحالة',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<MemberAvailability>(
                                isExpanded: true,
                                value: availability,
                                items: const [
                                  DropdownMenuItem(value: MemberAvailability.available, child: Text('متاح')),
                                  DropdownMenuItem(value: MemberAvailability.busy, child: Text('مشغول')),
                                  DropdownMenuItem(value: MemberAvailability.offline, child: Text('غير متصل')),
                                ],
                                onChanged: (v) { if (v != null) { availability = v; (context as Element).markNeedsBuild(); } },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text('تاريخ الانضمام: $dateText', textAlign: TextAlign.right)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('قريباً')));
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(color: Color(0xFFE6E9F0)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('عرض التقارير'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              onSave(titleController.text.trim().isEmpty ? null : titleController.text.trim(), availability, List<String>.from(skills));
                              Navigator.pop(context);
                            },
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('تعديل المعلومات'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E9F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        ],
      ),
    );
  }
}


