import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:transit/screens/type_specific/cabs/models.dart';

class CabService {
  static Future<List<Cab>> fetchCabs(Map<String, dynamic> requestData) async {
    log("CALLINGGG");
    final url = Uri.parse('https://api.transitco.in/api/cab/getQuote');
    
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );
log(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] && data['data']['cabRate'] != null) {
          return (data['data']['cabRate'] as List).map((e) => Cab.fromJson(e)).toList();
        }
      }
       final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? "No rides found.");
    } catch (e) {
      throw Exception("Failed to fetch rides: $e");
    }
  }
}
