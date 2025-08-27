import 'package:dio/dio.dart';
import '../Models/user_model.dart';

abstract class IAuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<void> startForgot({required String method, required String? email});
  Future<bool> verifyOtp({required String code});
}

class AuthRepository implements IAuthRepository {
  final Dio dio;
  AuthRepository(this.dio);

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final resp = await dio.post('auth/login', data: {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(Map<String, dynamic>.from(resp.data as Map));
  }

  @override
  Future<void> startForgot({required String method, required String? email}) async {
    await dio.post('auth/forgot/start', data: {
      'method': method,
      'email': email,
    });
  }

  @override
  Future<bool> verifyOtp({required String code}) async {
    final resp = await dio.post('auth/otp/verify', data: {'code': code});
    final data = Map<String, dynamic>.from(resp.data as Map);
    return data['status'] == 'ok';
  }
}


