import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'fixtures/auth_fixture.dart';
import 'fixtures/company_fixture.dart';

class MockApiAdapter {
  final Dio dio;
  final DioAdapter adapter;

  MockApiAdapter(this.dio) : adapter = DioAdapter(dio: dio) {
    _register();
  }

  void _register() {
    const delay = Duration(milliseconds: 600);
    adapter.onPost(
      'auth/login',
      (server) => server.reply(200, AuthFixture.loginSuccess, delay: delay),
      data: Matchers.any,
    );
    adapter.onPost(
      'auth/forgot/start',
      (server) => server.reply(200, AuthFixture.forgotOk, delay: delay),
      data: Matchers.any,
    );
    adapter.onPost(
      'auth/otp/verify',
      (server) => server.reply(200, AuthFixture.otpOk, delay: delay),
      data: Matchers.any,
    );
    adapter.onGet(
      'company/meta',
      (server) => server.reply(200, CompanyFixture.meta, delay: delay),
    );
    adapter.onPost(
      'company/register/step1',
      (server) => server.reply(200, {'ok': true}, delay: delay),
      data: Matchers.any,
    );
    adapter.onPost(
      'company/register/step2',
      (server) => server.reply(200, {'ok': true}, delay: delay),
      data: Matchers.any,
    );
  }
}


