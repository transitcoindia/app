import 'package:equatable/equatable.dart';

abstract class BlusmartEvent extends Equatable {
  const BlusmartEvent();
}

class FetchBlusmartOptions extends BlusmartEvent {
  final double latitude;
  final double longitude;

  const FetchBlusmartOptions(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}