import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/meruBloc/meru_event.dart';
import 'package:transit/bloc/venderos_all_bloc/meruBloc/meru_states.dart';
import 'package:transit/repository/vendors/meru_repo.dart';

class MeruBloc extends Bloc<MeruEvent, MeruState> {
  final MeruRepository rapidoRepository;

  MeruBloc(this.rapidoRepository) : super(MeruInitial());

  
  Stream<MeruState> mapEventToState(MeruEvent event) async* {
    if (event is FetchMeruOptions) {
      yield MeruLoading();
      try {
        final options = await rapidoRepository.fetchRides(event.latitude, event.longitude);
        yield MeruLoaded(options);
      } catch (e) {
        // Handle error
      }
    }
  }
}