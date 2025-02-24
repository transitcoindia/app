import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/theme/colors.dart';

class PreAuthButtons extends StatelessWidget {
  const PreAuthButtons({super.key, required this.onTap,this.bold = false,
  required this.label,
  this.alt=false
  });
final void Function()? onTap;
final String label;
final bool alt;
final bool bold ;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:  8),
      width: double.infinity,

      child: InkWell(
      
        
        onTap: onTap, 
     
      child: Container(
        padding: EdgeInsets.all(2),decoration: BoxDecoration(
          color: alt?white:elevatedButtonBlue,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color:alt?elevatedButtonBlue:white )
        ),
        alignment: Alignment.center,
        child: Text(label,style: TextStyle(
          fontWeight: bold?FontWeight.bold:null,
          color: alt?elevatedButtonBlue:white
        ),),
      )),
    );
  }
}