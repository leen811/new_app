import 'package:equatable/equatable.dart';

class LocationPoint extends Equatable {
  final double lat;
  final double lng;
  final double? accuracyM;
  final DateTime? ts;
  const LocationPoint({required this.lat, required this.lng, this.accuracyM, this.ts});
  @override
  List<Object?> get props => [lat, lng, accuracyM, ts];
}

class GeofenceSite extends Equatable {
  final String id;
  final String name;
  final String type; // circle | polygon
  final LocationPoint? center;
  final double? radiusM;
  final List<LocationPoint>? polygon;

  const GeofenceSite({
    required this.id,
    required this.name,
    required this.type,
    this.center,
    this.radiusM,
    this.polygon,
  });

  factory GeofenceSite.fromJson(Map<String, dynamic> json) => GeofenceSite(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        center: json['center'] == null
            ? null
            : LocationPoint(
                lat: (json['center']['lat'] as num).toDouble(),
                lng: (json['center']['lng'] as num).toDouble(),
              ),
        radiusM: (json['radiusM'] as num?)?.toDouble(),
        polygon: (json['polygon'] as List?)
            ?.map((p) => LocationPoint(lat: (p['lat'] as num).toDouble(), lng: (p['lng'] as num).toDouble()))
            .toList(),
      );

  @override
  List<Object?> get props => [id, name, type, center, radiusM, polygon];
}

class AttendancePolicy extends Equatable {
  final bool geoRequired;
  const AttendancePolicy({required this.geoRequired});
  factory AttendancePolicy.fromJson(Map<String, dynamic> json) =>
      AttendancePolicy(geoRequired: (json['geoRequired'] as bool? ?? true));
  @override
  List<Object?> get props => [geoRequired];
}


