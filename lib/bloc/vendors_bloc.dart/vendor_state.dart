import 'package:equatable/equatable.dart';
import 'package:transit/models/cab_options_model.dart';

abstract class VendorsState extends Equatable {
  const VendorsState();
}

class VendorsInitial extends VendorsState {
  @override
  List<Object> get props => [];
}

class VendorsLoading extends VendorsState {
  @override
  List<Object> get props => [];
}

class VendorsLoaded extends VendorsState {
  final List<CabOption> options;
  const VendorsLoaded(this.options);

  @override
  List<Object> get props => [options];
}
