import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:transit/models/autocomplete_model.dart';

class AutoCompleteService {
  final Dio _dio = Dio();

  AutoCompleteService();

  Future<List<AutocompletePrediction>> fetchAutoComplete({required String inp}) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': inp,
        'key': 'AIzaSyBUNCmPq77lyK-8dOo4CL7HqSnamk7RbCQ',
      },
    );
  final String apiKey = "AIzaSyBUNCmPq77lyK-8dOo4CL7HqSnamk7RbCQ";
  final String url = "https://places.googleapis.com/v1/places:searchText";

    try {
      final response = await _dio.post(
      url,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": apiKey,
          "X-Goog-FieldMask": "places.displayName,places.formattedAddress,places.priceLevel",
        },
      ),
      data: {
        "textQuery": "$inp",
      },
    );
      // log(response.toString());
      // log(response.statusCode.toString());
      // log(response.data.toString());
   
      if (response.statusCode == 200) {
        final data = response.data;
        log(data.toString());
        print("bnefore comvertinggggg");
        final autocompleteResponse = AutocompleteResponse.fromJson(data);
        print("after comvertinggggg");
        print(autocompleteResponse);
        return autocompleteResponse.predictions;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
