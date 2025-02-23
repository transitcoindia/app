import 'package:equatable/equatable.dart';

abstract class UberEvent extends Equatable {
  const UberEvent();
}

class FetchUberOptions extends UberEvent {
  final double latitude;
  final double longitude;

  const FetchUberOptions(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}