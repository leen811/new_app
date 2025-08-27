import 'package:dio/dio.dart';

import '../Models/company_model.dart';

abstract class ICompanyRepository {
  Future<Map<String, List<Map<String, String>>>> getMeta();
  Future<void> submitStep1(CompanyStep1 step1);
  Future<void> submitStep2(CompanyStep2 step2);
}

class CompanyRepository implements ICompanyRepository {
  final Dio dio;
  CompanyRepository(this.dio);

  @override
  Future<Map<String, List<Map<String, String>>>> getMeta() async {
    final resp = await dio.get('company/meta');
    final map = Map<String, dynamic>.from(resp.data as Map);
    Map<String, List<Map<String, String>>> result = {};
    for (final entry in map.entries) {
      result[entry.key] = List<Map<String, String>>.from(
        (entry.value as List).map((e) => Map<String, String>.from(e as Map)),
      );
    }
    return result;
  }

  @override
  Future<void> submitStep1(CompanyStep1 step1) async {
    await dio.post('company/register/step1', data: step1.toJson());
  }

  @override
  Future<void> submitStep2(CompanyStep2 step2) async {
    await dio.post('company/register/step2', data: step2.toJson());
  }
}


