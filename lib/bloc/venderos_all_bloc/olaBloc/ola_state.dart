import 'package:equatable/equatable.dart';
import 'package:transit/models/cab_options_model.dart';

abstract class OlaState extends Equatable {
  const OlaState();
}

class OlaInitial extends OlaState {
  @override
  List<Object> get props => [];
}

class OlaLoading extends OlaState {
  @override
  List<Object> get props => [];
}

class OlaLoaded extends OlaState {
  final List<CabOption> options;
  const OlaLoaded(this.options);

  @override
  List<Object> get props => [options];
}