import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/rapido_bloc/rapido_events.dart';
import 'package:transit/bloc/venderos_all_bloc/rapido_bloc/rapido_states.dart';
import 'package:transit/repository/vendors/rapido_repository.dart';

class RapidoBloc extends Bloc<RapidoEvent, RapidoState> {
  final RapidoRepository rapidoRepository;

  RapidoBloc(this.rapidoRepository) : super(RapidoInitial());

  
  Stream<RapidoState> mapEventToState(RapidoEvent event) async* {
    if (event is FetchRapidoOptions) {
      yield RapidoLoading();
      try {
        final options = await rapidoRepository.fetchRides(event.latitude, event.longitude);
        yield RapidoLoaded(options);
      } catch (e) {
        // Handle error
      }
    }
  }
}