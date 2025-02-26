

import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}
class AuthLoading extends AuthState {}


class WaitforOtp extends AuthState {}

class AuthError extends AuthState {
  const AuthError({required this.errorMessage});
  final String errorMessage;
}