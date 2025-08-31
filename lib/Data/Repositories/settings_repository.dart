import 'package:dio/dio.dart';

abstract class ISettingsRepository {
  Future<Map<String, dynamic>> general();
  Future<Map<String, dynamic>> updateGeneral(Map<String, dynamic> payload);
}

class SettingsRepository implements ISettingsRepository {
  final Dio dio;
  SettingsRepository(this.dio);

  @override
  Future<Map<String, dynamic>> general() async {
    final resp = await dio.get('/v1/settings/general');
    return Map<String, dynamic>.from(resp.data as Map);
  }

  @override
  Future<Map<String, dynamic>> updateGeneral(Map<String, dynamic> payload) async {
    final resp = await dio.put('/v1/settings/general', data: payload);
    return Map<String, dynamic>.from(resp.data as Map);
  }
}


