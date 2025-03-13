import 'dart:convert';
import 'package:http/http.dart' as http;

class AutocompletePrediction {
  final String description;
  final String placeId;

  AutocompletePrediction({
    required this.description,
    required this.placeId,
  });

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['displayName']['text'] as String,
      placeId: json['formattedAddress'] as String,
    );
  }
}

class AutocompleteResponse {
  final List<AutocompletePrediction> predictions;

  AutocompleteResponse({
    required this.predictions,
  });

  factory AutocompleteResponse.fromJson(Map<String, dynamic> json) {
    var placesJson = json['places'] as List;
    List<AutocompletePrediction> predictions = placesJson
        .map((placeJson) => AutocompletePrediction.fromJson(placeJson))
        .toList();

    return AutocompleteResponse(predictions: predictions);
  }
}