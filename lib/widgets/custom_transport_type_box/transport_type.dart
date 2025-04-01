import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/theme/colors.dart';

class TransportTypeBox extends StatelessWidget {
  const TransportTypeBox(
      {super.key,
      required this.label,
      required this.assetPath,
      required this.onTap});
  final String label;
  final String assetPath;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 61.h,
          width: 71.h,
          decoration: BoxDecoration(
              color: elevatedButtonBlue,
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Hero(
                  tag: assetPath,
                  child: SizedBox(
                      height: 30.h,
                      width: 30.w,
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Text(
                label,
                style: TextStyle(color: white, fontSize: 11.sp),
              )
            ],
          ),
        ),
      ),
    );
  }
}
