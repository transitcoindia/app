import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/data/other_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/cubits/flights_cubit/flight_det_cubit.dart';
import 'package:transit/screens/type_specific/flights/flight_search_form.dart';

class FlightHome extends StatelessWidget {
  const FlightHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlightTypeCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Hero(
                tag: serviceTypeAssetString[1],
                child: SizedBox(
                  height: 30.h,
                  width: 30.w,
                  child: Image.asset(
                    serviceTypeAssetString[1],
                    fit: BoxFit.cover,
                    color: black,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              const Text('Flights'),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _oneWayOrRoundTripSelector(),
              SizedBox(height: 20.h),
              const FlightSearchForm(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _oneWayOrRoundTripSelector() {
  return BlocBuilder<FlightTypeCubit, FlightType>(
    builder: (context, flightType) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _toggleButton(
            context: context,
            label: "One Way",
            isSelected: flightType == FlightType.oneWay,
            onTap: () => context.read<FlightTypeCubit>().selectOneWay(),
          ),
          SizedBox(width: 10.w),
          _toggleButton(
            context: context,
            label: "Round Trip",
            isSelected: flightType == FlightType.roundTrip,
            onTap: () => context.read<FlightTypeCubit>().selectRoundTrip(),
          ),
        ],
      );
    },
  );
}

Widget _toggleButton({
  required BuildContext context,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        Container(
          width: 14.w,
          height: 14.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
        SizedBox(width: 5.w),
        Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}
