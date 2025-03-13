import 'package:flutter/material.dart';
import 'package:transit/core/data/legal_and_buis.dart';
import 'package:transit/core/theme/colors.dart';

class LegalBPage extends StatelessWidget {
  const LegalBPage({super.key,required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(legalBusinessHeading[index]),),
      backgroundColor: white,
      body:SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: SizedBox(child: 
              
                 Text(legalBusiness[index])
                  
                 
                  ),
            ),
          ),
        ),
      ));
  }
}