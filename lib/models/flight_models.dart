class FlightModel {
  final String airline;
  final String flightNumber;
  final String departureTime;
  final String arrivalTime;
  final double price;

  FlightModel({
    required this.airline,
    required this.flightNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      airline: json['airline'],
      flightNumber: json['flightNumber'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      price: json['price'].toDouble(),
    );
  }
}
