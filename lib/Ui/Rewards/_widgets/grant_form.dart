import 'package:flutter/material.dart';
import '../../Common/press_fx.dart' as fx;
import '../../../Bloc/RewardsAdmin/rewards_admin_state.dart';

class GrantForm extends StatefulWidget {
  final RewardsLoaded state;
  final void Function(String employeeId, int amount, String reason, bool deduct) onSubmit;
  final void Function(int value) onQuick;
  final void Function(String reasonId) onSelectReason;

  const GrantForm({super.key, required this.state, required this.onSubmit, required this.onQuick, required this.onSelectReason});

  @override
  State<GrantForm> createState() => _GrantFormState();
}

class _GrantFormState extends State<GrantForm> {
  String? _employeeId;
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _reasonText = TextEditingController();

  @override
  void didUpdateWidget(covariant GrantForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.quickAmount != null) {
      _amount.text = widget.state.quickAmount!.toString();
    }
    if (widget.state.selectedReasonId != null) {
      final r = widget.state.reasons.firstWhere((e) => e.id == widget.state.selectedReasonId, orElse: () => widget.state.reasons.last);
      _reasonText.text = r.title;
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _reasonText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [Icon(Icons.redeem_outlined), SizedBox(width: 8), Text('منح توكينز للموظف', style: TextStyle(fontWeight: FontWeight.w800))]),
          const SizedBox(height: 12),
          // اختيار الموظف (DropdownMenu حديث)
          DropdownMenu<String>(
            initialSelection: _employeeId,
            onSelected: (v) => setState(() => _employeeId = v),
            label: const Text('اختر الموظف'),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            menuStyle: MenuStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              surfaceTintColor: const MaterialStatePropertyAll(Colors.white),
              backgroundColor: const MaterialStatePropertyAll(Colors.white),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFFF8FAFF),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                borderSide: BorderSide(color: Color(0xFF2563EB)),
              ),
            ),
            dropdownMenuEntries: [
              for (final e in s.balances)
                DropdownMenuEntry<String>(value: e.id, label: e.name, leadingIcon: const Icon(Icons.person_rounded)),
            ],
          ),
          const SizedBox(height: 12),
          // عدد التوكينز
          TextFormField(
            controller: _amount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'عدد التوكينز'),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Wrap(spacing: 8, children: [
              for (final v in const [200, 100, 50])
                ChoiceChip(
                  label: Text(v.toString()),
                  selected: widget.state.quickAmount == v,
                  onSelected: (_) => widget.onQuick(v),
                  selectedColor: const Color(0xFFE8F5E9),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE6E9F0))),
                ),
            ]),
          ]),
          const SizedBox(height: 12),
          // شبكة الأسباب
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.8,
            children: [
              for (final r in s.reasons)
                InkWell(
                  onTap: () => widget.onSelectReason(r.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE6E9F0)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [Icon(r.icon, size: 18), const SizedBox(width: 6), Flexible(child: Text(r.title, overflow: TextOverflow.ellipsis))],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _reasonText,
            decoration: const InputDecoration(labelText: 'سبب المنح'),
          ),
          const SizedBox(height: 12),
          Row(children: [
            OutlinedButton(
              onPressed: () {
                if (_employeeId != null && _amount.text.isNotEmpty) {
                  widget.onSubmit(_employeeId!, int.tryParse(_amount.text) ?? 0, _reasonText.text, true);
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                side: const BorderSide(color: Color(0xFFDC2626)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text('خصم'),
            ).withPressFX(),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () {
                if (_employeeId != null && _amount.text.isNotEmpty) {
                  widget.onSubmit(_employeeId!, int.tryParse(_amount.text) ?? 0, _reasonText.text, false);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              child: const Text('منح التوكينز'),
            ).withPressFX(),
          ]),
        ],
      ),
    );
  }
}


