import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/bloc/user_specific/user_bloc.dart/user_bloc.dart';
import 'package:transit/bloc/user_specific/user_bloc.dart/user_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserBloc userBloc; // Inject UserBloc
  bool isAuthenticated = false;
  static const String _authTokenKey = 'authToken';
  String? token;

  Stream<AuthState> get authStateStream => stream.where(
      (state) => state is AuthAuthenticated || state is AuthUnauthenticated);

  AuthBloc(this.userBloc) : super(AuthInitial()) {
    // ✅ Check if user is already logged in
    on<AuthCheckRequested>((event, emit) async {
      log("Auth check requested");

      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString(_authTokenKey);
      log("Auth check token: $savedToken");
      log("Token saved: ${prefs.getString(_authTokenKey)}");

      if (savedToken != null && savedToken.isNotEmpty) {
        token = savedToken;
        emit(AuthAuthenticated());
        isAuthenticated = true;
        log("User is authenticated");
      } else {
        emit(AuthUnauthenticated());
        log("User is unauthenticated");
      }
    });

    // ✅ Handle Login
    on<AuthLoginEvent>((event, emit) async {
      try {
        emit(AuthLoading());

        // Simulate login API call (Replace this with actual API call)
        await Future.delayed(Duration(seconds: 2));
        final token = "dummy_auth_token"; // Replace with real token

        // Save token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_authTokenKey, token);
        log("Token saved after login: ${prefs.getString(_authTokenKey)}");

        emit(AuthAuthenticated());
        isAuthenticated = true;

        // Fetch user details after login using the correct event in UserBloc
        userBloc.add(LoadUser(event.email)); // Pass email as userId for now
      } catch (error) {
        emit(AuthError(errorMessage: error.toString()));
      }
    });

    // ✅ Handle User Registration (Sign Up)
    on<RegisterUserEvent>((event, emit) async {
      try {
        emit(AuthLoading());

        // Perform the login API call
        final response = await _loginApi(event.email, event.password);

        if (response != null && response['user'] != null) {
          final token =
              response['user']['id']; // Assuming the token is in the 'id' field

          // Save token in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_authTokenKey, token);
          log("Token saved after login: $token");

          emit(AuthAuthenticated());
          isAuthenticated = true;

          // Fetch user details after login
          userBloc.add(LoadUser(event.email)); // Pass email as userId for now
        } else {
          emit(AuthError(errorMessage: "Login failed"));
        }
      } catch (error) {
        emit(AuthError(errorMessage: error.toString()));
      }
    });

    // ✅ Handle Logout
    on<AuthLogout>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authTokenKey);
      log("User logged out, token removed");

      emit(AuthUnauthenticated());
      isAuthenticated = false;
    });
  }
  // Function to make the login API call
  Future<Map<String, dynamic>?> _loginApi(String email, String password) async {
    final url = Uri.parse('https://api.transitco.in/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'identifier': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json
          .decode(response.body); // If successful, return the decoded response
    } else {
      log("Login failed with status code: ${response.statusCode}");
      return null; // Return null if the login fails
    }
  }
}
