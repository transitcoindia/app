import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

class LocationState extends Equatable {
  final bool permissionGranted;
  final LocationData? currentLocation;
  final String errorMessage;
  final String? locationString;

  const LocationState({
    required this.permissionGranted,
    this.currentLocation,
    this.errorMessage = '',
    this.locationString=''
  });

  LocationState copyWith({
    bool? permissionGranted,
    LocationData? currentLocation,
    String? errorMessage,  String? locationString,
  }) {
    return LocationState(
      permissionGranted: permissionGranted ?? this.permissionGranted,
      currentLocation: currentLocation ?? this.currentLocation,
      errorMessage: errorMessage ?? this.errorMessage,
      locationString: locationString ?? this.locationString
    );
  }

  @override
  List<Object?> get props => [permissionGranted, currentLocation, errorMessage];
}
