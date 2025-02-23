import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/location_bloc/location_bloc.dart';
import 'package:transit/bloc/location_bloc/location_state.dart';
import 'package:transit/bloc/maps_bloc/maps_bloc.dart';
import 'package:transit/bloc/ride_bloc/ride_bloc.dart';
import 'package:transit/bloc/vendors_bloc.dart/vendor_bloc.dart';
import 'package:transit/bloc/vendors_bloc.dart/vendor_event.dart';
import 'package:transit/bloc/vendors_bloc.dart/vendor_state.dart';
import 'package:transit/core/static_test_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/screens/map/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RidePage extends StatelessWidget {
  const RidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  context.push('/home');
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(85, 158, 158, 158),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: MapScreen(),
                  ),
                ),
              ),
              const FromToWidget(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Recommended for you "),
              ),
              BlocBuilder<VendorsBloc, VendorsState>(
                builder: (context, state) {
                  if (state is VendorsLoaded) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 5);
                          },
                          itemCount: state.options.length,
                          itemBuilder: (context, index) {
                            return BlocProvider(
                              create: (context) => RideBloc(),
                              child: RideOptionTile(
                                provider: state.options[index].provider.toString(),
                                eta: state.options[index].eta,
                                price: state.options[index].price,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 10,
                      child: const SizedBox.shrink(),
                    );
                  }
                },
              ),
              const TypesOfVehiclesList(),
              const ViewYourRideButton(label: "View your ride"),
            ],
          ),
        ),
      ),
    );
  }
}


class FromToWidget extends StatelessWidget {
  const FromToWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: translucentBlack, borderRadius: BorderRadius.circular(12)),
        child: BlocBuilder<LocationBloc,LocationState>(
          builder: (context, state) {

            return  Column(
          children: [
            Row(children: [const Icon(Icons.man),const SizedBox(width: 10,), Text(state.locationString!)],),
            const Divider(),
                    Row(children: [const Icon(Icons.circle),const SizedBox(width: 10,), Flexible(child: Text(context.read<MapBloc>().destinationString!))],)
                
          ],
                );
          },
          
        ),),
    );
  }
}

class TypesOfVehiclesList extends StatelessWidget {
  const TypesOfVehiclesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: translucentBlack, borderRadius: BorderRadius.circular(12)),child:
        Row(children: [
          const Icon(Icons.car_crash),
          const SizedBox(width: 10,),
          Text(typesOfCabs[index])
        ],),);
      }, separatorBuilder: (context, index) {
        return const SizedBox(height: 10,);
      }, itemCount: typesOfCabs.length),
    );
  }
}

class ViewYourRideButton extends StatelessWidget {
  const ViewYourRideButton({super.key, required this.label});
 final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: customgrey),
        child: Center(child: Text(label)),),
    );
  }
}
class RideOptionTile extends StatelessWidget {
  final String provider;
  final int eta;
  final double price;

  const RideOptionTile({
    super.key,
    required this.provider,
    required this.eta,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideBloc, RideState>(
      builder: (context, state) {
        final rideBloc = BlocProvider.of<RideBloc>(context);
        final bool isExpanded = state is RideExpandedState;

        return InkWell(
          onTap: () {
            rideBloc.add(ToggleRideExpansionEvent());
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: translucentBlack,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(provider),
                    Text('${eta} mins'),
                    Text('₹${price}'),
                    ElevatedButton(
                      onPressed: () {
                        rideBloc.add(OTPConfirmedEvent());
                        context.go('/rideInitiated');
                      },
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 8),
                  const Text('Distance: 21 km'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
