import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:intl/intl.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:transit/screens/type_specific/cabs/search.dart';

const String kGoogleApiKey =
    "AIzaSyBkMWyYFXHFAZHunyeb07KahLaAbPPesOc"; // Replace with your key

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

  DateTime? fromDate; // Separate variable for 'From' date
  DateTime? toDate; // Separate variable for 'To' date
  TimeOfDay? fromTime; // Separate variable for 'From' time
  TimeOfDay? toTime; // Separate variable for 'To' time

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

  void _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked; // Update only 'From' date
        } else {
          toDate = picked; // Update only 'To' date
        }
        log("Picked date: ${picked.day}");
      });
    }
  }

  void _selectTime(BuildContext context, bool isFromTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isFromTime) {
          fromTime = picked; // Update only 'From' time
        } else {
          toTime = picked; // Update only 'To' time
        }
        log("Picked time: ${picked.format(context)}");
      });
    }
  }

  void _searchRides() {
    if (fromController.text.isEmpty ||
        toController.text.isEmpty ||
        fromDate == null ||
        toDate == null ||
        fromTime == null ||
        toTime == null ||
        fromLocation == null ||
        toLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields correctly")),
      );
      return;
    }
    log("From date: ${fromDate!.day}, To date: ${toDate!.day}");
    log("From time: ${fromTime!.format(context)}, To time: ${toTime!.format(context)}");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseRideScreen(
          fromName: fromName,
          toName: toName,
          fromAddress: fromController.text,
          toAddress: toController.text,
          fromLocation: fromLocation!,
          toLocation: toLocation!,
          fromDate: fromDate!,
          fromTime: fromTime!,
          toDate: toDate!,
          toTime: toTime!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GooglePlaceAutoCompleteTextField(
            textEditingController: fromController,
            googleAPIKey: kGoogleApiKey,
            inputDecoration: InputDecoration(
              labelText: "From Location",
              suffixIcon: Icon(Icons.location_on_sharp),
            ),
            debounceTime: 800,
            countries: ["IN"],
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) {
              fromLocation = {
                "lat": double.parse(prediction.lat!),
                "lng": double.parse(prediction.lng!),
              };
            },
            itemClick: (Prediction prediction) async {
              fromName =
                  await getPlaceNameFromId(prediction.placeId.toString());

              fromController.text = prediction.description!;
              fromController.selection = TextSelection.fromPosition(
                TextPosition(offset: fromController.text.length),
              );
            },
          ),
          SizedBox(height: 25),
          GooglePlaceAutoCompleteTextField(
            textEditingController: toController,
            googleAPIKey: kGoogleApiKey,
            inputDecoration: InputDecoration(
              labelText: "To Location",
              suffixIcon: Icon(Icons.location_on_sharp),
            ),
            debounceTime: 800,
            countries: ["IN"],
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) {
              toLocation = {
                "lat": double.parse(prediction.lat!),
                "lng": double.parse(prediction.lng!),
              };
            },
            itemClick: (Prediction prediction) async {
              toName = await getPlaceNameFromId(prediction.placeId.toString());

              toController.text = prediction.description!;
              toController.selection = TextSelection.fromPosition(
                TextPosition(offset: toController.text.length),
              );
            },
          ),
          SizedBox(height: 25),
          _buildDateTimeContainer("From", _selectDate, _selectTime, true),
          SizedBox(height: 25),
          _buildDateTimeContainer("To", _selectDate, _selectTime, false),
          SizedBox(height: 45),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _searchRides,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.black,
              ),
              child: Text("Search", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeContainer(
      String label,
      Function(BuildContext, bool) onDateTap,
      Function(BuildContext, bool) onTimeTap,
      bool isFromDate) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => onDateTap(context, isFromDate),
            child: Text(
              isFromDate
                  ? (fromDate == null
                      ? "$label Date"
                      : DateFormat('yyyy-MM-dd').format(fromDate!))
                  : (toDate == null
                      ? "$label Date"
                      : DateFormat('yyyy-MM-dd').format(toDate!)),
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          Text("|",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => onTimeTap(context, isFromDate),
            child: Text(
              isFromDate
                  ? (fromTime == null ? "Time" : fromTime!.format(context))
                  : (toTime == null ? "Time" : toTime!.format(context)),
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
