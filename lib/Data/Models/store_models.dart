import 'package:equatable/equatable.dart';

class StoreProduct extends Equatable {
  final String id;
  final String name; // اسم المكافأة
  final int tokenPrice; // السعر بالتوكينز
  final String imageUrl; // رابط الصورة
  final bool active; // معروض/مخفي
  final bool featured; // مميز (اختياري)

  const StoreProduct({
    required this.id,
    required this.name,
    required this.tokenPrice,
    required this.imageUrl,
    this.active = true,
    this.featured = false,
  });

  StoreProduct copyWith({
    String? id,
    String? name,
    int? tokenPrice,
    String? imageUrl,
    bool? active,
    bool? featured,
  }) => StoreProduct(
        id: id ?? this.id,
        name: name ?? this.name,
        tokenPrice: tokenPrice ?? this.tokenPrice,
        imageUrl: imageUrl ?? this.imageUrl,
        active: active ?? this.active,
        featured: featured ?? this.featured,
      );

  @override
  List<Object?> get props => [id, name, tokenPrice, imageUrl, active, featured];
}


