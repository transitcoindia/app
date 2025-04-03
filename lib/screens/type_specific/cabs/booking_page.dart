import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:transit/bloc/user_specific/user_bloc.dart/user_bloc.dart';
import 'package:transit/bloc/user_specific/user_bloc.dart/user_states.dart';

import 'package:transit/screens/type_specific/cabs/payment.dart';
import 'package:transit/screens/type_specific/cabs/paymentScreen.dart';

class BookingPage extends StatefulWidget {
  final String bookingId;
  final dynamic rideData;

  const BookingPage({
    Key? key,
    required this.bookingId,
    required this.rideData,
  }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool isLoading = false;
  String? confirmedBookingId;
  Map<String, dynamic>? bookingDetails;

  late String userId; // Fetched from UserBloc

  @override
  void initState() {
    super.initState();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      userId =
          userState.user.id.toString(); // <-- Adjust if your user model differs
    } else {
      userId = "unknown";
    }
  }

  void _confirmRide() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse("https://api.transitco.in/api/cab/confirmBooking"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"bookingId": widget.bookingId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("Confirmed Booking Data: $data");

        confirmedBookingId = data["data"]["bookingId"];
        _showMessage("Ride Confirmed ✅");

        // Fetch booking details and then navigate to payment
        await _fetchBookingDetails(confirmedBookingId!);
      } else {
        _showMessage("Failed to confirm ride.");
      }
    } catch (e) {
      _showMessage("Error: ${e.toString()}");
    }
    setState(() => isLoading = false);
  }

  Future<void> _fetchBookingDetails(String bookingId) async {
    try {
      var request = http.Request(
        'GET',
        Uri.parse("https://api.transitco.in/api/cab/getBookingDetails"),
      );

      request.body = jsonEncode({"bookingId": bookingId});
      request.headers.addAll({"Content-Type": "application/json"});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        setState(() {
          bookingDetails = data["data"];
        });
        log("Booking Details: $bookingDetails");
        _showMessage("Ride Confirmed ✅");
      } else {
        _showMessage(
            "Failed to fetch booking details: ${response.reasonPhrase}");
      }
    } catch (e) {
      _showMessage("Error fetching details: $e");
    }
  }

  void _cancelRide() async {
    final res = await http.get(
        Uri.parse("https://api.transitco.in/api/cab/getCancellationReasons"));
    final reasons = jsonDecode(res.body)["data"]["cancellationList"];

    final selected = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text("Select Cancellation Reason"),
        children: reasons.map<Widget>((r) {
          return ListTile(
            title: Text(r["text"]),
            onTap: () => Navigator.pop(context, r),
          );
        }).toList(),
      ),
    );

    if (selected != null) {
      final reason = selected["text"];
      final reasonId = selected["id"];
      await http.post(
        Uri.parse("https://api.transitco.in/api/cab/cancelBooking"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "bookingId": widget.bookingId,
          "reason": reason,
          "reasonId": reasonId.toString(),
        }),
      );
      _showMessage("Booking cancelled successfully ❌");
      Navigator.pop(context);
    }
  }

  void _goToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(),
      ),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildTripSummary() {
    final route = bookingDetails?["routes"]?[0];
    final fare = bookingDetails?["cabRate"]?["fare"]?["totalAmount"];
    final cabType = bookingDetails?["cabRate"]?["cab"]?["type"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text("Trip Summary",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text("From: ${route?["source"]?["address"] ?? "—"}"),
        Text("To: ${route?["destination"]?["address"] ?? "—"}"),
        Text("Cab: $cabType"),
        Text("Fare: ₹$fare"),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _goToPayment,
          child: Text("Proceed to Payment (₹$fare)"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Booking")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Booking ID: ${widget.bookingId}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Cab Type: ${widget.rideData["cab"]["type"]}"),
                  Text("Fare: ₹${widget.rideData["fare"]["totalAmount"]}"),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.check),
                    label: Text("Confirm Ride"),
                    onPressed: _confirmRide,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: Icon(Icons.cancel),
                    label: Text("Cancel Ride"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: _cancelRide,
                  ),
                  if (bookingDetails != null) _buildTripSummary(),
                ],
              ),
      ),
    );
  }
}
