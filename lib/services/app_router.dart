import 'dart:async';

import 'package:capture/features/auth/cubit/auth_cubit.dart';
import 'package:capture/features/auth/cubit/auth_state.dart';
import 'package:capture/features/auth/cubit/sign_in_cubit.dart';
import 'package:capture/features/auth/cubit/sign_up_cubit.dart';
import 'package:capture/features/auth/presentations/sign_in_page.dart';
import 'package:capture/features/auth/presentations/sign_up_page.dart';
import 'package:capture/features/auth/repository/auth_repositry.dart';
import 'package:capture/features/history/presentations/history_page.dart';
import 'package:capture/features/home/bloc/product_listing_bloc.dart';
import 'package:capture/features/home/bloc/recomendation_bloc.dart';
import 'package:capture/features/home/cubit/category_cubit.dart';
import 'package:capture/features/home/presentations/home_page.dart';
import 'package:capture/features/home/presentations/product_page.dart';
import 'package:capture/features/home/presentations/search_page.dart';
import 'package:capture/features/home/repository/home_repository.dart';
import 'package:capture/features/notification/presentations/notification_page.dart';
import 'package:capture/features/profile/cubit/profile_cubit.dart';
import 'package:capture/features/profile/cubit/profile_update_cubit.dart';
import 'package:capture/features/profile/presentations/profile_page.dart';
import 'package:capture/features/profile/repository/profile_repository.dart';
import 'package:capture/features/starter/presentations/onboard_page.dart';
import 'package:capture/widgets/bottom_navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final AuthCubit _authCubit;
  static late final GoRouter _router;

  final AuthRepository _authRepository = AuthRepository();
  final HomeRepository _homeRepository = HomeRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> historyTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> notifTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> profileTabNavigatorKey =
      GlobalKey<NavigatorState>();

  AppRouter(this._authCubit) {
    final routes = <RouteBase>[
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: parentNavigatorKey,
        branches: [
          StatefulShellBranch(
            navigatorKey: homeTabNavigatorKey,
            routes: [
              GoRoute(
                path: Destination.homePath,
                pageBuilder: (context, GoRouterState state) {
                  return getPage(
                    child: MultiBlocProvider(providers: [
                      BlocProvider(
                        create: (_) => CategoryCubit(_homeRepository),
                      ),
                      BlocProvider(
                        create: (_) => RecomendationBloc(_homeRepository),
                      ),
                      BlocProvider(
                        create: (_) => ProductSearchBloc(_homeRepository),
                      ),
                    ], child: const HomePage()),
                    state: state,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: historyTabNavigatorKey,
            routes: [
              GoRoute(
                path: Destination.historyPath,
                pageBuilder: (context, GoRouterState state) {
                  return getPage(
                    child: const HistoryPage(),
                    state: state,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: notifTabNavigatorKey,
            routes: [
              GoRoute(
                path: Destination.notifPath,
                pageBuilder: (context, GoRouterState state) {
                  return getPage(
                    child: const NotificationPage(),
                    state: state,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: profileTabNavigatorKey,
            routes: [
              GoRoute(
                path: Destination.profilePath,
                pageBuilder: (context, GoRouterState state) {
                  return getPage(
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (_) => ProfileCubit(_profileRepository),
                        ),
                        BlocProvider(
                          create: (_) => ProfileUpdateCubit(_profileRepository),
                        ),
                      ],
                      child: const ProfilePage(),
                    ),
                    state: state,
                  );
                },
              ),
            ],
          ),
        ],
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return getPage(
            child: BottomNavigationPage(
              child: navigationShell,
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Destination.homePath,
        pageBuilder: (context, state) {
          return getPage(
            child: const HomePage(),
            state: state,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Destination.onBoardPath,
        pageBuilder: (context, state) {
          return getPage(
            child: const OnBoardPage(),
            state: state,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Destination.signInPath,
        pageBuilder: (context, state) {
          return getPage(
            child: BlocProvider<SignInCubit>(
                create: (context) => SignInCubit(_authRepository),
                child: const SignInPage()),
            state: state,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Destination.signUpPath,
        pageBuilder: (context, state) {
          return getPage(
            child: BlocProvider<SignUpCubit>(
              create: (context) => SignUpCubit(_authRepository),
              child: const SignUpPage(),
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Destination.productDetail,
        pageBuilder: (context, state) {
          return getPage(
            child: BlocProvider<SignUpCubit>(
              create: (context) => SignUpCubit(_authRepository),
              child: const ProductPage(),
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Destination.searchPath,
        pageBuilder: (context, state) {
          String? searchKey = state.pathParameters['key'];
          return getPage(
            child: BlocProvider<ProductSearchBloc>(
              create: (context) => ProductSearchBloc(_homeRepository),
              child: SearchPage(searchKey),
            ),
            state: state,
          );
        },
      ),
    ];

    _router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: Destination.homePath,
      refreshListenable: GoRouterRefreshStream(_authCubit.stream),
      routes: routes,
      redirect: (context, state) {
        final bool isAuthenticated =
            _authCubit.state.status == AuthStatus.authenticated &&
                _authCubit.state.token != "";

        final bool isUnauthenticated =
            _authCubit.state.status == AuthStatus.unauthenticated ||
                _authCubit.state.token == "";

        const nonAuthRoutes = [
          Destination.signInPath,
          Destination.signUpPath,
          Destination.onBoardPath,
        ];

        if (_authCubit.state.isOnBoard == false) {
          return Destination.onBoardPath;
        } else {
          String? subloc = state.fullPath;
          String fromRoutes = state.pathParameters['from'] ?? '';

          if (nonAuthRoutes.contains(subloc) && isAuthenticated) {
            if (fromRoutes.isNotEmpty) {
              return fromRoutes;
            }
            return Destination.homePath;
          } else if (!nonAuthRoutes.contains(subloc) && isUnauthenticated) {
            return '${Destination.signInPath}?from=${state.fullPath}';
          }
          return null;
        }
      },
    );
  }

  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }

  GoRouter get router => _router;
}

class Destination {
  // No Need Auth
  static const String onBoardPath = '/onboard';
  static const String signInPath = '/signIn';
  static const String signUpPath = '/signUp';

  // Need Auth
  static const String homePath = '/home';
  static const String productDetail = '/productDetail';
  static const String historyPath = '/history';
  static const String notifPath = '/notif';
  static const String profilePath = '/profile';
  static const String searchPath = '/search/:key';
}

class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates a [GoRouterRefreshStream].
  ///
  /// Every time the [stream] receives an event the [GoRouter] will refresh its
  /// current route.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
