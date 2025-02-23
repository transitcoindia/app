import 'package:equatable/equatable.dart';
import 'package:transit/models/cab_options_model.dart';

abstract class NammaYatriState extends Equatable {
  const NammaYatriState();
}

class NammaYatriInitial extends NammaYatriState {
  @override
  List<Object> get props => [];
}

class NammaYatriLoading extends NammaYatriState {
  @override
  List<Object> get props => [];
}

class NammaYatriLoaded extends NammaYatriState {
  final List<CabOption> options;
  const NammaYatriLoaded(this.options);

  @override
  List<Object> get props => [options];
}