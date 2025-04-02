import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/bloc/user_specific/user_bloc.dart/user_bloc.dart';
import 'package:transit/bloc/user_specific/user_bloc.dart/user_event.dart';
import 'package:transit/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authRepo = AuthRepo();
  final UserBloc userBloc; // Inject UserBloc
  bool isAuthenticated = false;
  static const String _authTokenKey = 'authToken';
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';

  AuthBloc(this.userBloc) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
    on<AuthLoginEvent>(_onAuthLoginEvent);
    on<RegisterUserEvent>(_onRegisterUserEvent);
    on<AuthRequestOtp>(_onAuthRequestOtp);
    on<AuthSendVerificationEmail>(_onAuthSendVerificationEmail);
    on<SubmitOtp>(_onSubmitOtp);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    log("Auth check requested");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    final email = prefs.getString(_emailKey);
    final password = prefs.getString(_passwordKey);

    log("Stored Token: $token");

    if (token != null && token.isNotEmpty) {
      try {
        final user = await authRepo.signInUser(email!, password!);
        if (user != null) {
          userBloc.add(LoadUser(user));
          emit(AuthAuthenticated());
          return;
        }
      } catch (e) {
        log("Error re-authenticating: $e");
      }
    }

    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthLoggedIn(
      AuthLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthAuthenticated());
    isAuthenticated = true;
  }

  Future<void> _onAuthLoggedOut(
      AuthLoggedOut event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear stored authentication details
    await authRepo.logout();
    log("User logged out");
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthLoginEvent(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      final res = await authRepo.signInUser(event.email, event.password);
      if (res == 'notVerified') {
        emit(AuthEmailVerify());
        return;
      }
      if (res == null) {
        emit(AuthError(errorMessage: "Invalid credentials"));
        return;
      }

      // Save credentials for persistence
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_authTokenKey);

      await prefs.setString(_authTokenKey, token!);
      await prefs.setString(_emailKey, event.email);
      await prefs.setString(_passwordKey, event.password);

      userBloc.add(LoadUser(res));
      isAuthenticated = true;
      emit(AuthAuthenticated());
    } catch (error) {
      emit(AuthError(errorMessage: error.toString()));
    }
  }

  Future<void> _onRegisterUserEvent(
      RegisterUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepo.registerUser(
        event.firstName,
        event.lastName,
        event.email,
        event.password,
        event.confirmPassword,
      );

      if (res == null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError(errorMessage: res));
      }
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  Future<void> _onAuthRequestOtp(
      AuthRequestOtp event, Emitter<AuthState> emit) async {
    try {
      await authRepo.sendOtp(event.mobile, event.email);
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  Future<void> _onAuthSendVerificationEmail(
      AuthSendVerificationEmail event, Emitter<AuthState> emit) async {
    try {
      await authRepo.sendVerifyEmail(event.email);
    } catch (e) {
      emit(AuthError(errorMessage: "Unable to send verification email"));
    }
  }

  Future<void> _onSubmitOtp(SubmitOtp event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      await authRepo.verifyOtp();
      isAuthenticated = true;
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  @override
  AuthState fromJson(Map<String, dynamic> json) {
    try {
      final isAuthenticated = json['isAuthenticated'] as bool;
      return isAuthenticated ? AuthAuthenticated() : AuthUnauthenticated();
    } catch (_) {
      return AuthInitial();
    }
  }

  @override
  Map<String, dynamic> toJson(AuthState state) {
    return {'isAuthenticated': state is AuthAuthenticated};
  }
}
