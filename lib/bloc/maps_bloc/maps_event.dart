import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OnMapCreated extends MapEvent {
  final GoogleMapController controller;
  final double latitude;
  final double longitude;
  OnMapCreated(this.controller, this.latitude, this.longitude);
}

class SearchLocation extends MapEvent {
  final String query;

  SearchLocation(this.query);
}
class ChangeSource extends MapEvent {
  final String? query;
  final String? placeId;

  ChangeSource({this.query, this.placeId});
}



class FindRoute extends MapEvent {
  final String destination;
  final String description;



  FindRoute(this.destination, this.description );
}
