import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState extends Equatable {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final LatLng? customSource;
  const MapState({
    this.markers = const <Marker>{},
    this.polylines = const <Polyline>{},
    this.customSource
  });

  MapState copyWith({
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    LatLng? customSource
  }) {
    return MapState(
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      customSource: customSource 
    );
  }

  @override
  List<Object> get props => [markers, polylines];
}
