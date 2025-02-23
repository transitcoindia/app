import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/InDriveBloc/indrive_events.dart';
import 'package:transit/bloc/venderos_all_bloc/InDriveBloc/indrive_state.dart';
import 'package:transit/repository/vendors/indrive_repo.dart';

class IndriverBloc extends Bloc<IndriverEvent, IndriverState> {
  final IndriveRepository rapidoRepository;

  IndriverBloc(this.rapidoRepository) : super(IndriverInitial());

  Stream<IndriverState> mapEventToState(IndriverEvent event) async* {
    if (event is FetchIndriverOptions) {
      yield IndriverLoading();
      try {
        final options = await rapidoRepository.fetchRides(event.latitude, event.longitude);
        yield IndriverLoaded(options);
      } catch (e) {
        // Handle error
      }
    }
  }
}