import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:transit/bloc/maps_bloc/maps_event.dart';
import 'package:transit/bloc/maps_bloc/maps_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  GoogleMapController? _mapController;
  double? latitude; 
    double? longitude; 
   LatLng? destination;
   String? destinationString;

  final Dio _dio = Dio();
  final String _apiKey = 'AIzaSyBkMWyYFXHFAZHunyeb07KahLaAbPPesOc';

  MapBloc() : super(const MapState()) {
    on<OnMapCreated>((event, emit) {
      _mapController = event.controller;
      latitude = event.latitude;
      longitude = event.longitude;

    });
on<ChangeSource>((event, emit) async {
  LatLng? position;

  try {
    if (event.placeId != null) {
      // Fetch coordinates using place_id
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': event.placeId,
          'key': _apiKey,
        },
      );

      final location = response.data['result']['geometry']['location'];
      latitude = location['lat'];
      longitude = location['lng'];
      position = LatLng(latitude!, longitude!);
    } else if (event.query != null) {
      // Fallback to query search
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/textsearch/json',
        queryParameters: {
          'query': event.query,
          'key': _apiKey,
        },
      );

      final results = response.data['results'] as List;
      if (results.isNotEmpty) {
        final location = results[0]['geometry']['location'];
        latitude = location['lat'];
        longitude = location['lng'];
        position = LatLng(latitude!, longitude!);
      }
    }

    if (position != null) {
      // Add marker for the new source
      final sourceMarker = Marker(
        markerId: MarkerId(event.placeId ?? event.query ?? 'Source'),
        position: position,
      );

      emit(state.copyWith(
        markers: Set.from(state.markers)..add(sourceMarker),
      ));

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(position, 14),
      );

      // If a destination is selected, draw the route
      if (destination != null) {
        final response = await _dio.get(
          'https://maps.googleapis.com/maps/api/directions/json',
          queryParameters: {
            'origin': '${position.latitude},${position.longitude}',
            'destination': '${destination!.latitude},${destination!.longitude}',
            'key': _apiKey,
          },
        );

        final routes = response.data['routes'];
        if (routes.isNotEmpty) {
          final polylinePoints = routes[0]['overview_polyline']['points'];
          final points = _decodePolyline(polylinePoints);

          final polyline = Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
          );

          emit(state.copyWith(
            polylines: Set.from(state.polylines)..clear()..add(polyline),
          ));
        }
      } else {
        // Clear polylines if no destination is set
        emit(state.copyWith(polylines: Set<Polyline>()));
      }
    }
  } catch (e) {
    print("Error in ChangeSource: $e");
  }
});




  // maps_bloc.dart
on<FindRoute>((event, emit) async {
  print("HELPPPPPPPPPP");
   destination = await  _getLatLong(event.destination);
   destinationString = event.description;
   print(destination!.toJson());   print(destination.runtimeType);
  final String url = 'https://routes.googleapis.com/directions/v2:computeRoutes';

  final Map<String, dynamic> requestBody = {
    "origin": {
      "location": {
        "latLng": {
          "latitude": latitude,
          "longitude": longitude
        }
      }
    },
    "destination": {
      "location": {
        "latLng": {
          "latitude": destination!.latitude,
          "longitude": destination!.longitude
        }
      }
    },
    "travelMode": "DRIVE",
    "routingPreference": "TRAFFIC_AWARE",
    "computeAlternativeRoutes": false,
    "routeModifiers": {
      "avoidTolls": false,
      "avoidHighways": false,
      "avoidFerries": false
    },
    "languageCode": "en-US",
    "units": "IMPERIAL"
  };
   final response = await _dio.post(
      url,
      data: requestBody,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _apiKey,
          'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
        },
      ),
    );
     

         List<LatLng> points=[];
         final routes = response.data['routes'];
       
        //   final routes = response.data['routes'];
        //  log('Routes are ${routes.toString()}');

  if (response.data != null && response.data['routes'] != null && response.data['routes'].isNotEmpty) {
      final polylinePoints = response.data['routes'][0]["polyline"]["encodedPolyline"];
      if (polylinePoints != null) {
         List<LatLng> points = _decodePolyline(polylinePoints);
      } else {
      }
    } else {

    }
  final polyline = Polyline(
    polylineId: const PolylineId('route'),
    points: points,
    color: Colors.blue,
    width: 5,
  );
  Set.from(state.polylines).clear();
  emit(state.copyWith(
    polylines: Set.from(state.polylines)..add(polyline)
  ));
  print("EMITING STATE WITH ${Set.from(state.polylines)..add(polyline)}");
});}

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}

Future<LatLng?> _getLatLong( String pid)async {
   final response = await Dio().get(
    'https://maps.googleapis.com/maps/api/place/details/json',
    queryParameters: {
      'place_id': pid,
      'key': 'AIzaSyBkMWyYFXHFAZHunyeb07KahLaAbPPesOc',
    },
  );


  final location = response.data['result']['geometry']['location'];

  final destination = LatLng(location['lat'], location['lng']);
  return destination;
}
