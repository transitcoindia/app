import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/theme/colors.dart';

class LoginTypePage extends StatelessWidget {
   LoginTypePage({super.key});
  final ValueNotifier<String> textNotifier = ValueNotifier<String>("signUp");




  void switchToLogin(){
    if(textNotifier.value=="logIn")
   { textNotifier.value="signUp";}
   else{
    textNotifier.value="logIn";
   }

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(bottom: false,
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

          ValueListenableBuilder<String>(
              valueListenable: textNotifier,
              builder: (context, value, child) {
                return SizedBox(
                  height: 300.h,
                  child: Image.asset('assets/lin_siup_images/ls${value=='LogIn'?0:1}.png'),
                );
              },),
            Container(height: 400.h,
decoration: BoxDecoration(
  color: bottomCardColor, borderRadius: BorderRadius.only(topLeft:Radius.circular(12) ,topRight:Radius.circular(12) )
),

            )
               
                
        
      
        
             
              ],
            )
          
      ),
    );
  }
}