import 'package:equatable/equatable.dart';

abstract class RapidoEvent extends Equatable {
  const RapidoEvent();
}

class FetchRapidoOptions extends RapidoEvent {
  final double latitude;
  final double longitude;

  const FetchRapidoOptions(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}