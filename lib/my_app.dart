import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Data/Repositories/auth_repository.dart';
import 'Data/Repositories/company_repository.dart';
import 'Data/Services/api_client.dart';
import 'Data/Services/mock_adapter.dart';
import 'router.dart';
import 'Bloc/auth/auth_bloc.dart';
import 'Data/Repositories/geofence_repository.dart';
import 'Data/Repositories/attendance_repository.dart';
import 'Data/Repositories/policy_repository.dart';
import 'Data/Repositories/location_source.dart';
import 'Data/Models/geofence_models.dart';
import 'Data/Repositories/chat_repository.dart';
import 'Data/Repositories/chat_detail_repository.dart';
import 'Data/Repositories/tasks_repository.dart';
import 'Data/Repositories/profile_repository.dart';
import 'Data/Repositories/assistant_repository.dart';
import 'Data/Repositories/digital_twin_repository.dart';
import 'Data/Repositories/perf360_repository.dart';
import 'Data/Repositories/training_repository.dart';
import 'Data/Repositories/settings_repository.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ApiClient _api;
  late final IAuthRepository _authRepository;
  late final ICompanyRepository _companyRepository;
  late final IGeofenceRepository _geofenceRepository;
  late final IAttendanceRepository _attendanceRepository;
  late final IPolicyRepository _policyRepository;
  late final ILocationSource _locationSource;
  late final IChatRepository _chatRepository;
  late final IChatDetailRepository _chatDetailRepository;
  late final ITasksRepository _tasksRepository;
  late final IProfileRepository _profileRepository;
  late final IAssistantRepository _assistantRepository;
  late final IDigitalTwinRepository _digitalTwinRepository;
  late final ITrainingRepository _trainingRepository;
  late final IPerf360Repository _perf360Repository;
  late final ISettingsRepository _settingsRepository;
  late final _router = buildRouter();

  @override
  void initState() {
    super.initState();
    _api = ApiClient.create();
    MockApiAdapter(_api.dio);
    _authRepository = AuthRepository(_api.dio);
    _companyRepository = CompanyRepository(_api.dio);
    _geofenceRepository = GeofenceRepository(_api.dio);
    _attendanceRepository = AttendanceRepository(_api.dio);
    _policyRepository = PolicyRepository(_api.dio);
    _locationSource = _MockLocationSource();
    _chatRepository = ChatRepository(_api.dio);
    _chatDetailRepository = ChatDetailRepository(_api.dio);
    _tasksRepository = TasksRepository(_api.dio);
    _profileRepository = ProfileRepository(_api.dio);
    _assistantRepository = AssistantRepository(_api.dio);
    _digitalTwinRepository = DigitalTwinRepository(_api.dio);
    _trainingRepository = TrainingRepository(_api.dio);
    _perf360Repository = Perf360Repository(_api.dio);
    _settingsRepository = SettingsRepository(_api.dio);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
      textTheme: GoogleFonts.cairoTextTheme(),
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      // إعدادات الانتقالات للسحب
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          // iOS: لا سحب تفاعلي
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          // Android: افتراضي غير تفاعلي
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          // باقي المنصات
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        },
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<IAuthRepository>.value(value: _authRepository),
          RepositoryProvider<ICompanyRepository>.value(value: _companyRepository),
          RepositoryProvider<IGeofenceRepository>.value(value: _geofenceRepository),
          RepositoryProvider<IAttendanceRepository>.value(value: _attendanceRepository),
          RepositoryProvider<IPolicyRepository>.value(value: _policyRepository),
          RepositoryProvider<ILocationSource>.value(value: _locationSource),
          RepositoryProvider<IChatRepository>.value(value: _chatRepository),
          RepositoryProvider<IChatDetailRepository>.value(value: _chatDetailRepository),
          RepositoryProvider<ITasksRepository>.value(value: _tasksRepository),
          RepositoryProvider<IProfileRepository>.value(value: _profileRepository),
          RepositoryProvider<IAssistantRepository>.value(value: _assistantRepository),
          RepositoryProvider<IDigitalTwinRepository>.value(value: _digitalTwinRepository),
          RepositoryProvider<ITrainingRepository>.value(value: _trainingRepository),
          RepositoryProvider<IPerf360Repository>.value(value: _perf360Repository),
          RepositoryProvider<ISettingsRepository>.value(value: _settingsRepository),
        ],
        child: BlocProvider(
          create: (_) => AuthBloc(),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'إدارة الشركات',
            theme: theme,
            routerConfig: _router,
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          ),
        ),
      ),
    );
  }
}

class _MockLocationSource implements ILocationSource {
  @override
  Future<LocationPoint> getCurrent() async {
    // Default to location inside the main office geofence
    // Main office: lat: 24.7136, lng: 46.6753, radius: 150m
    return const LocationPoint(lat: 24.7136, lng: 46.6753);
  }
}


