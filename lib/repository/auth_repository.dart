

import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AuthRepo {
    static const String _authTokenKey = 'authToken';

Future<String?> signInUser(String userName, String password)async {
 const loginUrl = 'https://transit-be.vercel.app/api/user/login/email';
 try{
  final loginResponse = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': userName,
        'password':password
      }),
    );
 final responseData = jsonDecode(loginResponse.body);
 var token =null;
if (responseData.containsKey('token')) {
   token = responseData['token'];
  print("Token: $token");
} else {
  print("Token not found in response.");
}

    if(
      loginResponse.statusCode == 200 && token!=null  // TODO: Remove comment in prod
        

    ){

   final prefs = await SharedPreferences.getInstance();
      await prefs.setString("password", password);
      await prefs.setString(_authTokenKey, token);
      await prefs.setString("email",userName);
    return null;
    }else{
  return json.decode(loginResponse.body)['message'];
    }


 }catch (e){
  rethrow;
 }

 
 }


Future<void> sendOtp(String? phoneNumber, String? email) async{
    const otpUrl = 'https://api.transitco.in/auth/otp/send';
    try{
 final otpResponse = await http.post(
      Uri.parse(otpUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        if(phoneNumber!=null)
        'mobile': phoneNumber.toString().trim(),
         if(email!=null)
        'email': email.toString().trim(),
      }),
    );

    }catch (e){


    }}






Future<void> registerUser(String userName, String password, String name, String phoneNumber,int otp) async {
  const registerUrl = 'https://transit-be.vercel.app/api/user/register/email';

  try {
    // Step 1: Request OTP
   
    
      // Step 2: Register User
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'mobile': phoneNumber,
          'email': userName,
          'password': password,
          'otp': otp.toString(),
        }),
      );

      if (response.statusCode == 200) {
        print('User registered successfully: ${response.body}');
      } else {
        print('Failed to register user: ${response.body}');
      }
    
  } catch (e) {
    print('An error occurred: $e');
  }
}


  bool checkIsAuthenticated() {
    return false;
  }

 Future<void> verifyOtp() async {


 
 await Future.delayed(const Duration(seconds: 3));
  return Future.value();}

}