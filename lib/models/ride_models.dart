// lib/data/ride_options.dart

class RideOption {
  final String provider;
  final int eta;
  final int price;
  final int distance;

  RideOption({
    required this.provider,
    required this.eta,
    required this.price,
    required this.distance,
  });
}

final List<RideOption> rideOptions = [
  RideOption(provider: 'Uber', eta: 10, price: 150, distance: 21),
  RideOption(provider: 'Lyft', eta: 15, price: 200, distance: 25),
  RideOption(provider: 'Ola', eta: 12, price: 180, distance: 19),
];
