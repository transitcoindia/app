import 'package:flutter/widgets.dart';
import 'package:transit/core/widgets/safe_scaffold.dart';
import 'package:transit/screens/home_screens/maps_page.dart';

class SecondMapsPage extends StatelessWidget {
   SecondMapsPage({super.key});
  
  final TextEditingController placeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      body: Column(children: [
         Hero(tag: 'map-search',
           child: CustomSearchBarMaps(label: "Where to ?",controller:   placeNameController 
           ,),
         )
      ],),
    );
  }
}