import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/screens/auth_screens/ots_screen.dart';
import 'package:transit/widgets/pre_auth_buttons.dart';

class SignUpScreen extends StatelessWidget {
   SignUpScreen({super.key,required this.type});
   final String type;
 bool isValidEmail(String value) {
  return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
}
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email cannot be empty';
  }
  if (!isValidEmail(value)) {
    return 'Enter a valid email address';
  }
  return null;
}
String? validateNumber(String? phoneNumber) {
  
  if(phoneNumber==null ){
    return "Phone number cannot be empty.";

  }
  if (phoneNumber.isEmpty) {
    return "Phone number cannot be empty.";
  }

  if (!RegExp(r'^\+?[0-9]*$').hasMatch(phoneNumber)) {
    return "Phone number must contain only numbers and an optional leading '+'.";
  }

  // if (phoneNumber.startsWith('0')) {
  //   return "Phone number should not start with zero.";
  // }

  if ((phoneNumber.length < 10 || phoneNumber.length > 15)) {
    return "Phone number must be between 10 and 15 digits.";
  }

  return null; // If all checks pass
}
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    type=='email'?
      _emailController.addListener(() {
      _isButtonEnabled.value = _emailController.text.isNotEmpty;
    }): _phoneController.addListener(() {
      _isButtonEnabled.value = _phoneController.text.isNotEmpty;
    });

    return Scaffold(backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
       
        children: [
           InkWell(
                                      onTap: () => Navigator.of(context).pop(),

            child: SizedBox(height: 20.h,width: 20.w,child: Image.asset('assets/general_icons/back_button.png'),)),
           SizedBox(height: 10.h),
           Text("Continue with ${type=='email'?'Email':'Mobile'}", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),),
                   SizedBox(height: 2.h),

           Text("Sign up with your ${type=='email'?'Email':'Mobile'}", style: TextStyle(fontSize: 12.sp),),
                      SizedBox(height: 30.h),

           Align(
            alignment: Alignment.centerLeft,
            child: Text("${type=='email'?'Email':'Mobile'}", style: TextStyle(fontSize: 12.sp)),
          ),
             SizedBox(height: 5.h),
   ValueListenableBuilder<bool>(
  valueListenable: _isButtonEnabled,
  builder: (context, isEnabled, child) {
    return TextFormField(keyboardType: type=='email'?TextInputType.emailAddress:TextInputType.number,
      validator:type=='email'? validateEmail:validateNumber,
      controller:type=='email'? _emailController:_phoneController,
      decoration: InputDecoration(labelStyle: TextStyle(fontSize: 3.sp),
        filled: true,
        fillColor: isEnabled ? enabledFillColor : white, // ✅ Ensure correct background fill
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // ✅ Remove unwanted default border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isEnabled ? enabledBorderColor : borderColor, width: 1.5), // ✅ Apply correct enabled border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isEnabled ? enabledBorderColor : borderColor, width: 1.5), // ✅ Ensure focused border is correct
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        hintText:" ${type=='email'?'Email':'Mobile Number'}",
        hintStyle:  TextStyle(color: const Color.fromARGB(255, 62, 62, 62), fontSize: 12.sp, fontWeight: FontWeight.w100),
      ),
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w200),
    );
  },
),

             SizedBox(height: 50.h),
 ValueListenableBuilder<bool>(
                  valueListenable: _isButtonEnabled,
                  builder: (context, isEnabled, child) {
                    print("building");
                    return SizedBox(
                      height: 56.h,
                      child: BlocListener<AuthBloc,AuthState>(listener: (context, state) {
                        
                      },
                        
                        child:  PreAuthButtons(
                          onTap: isEnabled ? () {
                            //TODO ENABLE OTP
                    //           context.read<AuthBloc>().add(AuthRequestOtp(
                    // email: _emailController.text,
                    // mobile: _phoneController.text));
if(_formKey.currentState!.validate())
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return OtpScreen(email: _emailController.text,phoneNumber:  _phoneController.text);
                    },));
                          } : null,
                          fontsize: 20.sp,
                          label: "Continue",
                          enabled: isEnabled,
                          bold: true,fontWeight: FontWeight.w600,
                        )
                      
                     
                      ),
                    );
                  },
                )
         
        ],
            ),
          ),
        ),
      ),
    );
  }
}