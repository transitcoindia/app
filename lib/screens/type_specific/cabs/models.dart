class Cab {
  final int id;
  final String name;
  final String image;
  final int seats;
  final bool ac;
  final double price;

  Cab({
    required this.id,
    required this.name,
    required this.image,
    required this.seats,
    required this.ac,
    required this.price,
  });

  factory Cab.fromJson(Map<String, dynamic> json) {
    return Cab(
      id: json['cab']['id'],
      name: json['cab']['type'],
      image: json['cab']['image'],
      seats: json['cab']['seatingCapacity'],
      ac: true,
      price: json['fare']['totalAmount'].toDouble(),
    );
  }
}
