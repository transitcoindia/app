import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/theme/colors.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
             double bottomPadding = MediaQuery.of(context).padding.bottom;
    double iconSize =  24; // ✅ Selected = 28, Unselected = 24
//isSelected ? 26 :
    double height = 30.h;
    double? width = null;
    return Container(padding: EdgeInsets.all(0),
    
      child: Container(
      decoration: BoxDecoration(color: elevatedButtonBlue),
        padding: EdgeInsets.only(bottom: bottomPadding/1.8, top: 4), 
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
      SizedBox(height: height,width:width,child: Image.asset('assets/bottom_bar_icons/home.png', height: iconSize,),),
         SizedBox(height: height,width:width,child: Image.asset('assets/bottom_bar_icons/travel.png'),),
      SizedBox(height: height,width:width,child: Image.asset('assets/bottom_bar_icons/explore.png'),),
      SizedBox(height: height,width:width,child: Image.asset('assets/bottom_bar_icons/profile.png'),),
            
            ],),),
    );
  }
}