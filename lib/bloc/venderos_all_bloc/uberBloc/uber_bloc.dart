import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/uberBloc/uber_event.dart';
import 'package:transit/bloc/venderos_all_bloc/uberBloc/uber_state.dart';
import 'package:transit/repository/vendors/uber_repo.dart';



class UberBloc extends Bloc<UberEvent, UberState> {
  final UberRepository uberRepository;

  UberBloc(this.uberRepository) : super(UberInitial()){
void getRides() {
    emit(state);
  }
  }

  
  Stream<UberState> mapEventToState(UberEvent event) async* {
    if (event is FetchUberOptions) {
      yield UberLoading();
      try {
        final options = await uberRepository.fetchRides(event.latitude, event.longitude);
        yield UberLoaded(options);
      } catch (e) {
        // Handle error
      }
    }
  }

  
}