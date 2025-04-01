import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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
  String? userId;
  bool isAuthenticated = false;
  static const String _authTokenKey = 'authToken';

  Stream<AuthState> get authStateStream => stream.where(
      (state) => state is AuthAuthenticated || state is AuthUnauthenticated);

  AuthBloc(this.userBloc) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      log("Auth check requested");

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_authTokenKey);
      log("Auth check token: $token");

      if (token != null && token.isNotEmpty) {
        emit(AuthAuthenticated());
        isAuthenticated = true;
        log("User is authenticated");
      } else {
        emit(AuthUnauthenticated());
        log("User is unauthenticated");
      }
    });

    on<AuthLoggedIn>((event, emit) {
      emit(AuthAuthenticated());
    });

    on<AuthLoggedOut>((event, emit) {
      emit(AuthUnauthenticated());
    });

    on<AuthLoginEvent>((event, emit) async {
      try {
        final res = await authRepo.signInUser(event.email, event.password);
        if (res != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_authTokenKey, res);
          log("Token saved: ${prefs.getString(_authTokenKey)}");
          emit(AuthAuthenticated());
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (error) {
        emit(AuthError(errorMessage: error.toString()));
      }
    });

    on<AuthLogout>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authTokenKey);
      await authRepo.logout();
      debugPrint("I am emitting the unauth state");
      emit(AuthUnauthenticated());
    });
  }

  AuthState fromJson(Map<String, dynamic> json) {
    try {
      final isAuthenticated = json['isAuthenticated'] as bool;
      return isAuthenticated ? AuthAuthenticated() : AuthUnauthenticated();
    } catch (_) {
      return AuthInitial();
    }
  }

  Map<String, dynamic> toJson(AuthState state) {
    if (state is AuthAuthenticated) {
      return {'isAuthenticated': true};
    } else if (state is AuthUnauthenticated) {
      return {'isAuthenticated': false};
    }
    return {};
  }
}
