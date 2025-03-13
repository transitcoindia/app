import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:transit/models/user_mode.dart';

class UserRepository {
  static const String _baseUrl = 'https://transit-be.vercel.app/api/user/details';

  Future<UserModel> fetchUser(String userId) async {
    final response = await http.get(Uri.parse('$_baseUrl?userId=$userId'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return UserModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
