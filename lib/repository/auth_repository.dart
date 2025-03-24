

import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
final String endpoint = 'https://api.transitco.in';
class AuthRepo {
    static const String _authTokenKey = 'authToken';

Future<String?> signInUser(String userName, String password)async {
 String loginUrl = '${endpoint}/api/auth/login';
 try{
  final loginResponse = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': userName,
        'password':password
      }),
    );
     log(loginResponse.body.toString());
     log(loginResponse.statusCode.toString());

  final Map<String, dynamic> responseData = jsonDecode(loginResponse.body);
 var token =null;
if (responseData.containsKey('token')) {
   token = responseData['token'];
  print("Token: $token");

} 
 else if (loginResponse.statusCode==403){
        print('Failed to login user: ${loginResponse.body}');
        return "notVerified";
      }
else {
  print("Token not found in response.");
}

    if(
      loginResponse.statusCode == 200 && token!=null  // TODO: Remove comment in prod
        

    ){
      log(responseData.containsKey('user').toString());
log(responseData['user'].containsKey('id').toString());
   final prefs = await SharedPreferences.getInstance();
      await prefs.setString("password", password);
      await prefs.setString(_authTokenKey, token);
      await prefs.setString("email",userName);
      await prefs.setString("userId",responseData['user']['id']);
    return responseData['user']['id'];
    }else{
      throw(json.decode(loginResponse.body)['error']);
   
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






Future<String?> registerUser(String firstName, String lastName, String email, String password,String confirmPassword) async {
  String registerUrl = '${endpoint}/api/auth/register';

  try {
    // Step 1: Request OTP
   
    
      // Step 2: Register User
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword

          // 'otp': otp.toString(),
        }),
      );
log(response.toString());
log(response.body.toString());
log(response.statusCode.toString());
      if (response.statusCode == 201) {
        print('User registered successfully: ${response.body}');
        return null;
      } 
     
      else {
        print('Failed to register user: ${response.body}');
        return response.body.toString();
      }

    
  } catch (e) {
    print('An error occurred: $e');
    return 'Error occoured';
  }
}


  bool checkIsAuthenticated() {
    return false;
  }

 Future<void> verifyOtp() async {


 
 await Future.delayed(const Duration(seconds: 3));
  return Future.value();}

  logout() async{
       final prefs = await SharedPreferences.getInstance();
      await prefs.remove("password");
      await prefs.remove(_authTokenKey);
      await prefs.remove("email");
  }

 Future<String?> sendVerifyEmail(String email) async{
  String registerUrl = '${endpoint}/api/auth/verify-email';

  try {
    // Step 1: Request OTP
   
    
      // Step 2: Register User
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
    
          'email': email,

          // 'otp': otp.toString(),
        }),
      );
log(response.toString());
log(response.body.toString());
log(response.statusCode.toString());
      if (response.statusCode == 201) {
        print('Email verify email sent successfully: ${response.body}');
        return null;
      } 
     
      else {
        print('Failed to register user: ${response.body}');
        return response.body.toString();
      }

    
  } catch (e) {
    print('An error occurred: $e');
    return 'Error occoured';
  }

  }

}