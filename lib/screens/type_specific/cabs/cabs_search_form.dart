import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
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
  String fromName = '';
  String toName = '';
  Map<String, double>? fromLocation;
  Map<String, double>? toLocation;
  
  DateTime? selectedDate;
  TimeOfDay? selectedTime;


Future<String> getPlaceNameFromId(String placeId) async {
  const String apiKey = kGoogleApiKey;
  final String url =
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

  final response = await http.get(Uri.parse(url));
log(response.body);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['result']['name'] ?? 'Unknown Place';
  } else {
    throw Exception('Failed to load place details');
  }
}

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
        builder: (context) => ChooseRideScreen(fromName: fromName,toName: toName,
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
              itemClick: (Prediction prediction) async{
                // log(prediction.placeId);
                 fromName = await getPlaceNameFromId(prediction.placeId.toString()); // Fetch the place name

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
              itemClick: (Prediction prediction)async {
                 toName = await getPlaceNameFromId(prediction.placeId.toString()); // Fetch the place name

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
