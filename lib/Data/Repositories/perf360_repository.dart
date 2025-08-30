import 'package:dio/dio.dart';

import '../Models/360/analytics_payload.dart';

abstract class IPerf360Repository {
  Future<Map<String, dynamic>> summary();
  Future<List<Map<String, dynamic>>> pending();
  Future<List<Map<String, dynamic>>> peers();
  Future<Map<String, dynamic>> submit(Map<String, dynamic> payload);
  Future<List<Map<String, dynamic>>> getDetailedResults();
  Future<AnalyticsPayload> getAnalytics();
}

class Perf360Repository implements IPerf360Repository {
  final Dio dio;
  Perf360Repository(this.dio);
  @override
  Future<Map<String, dynamic>> summary() async => Map<String, dynamic>.from((await dio.get('/v1/perf360/summary', queryParameters: {'me': 1})).data as Map);
  @override
  Future<List<Map<String, dynamic>>> pending() async => List<Map<String, dynamic>>.from((await dio.get('/v1/perf360/pending')).data as List);
  @override
  Future<List<Map<String, dynamic>>> peers() async => List<Map<String, dynamic>>.from((await dio.get('/v1/perf360/peers')).data as List);
  @override
  Future<Map<String, dynamic>> submit(Map<String, dynamic> payload) async => Map<String, dynamic>.from((await dio.post('/v1/perf360/submit', data: payload)).data as Map);
  @override
  Future<List<Map<String, dynamic>>> getDetailedResults() async => List<Map<String, dynamic>>.from((await dio.get('/v1/perf360/results')).data as List);
  @override
  Future<AnalyticsPayload> getAnalytics() async => AnalyticsPayload.fromJson(Map<String, dynamic>.from((await dio.get('/v1/perf360/analytics')).data as Map));
}


