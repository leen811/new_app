import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'fixtures/auth_fixture.dart';
import 'fixtures/company_fixture.dart';
import 'fixtures/chat_fixture.dart';
import 'fixtures/dt_fixture.dart';
import 'fixtures/tasks_fixture.dart';
import 'fixtures/profile_fixture.dart';
import 'fixtures/geofences_fixture.dart';
import 'fixtures/attendance_fixture.dart';
import 'fixtures/policy_fixture.dart';

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

    // Bottom nav endpoints
    adapter.onGet(
      'chat/messages',
      (server) => server.reply(200, ChatFixture.messages, delay: delay),
    );
    adapter.onGet(
      'dt/summary',
      (server) => server.reply(200, DtFixture.summary, delay: delay),
    );
    adapter.onGet(
      'tasks',
      (server) => server.reply(200, TasksFixture.tasks, delay: delay),
    );
    adapter.onGet(
      'profile/me',
      (server) => server.reply(200, ProfileFixture.me, delay: delay),
    );

    // Attendance & geofence
    adapter.onGet(
      'geofences',
      (server) => server.reply(200, GeofencesFixture.list, delay: delay),
    );
    adapter.onGet(
      'attendance/policy',
      (server) => server.reply(200, PolicyFixture.policy, delay: delay),
    );
    adapter.onPost(
      'attendance/check-in',
      (server) => server.reply(200, AttendanceFixture.checkIn, delay: delay),
      data: Matchers.any,
    );
    adapter.onPost(
      'attendance/check-out',
      (server) => server.reply(200, AttendanceFixture.checkOut, delay: delay),
      data: Matchers.any,
    );
    adapter.onPost(
      'attendance/break/start',
      (server) => server.reply(200, AttendanceFixture.breakStart, delay: delay),
      data: Matchers.any,
    );
    adapter.onPost(
      'attendance/break/stop',
      (server) => server.reply(200, AttendanceFixture.breakStop, delay: delay),
      data: Matchers.any,
    );
  }
}


