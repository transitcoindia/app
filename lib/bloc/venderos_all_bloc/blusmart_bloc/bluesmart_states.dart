import 'package:equatable/equatable.dart';
import 'package:transit/models/cab_options_model.dart';

abstract class BlusmartState extends Equatable {
  const BlusmartState();
}

class BlusmartInitial extends BlusmartState {
  @override
  List<Object> get props => [];
}

class BlusmartLoading extends BlusmartState {
  @override
  List<Object> get props => [];
}

class BlusmartLoaded extends BlusmartState {
  final List<CabOption> options;
  const BlusmartLoaded(this.options);

  @override
  List<Object> get props => [options];
}