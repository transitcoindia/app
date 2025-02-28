import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/core/data/pre_login_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/screens/auth_screens/sign_up_screen.dart';
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
  late AnimationController _textAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _updateSlideAnimation();
    _updateTextSlideAnimation();
  }

  void _updateSlideAnimation() {
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: slideLeft ? const Offset(-1, 0) : const Offset(1, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _updateTextSlideAnimation() {
    _textSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: slideLeft ? const Offset(-1, 0) : const Offset(1, 0),
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void switchToLogin() {
    _animationController.forward();
    _textAnimationController.forward().then((_) {
      textNotifier.value = textNotifier.value == "logIn" ? "signUp" : "logIn";
      slideLeft = !slideLeft;
      _updateSlideAnimation();
      _updateTextSlideAnimation();
      _animationController.reset();
      _textAnimationController.reset();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textAnimationController.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal:  8.0),
                         child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: SizedBox(height: 20.h,width: 20.w,child: Image.asset('assets/general_icons/back_button.png'),)),
                       ),

            Center(
              child: SizedBox(
                height: 26.h,
                child: Image.asset('assets/logos/transit_logo.png'),
              ),
            ),

            Align(alignment: Alignment.bottomCenter,
              child: SizedBox(
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
                            key: ValueKey<String>(value),
                            height: 300.h,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              height: 382.h,
              decoration: BoxDecoration(
                color: bottomCardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:  12.0, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SlideTransition(
                      position: _textSlideAnimation,
                      child: ValueListenableBuilder<String>(
                        valueListenable: textNotifier,
                        builder: (context, value, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authTypeHeading[value == "logIn" ? 0 : 1],
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22.sp),
                              ),
                              SizedBox(height: 10.h,),

                              Text(authTypeDesc[value == "logIn" ? 0 : 1]),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 3.h,),
                    ValueListenableBuilder<String>(
                      valueListenable: textNotifier,
                      builder: (context, value, child) {
                        return SizedBox(
                        height: 38.h,
                        child: PreAuthButtons(bold: true,horizontalPadding: 2,
                          leadingIcon: 'assets/auth_icons/email.png',
                                                fontWeight: FontWeight.w500,
                      
                          border: false,
                          label: '${textNotifier.value == "logIn" ? "Login" : "Sign Up"} with Email',
                          onTap: () {
                      
                           Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                             return SignUpScreen(type:'email');
                           },));
                          },
                        ),
                      );

                      },
                     
                    ),
                    ValueListenableBuilder<String>(
                                            valueListenable: textNotifier,
builder: (context, value, child) {
  return SizedBox(
                        height: 38.h,
                        child: PreAuthButtons(bold: true,horizontalPadding: 2,
                                              fontWeight: FontWeight.w500,
                      
                          leadingIcon: 'assets/auth_icons/google.png',
                          border: false,
                          label: '${textNotifier.value == "logIn" ? "Login" : "Sign Up"} with Google',
                          onTap: () {},
                        ),
                      );
},
                     
                    ),
                    ValueListenableBuilder<String>(
                      valueListenable: textNotifier,
                      builder: (context, value, child) {
                        return  SizedBox(
                        height: 38.h,
                        child: PreAuthButtons(bold: true,horizontalPadding: 2,
                        fontWeight: FontWeight.w500,
                          leadingIcon: 'assets/auth_icons/mobile.png',
                          border: false,
                          label: '${textNotifier.value == "logIn" ? "Login" : "Sign Up"} with Phone Number',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                             return SignUpScreen(type:'phone');
                           },));
                          },
                        ),
                      );
                      },
                     
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: switchToLogin,
                        style: ButtonStyle(
    overlayColor: WidgetStateProperty.all(Colors.transparent), // Disables ripple effect
    splashFactory: NoSplash.splashFactory, // Disables touch feedback
  ),
                        child: ValueListenableBuilder<String>(
                          valueListenable: textNotifier,
                          builder: (context, value, child) {
                            return Text(
                            textNotifier.value == "logIn"
                                ? "Don't have an account? Sign up"
                                : "Already have an account? Log in",
                            style: TextStyle(color: black, fontWeight: FontWeight.w200),
                          );
                          },
                     
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
