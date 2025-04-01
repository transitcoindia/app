import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/core/theme/colors.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    double iconSize = 24; // Default icon size
    double height = 30.h;
    double? width;

    return Container(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(color: elevatedButtonBlue),
        padding: EdgeInsets.only(bottom: bottomPadding / 1.8, top: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Button
            InkWell(
              onTap: () {
                // Add navigation logic for Home
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/bottom_bar_icons/home.png',
                    height: iconSize,
                  ),
                  SizedBox(height: 4), // Space between icon and text
                  Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 12.sp, // Responsive font size
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Booking Button
            InkWell(
              onTap: () {
                // Add navigation logic for Booking
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/bottom_bar_icons/travel.png',
                    height: iconSize,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Booking",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Profile Button
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                log(state.toString());
                return InkWell(
                  onTap: () {
                    if (state is AuthAuthenticated) {
                      GoRouter.of(context).push('/profile');
                    } else {
                      GoRouter.of(context).push('/login');
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/bottom_bar_icons/profile.png',
                        height: iconSize,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
