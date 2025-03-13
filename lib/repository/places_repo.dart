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
        'key': 'AIzaSyBkMWyYFXHFAZHunyeb07KahLaAbPPesOc',
      },
    );

    try {
      final response = await _dio.getUri(uri);
      if (response.statusCode == 200) {
        final data = response.data;
        final autocompleteResponse = AutocompleteResponse.fromJson(data);
        return autocompleteResponse.predictions;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
