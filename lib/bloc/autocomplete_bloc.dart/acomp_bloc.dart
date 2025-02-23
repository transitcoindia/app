import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/autocomplete_bloc.dart/acomp_event.dart';
import 'package:transit/bloc/autocomplete_bloc.dart/acompstate.dart';
import 'package:transit/repository/places_repo.dart';

enum Pos{source,destination}
class AutocompleteBloc extends Bloc<AutocompleteEvent, AutocompleteState> {
  final AutoCompleteService auto;

  AutocompleteBloc(this.auto) : super(AutocompleteInitial()) {
    on<FetchSuggestions>(_onFetchSuggestions);
    on<CompletedSuggestion>((event, emit)async {
      Future.delayed(Duration(seconds: 1));
      emit(Completed());
    },);
  }

  Future<void> _onFetchSuggestions(
    FetchSuggestions event,
    Emitter<AutocompleteState> emit,
  ) async {
    try {
      if(event.pos== Pos.source){
            emit(AutocompleteLoading(Pos.source));
      final predictions = await auto.fetchAutoComplete(inp: event.input);

        emit(AutocompleteLoadedSource(predictions));
      }else{
                    emit(AutocompleteLoading(Pos.destination));
      final predictions = await auto.fetchAutoComplete(inp: event.input);
      emit(AutocompleteLoadedDestination(predictions,));}
    } catch (e) {
      emit(AutocompleteError(e.toString()));
    }
  }
}
