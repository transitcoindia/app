import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/theme/colors.dart';

class PreAuthButtons extends StatelessWidget {
  const PreAuthButtons({super.key, required this.onTap,this.bold = false,this.leadingIcon,
  required this.label,
  this.alt=false, this.border=true
  });
final void Function()? onTap;
final String label;
final bool alt;
final bool bold ;
final String? leadingIcon;
final bool border;
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
          border: Border.all( color:border?alt?elevatedButtonBlue:white:transparent )
        ),
        alignment: Alignment.center,
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(leadingIcon!=null)
            SizedBox(height: 20.h,width: 20.w,child: Image.asset(leadingIcon!),),
          
           if(leadingIcon!=null)SizedBox(width: 4.w,),
            Text(label,style: TextStyle(
              fontWeight: bold?FontWeight.bold:null,
              color: alt?elevatedButtonBlue:white
            ),),
          ],
        ),
      )),
    );
  }
}