import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/theme/colors.dart';

class LoginTypePage extends StatelessWidget {
  const LoginTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child:
             Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Logo at the top
                Center(
                  child: SizedBox(
                    height: 26.h,
                    child: Image.asset('assets/logos/transit_logo.png'),
                  ),
                ),

        
                // Animated Image Switcher
               
                
        
      
        
             
              ],
            )
          
      ),
    );
  }
}