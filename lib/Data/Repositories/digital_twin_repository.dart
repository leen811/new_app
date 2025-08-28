import 'package:dio/dio.dart';

abstract class IDigitalTwinRepository {
  Future<Map<String, dynamic>> overview();
  Future<List<Map<String, dynamic>>> recommendations();
  Future<List<Map<String, dynamic>>> weekly();
  Future<List<Map<String, dynamic>>> daily();
}

class DigitalTwinRepository implements IDigitalTwinRepository {
  final Dio dio;
  DigitalTwinRepository(this.dio);
  @override
  Future<Map<String, dynamic>> overview() async => Map<String, dynamic>.from((await dio.get('/v1/twin/overview')).data as Map);
  @override
  Future<List<Map<String, dynamic>>> recommendations() async => List<Map<String, dynamic>>.from((await dio.get('/v1/twin/recommendations')).data as List);
  @override
  Future<List<Map<String, dynamic>>> weekly() async => List<Map<String, dynamic>>.from((await dio.get('/v1/twin/productivity/weekly')).data as List);
  @override
  Future<List<Map<String, dynamic>>> daily() async => List<Map<String, dynamic>>.from((await dio.get('/v1/twin/productivity/daily')).data as List);
}


