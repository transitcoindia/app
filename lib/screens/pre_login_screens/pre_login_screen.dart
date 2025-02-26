import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/core/data/pre_login_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/cubits/pre_login_cubit/pre_cubit.dart';
import 'package:transit/widgets/pre_auth_buttons.dart';
import 'package:animations/animations.dart';

class PreLoginScreen extends StatelessWidget {
  const PreLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
      final PageController _pageController = PageController();

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
                  BlocListener<PreLoginCubit, int>(
              listener: (context, index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 450.h,
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(), 
                    itemCount: 3, 
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double pageOffset = 0;
                          if (_pageController.position.haveDimensions) {
                            pageOffset = _pageController.page! - index;
                          }
                          return Transform.scale(
                            scale: 1 - (pageOffset.abs() * 0.1), 
                            child: Opacity(
                              opacity: 1 - (pageOffset.abs() * 0.5),
                              child: child,
                            ),
                          );
                        },
                        child: Image.asset(
                          fit: BoxFit.contain,
                          'assets/images/pre_login$index.png',
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

                  // Animated Text Switcher
                  Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: SizedBox(height: 100.h,
                          child: Column(
                            key: ValueKey<int>(index),
                            children: [
                              Text(
                                preLoginHeading[index],
                                style: const TextStyle(fontWeight: FontWeight.w700),
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
                                       // SizedBox(height: 5.h), // Spacer
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
                                  radius: 3,
                                  backgroundColor: i == index ? selectedCircleAvatar : deselectedCircleAvatar,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Auth Buttons
                   SizedBox(height: 25.h), // Ensures fixed spacing
                  Column(
                    children: [
                      SizedBox(height: 29.h,
                        child: PreAuthButtons(
                          bold: true,
                          onTap: () {
                            GoRouter.of(context).push('/loginType');
                          },
                          label: "Log In",
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(height: 29.h,
                        child: PreAuthButtons(
                          alt: true,
                          onTap: () {},
                          label: "I’m new, Sign me up",
                        ),
                      ),
                    ],
                  ),
                                     SizedBox(height: 25.h), // Ensures fixed spacing

                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
