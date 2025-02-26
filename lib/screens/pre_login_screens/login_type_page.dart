import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/data/pre_login_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/widgets/pre_auth_buttons.dart';

class LoginTypePage extends StatefulWidget {
  const LoginTypePage({super.key});

  @override
  _LoginTypePageState createState() => _LoginTypePageState();
}

class _LoginTypePageState extends State<LoginTypePage> with TickerProviderStateMixin {
  final ValueNotifier<String> textNotifier = ValueNotifier<String>("signUp");
  bool slideLeft = true; // Tracks the animation direction

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller (Faster: 350ms)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _updateSlideAnimation();
  }

  void _updateSlideAnimation() {
    // Alternate the direction
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: slideLeft ? const Offset(-1, 0) : const Offset(1, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void switchToLogin() {
    // Start animation in the current direction
    _animationController.forward().then((_) {
      // Toggle the value after animation completes
      textNotifier.value = textNotifier.value == "logIn" ? "signUp" : "logIn";

      // Flip animation direction for next transition
      slideLeft = !slideLeft;
      _updateSlideAnimation();

      // Reset animation for next transition
      _animationController.reset();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo at the top
            Center(
              child: SizedBox(
                height: 26.h,
                child: Image.asset('assets/logos/transit_logo.png'),
              ),
            ),

            // Page-like Animated Image
            SizedBox(
              height: 300.h,
              child: Stack(
                children: [
                  SlideTransition(
                    position: _slideAnimation,
                    child: ValueListenableBuilder<String>(
                      valueListenable: textNotifier,
                      builder: (context, value, child) {
                        return Image.asset(
                          'assets/lin_siup_images/ls${value == "logIn" ? 0 : 1}.png',
                          key: ValueKey<String>(value), // Ensures animation triggers
                          height: 300.h,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Card (Fade Animation)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: ValueListenableBuilder<String>(
                valueListenable: textNotifier,
                builder: (context, value, child) {
                  return Container(
                    key: ValueKey<String>(value),
                    height: 382.h,
                    decoration: BoxDecoration(
                      color: bottomCardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            authTypeHeading[value == "logIn" ? 0 : 1],
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22.sp),
                          ),
                          Text(authTypeDesc[value == "logIn" ? 0 : 1]),

                          // Buttons
                          SizedBox(
                            height: 38.h,
                            child: PreAuthButtons(
                              leadingIcon: 'assets/auth_icons/email.png',
                              border: false,
                              label: '${value == "logIn" ? "Login" : "Sign Up"} with Email',
                              onTap: () {},
                            ),
                          ),
                          SizedBox(
                            height: 38.h,
                            child: PreAuthButtons(
                              leadingIcon: 'assets/auth_icons/google.png',
                              border: false,
                              label: '${value == "logIn" ? "Login" : "Sign Up"} with Google',
                              onTap: () {},
                            ),
                          ),
                          SizedBox(
                            height: 38.h,
                            child: PreAuthButtons(
                              leadingIcon: 'assets/auth_icons/mobile.png',
                              border: false,
                              label: '${value == "logIn" ? "Login" : "Sign Up"} with Phone',
                              onTap: () {},
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: switchToLogin,
                              child: Text(
                                value == "logIn"
                                    ? "Don't have an account? Sign up"
                                    : "Already have an account? Log in",
                                style: TextStyle(color: black),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
