import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Bloc/StoreAdmin/store_admin_bloc.dart';
import '../../../../Bloc/StoreAdmin/store_admin_event.dart';
import '../../../../Bloc/StoreAdmin/store_admin_state.dart';
import '../../../../Data/Models/store_models.dart';

Future<void> showProductEditorSheet(BuildContext context, {StoreProduct? product}) async {
  final String initialName = product != null ? product.name : '';
  final String initialPrice = product != null ? product.tokenPrice.toString() : '';
  final String initialImage = product != null ? product.imageUrl : '';
  final bool initialFeatured = product != null ? product.featured : false;

  final name = TextEditingController(text: initialName);
  final price = TextEditingController(text: initialPrice);
  String imageUrl = initialImage;
  bool featured = initialFeatured;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (ctx, setSheetState) {
          return BlocBuilder<StoreAdminBloc, StoreAdminState>(
            builder: (ctx2, st) {
              if (st is StoreLoaded && st.uploadingUrl != null) {
                imageUrl = st.uploadingUrl!;
              }
              final saving = st is StoreLoaded && st.saving;
              return Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(children: const [Icon(Icons.add_photo_alternate_outlined), SizedBox(width: 6), Text('رفع صورة', style: TextStyle(fontWeight: FontWeight.w800))]),
                      const SizedBox(height: 8),
                      _ImageUploaderTile(
                        url: imageUrl,
                        onPick: (bytes, filename) {
                          if (!Navigator.of(sheetContext).mounted) return;
                          ctx2.read<StoreAdminBloc>().add(StoreImagePicked(bytes, filename));
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: name,
                        decoration: const InputDecoration(labelText: 'اسم المكافأة*'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: price,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'السعر بالتوكينز*', hintText: 'توكينز'),
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        value: featured,
                        onChanged: (v) => setSheetState(() => featured = v ?? false),
                        title: const Text('مميز'),
                        activeColor: const Color(0xFF667085),
                      ), 
                      const SizedBox(height: 16),
                      if (saving) const LinearProgressIndicator(minHeight: 2),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(color: Color(0xFF667085)),
                              foregroundColor: const Color(0xFF667085),
                            ),
                            child: const Text('إلغاء'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: saving ? null : () {
                              final n = name.text.trim();
                              final p = int.tryParse(price.text.trim());
                              if (n.isEmpty || p == null || p <= 0 || imageUrl.isEmpty) {
                                if (Navigator.of(sheetContext).mounted) {
                                  ScaffoldMessenger.of(sheetContext).showSnackBar(const SnackBar(content: Text('تحقق من البيانات: الاسم والسعر والصورة مطلوبة')));
                                }
                                return;
                              }
                              try {
                                ctx2.read<StoreAdminBloc>().add(StoreSaveSubmitted(id: product?.id, name: n, tokenPrice: p, imageUrl: imageUrl, featured: featured));
                                if (Navigator.of(sheetContext).mounted) {
                                  Navigator.of(sheetContext).pop();
                                  ScaffoldMessenger.of(sheetContext).showSnackBar(const SnackBar(content: Text('تم الحفظ بنجاح')));
                                }
                              } catch (e) {
                                if (Navigator.of(sheetContext).mounted) {
                                  ScaffoldMessenger.of(sheetContext).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                                }
                              }
                            },
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: const Color(0xFFF59E0B),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('حفظ'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}

class _ImageUploaderTile extends StatelessWidget {
  final String url; final void Function(Uint8List, String) onPick;
  const _ImageUploaderTile({required this.url, required this.onPick});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Placeholder pick simulation: in real app, integrate ImagePicker/FilePicker
        final bytes = Uint8List.fromList(List.generate(20, (i) => i));
        onPick(bytes, 'upload_${DateTime.now().millisecondsSinceEpoch}.png');
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E9F0)),
        ),
        child: url.isEmpty
            ? const Center(child: Text('اضغط لرفع صورة'))
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(url, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
              ),
      ),
    );
  }
}


