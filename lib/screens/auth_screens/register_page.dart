import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/core/widgets/safe_scaffold.dart';
import 'package:transit/screens/auth_screens/ots_screen.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKeyReg = GlobalKey<FormState>();
   
    bool isValidEmail(String value) {
  return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Name cannot be empty';
  }
  return null;
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

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number cannot be empty';
  }
  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'Phone number must contain only numeric characters';
  }
  return null;
}


String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password cannot be empty';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
    return 'Password must contain at least one uppercase letter';
  }
  if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
    return 'Password must contain at least one lowercase letter';
  }
  if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
    return 'Password must contain at least one number';
  }
  if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) {
    return 'Password must contain at least one special character';
  }
  return null;
}

String? validateConfirmPassword(String? value, String originalPassword) {
  if (value == null || value.isEmpty) {
    return 'Confirm password cannot be empty';
  }
  if (value != originalPassword) {
    return 'Passwords do not match';
  }
  return null;
}

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
        } else if (state is AuthAuthenticated) {
          Navigator.of(context).pop(); // Hide loading dialog
          context.go('/home'); // Navigate to home after successful registration
        } else if (state is AuthError) {
          Navigator.of(context).pop(); // Hide loading dialog on error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: SafeScaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKeyReg, // Form should wrap the entire column containing fields
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset('assets/images/Register.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: const Text(
                      "Welcome to transit!",
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                  CustomTextFieldWithTop(
                    controller: _nameController,
                    label: "Name",
                    hintText: "Enter name",
                    validator: (value) {
                     return  validateName(value);
                    },
                  ),
                  CustomTextFieldWithTop(
                    controller: _emailController,
                    label: "Email",
                    hintText: "Enter email",
                    validator: (value) {
                                  return           validateEmail(value);

                    },
                  ),
                  CustomTextFieldWithTop(
                    controller: _phoneController,
                    label: "Phone Number",
                    hintText: "Enter phone number",
                    validator: (value) {
                     return validatePhoneNumber(value);
                    },
                  ),
                  CustomTextFieldWithTop(obscureText: true,
                    controller: _passwordController,
                    label: "Password",
                    hintText: "Enter password",
                    validator: (value) {
                     return validatePassword(value);
                    },
                  ),
                  CustomTextFieldWithTop(
                    obscureText: true,
                    controller: _confirmPasswordController,
                    label: "Confirm Password",
                    hintText: "Enter confirm password",
                    validator: (value) {
                  return   validateConfirmPassword(value, _passwordController.text);
                    }
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKeyReg.currentState!.validate()) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return OtpScreen(
      //  name: _nameController.text,
      //                         email: _emailController.text,
      //                         phoneNumber: _phoneController.text,
      //                         password: _passwordController.text,                     
                              
                                   );
                        },)
                        );
                        // Dispatch the registration event if the form is valid
                        
                        // context.read<AuthBloc>().add(RegisterUserEvent(
                        //       name: _nameController.text,
                        //       email: _emailController.text,
                        //       phone: _phoneController.text,
                        //       password: _passwordController.text,
                             
                        //     ));
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldWithTop extends StatelessWidget {
  const CustomTextFieldWithTop({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.validator,
    this.obscureText= false
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? Function(String?) validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          TextFormField(
             obscureText:obscureText ,
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white, 
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
            ),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
