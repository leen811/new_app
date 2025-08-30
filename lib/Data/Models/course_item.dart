import 'package:equatable/equatable.dart';

class CourseItem extends Equatable {
  final String id;
  final String title;
  final String provider;
  final String priceLabel;
  final int hours;
  final String level;
  final double rating;
  final int ratingCount;
  final int matchPct;
  final List<String> tags;
  final String reason;
  final String startHijri;
  final String imageUrl;
  final bool isBookmarked;
  const CourseItem({required this.id, required this.title, required this.provider, required this.priceLabel, required this.hours, required this.level, required this.rating, required this.ratingCount, required this.matchPct, required this.tags, required this.reason, required this.startHijri, required this.imageUrl, required this.isBookmarked});
  factory CourseItem.fromJson(Map<String, dynamic> j) => CourseItem(
        id: j['id'] as String,
        title: j['title'] as String,
        provider: j['provider'] as String,
        priceLabel: j['priceLabel'] as String,
        hours: (j['hours'] as num).toInt(),
        level: j['level'] as String,
        rating: (j['rating'] as num).toDouble(),
        ratingCount: (j['ratingCount'] as num).toInt(),
        matchPct: (j['matchPct'] as num).toInt(),
        tags: List<String>.from(j['tags'] as List),
        reason: j['reason'] as String,
        startHijri: j['startHijri'] as String,
        imageUrl: j['imageUrl'] as String,
        isBookmarked: j['isBookmarked'] as bool,
      );
  @override
  List<Object?> get props => [id, title, provider, priceLabel, hours, level, rating, ratingCount, matchPct, tags, reason, startHijri, imageUrl, isBookmarked];
}


