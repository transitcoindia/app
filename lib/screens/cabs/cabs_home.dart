import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/bloc/location_bloc/location_bloc.dart';
import 'package:transit/core/data/other_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/cubits/flights_cubit/flight_det_cubit.dart';
import 'package:transit/screens/map/map_widget.dart';
import 'package:transit/screens/type_specific/cabs/cabs_search_form.dart';
import 'package:transit/screens/type_specific/flights/flight_search_form.dart';
import 'package:transit/widgets/custom_nav_bar/custom_nv_bar.dart';

class CabsHome extends StatelessWidget {
  const CabsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlightTypeCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Find Your Ride"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                SearchPage(),
                // Container(
                //   color: Colors.pink,height: 450,
                //   child: MapScreen())
              ],
            ),
          ),
        ),
        bottomNavigationBar: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: SizedBox(
            key: ValueKey('bnb'),
            height: 80.h,
            child: CustomNavBar(),
          ),
        ),
      ),
    );
  }
}
