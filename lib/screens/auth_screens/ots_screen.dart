import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/core/widgets/safe_scaffold.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key,
  //  required this.name, required this.email,required this.phoneNumber, required this.password
   });
  // final String name;
  // final String email;
  // final String phoneNumber;
  // final String password;

  final int otpLength = 6;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {

        if (state is AuthLoading) {
          // Show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );
        }
        else if(state is AuthError){
       showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>  Center(child: Container(child: Text(state.errorMessage) ,)),
          );
        }
        
         else if (state is AuthAuthenticated) {
          Navigator.of(context).pop(); // Hide loading dialog
          context.push('/home'); // Navigate to home after successful registration
        } else if (state is AuthError) {
          Navigator.of(context).pop(); // Hide loading dialog on error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text(name  + email + phoneNumber + password),
                const Text(
                  "Enter 6-digit OTP",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter the OTP sent on your phone/email",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                OtpTextField(
                  numberOfFields: otpLength,
                  fieldWidth: MediaQuery.of(context).size.width/8,
                  borderColor: Colors.white,
                  cursorColor: Colors.white,
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.1), // Background color for boxes
                  borderRadius: BorderRadius.circular(8),
                  textStyle: const TextStyle(
                    color: Colors.white, // Text color set to white
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  showFieldAsBox: true, // Shows the input fields as boxes
                  onCodeChanged: (String code) {
                    // Handle any change in the input
                  },
                  onSubmit: (String otp) {
                    // If all 6 digits are entered, trigger SubmitOtp event

                    final otpValue = int.tryParse(otp);
                    // if (otpValue != null) {
                    //   context.read<AuthBloc>().add(RegisterUserEvent(
                    //     email: email,name: name,password: password,phone: phoneNumber,
                    //     otp:otpValue));
                    // }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


