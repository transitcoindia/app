import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:intl/intl.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:transit/screens/type_specific/cabs/search.dart';

const String kGoogleApiKey = "AIzaSyBkMWyYFXHFAZHunyeb07KahLaAbPPesOc"; // Replace with your key

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  
  Map<String, double>? fromLocation;
  Map<String, double>? toLocation;
  
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        log("Picked da ${picked!.day}");
        selectedDate = picked;
                log("Picked da ${selectedDate!.day}");

      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        log("Picked da ${picked!.toString()}");
        selectedTime = picked;
                log("Picked da ${selectedTime!.toString()}");

      });
    }
  }

  void _searchRides() {
    if (fromController.text.isEmpty ||
        toController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null ||
        fromLocation == null ||
        toLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields correctly")),
      );
      return;
    }
                log("Picked da ${selectedDate!.day}");
                log("Picked da ${selectedTime!.toString()}");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseRideScreen(
          fromAddress: fromController.text,
          toAddress: toController.text,
          fromLocation: fromLocation!,
          toLocation: toLocation!,
          selectedDate: selectedDate!,
          selectedTime: selectedTime!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GooglePlaceAutoCompleteTextField(
              textEditingController: fromController,
              googleAPIKey: kGoogleApiKey,
              inputDecoration: InputDecoration(
                labelText: "From Location",
                suffixIcon: Icon(Icons.search),
              ),
              debounceTime: 800,
              countries: ["IN"],
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (Prediction prediction) {
                fromLocation = {
                  "lat": double.parse(prediction.lat!),
                  "lng": double.parse(prediction.lng!)
                };
              },
              itemClick: (Prediction prediction) {
                fromController.text = prediction.description!;
                fromController.selection = TextSelection.fromPosition(
                  TextPosition(offset: fromController.text.length),
                );
              },
            ),
            SizedBox(height: 10),
            GooglePlaceAutoCompleteTextField(
              textEditingController: toController,
              googleAPIKey: kGoogleApiKey,
              inputDecoration: InputDecoration(
                labelText: "To Location",
                suffixIcon: Icon(Icons.search),
              ),
              debounceTime: 800,
              countries: ["IN"],
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (Prediction prediction) {
                toLocation = {
                  "lat": double.parse(prediction.lat!),
                  "lng": double.parse(prediction.lng!)
                };
              },
              itemClick: (Prediction prediction) {
                toController.text = prediction.description!;
                toController.selection = TextSelection.fromPosition(
                  TextPosition(offset: toController.text.length),
                );
              },
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(selectedDate == null
                  ? "Select Date"
                  : DateFormat('yyyy-MM-dd').format(selectedDate!)),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text(selectedTime == null
                  ? "Select Time"
                  : selectedTime!.format(context)),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchRides,
              child: Text("Find Rides"),
            ),
          ],
        ),
    );
  }
}
