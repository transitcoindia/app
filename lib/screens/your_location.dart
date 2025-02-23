import 'package:flutter/widgets.dart';

class MyLocation extends StatelessWidget {
  const MyLocation({super.key, req, required this.position});
 final String position;
  @override
  Widget build(BuildContext context) {
    return Text(position);
  }
}