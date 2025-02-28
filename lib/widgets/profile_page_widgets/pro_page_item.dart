import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/theme/colors.dart';

class ProfilePageItem extends StatelessWidget {
  const ProfilePageItem({super.key,required  this.iconPath,required this.label,
  this.top=false,this.bottom=false,
  required this.onTap
  });
  final String iconPath;
  final String label;
  final bool top;
final bool bottom;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap,
      child: Container(decoration: BoxDecoration(color: white, 
       borderRadius: BorderRadius.only(
            topLeft: top ? Radius.circular(12) : Radius.zero,
            topRight: top ? Radius.circular(12) : Radius.zero,
            bottomLeft: bottom ? Radius.circular(12) : Radius.zero,
            bottomRight: bottom ? Radius.circular(12) : Radius.zero,
          ),
        ),
      padding: EdgeInsets.all(6),
      child: Row(
       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        SizedBox(height: 20.h,width: 20.w,child: Image.asset(iconPath),),
        SizedBox(width: 10.w,),
        Text(label),
     Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.arrow_forward_ios_sharp, color: bottomCardColor,))
      ],),
      ),
    );
  }
}