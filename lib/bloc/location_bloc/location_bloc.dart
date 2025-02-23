import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';
import 'location_event.dart';
import 'location_state.dart';
import 'package:geocoding/geocoding.dart' hide Location;
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<LocationData>? _locationSubscription;
  final _locationService = Location();
  late LocationData _location;
   String locationString  = '';
  LocationBloc() : super(const LocationState(permissionGranted: false)) {
    on<RequestLocationPermission>(_onRequestLocationPermission);
    on<StartLocationTracking>(_onStartLocationTracking);
    on<StopLocationTracking>(_onStopLocationTracking);
  }

  Future<void> _onRequestLocationPermission(
      RequestLocationPermission event, Emitter<LocationState> emit) async {
    final status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      emit(state.copyWith(permissionGranted: true, errorMessage: ''));
      add(StartLocationTracking());
    } else {
      emit(state.copyWith(permissionGranted: false, errorMessage: 'Permission denied.'));
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

Future<void> _onStartLocationTracking(
    StartLocationTracking event, Emitter<LocationState> emit) async {
  if (state.permissionGranted) {
    try {
      debugPrint("Checking location service status...");
      if (!(await _locationService.serviceEnabled())) {
        debugPrint("Service not enabled, requesting service...");
        if (!(await _locationService.requestService())) {
          debugPrint("Failed to enable location service");
          emit(state.copyWith(errorMessage: "Location service not enabled"));
          return;
        }
      }

      debugPrint("Starting location updates...");
      // Cancel any existing subscription to avoid duplicates
      await _locationSubscription?.cancel();

      // Keep a local completer to manage event lifecycle
      final Completer<void> completer = Completer<void>();

      _locationSubscription = _locationService.onLocationChanged.listen(
        (LocationData locationData) async {
          debugPrint("Location stream update: $locationData");
          final address = await _getAddress(locationData.latitude!, locationData.longitude!);
    print(locationData);
    print(address);
    emit(state.copyWith(
      currentLocation: locationData,
      locationString: address,
      errorMessage: '',
    ));
        },
        onDone: () {
          debugPrint("Location stream completed.");
          if (!completer.isCompleted) completer.complete();
        },
        onError: (error) {
          debugPrint("Error in location stream: $error");
          emit(state.copyWith(errorMessage: error.toString()));
          if (!completer.isCompleted) completer.complete();
        },
      );

      // Await the completer to ensure the event handler remains active
      await completer.future;

    } catch (e) {
      debugPrint("Error in _onStartLocationTracking: $e");
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
              locationString = await _getAddress(_location.latitude!, _location.longitude!);
// locationString = await _getAddress(_location.latitude!, _location.longitude!);
debugPrint("holdinggggggg");
debugPrint(locationString);
emit(state.copyWith(locationString: locationString));
}


  Future<String> _getAddress(double latitude, double longitude) async {
    try {
      debugPrint("Calling address fetch");
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
       print(place.toString());
        return "${place.name}  ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
     
      }
      else{
        return "Unable to fetch address";
      }
    } catch (e) {
      print(e);
       return"Unable to get address";
    }
  }

  Future<void> _onStopLocationTracking(
      StopLocationTracking event, Emitter<LocationState> emit) async {
    debugPrint("Stopping location updates...");
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    debugPrint("Location updates stopped.");
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
