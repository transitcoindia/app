import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/flights_bloc/flight_bloc.dart';

import 'package:transit/models/flight_models.dart';
import 'package:transit/repository/flight_repo.dart';

class FlightResultsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => FlightSearchBloc(FlightRepository()),

      child: BlocBuilder<FlightSearchBloc, FlightSearchState>(
        builder: (context, state) {
          if (state is FlightSearchLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FlightSearchSuccess) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.flights.length,
              itemBuilder: (context, index) {
                final FlightModel flight = state.flights[index];
                return ListTile(
                  title: Text("${flight.airline} - ${flight.flightNumber}"),
                  subtitle: Text("${flight.departureTime} → ${flight.arrivalTime}"),
                  trailing: Text("\$${flight.price}"),
                );
              },
            );
          } else if (state is FlightSearchFailure) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return SizedBox.shrink(); // Default state
        },
      ),
    );
  }
}
