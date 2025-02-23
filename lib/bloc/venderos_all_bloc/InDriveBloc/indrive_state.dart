import 'package:equatable/equatable.dart';
import 'package:transit/models/cab_options_model.dart';

abstract class IndriverState extends Equatable {
  const IndriverState();
}

class IndriverInitial extends IndriverState {
  @override
  List<Object> get props => [];
}

class IndriverLoading extends IndriverState {
  @override
  List<Object> get props => [];
}

class IndriverLoaded extends IndriverState {
  final List<CabOption> options;
  const IndriverLoaded(this.options);

  @override
  List<Object> get props => [options];
}