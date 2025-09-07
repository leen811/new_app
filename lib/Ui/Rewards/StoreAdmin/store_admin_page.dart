import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Bloc/StoreAdmin/store_admin_bloc.dart';
import '../../../Bloc/StoreAdmin/store_admin_event.dart';
import '../../../Bloc/StoreAdmin/store_admin_state.dart';
import '../../../Data/Repositories/store_repository.dart';
import 'widgets/product_admin_card.dart';
import 'widgets/skeleton_store.dart';
import 'widgets/product_editor_sheet.dart';

class StoreAdminPage extends StatelessWidget {
  const StoreAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة متجر المكافآت'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: const BackButton(),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          // ملاحظة: استبدل MockStoreRepository بالريبو الحقيقي في الإنتاج
          create: (_) => StoreAdminBloc(MockStoreRepository())..add(const StoreLoad()),
          child: BlocConsumer<StoreAdminBloc, StoreAdminState>(
            // ابني الواجهة فقط للحالات الرئيسية حتى ما نتعطّل بحالات وسيطة
            buildWhen: (prev, curr) =>
                curr is StoreLoading || curr is StoreLoaded || curr is StoreError,
            listener: (context, state) {
              if (state is StoreError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.msg)),
                );
              }
            },
            builder: (context, state) {
              if (state is StoreLoading) return const StoreSkeleton();
              if (state is StoreError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.msg,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  ),
                );
              }
              // أمان: لو حالة غير متوقعة، لا تبني شيء
              if (state is! StoreLoaded) return const SizedBox.shrink();

              final s = state;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'ابحث عن مكافأة…',
                                filled: true,
                                fillColor: const Color(0xFFF8FAFF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
                                ),
                                prefixIcon: const Icon(Icons.search),
                              ),
                              onChanged: (q) => context
                                  .read<StoreAdminBloc>()
                                  .add(StoreSearchChanged(q)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 55,
                            child: FilledButton.icon(
                              onPressed: () {
                                try {
                                  // ما في داعي لـ addPostFrameCallback
                                  showProductEditorSheet(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('خطأ في فتح نافذة الإضافة: $e'),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('إضافة'),
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 6, 8),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 9,
                        childAspectRatio: .99,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (c, i) => ProductAdminCard(
                          item: s.items[i],
                          onEdit: () {
                            try {
                              showProductEditorSheet(context, product: s.items[i]);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('خطأ في التعديل: $e')),
                              );
                            }
                          },
                          onDelete: () {
                            try {
                              context
                                  .read<StoreAdminBloc>()
                                  .add(StoreDeleteRequested(s.items[i].id));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم الحذف بنجاح')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('خطأ في الحذف: $e')),
                              );
                            }
                          },
                          onToggle: (v) {
                            try {
                              context
                                  .read<StoreAdminBloc>()
                                  .add(StoreToggleActive(s.items[i].id, v));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('خطأ في التبديل: $e')),
                              );
                            }
                          },
                        ),
                        childCount: s.items.length,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
