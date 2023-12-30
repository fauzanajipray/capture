import 'package:capture/features/auth/cubit/auth_cubit.dart';
import 'package:capture/features/auth/cubit/auth_state.dart';
import 'package:capture/features/auth/presentations/login_error_screen.dart';
import 'package:capture/services/app_router.dart';
import 'package:capture/services/dio_client.dart';
import 'package:capture/utils/dio_exceptions.dart';
import 'package:capture/widgets/loading_progress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(printer: PrettyPrinter());

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getApplicationDocumentsDirectory());
  HydratedBloc.storage = storage;
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDateFormatting('id_ID', null);
  await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late DioClient dioClient;
  late final AuthCubit _authCubit;
  late final GoRouter _router;

  @override
  void initState() {
    _authCubit = AuthCubit();
    dioClient = DioClient(authCubit: _authCubit);
    dioClient.init();
    _router = AppRouter(_authCubit).router;
    Future.delayed(Duration.zero, () {
      initAsyncData();
    });
    super.initState();
  }

  void initAsyncData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authCubit.checkToken();
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _authCubit),
      ],
      child: buildMaterialApp(),
    );
  }

  Widget buildMaterialApp() {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      builder: (context, child) {
        return BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (previous, current) {
            return previous.status != current.status;
          },
          builder: (BuildContext context, AuthState state) {
            FlutterNativeSplash.remove();
            if (state.status == AuthStatus.initial ||
                state.status == AuthStatus.loading) {
              return const Scaffold(
                body: LoadingProgress(),
              );
            } else if (state.status == AuthStatus.failure ||
                state.status == AuthStatus.reloading) {
              return LoginErrorScreen(
                  DioExceptions.fromDioError(state.error!, context).toString());
            }
            dioClient.init();
            return ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              ],
            );
          },
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF304AAC),
          primaryContainer: const Color(0x3348B5D6),
          onSurfaceVariant: Colors.grey,
        ),
      ),
    );
  }
}
