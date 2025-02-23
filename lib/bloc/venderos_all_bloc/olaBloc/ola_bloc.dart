import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/olaBloc/ola_event.dart';
import 'package:transit/bloc/venderos_all_bloc/olaBloc/ola_state.dart';

import 'package:transit/repository/vendors/ola_repository.dart';

class OlaBloc extends Bloc<OlaEvent, OlaState> {
  final OlaRepository olaRepository;

  OlaBloc(this.olaRepository) : super(OlaInitial());

  
  Stream<OlaState> mapEventToState(OlaEvent event) async* {
    if (event is FetchOlaOptions) {
      yield OlaLoading();
      try {
        final options = await olaRepository.fetchRides(event.latitude, event.longitude);
        yield OlaLoaded(options);
      } catch (e) {
        // Handle error
      }
    }
  }
}