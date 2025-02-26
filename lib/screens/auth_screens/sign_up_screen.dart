import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/widgets/pre_auth_buttons.dart';

class SignUpScreen extends StatelessWidget {
   SignUpScreen({super.key});
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
      _emailController.addListener(() {
      _isButtonEnabled.value = _emailController.text.isNotEmpty;
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
           Text("Continue with Email", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),),
                   SizedBox(height: 2.h),

           Text("Sign up with your email.", style: TextStyle(fontSize: 12.sp),),
                      SizedBox(height: 30.h),

           Align(
            alignment: Alignment.centerLeft,
            child: Text("Email", style: TextStyle(fontSize: 12.sp)),
          ),
             SizedBox(height: 5.h),
   ValueListenableBuilder<bool>(
  valueListenable: _isButtonEnabled,
  builder: (context, isEnabled, child) {
    return TextFormField(
      validator: validateEmail,
      controller: _emailController,
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
        hintText: 'Email Address',
        hintStyle:  TextStyle(color: const Color.fromARGB(255, 62, 62, 62), fontSize: 12.sp, fontWeight: FontWeight.w100),
      ),
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w200),
    );
  },
),



          // const SizedBox(height: 10),
          // const Align(
          //   alignment: Alignment.centerLeft,
          //   child: Text("Password", style: TextStyle(fontSize: 16)),
          // ),
          // TextFormField(
          //   validator: (value) =>
          //       value == null || value.isEmpty ? 'Password cannot be empty' : null,
          //   obscureText: true,
          //   controller: _passwordController,
          //   decoration: InputDecoration(
          //     filled: true,
          //     fillColor: Colors.white,
          //     contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(12),
          //       borderSide: BorderSide.none,
          //     ),
          //     errorBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(12),
          //       borderSide: const BorderSide(color: Colors.red),
          //     ),
          //     hintText: 'Enter your password',
          //     hintStyle: const TextStyle(color: Colors.grey),
          //   ),
          //   style: const TextStyle(color: Colors.black),
          // ),
          // const SizedBox(height: 30),
          // BlocListener<AuthBloc,AuthState>(listener: (context, state) {
          //   if(state is AuthLoading){
          //     showDialog(
          //                 context: context,
          //                 barrierDismissible: false,
          //                 builder: (context) => const Center(child: CircularProgressIndicator()),
          //               );
          //   } else if (state is AuthError){
          //     if(Navigator.canPop(context)){
          //       Navigator.of(context).pop();
          //       showDialog(
          //                 context: context,
          //                 barrierDismissible: false,
          //                 builder: (context) =>  Dialog(
          //                   child: SingleChildScrollView(
          //                     child: Column(
          //                       children: [
          //                         Text(state.errorMessage, style: TextStyle(color: black),),
          //                         ElevatedButton(onPressed: (){
          //                        Navigator.of(context).pop();
          //                         }, child: Text("Retry"))
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               );
          //     }
          //   }
          // },
          //   child: TextButton(
          //     onPressed: () {
                
          //       if (_formKey.currentState!.validate()) {
                  
          //         context.read<AuthBloc>().add(AuthLoginEvent(
          //             email: _emailController.text,
          //             password: _passwordController.text));
          //       }
          //     },
          //     style: TextButton.styleFrom(
          //       backgroundColor: Colors.transparent,
          //       side: const BorderSide(color: Colors.white),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //     child: const Text('Sign In', style: TextStyle(color: Colors.white)),
          //   ),
          // ),
          // const SizedBox(height: 20),
             SizedBox(height: 50.h),
 ValueListenableBuilder<bool>(
                  valueListenable: _isButtonEnabled,
                  builder: (context, isEnabled, child) {
                    print("building");
                    return SizedBox(
                      height: 56.h,
                      child: PreAuthButtons(
                        onTap: isEnabled ? () {} : null,
                        fontsize: 20.sp,
                        label: "Continue",
                        enabled: isEnabled,
                        bold: true,fontWeight: FontWeight.w600,
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