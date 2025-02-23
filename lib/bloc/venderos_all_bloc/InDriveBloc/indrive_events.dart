import 'package:equatable/equatable.dart';

abstract class IndriverEvent extends Equatable {
  const IndriverEvent();
}

class FetchIndriverOptions extends IndriverEvent {
  final double latitude;
  final double longitude;

  const FetchIndriverOptions(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}