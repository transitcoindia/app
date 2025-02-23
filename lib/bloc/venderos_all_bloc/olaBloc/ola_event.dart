import 'package:equatable/equatable.dart';

abstract class OlaEvent extends Equatable {
  const OlaEvent();
}

class FetchOlaOptions extends OlaEvent {
  final double latitude;
  final double longitude;

  const FetchOlaOptions(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}