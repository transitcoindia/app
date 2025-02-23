import 'package:flutter/material.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/core/widgets/safe_scaffold.dart';

class YourRides extends StatelessWidget {
  const YourRides({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(appBar: AppBar(
      title: const Text("Your rides", style: TextStyle(color: white),),
      backgroundColor: Colors.transparent ,
      leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(Icons.arrow_back_outlined, color: white,)),),
      
      body: Padding(padding: const EdgeInsets.all(8),child: 
    ListView.separated(itemBuilder: (context, index) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: customgrey, borderRadius: BorderRadius.circular(12)),
      child: const Column(children: [
        Row(
          children: [
            Text('Date'),Spacer(),
                        Text('date'),

          ],
        ),
        Row(
          children: [
            Text('Ride ID'),Spacer(),
                        Text('ride id'),

          ],
        ),
        Row(
          children: [
            Text('Location'),Spacer(),
                        Text('location'),

          ],
        )
      ],),
      );
    }, separatorBuilder: (context, index) {
      return const SizedBox(height: 10,);
    }, itemCount: 1)
    ,),);
  }
}