import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transit/models/flight_models.dart';

class FlightRepository {
  final String baseUrl = "https://api.example.com"; // Replace with actual API

  Future<List<FlightModel>> getFlights({
    required String from,
    required String to,
    required String departureDate,
    String? returnDate,
    required int passengers,
  }) async {
    try {
      final response = await http.get(Uri.parse(
        "$baseUrl/flights?from=$from&to=$to&departureDate=$departureDate&returnDate=${returnDate ?? ''}&passengers=$passengers",
      ));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => FlightModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch flights");
      }
    } catch (e) {
      throw Exception("Error fetching flights: $e");
    }
  }
}
