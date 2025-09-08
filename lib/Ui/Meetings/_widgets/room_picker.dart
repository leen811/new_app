import 'package:flutter/material.dart';
import '../../../Data/Models/meetings_models.dart';

Future<MeetingRoom?> showRoomPicker(BuildContext context, List<MeetingRoom> rooms) async {
  return showModalBottomSheet<MeetingRoom>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (ctx) => _RoomPickerSheet(rooms: rooms),
  );
}

class _RoomPickerSheet extends StatefulWidget {
  final List<MeetingRoom> rooms;
  const _RoomPickerSheet({required this.rooms});
  @override
  State<_RoomPickerSheet> createState() => _RoomPickerSheetState();
}

class _RoomPickerSheetState extends State<_RoomPickerSheet> {
  final _q = TextEditingController();

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.rooms
        .where((r) => r.name.toLowerCase().contains(_q.text.toLowerCase()))
        .toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              const Expanded(child: Text('اختر قاعة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ]),
            const SizedBox(height: 8),
            TextField(
              controller: _q,
              decoration: const InputDecoration(hintText: 'بحث عن القاعات', prefixIcon: Icon(Icons.search)),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final r = filtered[i];
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.pop(context, r),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE6E9F0)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.meeting_room_outlined, color: Color(0xFF0F172A)),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(r.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                            if (r.location != null) Text(r.location!, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                          ])),
                          if (r.capacity != null) Text('سعة ${r.capacity}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


