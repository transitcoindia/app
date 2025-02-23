import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/blusmart_bloc/bluesmart_events.dart';
import 'package:transit/bloc/venderos_all_bloc/blusmart_bloc/bluesmart_states.dart';
import 'package:transit/repository/vendors/blusmart_repo.dart';

class BlusmartBloc extends Bloc<BlusmartEvent, BlusmartState> {
  final BlusmartRepo rapidoRepository;

  BlusmartBloc(this.rapidoRepository) : super(BlusmartInitial());

  Stream<BlusmartState> mapEventToState(BlusmartEvent event) async* {
    if (event is FetchBlusmartOptions) {
      yield BlusmartLoading();
      try {
        final options = await rapidoRepository.fetchRides(event.latitude, event.longitude);
        yield BlusmartLoaded(options);
      } catch (e) {
        // Handle error
      }
    }
  }
}