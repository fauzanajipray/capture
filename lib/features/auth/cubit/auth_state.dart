import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  loading,
  reloading,
  authenticated,
  unauthenticated,
  failure
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.token = '',
    this.isLogin = false,
    this.isOnBoard = false,
    this.error,
  });

  final AuthStatus status;
  final String token;
  final bool isLogin;
  final bool isOnBoard;
  final DioException? error;

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    bool? isLogin,
    bool? isOnBoard,
    DioException? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      isLogin: isLogin ?? this.isLogin,
      isOnBoard: isOnBoard ?? this.isOnBoard,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        token,
        isLogin,
        isOnBoard,
        error,
      ];
}
