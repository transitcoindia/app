import 'package:equatable/equatable.dart';
import 'package:transit/models/cab_options_model.dart';

abstract class MeruState extends Equatable {
  const MeruState();
}

class MeruInitial extends MeruState {
  @override
  List<Object> get props => [];
}

class MeruLoading extends MeruState {
  @override
  List<Object> get props => [];
}

class MeruLoaded extends MeruState {
  final List<CabOption> options;
  const MeruLoaded(this.options);

  @override
  List<Object> get props => [options];
}