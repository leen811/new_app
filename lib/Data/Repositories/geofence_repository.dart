import 'package:dio/dio.dart';
import '../Models/geofence_models.dart';

abstract class IGeofenceRepository {
  Future<List<GeofenceSite>> fetchSites();
}

class GeofenceRepository implements IGeofenceRepository {
  final Dio dio;
  GeofenceRepository(this.dio);

  @override
  Future<List<GeofenceSite>> fetchSites() async {
    final resp = await dio.get('geofences');
    final list = List<Map<String, dynamic>>.from(resp.data as List);
    return list.map(GeofenceSite.fromJson).toList();
  }
}


