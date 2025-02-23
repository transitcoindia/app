import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/nammaYatriBloc/namma_yatri__state.dart';
import 'package:transit/bloc/venderos_all_bloc/nammaYatriBloc/namma_yatri_event.dart';
import 'package:transit/repository/vendors/namma_yatri_repo.dart';

class NammaYatriBloc extends Bloc<NammaYatriEvent, NammaYatriState> {
  final NammaYatriRepository nammYatriRepo;

  NammaYatriBloc(this.nammYatriRepo) : super(NammaYatriInitial());

  
  Stream<NammaYatriState> mapEventToState(NammaYatriEvent event) async* {
    if (event is FetchNammaYatriOptions) {
      yield NammaYatriLoading();
      try {
        final options = await nammYatriRepo.fetchRides(event.latitude, event.longitude);
        yield NammaYatriLoaded(options);
      } catch (e) {
        // Handle error
      }
    }
  }
}