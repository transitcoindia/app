import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/core/widgets/safe_scaffold.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child:
                            Image.asset('assets/general_icons/back_button.png'),
                      )),
                  SizedBox(height: 10.h),
                  Text(
                    "Welcome",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                  ),
                  Text(
                    "Back!",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                  ),
                  Text("."),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Email", style: TextStyle(fontSize: 12.sp)),
                  ),
                  TextFormField(
                    validator: (value) => validateEmail(value),
                    controller: _userNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      hintText: '',
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Password", style: TextStyle(fontSize: 16)),
                  ),
                  TextFormField(
                    validator: (value) => value == null || value.isEmpty
                        ? 'Password cannot be empty'
                        : null,
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      hintText: '',
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  InkWell(
                      onTap: () {
                        // context.read<AuthBloc>().add(Password)
                      },
                      child: SizedBox(
                        child: Text("Forgot Password?"),
                      )),
                  const SizedBox(height: 30),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthLoading) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is AuthEmailVerify) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Dialog(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    "Please check your email inbox to verify your email",
                                    style: TextStyle(color: black),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Ok")),
                                  ElevatedButton(
                                      onPressed: () {
                                        context.read<AuthBloc>().add(
                                            AuthSendVerificationEmail(
                                                email:
                                                    _userNameController.text));
                                      },
                                      child: Text("Resend verify email"))
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (state is AuthError) {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Dialog(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      state.errorMessage,
                                      style: TextStyle(color: black),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Retry"))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      } else if (state is AuthAuthenticated) {
                        GoRouter.of(context).push('/home');
                      }
                    },
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(AuthLoginEvent(
                              email: _userNameController.text,
                              password: _passwordController.text));
                          GoRouter.of(context).push('/home');
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Sign In',
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () {},
                      child: const Text("Forgot password ?",
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
