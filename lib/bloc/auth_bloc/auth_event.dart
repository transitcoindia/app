

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
  final String firstName;
  final String lastName;
  final String email;
  // final String phone;
  final String password;
  final String confirmPassword;
  // final int otp;


  const RegisterUserEvent({
    required this.firstName,
    required this.email,
    required this.lastName,
    required this.password,
        required this.confirmPassword,

    // required this.otp
   
  });
}

class SubmitOtp extends AuthEvent {
  final int otp;



  const SubmitOtp({
  required this.otp
   
  });
}

class AuthSendVerificationEmail extends AuthEvent {
final String email;
AuthSendVerificationEmail({ required  this.email});

}


class AuthLogout extends AuthEvent {}
class ForgotPassword extends AuthEvent {}