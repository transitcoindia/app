import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:transit/bloc/autocomplete_bloc.dart/acomp_bloc.dart';
import 'package:transit/bloc/autocomplete_bloc.dart/acomp_event.dart';
import 'package:transit/bloc/autocomplete_bloc.dart/acompstate.dart';
import 'package:transit/bloc/flights_bloc/flight_bloc.dart';
import 'package:transit/bloc/maps_bloc/maps_bloc.dart';
import 'package:transit/bloc/maps_bloc/maps_event.dart';
import 'package:transit/cubits/flights_cubit/flight_det_cubit.dart';
import 'package:transit/screens/home_screens/maps_page.dart';
import 'package:transit/screens/map/empty_maps.dart';
import 'package:transit/screens/map/map_widget.dart';
import 'package:transit/screens/type_specific/flights/search_results.dart';

class CabsSearchForm extends StatefulWidget {
  const CabsSearchForm({super.key});

  @override
  _CabsSearchFormState createState() => _CabsSearchFormState();
}

class _CabsSearchFormState extends State<CabsSearchForm> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController departureDateController = TextEditingController();
  final TextEditingController returnDateController = TextEditingController();
  final TextEditingController passengersController = TextEditingController(text: "1");

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat.yMMMd().format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightTypeCubit, FlightType>(
      builder: (context, flightType) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              topHelperText: "(This will help our driver reach out to you)",
              topText: "Pick-up Address",
              label: "Enter exact pick up address", controller: fromController,onChanged: (value){
                   Future.delayed(Durations.long1);
                    context
                        .read<AutocompleteBloc>()
                        .add(FetchSuggestions(value,Pos.source));
            }),
            BlocBuilder<AutocompleteBloc, AutocompleteState>(
          builder: (context, state) {
            if (state is AutocompleteLoadedSource ) {
              return Container(
                constraints: const BoxConstraints(minHeight: 0, maxHeight: 150),
                child: SingleChildScrollView(
                  child: Column(
                      children: List.generate(
                    state.predictions.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {

                          if(GoRouter.of(context)
                          .state!.fullPath.toString() ==
                      '/home'){
                        // print(GoRouter.of(context)
                        //   .state!.fullPath.toString()
                        //    + "is my current");
// context.push('/page1');         print("LKJHKJHKJHKJHKHK");           
  }
                          fromController.text =
                              state.predictions[index].description;
                          context
                              .read<AutocompleteBloc>()
                              .add(CompletedSuggestion());
   context.read<MapBloc>().add(ChangeSource(query:  state.predictions[index].description,
                            placeId:   state.predictions[index].placeId,
                              ));;
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Card(
                            // color: const Color.fromARGB(63, 96, 96, 96),
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
            } else if (state is AutocompleteLoading && state.pos==Pos.source) {
              return const CircularProgressIndicator();
            }
            else{
              return SizedBox();
            }
          },
        ),
            SizedBox(height: 10.h),
            _buildTextField(topHelperText: "(This will help to avoid extra charges)",
              topText: "Drop off Addrress",
              label: "Enter exact drop off address", controller: toController,
              onChanged: (value){
                   Future.delayed(Durations.long1);
                    context
                        .read<AutocompleteBloc>()
                        .add(FetchSuggestions(value,Pos.destination));
            }
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

                          if(GoRouter.of(context)
                          .state!.fullPath.toString() ==
                      '/home'){
                        // print(GoRouter.of(context)
                        //   .state!.fullPath.toString()
                        //    + "is my current");
// context.push('/page1');         print("LKJHKJHKJHKJHKHK");           
  }
                          toController.text =
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
                            // color: const Color.fromARGB(63, 96, 96, 96),
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
        ),
            SizedBox(height: 10.h),
            _buildDateField(label: "Departure Date", controller: departureDateController),
            if (flightType == FlightType.roundTrip) ...[
              SizedBox(height: 10.h),
              _buildDateField(label: "Return Date", controller: returnDateController),
            ],
            SizedBox(height: 10.h),
            // _buildTextField(label: "Passengers", controller: passengersController, keyboardType: TextInputType.number),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
               onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return MapsPage();
                },));
  // final bloc = context.read<FlightSearchBloc>();
  // bloc.add(FetchFlights(
  //   from: fromController.text,
  //   to: toController.text,
  //   departureDate: departureDateController.text,
  //   returnDate: context.read<FlightTypeCubit>().state == FlightType.roundTrip 
  //       ? returnDateController.text 
  //       : null,
  //   passengers: int.tryParse(passengersController.text) ?? 1,
  // ));
},

                child: Text("Search Cabs", style: TextStyle(fontSize: 18.sp)),
              ),
            ),
                //  FlightResultsWidget(),
                  

          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required topText,required topHelperText,
    required String label, required TextEditingController controller, TextInputType? keyboardType,
 void Function(String)? onChanged
  }) {
    return Column(
      children: [Row(
        children: [
          Text(topText, style: TextStyle(fontWeight: FontWeight.w700),),
          SizedBox(width: 8,),
          Text(topHelperText, style: TextStyle(fontSize: 8.sp),)
        ],
      ),
        TextFormField(
          onChanged: onChanged,
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({required String label, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context, controller),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        suffixIcon: Icon(Icons.calendar_today),
      ),
    );
  }
}
