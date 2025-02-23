import 'package:transit/bloc/autocomplete_bloc.dart/acomp_bloc.dart';

abstract class AutocompleteEvent {}

class FetchSuggestions extends AutocompleteEvent {
  final String input;
  final Pos pos;
  FetchSuggestions(this.input, this.pos);
}

class CompletedSuggestion extends AutocompleteEvent {
}