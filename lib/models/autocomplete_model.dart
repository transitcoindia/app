class AutocompletePrediction {
  final String description;
  final String placeId;

  AutocompletePrediction({
    required this.description,
    required this.placeId,
  });

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['description'] as String,
      placeId: json['place_id'] as String,
    );
  }
}

class AutocompleteResponse {
  final List<AutocompletePrediction> predictions;

  AutocompleteResponse({
    required this.predictions,
  });

  factory AutocompleteResponse.fromJson(Map<String, dynamic> json) {
    var predictionsJson = json['predictions'] as List;
    List<AutocompletePrediction> predictions = predictionsJson
        .map((predictionJson) => AutocompletePrediction.fromJson(predictionJson))
        .toList();

    return AutocompleteResponse(predictions: predictions);
  }
}
