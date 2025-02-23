import 'package:equatable/equatable.dart';
import 'package:transit/models/cab_options_model.dart';

abstract class RapidoState extends Equatable {
  const RapidoState();
}

class RapidoInitial extends RapidoState {
  @override
  List<Object> get props => [];
}

class RapidoLoading extends RapidoState {
  @override
  List<Object> get props => [];
}

class RapidoLoaded extends RapidoState {
  final List<CabOption> options;
  const RapidoLoaded(this.options);

  @override
  List<Object> get props => [options];
}