import '../Models/geofence_models.dart';

abstract class ILocationSource {
  Future<LocationPoint> getCurrent();
}


