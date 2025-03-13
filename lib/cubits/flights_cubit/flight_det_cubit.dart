import 'package:flutter_bloc/flutter_bloc.dart';

enum FlightType { oneWay, roundTrip }

class FlightTypeCubit extends Cubit<FlightType> {
  FlightTypeCubit() : super(FlightType.oneWay);

  void selectOneWay() => emit(FlightType.oneWay);
  void selectRoundTrip() => emit(FlightType.roundTrip);
}
