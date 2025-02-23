import 'package:flutter/material.dart';
import 'package:transit/core/theme/colors.dart';

class CurrentAddressWidget extends StatelessWidget {
  const CurrentAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(color: customgrey,borderRadius: BorderRadius.circular(12)),
    child: Text('loaded'),
    );
  }
}