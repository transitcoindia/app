import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChooseRideScreen extends StatefulWidget {
  final String fromAddress;
  final String toAddress;
  final Map<String, double> fromLocation;
  final Map<String, double> toLocation;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  ChooseRideScreen({
    required this.fromAddress,
    required this.toAddress,
    required this.fromLocation,
    required this.toLocation,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  _ChooseRideScreenState createState() => _ChooseRideScreenState();
}

class _ChooseRideScreenState extends State<ChooseRideScreen> {
  List<dynamic> rides = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
  fetchRides();  });
  
  }
String formatTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('HH:mm:ss').format(dateTime);
}

  Future<void> fetchRides() async {
    setState(() => isLoading = true);

    final apiUrl = "https://api.transitco.in/api/cab/getQuote"; // Replace with actual API URL
    final requestBody = {
      "tripType": 1,
      "cabType": [1, 2, 3],
      "routes": [
        {
          "startDate":DateFormat('yyyy-MM-dd').format(widget.selectedDate),// ,
          "startTime":formatTimeOfDay(widget.selectedTime),//,
          "source": {
            "address": widget.fromAddress,
            "coordinates": {
              "latitude": widget.fromLocation['lat'],
              "longitude": widget.fromLocation['lng'],
            }
          },
          "destination": {
            "address": widget.toAddress,
            "coordinates": {
              "latitude": widget.toLocation['lat'],
              "longitude": widget.toLocation['lng'],
            }
          }
        }
      ]
    };
log(widget.toLocation['lat'].toString());
log(widget.toLocation['lng'].toString());
log(widget.fromLocation['lat'].toString());
log(widget.fromLocation['lng'].toString());

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      print(DateFormat('yyyy-MM-dd').format(widget.selectedDate));
log(response.body);
print(widget.selectedTime.format(context));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["success"] && responseData["data"]["cabRate"] != null) {
          setState(() {
            rides = responseData["data"]["cabRate"];
            isLoading = false;
          });
        } else {
          showError(responseData["message"] ?? "No rides found.");
        }
      } else {
        showError("Failed to fetch rides. Please try again.");
      }
    } catch (error) {
      showError("Network error: ${error.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Ride")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : rides.isEmpty
                ? Center(child: Text("No rides available"))
                : ListView.builder(
                    itemCount: rides.length,
                    itemBuilder: (context, index) {
                      final ride = rides[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.directions_car, size: 40),
                          title: Text(ride["cab"]["type"]),
                          subtitle: Text("Seats: ${ride["cab"]["seatingCapacity"]} | ₹${ride["fare"]["totalAmount"]}"),
                          trailing: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Ride selected: ${ride["cab"]["type"]}")),
                              );
                            },
                            child: Text("Select"),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
