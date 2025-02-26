

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {}

class AuthLoggedOut extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  const AuthLoginEvent( {required this.email,required  this.password});

 final String email;
 final String password;
}

class AuthRequestOtp extends AuthEvent {
  const AuthRequestOtp({this.email,this.mobile});
  final String? email;
  final String? mobile;
}
class AuthErrorEvent extends AuthEvent {
  const AuthErrorEvent( {required this.errorMessage});

 final String errorMessage;

}

class RegisterUserEvent extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final int otp;


  const RegisterUserEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.otp
   
  });
}

class SubmitOtp extends AuthEvent {
  final int otp;



  const SubmitOtp({
  required this.otp
   
  });
}




class AuthLogout extends AuthEvent {}