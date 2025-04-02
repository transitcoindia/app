import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/screens/type_specific/cabs/booking_page.dart';
import 'dart:convert';
import 'package:transit/screens/type_specific/cabs/payment.dart';

class ChooseRideScreen extends StatefulWidget {
  final String fromAddress;
  final String toAddress;
  final Map<String, double> fromLocation;
  final Map<String, double> toLocation;
  final DateTime fromDate;
  final DateTime toDate;
  final TimeOfDay fromTime;
  final TimeOfDay toTime;
  final String fromName;
  final String toName;

  ChooseRideScreen({
    required this.fromAddress,
    required this.toAddress,
    required this.fromLocation,
    required this.toLocation,
    required this.fromDate,
    required this.toDate,
    required this.fromTime,
    required this.toTime,
    required this.fromName,
    required this.toName,
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
      fetchRides();
    });
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  Future<void> fetchRides() async {
    setState(() => isLoading = true);

    final apiUrl = "https://api.transitco.in/api/cab/getQuote";
    final requestBody = {
      "tripType": 1,
      "cabType": [1, 2, 14, 15, 16, 72, 73, 74],
      "routes": [
        {
          "startDate": DateFormat('yyyy-MM-dd').format(widget.fromDate),
          "startTime": formatTimeOfDay(widget.fromTime),
          "source": {
            "address": widget.fromAddress,
            "name": widget.fromName,
            "coordinates": {
              "latitude": 22.6531496,
              "longitude": 88.4448719,
            }
          },
          "destination": {
            "address": widget.toAddress,
            "name": widget.toName,
            "coordinates": {
              "latitude": 22.7008099,
              "longitude": 88.3747597,
            }
          }
        }
      ]
    };

    log(requestBody.toString());

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["success"] &&
            responseData["data"]["cabRate"] != null) {
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
                      return RideCard(
                        ride: ride,
                        fromAddress: widget.fromAddress,
                        toAddress: widget.toAddress,
                        fromLocation: widget.fromLocation,
                        toLocation: widget.toLocation,
                        fromTime: widget.fromTime,
                      );
                    },
                  ),
      ),
    );
  }
}

// class RideCard extends StatelessWidget {
//   final dynamic ride;

//   const RideCard({required this.ride, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       color: const Color(0xFFE6F7FB), // light blue background
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // LEFT SIDE: Text
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   ride["cab"]["type"] ?? "Cab Type",
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "Seats: ${ride["cab"]["seatingCapacity"]}",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "₹${ride["fare"]["totalAmount"]}",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Navigator.of(context).push(MaterialPageRoute(
//                     //   builder: (context) =>
//                     //       RazorpayPaymentPage(userId: "user_id_here"),
//                     // ));
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => BookingPage(
//                           bookingId: "QT503901521",
//                           rideData: ride,
//                         ),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueGrey[900],
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 10,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                   child: const Text("Book Now"),
//                 ),
//               ],
//             ),
//             // RIGHT SIDE: Car image
//             Image.asset(
//               'assets/bookingcar.png',
//               width: 120,
//               height: 80,
//               fit: BoxFit.contain,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class RideCard extends StatelessWidget {
  final dynamic ride;
  final String fromAddress;
  final String toAddress;
  final Map<String, double> fromLocation;
  final Map<String, double> toLocation;
  final TimeOfDay fromTime;

  const RideCard({
    required this.ride,
    required this.fromAddress,
    required this.toAddress,
    required this.fromLocation,
    required this.toLocation,
    required this.fromTime,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE6F7FB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ride["cab"]["type"] ?? "Cab Type",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("Seats: ${ride["cab"]["seatingCapacity"]}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                SizedBox(height: 8),
                Text("₹${ride["fare"]["totalAmount"]}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () => _handleBookNow(
                    context,
                    ride,
                    fromAddress,
                    toAddress,
                    fromLocation,
                    toLocation,
                    fromTime,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[900],
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Book Now"),
                ),
              ],
            ),
            Image.asset(
              'assets/bookingcar.png',
              width: 120,
              height: 80,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  String formatTimeOfDay(TimeOfDay time) {
    final int hour = time.hour;
    final int minute = time.minute;
    final String period = hour >= 12 ? "PM" : "AM";
    final int formattedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final String formattedMinute = minute.toString().padLeft(2, '0');

    return "$formattedHour:$formattedMinute $period";
  }

  Future<void> _handleBookNow(
      BuildContext context,
      Map<String, dynamic> ride,
      String fromAddress,
      String toAddress,
      Map<String, double> fromLocation,
      Map<String, double> toLocation,
      TimeOfDay fromTime) async {
    log("Proceeding with booking...");
    final bookingRequest = {
      "tnc": 1,
      "referenceId": "tttt",
      "tripType": 1,
      "cabType": 3,
      "fare": {"advanceReceived": 0, "totalAmount": 2082},
      "platform": {"deviceName": "", "ip": "", "type": ""},
      "apkVersion": "",
      "sendEmail": 1,
      "sendSms": 1,
      "routes": [
        {
          "startDate": "2025-04-25",
          "startTime": "17:10:00",
          "source": {
            "address": "Bengaluru",
            "coordinates": {
              "latitude": 12.9087928999999999035708242445252835750579833984375,
              "longitude": 77.64249780000000100699253380298614501953125
            }
          },
          "destination": {
            "address": "Bengaluru airport",
            "coordinates": {
              "latitude": 13.2007713317871004932158029987476766109466552734375,
              "longitude": 77.71022796630859375
            }
          }
        }
      ],
      "traveller": {
        "firstName": "Tapesh",
        "lastName": "",
        "primaryContact": {"code": 91, "number": "7085563968"},
        "alternateContact": {"code": 91, "number": "8794103394"},
        "email": "test.yadav4@gmail.com",
        "companyName": "",
        "address": "",
        "gstin": ""
      },
      "additionalInfo": {
        "specialInstructions": "cab should be clean",
        "noOfPerson": 4,
        "noOfLargeBags": 0,
        "noOfSmallBags": 3,
        "carrierRequired": 0,
        "kidsTravelling": 0,
        "seniorCitizenTravelling": 0,
        "womanTravelling": 0
      }
    };

    log("Booking Request: ${jsonEncode(bookingRequest)}");

    try {
      final response = await http.post(
        Uri.parse("https://api.transitco.in/api/cab/book"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bookingRequest),
      );

      log("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          final String bookingId = data["data"]["bookingId"];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingPage(
                bookingId: bookingId,
                rideData: ride,
              ),
            ),
          );
        } else {
          _showMessage(context, "Booking failed: ${data["message"]}");
        }
      } else {
        _showMessage(context, "Failed to book ride.");
      }
    } catch (e) {
      log("Booking error: $e");
      _showMessage(context, "Error: $e");
    }
  }

  void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
