import 'package:dio/dio.dart';

abstract class IProfileRepository {
  Future<Map<String, dynamic>> me();
}

class ProfileRepository implements IProfileRepository {
  final Dio dio;
  ProfileRepository(this.dio);
  @override
  Future<Map<String, dynamic>> me() async {
    final resp = await dio.get('profile/me');
    return Map<String, dynamic>.from(resp.data as Map);
  }
}


