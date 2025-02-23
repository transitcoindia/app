// cab_option.dart
class CabOption {
  final String provider;
  final String name;
  final double price;
  final int eta; // Estimated time of arrival in minutes

  CabOption({
    required this.provider,
    required this.name,
    required this.price,
    required this.eta,
  });

  List<Object> get props => [provider, name, price, eta];
}
