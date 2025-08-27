import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Data/Repositories/auth_repository.dart';
import 'Data/Repositories/company_repository.dart';
import 'Data/Services/api_client.dart';
import 'Data/Services/mock_adapter.dart';
import 'router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ApiClient _api;
  late final IAuthRepository _authRepository;
  late final ICompanyRepository _companyRepository;
  late final _router = buildRouter();

  @override
  void initState() {
    super.initState();
    _api = ApiClient.create();
    MockApiAdapter(_api.dio);
    _authRepository = AuthRepository(_api.dio);
    _companyRepository = CompanyRepository(_api.dio);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
      textTheme: GoogleFonts.cairoTextTheme(),
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<IAuthRepository>.value(value: _authRepository),
          RepositoryProvider<ICompanyRepository>.value(value: _companyRepository),
        ],
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
    );
  }
}


