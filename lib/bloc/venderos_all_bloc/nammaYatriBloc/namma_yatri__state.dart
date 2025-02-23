import 'package:equatable/equatable.dart';

abstract class NammaYatriEvent extends Equatable {
  const NammaYatriEvent();
}

class FetchNammaYatriOptions extends NammaYatriEvent {
  final double latitude;
  final double longitude;

  const FetchNammaYatriOptions(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}