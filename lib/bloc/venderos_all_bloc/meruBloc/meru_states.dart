import 'package:equatable/equatable.dart';

abstract class MeruEvent extends Equatable {
  const MeruEvent();
}

class FetchMeruOptions extends MeruEvent {
  final double latitude;
  final double longitude;

  const FetchMeruOptions(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}