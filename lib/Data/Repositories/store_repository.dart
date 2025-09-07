import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../Models/store_models.dart';

abstract class StoreRepository {
  Future<List<StoreProduct>> list({String query = ''});
  Future<StoreProduct> create({required String name, required int tokenPrice, required String imageUrl, bool featured = false});
  Future<StoreProduct> update(String id, {String? name, int? tokenPrice, String? imageUrl, bool? active, bool? featured});
  Future<void> delete(String id);
  Future<String> uploadImage(Uint8List bytes, {required String filename});
}

class MockStoreRepository implements StoreRepository {
  final List<StoreProduct> _items = [
    const StoreProduct(id: 'gc-100', name: 'بطاقة شراء 100 ريال', tokenPrice: 500, imageUrl: 'https://picsum.photos/seed/gc100/1200/600', featured: true),
    const StoreProduct(id: 'gc-250', name: 'بطاقة شراء 250 ريال', tokenPrice: 1100, imageUrl: 'https://picsum.photos/seed/gc250/1200/600'),
    const StoreProduct(id: 'fuel-20', name: 'خصم %20 على البنزين', tokenPrice: 300, imageUrl: 'https://picsum.photos/seed/fuel/1200/600'),
    const StoreProduct(id: 'dayoff', name: 'يوم إجازة إضافي', tokenPrice: 1000, imageUrl: 'https://picsum.photos/seed/dayoff/900/450', featured: true),
  ];

  @override
  Future<List<StoreProduct>> list({String query = ''}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final q = query.trim();
    if (q.isEmpty) return List.unmodifiable(_items);
    return _items.where((e) => e.name.contains(q)).toList(growable: false);
  }

  @override
  Future<StoreProduct> create({required String name, required int tokenPrice, required String imageUrl, bool featured = false}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final p = StoreProduct(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, tokenPrice: tokenPrice, imageUrl: imageUrl, featured: featured);
    _items.add(p);
    return p;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _items.removeWhere((e) => e.id == id);
  }

  @override
  Future<String> uploadImage(Uint8List bytes, {required String filename}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 'https://picsum.photos/seed/${filename.hashCode}/1200/600';
  }

  @override
  Future<StoreProduct> update(String id, {String? name, int? tokenPrice, String? imageUrl, bool? active, bool? featured}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final i = _items.indexWhere((e) => e.id == id);
    if (i == -1) throw Exception('not found');
    final cur = _items[i];
    final nxt = cur.copyWith(
      name: name,
      tokenPrice: tokenPrice,
      imageUrl: imageUrl,
      active: active,
      featured: featured,
    );
    _items[i] = nxt;
    return nxt;
  }
}

class DioStoreRepository implements StoreRepository {
  final Dio dio;
  DioStoreRepository(this.dio);

  @override
  Future<StoreProduct> create({required String name, required int tokenPrice, required String imageUrl, bool featured = false}) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<StoreProduct>> list({String query = ''}) {
    throw UnimplementedError();
  }

  @override
  Future<String> uploadImage(Uint8List bytes, {required String filename}) {
    throw UnimplementedError();
  }

  @override
  Future<StoreProduct> update(String id, {String? name, int? tokenPrice, String? imageUrl, bool? active, bool? featured}) {
    throw UnimplementedError();
  }
}


