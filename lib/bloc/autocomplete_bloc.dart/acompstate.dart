import 'package:transit/bloc/autocomplete_bloc.dart/acomp_bloc.dart';
import 'package:transit/models/autocomplete_model.dart';

abstract class AutocompleteState {}

class AutocompleteInitial extends AutocompleteState {}

class AutocompleteLoading extends AutocompleteState {
  final Pos pos;
  AutocompleteLoading(this.pos);
}

class AutocompleteLoadedSource extends AutocompleteState {
  final List<AutocompletePrediction> predictions;
  AutocompleteLoadedSource(this.predictions);
}
class AutocompleteLoadedDestination extends AutocompleteState {
  final List<AutocompletePrediction> predictions;
  AutocompleteLoadedDestination(this.predictions, );
}
class AutocompleteError extends AutocompleteState {
  final String message;
  AutocompleteError(this.message);
}

class Completed extends AutocompleteState {}
