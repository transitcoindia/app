import 'package:equatable/equatable.dart';
import 'package:transit/models/cab_options_model.dart';

abstract class UberState extends Equatable {
  const UberState();
}

class UberInitial extends UberState {
  @override
  List<Object> get props => [];
}

class UberLoading extends UberState {
  @override
  List<Object> get props => [];
}

class UberLoaded extends UberState {
  final List<CabOption> options;
  const UberLoaded(this.options);

  @override
  List<Object> get props => [options];
}