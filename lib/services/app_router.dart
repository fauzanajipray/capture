import 'dart:async';

import 'package:capture/features/auth/cubit/auth_cubit.dart';
import 'package:capture/features/auth/cubit/auth_state.dart';
import 'package:capture/features/auth/cubit/sign_in_cubit.dart';
import 'package:capture/features/auth/presentations/sign_in_page.dart';
import 'package:capture/features/auth/presentations/sign_up_page.dart';
import 'package:capture/features/auth/repository/auth_repositry.dart';
import 'package:capture/features/home/presentations/home_page.dart';
import 'package:capture/features/starter/presentations/onboard_page.dart';
import 'package:capture/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final AuthCubit _authCubit;
  static late final GoRouter _router;

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  AppRouter(this._authCubit) {
    final routes = [
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
                create: (context) => SignInCubit(AuthRepository()),
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
            child: const SignUpPage(),
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
          logger.d('on board : ${_authCubit.state.isOnBoard}');
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
