import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/location_bloc/location_bloc.dart';
import 'package:transit/bloc/location_bloc/location_event.dart';
import 'package:transit/bloc/location_bloc/location_state.dart';
import 'package:transit/bloc/maps_bloc/maps_bloc.dart';
import 'package:transit/bloc/maps_bloc/maps_event.dart';
import 'package:transit/bloc/maps_bloc/maps_state.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;


  @override
  void initState() {
    if(context.read<LocationBloc>().state.currentLocation==null 
    )
      context.read<LocationBloc>().add(RequestLocationPermission());

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.currentLocation == null) {

            context.read<LocationBloc>().add(RequestLocationPermission());
                        context.read<LocationBloc>().add(StartLocationTracking());

            return const Center(child: CircularProgressIndicator());
          }
          
          final LatLng userLocation = LatLng(
            locationState.currentLocation!.latitude!,
            locationState.currentLocation!.longitude!,
          );
          
          return BlocBuilder<MapBloc,MapState>(builder: (context, state) {

            Set<Marker> markers = {};
            if(state.markers.isNotEmpty)
           { markers.addAll(state.markers );}
           print("PRINTING POLYINESSSSS");
           print(state.polylines);
 if (state.polylines.isNotEmpty) {
  // Assuming you have userLocation (start) and destination as LatLng objects
    if(state.customSource!=null) {
      LatLng userLocation = state.customSource
      !;
    }
  LatLng destination = context.read<MapBloc>().destination!; // Assuming you have the destination in state

  // Ensure that the southwest has the smallest latitude and longitude,
  // and the northeast has the largest latitude and longitude.
  LatLngBounds bounds = LatLngBounds(
    southwest: LatLng(
      userLocation.latitude < destination.latitude ? userLocation.latitude : destination.latitude,
      userLocation.longitude < destination.longitude ? userLocation.longitude : destination.longitude,
    ),
    northeast: LatLng(
      userLocation.latitude > destination.latitude ? userLocation.latitude : destination.latitude,
      userLocation.longitude > destination.longitude ? userLocation.longitude : destination.longitude,
    ),
  );
  markers.addAll({Marker(markerId: const MarkerId('l'), 
               position: context.read<MapBloc>().destination!, // The destination LatLng
      infoWindow: const InfoWindow(title: 'Destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),)});
  // Animate the camera to fit the bounds
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)); // 50 is padding
  });
}
log("UPDATING POLYLINESSSSSS");
log(state.polylines.toString());
// log(state.polylines.first.toString());

            return  GoogleMap(
              zoomControlsEnabled: true,
              compassEnabled: true,///minMaxZoomPreference: MinMaxZoomPreference(1.0, 2.0),
              markers: markers,zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: userLocation,
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                 context.read<MapBloc>().add(OnMapCreated(controller,locationState.currentLocation!.latitude! ,
              locationState.currentLocation!.longitude!,
                    ));
                _mapController = controller;
                _mapController!.animateCamera(
                  CameraUpdate.newLatLng(userLocation),
                );
              },polylines: state.polylines,

            );
            
          },
         
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
