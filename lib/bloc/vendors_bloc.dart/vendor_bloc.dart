import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/InDriveBloc/indrive_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/InDriveBloc/indrive_state.dart';
import 'package:transit/bloc/venderos_all_bloc/blusmart_bloc/bluesmart_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/blusmart_bloc/bluesmart_states.dart';
import 'package:transit/bloc/venderos_all_bloc/meruBloc/meru_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/meruBloc/meru_event.dart';
import 'package:transit/bloc/venderos_all_bloc/nammaYatriBloc/namma_yatri_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/nammaYatriBloc/namma_yatri_event.dart';
import 'package:transit/bloc/venderos_all_bloc/olaBloc/ola_state.dart';
import 'package:transit/bloc/venderos_all_bloc/rapido_bloc/rapido_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/olaBloc/ola_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/rapido_bloc/rapido_states.dart';
import 'package:transit/bloc/venderos_all_bloc/uberBloc/uber_bloc.dart';
import 'package:transit/bloc/venderos_all_bloc/uberBloc/uber_state.dart';
import 'package:transit/bloc/vendors_bloc.dart/vendor_event.dart';
import 'package:transit/bloc/vendors_bloc.dart/vendor_state.dart';
import 'package:transit/models/cab_options_model.dart';

class VendorsBloc extends Bloc<VendorsEvent, VendorsState> {
  final UberBloc uberBloc;
  final OlaBloc olaBloc;
  final RapidoBloc rapidoBloc;
  final IndriverBloc inDriverBloc;
  final MeruBloc meruBloc;
  final NammaYatriBloc nammaYatriBloc;
  final BlusmartBloc blusmartBloc;

  VendorsBloc(
    this.uberBloc,
    this.olaBloc,
    this.rapidoBloc,
    this.inDriverBloc,
    this.meruBloc,
    this.nammaYatriBloc,
    this.blusmartBloc,
  ) : super(VendorsInitial()) {
    int selectedIndex = -1;
    on<SelectRide>((event, emit) {
      selectedIndex = event.index;
    });

    on<FetchVendorOptions>(_onFetchVendorOptions);

    // Listen for updates from all the BLoCs
    uberBloc.stream.listen((state) => _aggregateOptions());
    olaBloc.stream.listen((state) => _aggregateOptions());
    rapidoBloc.stream.listen((state) => _aggregateOptions());
    inDriverBloc.stream.listen((state) => _aggregateOptions());
    meruBloc.stream.listen((state) => _aggregateOptions());
    nammaYatriBloc.stream.listen((state) => _aggregateOptions());
    blusmartBloc.stream.listen((state) => _aggregateOptions());
  }

  /// Handles fetching of vendor options with a delay
  Future<void> _onFetchVendorOptions(
    FetchVendorOptions event,
    Emitter<VendorsState> emit,
  ) async {
    emit(VendorsLoading());

    // Collect all available options from different BLoCs
    await _aggregateOptions();

    List<CabOption> options = [];

    if (uberBloc.state is UberLoaded) {
      options.addAll((uberBloc.state as UberLoaded).options);
    }
    if (olaBloc.state is OlaLoaded) {
      options.addAll((olaBloc.state as OlaLoaded).options);
    }
    if (rapidoBloc.state is RapidoLoaded) {
      options.addAll((rapidoBloc.state as RapidoLoaded).options);
    }
    if (inDriverBloc.state is IndriverLoaded) {
      options.addAll((inDriverBloc.state as IndriverLoaded).options);
    }
    if (meruBloc.state is MeruLoaded) {
      options.addAll((meruBloc.state as MeruLoaded).options);
    }
    if (nammaYatriBloc.state is NammaYatriLoaded) {
      options.addAll((nammaYatriBloc.state as NammaYatriLoaded).options);
    }
    if (blusmartBloc.state is BlusmartLoaded) {
      options.addAll((blusmartBloc.state as BlusmartLoaded).options);
    }

    // Dummy data for testing
    options.addAll([
      CabOption(provider: 'Uber', name: 'Richard', price: 69.0, eta: 2),
      CabOption(provider: 'Ola', name: 'Richard', price: 420.0, eta: 1),
      CabOption(provider: 'Rapido', name: 'Richard', price: 64.92, eta: 2),
    ]);

    if (options.isNotEmpty) {
      await Future.delayed(Duration(seconds: 2)); // Delay before emitting the state
      emit(VendorsLoaded(options));
    } else {
      emit(VendorsInitial()); // Or another appropriate state for empty options
    }
  }

  /// Aggregates options with a delay
  Future<void> _aggregateOptions() async {
    List<CabOption> options = [];

    if (uberBloc.state is UberLoaded) {
      options.addAll((uberBloc.state as UberLoaded).options);
    }
    if (olaBloc.state is OlaLoaded) {
      options.addAll((olaBloc.state as OlaLoaded).options);
    }
    if (rapidoBloc.state is RapidoLoaded) {
      options.addAll((rapidoBloc.state as RapidoLoaded).options);
    }
    if (inDriverBloc.state is IndriverLoaded) {
      options.addAll((inDriverBloc.state as IndriverLoaded).options);
    }
    if (meruBloc.state is MeruLoaded) {
      options.addAll((meruBloc.state as MeruLoaded).options);
    }
    if (nammaYatriBloc.state is NammaYatriLoaded) {
      options.addAll((nammaYatriBloc.state as NammaYatriLoaded).options);
    }
    if (blusmartBloc.state is BlusmartLoaded) {
      options.addAll((blusmartBloc.state as BlusmartLoaded).options);
    }

    // Dummy data for testing
    options.addAll([
      CabOption(provider: 'Uber', name: 'Richard', price: 69.0, eta: 2),
      CabOption(provider: 'Ola', name: 'Richard', price: 420.0, eta: 1),
      CabOption(provider: 'Rapido', name: 'Richard', price: 64.92, eta: 2),
    ]);

    if (options.isNotEmpty) {
      await Future.delayed(Duration(seconds: 2)); // Delay before emitting the state
      emit(VendorsLoaded(options));
    }
  }
}
