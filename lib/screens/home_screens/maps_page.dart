import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit/bloc/autocomplete_bloc.dart/acomp_bloc.dart';
import 'package:transit/bloc/autocomplete_bloc.dart/acomp_event.dart';
import 'package:transit/bloc/autocomplete_bloc.dart/acompstate.dart';
import 'package:transit/bloc/location_bloc/location_bloc.dart';
import 'package:transit/bloc/location_bloc/location_state.dart';
import 'package:transit/bloc/maps_bloc/maps_bloc.dart';
import 'package:transit/bloc/maps_bloc/maps_event.dart';
import 'package:transit/bloc/maps_bloc/maps_state.dart';
import 'package:transit/bloc/vendors_bloc.dart/vendor_bloc.dart';
import 'package:transit/bloc/vendors_bloc.dart/vendor_event.dart';
import 'package:transit/bloc/vendors_bloc.dart/vendor_state.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/repository/places_repo.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/screens/map/map_widget.dart';

class MapsPage extends StatelessWidget {
  MapsPage({super.key});

  final TextEditingController placeNameController = TextEditingController();
  final TextEditingController SourceNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //  WidgetsBinding.instance
    //     .addPostFrameCallback((_){

    //     });
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: const SizedBox(),
      floatingActionButtonLocation: CustomFabLocation(offsetFromBottom: 40),

      // Centers the FAB

      floatingActionButton: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state.polylines.isNotEmpty || state.markers.isNotEmpty) {
            return FloatingActionButton.extended(
              backgroundColor: backgroundColor,
              elevation: 10,
              isExtended: true,
              onPressed: () {
                context.push('/page3');
                context.read<VendorsBloc>().add(FetchVendorOptions());
              },
              label: const Flexible(
                child: Text(
                  "Book ride",
                  style: TextStyle(color: white),
                  maxLines: 1,
                ),
              ),
            );
          } else {
            return const SizedBox
                .shrink(); // Do not render the FAB if the condition is not met
          }
        },
      ),
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                context.push('/home');
              },
              icon: const Icon(Icons.arrow_back)),

              CustomSourcePicker(controller:SourceNameController ,label: 'Source',),
          CustomSearchBarMaps(
            label: "Search your ride",
            controller: placeNameController,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(85, 158, 158, 158),
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(
                    child: Stack(children: [
                  MapScreen(),

                  //   BlocBuilder<MapBloc, MapState>(
                  //   builder: (context, state) {
                  //     print(state.polylines);
                  //     print(state.markers);
                  //     if (state.polylines.isNotEmpty || state.markers.isNotEmpty) {
                  //       return ;
                  //     } else {
                  //       return SizedBox();
                  //     }
                  //   },
                  // )
                ]))),
          )),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    ));
  }
}

class CustomSearchBarMaps extends StatelessWidget {
  CustomSearchBarMaps({
    super.key,
    required this.label,
    required this.controller,
  });
  final String label;

  final TextEditingController controller;

  AutoCompleteService auto = AutoCompleteService();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(2),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: customgrey),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (GoRouter.of(context)
                          .routerDelegate
                          .currentConfiguration
                          .fullPath ==
                      '/') {
                    context.push('/maps-2');
                  }
                },
                child: TextField(
                  style: const TextStyle(color: white),
                  cursorColor: white,
                  controller: controller,
                  decoration: InputDecoration(
                    iconColor: white, suffixIconColor: white,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: label, hintStyle: const TextStyle(color: white),
                    isCollapsed: true, // Removes default padding
                    // Optional: Set hint text color
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 4), // Custom vertical padding

                    suffix: IconButton(
                      onPressed: () async {
                        context
                            .read<MapBloc>()
                            .add(SearchLocation(controller.text));
                        Future.delayed(const Duration(seconds: 5));
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ),
                  onTapAlwaysCalled: false,
                  onChanged: (value) {
                    Future.delayed(Durations.long1);
                    context
                        .read<AutocompleteBloc>()
                        .add(FetchSuggestions(value,Pos.destination));

                    // context.read<AutocompleteBloc>().mapEventToState(FetchSuggestions(value));
                  },
                ),
              ),
            ),
          ),
        ),
        BlocBuilder<AutocompleteBloc, AutocompleteState>(
          builder: (context, state) {
            if (state is AutocompleteLoadedDestination ) {
              return Container(
                constraints: const BoxConstraints(minHeight: 0, maxHeight: 150),
                child: SingleChildScrollView(
                  child: Column(
                      children: List.generate(
                    state.predictions.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
     print("Coming herererere");
                          if(GoRouter.of(context)
                          .state!.fullPath.toString() ==
                      '/home'){
                        print(GoRouter.of(context)
                          .state!.fullPath.toString()
                           + "is my current");
context.push('/page1');         print("LKJHKJHKJHKJHKHK");             }
                          controller.text =
                              state.predictions[index].description;
                          context
                              .read<AutocompleteBloc>()
                              .add(CompletedSuggestion());

                          context.read<MapBloc>().add(FindRoute(
                              state.predictions[index].placeId,
                              state.predictions[index].description));
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Card(
                            color: const Color.fromARGB(63, 96, 96, 96),
                            elevation: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(state.predictions[index].description),
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                ),
              );
            } else if (state is Completed) {
              return const SizedBox();
            } else if (state is AutocompleteInitial) {
              return const SizedBox();
            } else if (state is AutocompleteLoading && state.pos==Pos.destination) {
              return const CircularProgressIndicator();
            }
            else{
              return SizedBox();
            }
          },
        )
      ],
    );
  }
}

class CustomFabLocation extends FloatingActionButtonLocation {
  final double offsetFromBottom;

  CustomFabLocation({required this.offsetFromBottom});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2;
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        offsetFromBottom;
    return Offset(fabX, fabY);
  }
}


class SourceLocationPickers extends StatelessWidget {
  const SourceLocationPickers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class CustomSourcePicker extends StatelessWidget {
  const CustomSourcePicker({super.key,required this.label,required this.controller});
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(2),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: customgrey),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (GoRouter.of(context)
                          .routerDelegate
                          .currentConfiguration
                          .fullPath ==
                      '/') {
                    context.push('/maps-2');
                  }
                },
                child: BlocListener<LocationBloc,LocationState>(listener: (context, state) {
                  if(state.locationString!=null && controller.text.isEmpty){
                    controller.text=state.locationString!;

                  }
                },
                  child: TextField(
                    style: const TextStyle(color: white),
                    cursorColor: white,
                    controller: controller,
                    decoration: InputDecoration(
                      iconColor: white, suffixIconColor: white,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: label, hintStyle: const TextStyle(color: white),
                      isCollapsed: true, // Removes default padding
                      // Optional: Set hint text color
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4), // Custom vertical padding
                  
                      suffix: IconButton(
                        onPressed: () async {
                          // context
                          //     .read<MapBloc>()
                          //     .add(SearchLocation(controller.text));
                          // Future.delayed(const Duration(seconds: 5));
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ),
                    onTapAlwaysCalled: false,
                    onChanged: (value) {
                      Future.delayed(Durations.long1);
                      context
                          .read<AutocompleteBloc>()
                          .add(FetchSuggestions(value,Pos.source));
                  
                      //context.read<AutocompleteBloc>().mapEventToState(FetchSuggestions(value));
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocBuilder<AutocompleteBloc, AutocompleteState>(
          builder: (context, state) {
            print(state);
            if (state is AutocompleteLoadedSource  )  {
              return Container(
                constraints: const BoxConstraints(minHeight: 0, maxHeight: 150),
                child: SingleChildScrollView(
                  child: Column(
                      children: List.generate(
                    state.predictions.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {

                      
                          controller.text =
                              state.predictions[index].description;
                          context
                              .read<AutocompleteBloc>()
                              .add(CompletedSuggestion());

                          context.read<MapBloc>().add(ChangeSource(query:  state.predictions[index].description,
                            placeId:   state.predictions[index].placeId,
                              ));
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Card(
                            color: const Color.fromARGB(63, 96, 96, 96),
                            elevation: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(state.predictions[index].description),
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                ),
              );
            } else if (state is Completed) {
              return const SizedBox();
            } else if (state is AutocompleteInitial) {
              return const SizedBox();
            } else if (state is AutocompleteLoading && state.pos==Pos.source){
              return const CircularProgressIndicator();
            }
            else{
              return SizedBox();
            }
          },
        )
      ],
    );
  }
}