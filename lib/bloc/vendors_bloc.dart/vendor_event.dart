
abstract class VendorsEvent {}

class FetchVendorOptions extends VendorsEvent {
}

class SelectRide extends VendorsEvent{
final int index;


   SelectRide(this.index,);

  @override
  List<Object> get props => [index];
}
