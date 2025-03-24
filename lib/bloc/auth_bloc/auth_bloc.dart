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

  bool isAuthenticated = false;
    static const String _authTokenKey = 'authToken';

 Stream<AuthState> get authStateStream => stream.where((state) =>
    state is AuthAuthenticated || state is AuthUnauthenticated);
  AuthBloc( this.userBloc) : super(AuthInitial()) {



    
    on<AuthCheckRequested>((event, emit) async{
      log("Auth check requested");
       final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    final email = prefs.getString("email");
    final password = prefs.getString("password");
          log("Auth check ${token}");

 if (!(token==null || token.isEmpty)) {
        emit(AuthAuthenticated());

  await  authRepo.   signInUser(email!, password!).then((value) {
   
      isAuthenticated=true;
      log("Passing $value");
      userBloc.add(LoadUser(value!));
      log(isAuthenticated.toString());
    
  },);
  
      // _isLoggedIn = true;
      // // Optionally, you can load the user details if required
      // _userProvider.loadUser(email,); // Call this with a proper identifier if required
      // log("User is already logged in");
    } else {
      // handleError("TOken is ${token.toString()}");
      // log("No saved token found, user is not logged in");
    }
      if (isAuthenticated) {
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLoggedIn>((event, emit) {
      emit(AuthAuthenticated());
    });

    on<AuthLoggedOut>((event, emit) {
      emit(AuthUnauthenticated());
    });
on<AuthRequestOtp>((event, emit)async {
  try{

    await authRepo.sendOtp(event.mobile, event.email);
  }catch(e){
    emit(AuthError(errorMessage: e.toString()));
  }
},);
    on<AuthLoginEvent>(
      (event, emit) async {
        try {
          // emit(AuthLoading());
          // debugPrint("should be in loading now");
          // Call the login function and await its completion
          final res = 
          await authRepo
              .signInUser(event.email, event.password)
         
             ;
           
        log(res==null?"True":"False");
                if(res=='notVerified'){
                  emit(AuthEmailVerify());
                }else if( res == null)

             {  
              log("Emit correc state");
                  emit(AuthAuthenticated());
              isAuthenticated = true;

                    //userBloc.add(LoadUser(res!));
}

          // After the successful login, emit the authenticated state
        } catch (error) {
          // If an error occurs, emit an error state
          emit(AuthError(errorMessage: error.toString()));
        }
      },
    );

  on<RegisterUserEvent>((event, emit) async {
    emit(AuthLoading());
    try {
 final res= await authRepo.registerUser(event.firstName,event.lastName,event.email,event.password,event.confirmPassword);
if(res==null)
{ emit(AuthAuthenticated());}

else{
  emit(AuthError(errorMessage: res));

}
 // emit(WaitforOtp());
 
}  catch (e) {
  emit(AuthError(errorMessage: e.toString()));
  
}
  },);

on<AuthSendVerificationEmail>((event, emit) async{
  try {
 var res =  await authRepo.sendVerifyEmail(event.email);
 
} catch (e) {
  emit(AuthError(errorMessage: "Unable to send verification email"));
}
});
on<AuthLogout>((event, emit)async {
  await authRepo.logout();
  debugPrint("I am emitting the unauth state");
  emit(AuthUnauthenticated());
},);
 on<SubmitOtp>((event,emit) async {
  try {
      emit(AuthLoading());

  await authRepo.verifyOtp();
  emit(AuthAuthenticated());
}  catch (e) {
  emit(AuthError(errorMessage: e.toString()));
}
  
    //await authRepo.registerUser(userName, password, name, phoneNumber)
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


