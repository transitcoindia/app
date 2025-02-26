import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/core/widgets/safe_scaffold.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:transit/widgets/pre_auth_buttons.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key,
  //  required this.name, 
  required this.email
  ,required this.phoneNumber
  //, required this.password
   });
  // final String name;
  final String email;
  final String phoneNumber;
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
      child: Scaffold(backgroundColor: white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                     InkWell(
                                        onTap: () => Navigator.of(context).pop(),
          
              child: SizedBox(height: 20.h,width: 20.w,child: Image.asset('assets/general_icons/back_button.png'),)),
             SizedBox(height: 10.h),
             Text("Enter Code", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),),
                     SizedBox(height: 2.h),
          
             Text("We have sent a verification code to your email", style: TextStyle(fontSize: 12.sp),),
                                Text("$email", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),),
          
                        SizedBox(height: 30.h),
          
         
                
                 SizedBox(height: 50.h,
                   child: OtpTextField(
                     numberOfFields: otpLength,
                     fieldWidth: MediaQuery.of(context).size.width / 8,
                     borderColor: enabledBorderColor, // Same color for both focus and non-focus states
                     cursorColor: black,
                     filled: true,
                     fillColor: enabledFillColor, // Background color inside the fields
                     borderRadius: BorderRadius.circular(8),
                     textStyle: const TextStyle(
                       color: black, // Text color set to white
                       fontSize: 22,
                             height: 1, // Adjust line height if needed

                       fontWeight: FontWeight.w600,
                     ),
                     showFieldAsBox: true, // Shows the input fields as boxes
                     enabledBorderColor: enabledBorderColor, // Ensuring both focused and non-focused borders match
                     focusedBorderColor: enabledBorderColor,
                     onCodeChanged: (String code) {
                       // Handle any change in the input
                     },
                     onSubmit: (String otp) {
                       final otpValue = int.tryParse(otp);
                       // if (otpValue != null) {
                       //   context.read<AuthBloc>().add(RegisterUserEvent(
                       //     email: email, name: name, password: password, phone: phoneNumber,
                       //     otp: otpValue));
                       // }
                     },
                   ),
                 )
,
SizedBox(height: 10.h,),
InkWell(onTap: () {
  
},
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
             Text("You didn’t receive any code? ", style: TextStyle(fontSize: 12.sp),),
                                  Text("Resend Code", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),),
            
  ],),
),
SizedBox(height: 25.h,),
SizedBox(
  height: 56.h,
  child: PreAuthButtons(onTap: (){
    //TODO use read login
    context.read<AuthBloc>().add(AuthLoggedIn());
    GoRouter.of(context).push('/home');
  }, label: "Continue", 
                            fontsize: 20.sp,

  fontWeight: FontWeight.w600,))



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


