import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:transit/models/flight_models.dart';
import 'package:transit/repository/flight_repo.dart';

// Events
abstract class FlightSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchFlights extends FlightSearchEvent {
  final String from;
  final String to;
  final String departureDate;
  final String? returnDate;
  final int passengers;

  FetchFlights({
    required this.from,
    required this.to,
    required this.departureDate,
    this.returnDate,
    required this.passengers,
  });

  @override
  List<Object> get props => [from, to, departureDate, returnDate ?? '', passengers];
}

// States
abstract class FlightSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class FlightSearchInitial extends FlightSearchState {}

class FlightSearchLoading extends FlightSearchState {}

class FlightSearchSuccess extends FlightSearchState {
  final List<FlightModel> flights;
  FlightSearchSuccess(this.flights);

  @override
  List<Object> get props => [flights];
}

class FlightSearchFailure extends FlightSearchState {
  final String error;
  FlightSearchFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Bloc
class FlightSearchBloc extends Bloc<FlightSearchEvent, FlightSearchState> {
  final FlightRepository repository;

  FlightSearchBloc(this.repository) : super(FlightSearchInitial()) {
    on<FetchFlights>((event, emit) async {
      emit(FlightSearchLoading());

      try {
        final flights = await repository.getFlights(
          from: event.from,
          to: event.to,
          departureDate: event.departureDate,
          returnDate: event.returnDate,
          passengers: event.passengers,
        );
        emit(FlightSearchSuccess(flights));
      } catch (e) {
        emit(FlightSearchFailure(e.toString()));
      }
    });
  }
}
