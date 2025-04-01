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
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String fromName;
  final String toName;

  ChooseRideScreen(
      {required this.fromAddress,
      required this.toAddress,
      required this.fromLocation,
      required this.toLocation,
      required this.selectedDate,
      required this.selectedTime,
      required this.fromName,
      required this.toName});

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
          "startDate": DateFormat('yyyy-MM-dd').format(widget.selectedDate),
          "startTime": formatTimeOfDay(widget.selectedTime),
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
                      return RideCard(ride: ride);
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

  const RideCard({required this.ride, super.key});

  Future<void> _handleBookNow(BuildContext context) async {
    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthAuthenticated) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    final userId =
        "yourUserId"; // You can pass this from AuthBloc/UserBloc if needed

    // Fetch the saved token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken'); // Fetch the token
    log("📦 Token read in RideCard: $token");
    //final token =
    //"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImNtOHlncmVreTAwMDBsbDBqdjJiOGl5M3YiLCJpYXQiOjE3NDM1NDA5MDAsImV4cCI6MTc0MzU0MTgwMH0.iS9Leq7vhjwQHMVY2nKyzyXfMynHvyqr6Rfqr6ccTJc;";

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No authentication token found.")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("https://api.transitco.in/api/cab/book"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Add token to the Authorization header
        },
        body: jsonEncode({
          "tripType": 1,
          "cabType": ride["cab"]["id"],
          "routes": [
            {
              "startDate": "2025-04-10",
              "startTime": "12:00:00",
              "source": {
                "address": "Pickup Address",
                "coordinates": {"latitude": 22.65, "longitude": 88.44}
              },
              "destination": {
                "address": "Drop Address",
                "coordinates": {"latitude": 22.70, "longitude": 88.37}
              }
            }
          ]
        }),
      );

      // Log the status code and response body for debugging
      log("Booking response status code: ${response.statusCode}");
      log("Booking response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bookingId = data["data"]["bookingId"];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingPage(
              bookingId: bookingId,
              rideData: ride,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking failed. Try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    }
  }

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
            // Text & Button
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
                  onPressed: () => _handleBookNow(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[900],
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Book Now"),
                ),
              ],
            ),
            // Car image
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
}
