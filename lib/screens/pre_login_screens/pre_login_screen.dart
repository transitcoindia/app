import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/data/pre_login_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/widgets/pre_auth_buttons.dart';

class PreLoginScreen extends StatelessWidget {
  const PreLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: white,
    
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Center(child: SizedBox(
          
          height: 26.h,
          child: Image.asset('assets/logos/transit_logo.png'))),
      Image.asset('assets/images/pre_login0.png'),

      Text(preLoginHeading[0], style: TextStyle(fontWeight: FontWeight.bold),),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(preLoginSubText[0], 
        textAlign: TextAlign.center,
        ),
      ),
      SizedBox(height: 20.h,
        child: ListView.separated(separatorBuilder: (context, index) {
          return SizedBox(width: 10.w,);
        },
          itemCount: 3,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
          return CircleAvatar(radius: 3,backgroundColor: index==0?selectedCircleAvatar:deselectedCircleAvatar,);
        },),
      ),
       SizedBox(height: 10.h,),
      Column(
        children: [
          PreAuthButtons(onTap: () {
            
          },label: "Log In",),
          SizedBox(height: 10.h,),
           PreAuthButtons(
            alt: true,
            onTap: () {
            
          },label: "I’m new, Sign me up",),
        ],
      )
      ],),
    ),
    );
  }
}