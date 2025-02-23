

import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart' as http;
class AuthRepo {

Future<String?> signInUser(String userName, String password)async {
 const loginUrl = 'https://api.transitco.in/auth/login';
 try{
  // final loginResponse = await http.post(
  //     Uri.parse(loginUrl),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'identifier': userName,
  //       'password':password
  //     }),
  //   );
  //   print(loginResponse.body.toString());
    if(
      //loginResponse.statusCode == 200   // TODO: Remove comment in prod
      true
    ){
    return null;
    }else{
  //return json.decode(loginResponse.body)['message'];
    }


 }catch (e){}

  await Future.delayed(const Duration(seconds: 1));
  return Future.value();
 }


Future<void> sendOtp(int phoneNumber) async{
    const otpUrl = 'https://api.transitco.in/auth/otp/send';
    try{
 final otpResponse = await http.post(
      Uri.parse(otpUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mobile': phoneNumber,
      }),
    );

    }catch (e){


    }}






Future<void> registerUser(String userName, String password, String name, String phoneNumber,int otp) async {
  const registerUrl = 'https://api.transitco.in/auth/otp/signup';

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