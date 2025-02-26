import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/core/data/pre_login_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/cubits/pre_login_cubit/pre_cubit.dart';
import 'package:transit/widgets/pre_auth_buttons.dart';

class PreLoginScreen extends StatelessWidget {
  const PreLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: BlocProvider(
          create: (_) => PreLoginCubit(),
          child: BlocBuilder<PreLoginCubit, int>(
            builder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Center(
                    child: SizedBox(
                      height: 26.h,
                      child: Image.asset('assets/logos/transit_logo.png'),
                    ),
                  ),

                  // Animated Image Switcher
                  Container(//decoration: BoxDecoration(border: Border.all(color: Colors.pink)),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                      child: Container(
                        // constraints: BoxConstraints(maxHeight: 440.h, minHeight: 440.h),
                        key: ValueKey<int>(index), // Ensures smooth animation
                        height: 380.h, // Keep this stable
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Image.asset(
                            fit: BoxFit.fitWidth,
                            'assets/images/pre_login$index.png'),
                        ),
                      ),
                    ),
                  ),

                  // Animated Text Switcher
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: SizedBox(height: 100.h,
                      child: Column(
                        key: ValueKey<int>(index),
                        children: [
                          Text(
                            preLoginHeading[index],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              preLoginSubText[index],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Fixed Positioned Dots
                  SizedBox(height: 10.h), // Spacer
                  SizedBox(
                    height: 20.h, // Fixed height to prevent shifting
                    child: Align(
                      alignment: Alignment.center, // Keeps it centered
                      child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(width: 10.w),
                        itemCount: preLoginHeading.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            // onTap: () => context.read<PreLoginCubit>().changeIndex(i),
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: i == index ? selectedCircleAvatar : deselectedCircleAvatar,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Auth Buttons
                  const SizedBox(height: 20), // Ensures fixed spacing
                  Column(
                    children: [
                      PreAuthButtons(
                        bold: true,
                        onTap: () {
                          GoRouter.of(context).push('/loginType');
                        },
                        label: "Log In",
                      ),
                      SizedBox(height: 10.h),
                      PreAuthButtons(
                        alt: true,
                        onTap: () {},
                        label: "I’m new, Sign me up",
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
