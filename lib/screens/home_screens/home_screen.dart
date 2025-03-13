import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/bloc/location_bloc/location_bloc.dart';
import 'package:transit/bloc/location_bloc/location_state.dart';
import 'package:transit/core/data/other_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/screens/home_screens/maps_page.dart';
import 'package:transit/screens/your_location.dart';
import 'package:transit/widgets/custom_nav_bar/custom_nv_bar.dart';
import 'package:transit/widgets/custom_transport_type_box/transport_type.dart';
import 'package:transit/widgets/search_bar/search_bar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController placeNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBody: true,          resizeToAvoidBottomInset: false, // Prevents auto-resizing that may cause gaps

      bottomNavigationBar: AnimatedSwitcher(
      duration: Duration(milliseconds: 300), // ✅ Animation duration
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child:  SizedBox(
              key: ValueKey('bnb'), // ✅ Unique key for animation
              height: 80.h,
              child: CustomNavBar(
                // currentIndex: _selectedIndex,
                // onTap: _onItemTapped,
              ),
            )
          , // ✅ Animates disappearing
    ),
      backgroundColor: white,
      body: Center(
          child: Column(
        children: [
          Container(
              height: 146.h,
              padding: EdgeInsets.symmetric(vertical: 0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    bottomCardColor,
                    const Color.fromARGB(52, 177, 212, 224)
                  ])),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: CustomSearchBar(
                      controller: placeNameController,
                    ),
                  ),
                  // SizedBox(height: 0.h,)
                ],
              )),
              SizedBox(height: 75.h,
                child: ListView.separated(shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                  return TransportTypeBox(
                    
                    onTap: () {
                      switch(index){
                        case 0://cabs
                        GoRouter.of(context).push('/cabs');
                        break;
                         case 1://flights
                         GoRouter.of(context).push('/flights');
                        break;
                         case 2://trains
                        break;
                         case 3://busses
                        break;
                         case 4://stays
                        break;
                      }
                    },
                    label:transportNames[index], assetPath:serviceTypeAssetString[index]);
                }, separatorBuilder: (context, index) {
                  return SizedBox(width: 1.w,);
                }, itemCount: 5),
              ),
 BlocListener<LocationBloc,LocationState>(
              listener: (context, state) {
             },
              child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if(state.currentLocation!= null) {
          // Pass state.currentPosition as a parameter to MyLocation widget
                return Column(
          children: [
           Text( context.read<LocationBloc>().locationString + 'my add' + state.locationString.toString()),
            MyLocation(position: state.currentLocation!.latitude.toString() +state.currentLocation!.longitude.toString() ),
          ],
                );
                }else{
          return Text("Not tracking locatin");
                }
              },)),
          Text("Hello"),
        ],
      )),
    );
  }
}

// Scaffold(
//         backgroundColor: backgroundColor,
//         bottomNavigationBar: BottomNavigationBar(backgroundColor: customgrey,
//           onTap: (value) {
//             if(value==0){
//               context.push('/page3');
//               // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//               //   return const ListOfRidesPage();
//               // },));
//             }
//             if(value==1){
//               context.push('/profile');

//             }

//           },
//           items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.white,), label: '',

//           ),
//            BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.white,),label: '')

//         ]),
//         body:  SingleChildScrollView(
//           child: Column(children: [
//             const TopBar(),
//             const AdvertisAdvertisementWidget(),
//              CustomSearchBarMaps(
//               label: "Search your ride",
//               controller: placeNameController,
//             ),
//             // Hero(tag: 'map-search',
//             //   child: CustomSearchBar(label: "Where to ?",controller:   placeNameController
//             //   ,),
//             // ),
//             const Text("Save on every ride"),
//             const SaveonEveryRideWidget(),
//             BlocListener<LocationBloc,LocationState>(
//               listener: (context, state) {
//              },
//               child: BlocBuilder<LocationBloc, LocationState>(
//               builder: (context, state) {
//                 if(state.currentLocation!= null) {
//           // Pass state.currentPosition as a parameter to MyLocation widget
//                 return Column(
//           children: [
//            Text( context.read<LocationBloc>().locationString + 'my add' + state.locationString.toString()),
//             MyLocation(position: state.currentLocation!.latitude.toString() +state.currentLocation!.longitude.toString() ),
//           ],
//                 );
//                 }else{
//           return Text("Not tracking locatin");
//                 }
//               },))

//                  //   SaveonEveryRideWidget()

//           ],),
//         ),
//       ),
class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: customgrey),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                context.push('/page1');
              },
              child: CircleAvatar(
                // Adjust the radius to your desired size
                child: ClipOval(
                  child: SizedBox(
                    width: 80, // Adjust the width to control the zoom level
                    height: 80, // Adjust the height to control the zoom level
                    child: FittedBox(
                      fit: BoxFit
                          .cover, // Ensures the image covers the container
                      child: Image.asset('assets/images/transit_logo.jpeg'),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  context.push('/page2');
                },
                icon: const Icon(Icons.person))
          ],
        ),
      ),
    );
  }
}

class AdvertisAdvertisementWidget extends StatelessWidget {
  const AdvertisAdvertisementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: translucentBlack, borderRadius: BorderRadius.circular(12)),
        height: 200,
        child: const Center(
          child: Text("Advertisement placeholder"),
        ),
      ),
    );
  }
}

// class CustomSearchBar extends StatelessWidget {
//   const CustomSearchBar({super.key,required this.label, required this.controller, });
//  final String label;

//  final TextEditingController controller;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(padding: const EdgeInsets.all(2),width: double.infinity,
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: customgrey),
//         child: Center(
//           child: Card(color: transparent,elevation: 0,
//             child: GestureDetector(onTap: () {
//                      if(GoRouter.of(context).routerDelegate.currentConfiguration.fullPath == '/')
//               {                context.push('/maps-2');
//               }
//             },
//               child: TextField(
//                  style: const TextStyle(color: white), cursorColor: white,
//                 controller: controller,decoration: InputDecoration(iconColor: white,suffixIconColor: white,
//                    border: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                 hintText: label,    hintStyle: const TextStyle(color: white),         isCollapsed: true, // Removes default padding
//               // Optional: Set hint text color
//               contentPadding: const EdgeInsets.symmetric(vertical: 12), // Custom vertical padding

//               suffixIcon: const Icon(Icons.search),
//                ),
//                onTapAlwaysCalled: false,
//                onChanged: (value) {

//                },

//                 ),
//             ),
//           ),
//         ),),
//     );
//   }
// }

class SaveonEveryRideWidget extends StatelessWidget {
  const SaveonEveryRideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                width: 250,
                decoration: BoxDecoration(
                    color: translucentBlack,
                    borderRadius: BorderRadius.circular(12)),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 15,
              );
            },
            itemCount: 3),
      ),
    );
  }
}
