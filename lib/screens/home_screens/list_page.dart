import 'package:flutter/material.dart';
import 'package:transit/core/static_test_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:go_router/go_router.dart';
class ListOfRidesPage extends StatelessWidget {
  const ListOfRidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: backgroundColor,
      body:
        Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             IconButton(onPressed: (){
   context.go('/');

      }, icon: const Icon(Icons.arrow_back)),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: translucentBlack, borderRadius: BorderRadius.circular(12)),child:
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  
                  Text(rideProvidersName[index]),
                  const Text("Price"),
                  const Text("Time")
                ],),);
                      }, separatorBuilder: (context, index) {
                return const SizedBox(height: 10,);
                      }, itemCount: rideProvidersName.length),
              ),
            ),
          ],
        ),));
  }
}