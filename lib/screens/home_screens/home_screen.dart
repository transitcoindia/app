import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/bloc/location_bloc/location_bloc.dart';
import 'package:transit/bloc/location_bloc/location_state.dart';
import 'package:transit/core/data/other_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/widgets/custom_nav_bar/custom_nv_bar.dart';
import 'package:transit/widgets/custom_transport_type_box/transport_type.dart';
import 'package:transit/widgets/search_bar/search_bar.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  // Default location
  final String defaultLocation = "Bengaluru, 562157";

  // New transport types based on Figma design
  final List<String> transportTypes = [
    'Daily',
    'Outstation',
    'Rental',
    'Airport'
  ];
  final List<IconData> transportIcons = [
    Icons.directions_car,
    Icons.directions_car,
    Icons.directions_car,
    Icons.airplanemode_active
  ];

  // Function to get formatted address
  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Format the address as city, postal code
        return "${place.locality}, ${place.postalCode}";
      }
    } catch (e) {
      print("Error getting address: $e");
    }
    return defaultLocation; // Return default if geocoding fails
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
      body: Stack(
        children: [
          // Gradient background at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 146.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    bottomCardColor, // Use your defined color
                    const Color.fromARGB(52, 177, 212, 224)
                  ],
                ),
              ),
            ),
          ),

          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Header
                  BlocListener<LocationBloc, LocationState>(
                    listener: (context, state) {
                      // You can add any location change listener logic here
                    },
                    child: BlocBuilder<LocationBloc, LocationState>(
                      builder: (context, state) {
                        return FutureBuilder<String>(
                          future: state.currentLocation != null
                              ? _getAddressFromLatLng(
                                  state.currentLocation!.latitude!,
                                  state.currentLocation!.longitude!)
                              : Future.value(defaultLocation),
                          builder: (context, snapshot) {
                            String displayLocation =
                                snapshot.data ?? defaultLocation;

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      size: 20.sp, color: Colors.grey[700]),
                                  SizedBox(width: 4.w),
                                  Text(
                                    displayLocation,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Search Bar
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey[200],
                  //       borderRadius: BorderRadius.circular(8.r),
                  //     ),
                  //     padding: EdgeInsets.symmetric(horizontal: 12.w),
                  //     height: 48.h,
                  //     child: Row(
                  //       children: [
                  //         Icon(Icons.search, color: Colors.grey[600]),
                  //         SizedBox(width: 8.w),
                  //         Expanded(
                  //           child: TextField(
                  //             controller: searchController,
                  //             decoration: InputDecoration(
                  //               hintText: 'Search',
                  //               border: InputBorder.none,
                  //               hintStyle: TextStyle(
                  //                 color: Colors.grey[600],
                  //                 fontSize: 14.sp,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  // Transport Type Categories
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 30.h),
                    child: SizedBox(
                      height: 80.h, // Adjust height as needed
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return TransportTypeBox(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    GoRouter.of(context).push('/cabs');
                                    break;
                                  case 1:
                                    GoRouter.of(context).push('/outstation');
                                    break;
                                  case 2:
                                    GoRouter.of(context).push('/rental');
                                    break;
                                  case 3:
                                    GoRouter.of(context).push('/flights');
                                    break;
                                }
                              },
                              label: transportNames[index],
                              assetPath: serviceTypeAssetString[index]);
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 8.w),
                        itemCount: transportTypes.length,
                      ),
                    ),
                  ),

                  // Fare Info Card
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Up-to-date fares",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "We always show you the price fares so that you can get what you expect.",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Image.asset(
                            'assets/images/fare_illustration.png',
                            height: 80.h,
                            errorBuilder: (context, error, stackTrace) {
                              // Display a placeholder if image not found
                              return Container(
                                height: 80.h,
                                width: 80.w,
                                color: Colors.transparent,
                                child: Icon(Icons.person,
                                    size: 50.sp, color: Colors.orange),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Indicator dots for fare card
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [0, 1, 2].map((index) {
                        return Container(
                          width: 8.w,
                          height: 8.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0 ? Colors.black : Colors.grey[300],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Road Trips Section
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[800],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Road Trips Hits!",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            height: 120.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            // Image for road trip would go here
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Coorg - The Scotland of India",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Indicator dots for road trips
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 8.w,
                          height: 8.h,
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0 ? Colors.black : Colors.grey[300],
                          ),
                        );
                      }),
                    ),
                  ),

                  // Tagline
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    child: Text(
                      "Seamless transit, endless journeys, unforgettable memories.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportTypeItem(
      BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        height: 70.h,
        decoration: BoxDecoration(
          color: Colors.blueGrey[800],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
