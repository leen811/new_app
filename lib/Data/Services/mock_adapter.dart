import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'fixtures/auth_fixture.dart';
import 'fixtures/company_fixture.dart';
import 'fixtures/chat_fixture.dart';
import 'fixtures/dt_fixture.dart';
import 'fixtures/chat_detail_fixture.dart';
import 'fixtures/tasks_fixture.dart';
import 'fixtures/profile_fixture.dart';
import 'fixtures/profile_fixture.dart' as ProfileFx;
import 'fixtures/geofences_fixture.dart';
import 'fixtures/attendance_fixture.dart';
import 'fixtures/policy_fixture.dart';
import 'fixtures/tasks_fixture.dart' as TasksFx;
import 'fixtures/ai_fixture.dart';
import 'fixtures/digital_twin_fixture.dart';
import 'fixtures/training_fixture.dart';
import 'fixtures/perf360_fixture.dart';

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
    // Assistant AI endpoints
    adapter.onGet(
      '/v1/ai/suggest',
      (server) => server.reply(200, AiFixture.suggest, delay: delay),
    );

    // Smart Training endpoints
    adapter.onGet(
      '/v1/training/alerts',
      (server) => server.reply(200, TrainingFixture.alerts, delay: delay),
    );

    // Perf360 endpoints
    adapter.onGet(
      '/v1/perf360/summary',
      (server) => server.reply(200, Perf360Fixture.summary, delay: delay),
      queryParameters: {'me': 1},
    );
    adapter.onGet(
      '/v1/perf360/pending',
      (server) => server.reply(200, Perf360Fixture.pending, delay: delay),
    );
    adapter.onGet(
      '/v1/perf360/peers',
      (server) => server.reply(200, Perf360Fixture.peers, delay: delay),
    );
    adapter.onPost(
      '/v1/perf360/submit',
      (server) => server.reply(200, {'ok': true}, delay: delay),
      data: Matchers.any,
    );
    adapter.onGet(
      '/v1/perf360/results',
      (server) => server.reply(200, Perf360Fixture.results, delay: delay),
    );
    adapter.onGet(
      '/v1/perf360/analytics',
      (server) => server.reply(200, Perf360Fixture.analytics, delay: delay),
    );
    adapter.onGet(
      '/v1/training/skills-progress',
      (server) => server.reply(200, TrainingFixture.skills, delay: delay),
    );
    // Courses with category filters (match by query parameters)
    adapter.onGet(
      '/v1/training/courses',
      (server) => server.reply(200, TrainingFixture.page(category: 'all', page: 1), delay: delay),
      queryParameters: {'category': 'all', 'page': Matchers.any},
    );
    adapter.onGet(
      '/v1/training/courses',
      (server) => server.reply(200, TrainingFixture.page(category: 'management', page: 1), delay: delay),
      queryParameters: {'category': 'management', 'page': Matchers.any},
    );
    adapter.onGet(
      '/v1/training/courses',
      (server) => server.reply(200, TrainingFixture.page(category: 'technology', page: 1), delay: delay),
      queryParameters: {'category': 'technology', 'page': Matchers.any},
    );
    adapter.onGet(
      '/v1/training/courses',
      (server) => server.reply(200, TrainingFixture.page(category: 'soft', page: 1), delay: delay),
      queryParameters: {'category': 'soft', 'page': Matchers.any},
    );
    adapter.onGet(
      '/v1/training/courses',
      (server) => server.reply(200, TrainingFixture.page(category: 'engineering', page: 1), delay: delay),
      queryParameters: {'category': 'engineering', 'page': Matchers.any},
    );
    adapter.onGet(
      '/v1/training/courses',
      (server) => server.reply(200, TrainingFixture.page(category: 'productivity', page: 1), delay: delay),
      queryParameters: {'category': 'productivity', 'page': Matchers.any},
    );
    adapter.onPost(
      RegExp(r"/v1/training/courses/.+/bookmark"),
      (server) => server.reply(200, {'ok': true, 'isBookmarked': true}, delay: delay),
      data: Matchers.any,
    );
    adapter.onPost(
      '/v1/ai/chat',
      (server) => server.reply(200, AiFixture.reply(''), delay: delay),
      data: Matchers.any,
    );
    adapter.onPost(
      '/v1/ai/execute',
      (server) => server.reply(200, AiFixture.executed(''), delay: delay),
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
      (server) => server.reply(200, ChatFixture.conversations, delay: delay),
    );
    adapter.onGet(
      'chat/conversations',
      (server) => server.reply(200, ChatFixture.conversations, delay: delay),
    );
    adapter.onPost(
      'chat/pin',
      (server) => server.reply(200, {'ok': true}, delay: delay),
      data: Matchers.any,
    );
    adapter.onPost(
      'chat/mark-read',
      (server) => server.reply(200, {'ok': true}, delay: delay),
      data: Matchers.any,
    );
    // Chat detail endpoints
    adapter.onGet(
      '/v1/chat/history',
      (server) {
        final data = ChatDetailFixture.page(from: DateTime.now(), older: false);
        server.reply(200, data, delay: delay);
      },
    );
    adapter.onPost(
      '/v1/chat/send',
      (server) => server.reply(200, ChatDetailFixture.sendOk(), delay: delay),
      data: Matchers.any,
    );
    adapter.onPost(
      '/v1/chat/mark-read',
      (server) => server.reply(200, {'ok': true}, delay: delay),
      data: Matchers.any,
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
    // Profile tab endpoints
    adapter.onGet(
      '/v1/profile/me',
      (server) => server.reply(200, ProfileFx.ProfileTabFixture.user, delay: delay),
    );
    adapter.onGet(
      '/v1/profile/performance',
      (server) => server.reply(200, ProfileFx.ProfileTabFixture.performance, delay: delay),
    );
    // Personal info detail endpoints
    adapter.onGet(
      '/v1/profile/personal-info',
      (server) => server.reply(200, ProfileFx.PersonalInfoFixture.detail, delay: delay),
    );
    adapter.onPut(
      '/v1/profile/personal-info',
      (server) => server.reply(200, {'ok': true, ...ProfileFx.PersonalInfoFixture.detail}, delay: delay),
      data: Matchers.any,
    );
    // Tasks tab endpoints
    adapter.onGet(
      '/v1/tasks/kpi-overview',
      (server) => server.reply(200, TasksFx.TasksTabFixture.kpiOverview, delay: delay),
    );
    adapter.onGet(
      '/v1/tasks/daily',
      (server) => server.reply(200, TasksFx.TasksTabFixture.dailyTasks, delay: delay),
    );
    adapter.onPost(
      RegExp(r"/v1/tasks/.+/toggle-complete"),
      (server) => server.reply(200, {'ok': true, 'done': true}, delay: delay),
      data: Matchers.any,
    );
    adapter.onPost(
      RegExp(r"/v1/tasks/.+/timer/start"),
      (server) => server.reply(200, {'ok': true}, delay: delay),
      data: Matchers.any,
    );
    adapter.onPost(
      RegExp(r"/v1/tasks/.+/timer/stop"),
      (server) => server.reply(200, {'ok': true, 'seconds': 10}, delay: delay),
      data: Matchers.any,
    );
    adapter.onGet(
      '/v1/challenges/group',
      (server) => server.reply(200, TasksFx.TasksTabFixture.challengesGroup, delay: delay),
    );
    adapter.onGet(
      '/v1/challenges/team-progress',
      (server) => server.reply(200, TasksFx.TasksTabFixture.teamProgress, delay: delay),
    );

    // Attendance & geofence
    adapter.onGet(
      'geofences',
      (server) => server.reply(200, GeofencesFixture.list, delay: delay),
    );

    // Digital Twin endpoints
    adapter.onGet(
      '/v1/twin/overview',
      (server) => server.reply(200, DigitalTwinFixture.overview, delay: delay),
    );
    adapter.onGet(
      '/v1/twin/recommendations',
      (server) => server.reply(200, DigitalTwinFixture.recommendations, delay: delay),
    );
    adapter.onGet(
      '/v1/twin/productivity/weekly',
      (server) => server.reply(200, DigitalTwinFixture.weekly(), delay: delay),
    );
    adapter.onGet(
      '/v1/twin/productivity/daily',
      (server) => server.reply(200, DigitalTwinFixture.daily(), delay: delay),
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


