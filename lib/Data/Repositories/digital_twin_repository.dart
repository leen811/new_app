import 'package:dio/dio.dart';

abstract class IDigitalTwinRepository {
  Future<Map<String, dynamic>> fetchSummary();
}

class DigitalTwinRepository implements IDigitalTwinRepository {
  final Dio dio;
  DigitalTwinRepository(this.dio);
  @override
  Future<Map<String, dynamic>> fetchSummary() async {
    final resp = await dio.get('dt/summary');
    return Map<String, dynamic>.from(resp.data as Map);
  }
}


