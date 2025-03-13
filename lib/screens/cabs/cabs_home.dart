import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/data/other_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/cubits/flights_cubit/flight_det_cubit.dart';
import 'package:transit/screens/type_specific/cabs/cabs_search_form.dart';
import 'package:transit/screens/type_specific/flights/flight_search_form.dart';

class CabsHome extends StatelessWidget {
  const CabsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlightTypeCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Hero(
                tag: serviceTypeAssetString[0],
                child: SizedBox(
                  height: 30.h,
                  width: 30.w,
                  child: Image.asset(
                    serviceTypeAssetString[0],
                    fit: BoxFit.cover,
                    color: black,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              const Text('Cabs'),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              SizedBox(height: 20.h),
              const CabsSearchForm(),
            ],
          ),
        ),
      ),
    );
  }
}


