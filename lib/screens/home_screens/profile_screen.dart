import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/core/theme/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 80, 83, 89),
        body:SingleChildScrollView(
        child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.center,
        
        children: [
        SizedBox(           width: double.infinity,
        
          child: Stack(children: [
            Column(
              children: [
                SizedBox(            height: 250,width: double.infinity,
                
                  child:Image.asset('assets/images/profile_bg.jpeg',fit: BoxFit.fitWidth,)),
                     const Text('Walt Whitman', style: TextStyle(fontSize: 22),),
        const Text('+91 9238475827', style: TextStyle(fontSize: 16,color: white),),
              const Text('ehref@gmail.com', style: TextStyle(fontSize: 16,color: white),),
        
        const SizedBox(height: 
        5,)
              ],
            ),
            const Positioned(top: 200,left: 10,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: CircleAvatar(backgroundColor: backgroundColor,foregroundColor: white,
                  radius: 60,
                  child: Icon(Icons.person),)),
            )
            
            
            ]),
        ),
           
        
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Column(
         children: [
           //const PreviousRides(),
           CustomProfilePageButton(onPressed: (){
          context.push('/your-rides');
              
           }, label: 'See all rides', child: const SizedBox()),
            const SizedBox(height: 
        5,),
              CustomProfilePageButton(
                icon: Icons.info,
                label: "About app",
                
                onPressed: (){
                context.push('/about-us');
              }, child: const Row(children: [
                 Icon(Icons.info),Text("About app")
              ],)),
                      const SizedBox(height: 5,),
            
              CustomProfilePageButton(icon: 
               Icons.person,
                label: "Contact us",
                onPressed: (){
                context.push('/contact-us');
              }, child: const Row(children: [
                 Icon(Icons.person),Text("Contace us")
              ],)),
              const SizedBox(height: 5,),
                  BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                return CustomProfilePageButton(
                  label: "Logout",
                  onPressed: (){
                  context.read<AuthBloc>().add(AuthLogout());
                
                }, child: const Text("Logout",style: TextStyle(color: red),));
                
              },
               
              ),
         ],
             ),
           ),
            
            ],),) ,),
    );
  }
}


class CustomProfilePageButton extends StatelessWidget {
  final dynamic onPressed;
  final Widget child;
  final IconData? icon;
  final String label;
  const CustomProfilePageButton({super.key, required this.onPressed, required this.child
  , this.icon, required this.label
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: onPressed, child: Center(
        child: Container(padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            
            color:label=='Logout'?red: backgroundColor,borderRadius: BorderRadius.circular(4),),
          child: Row(
            mainAxisAlignment:(label=='Logout' || label=='See all rides')? MainAxisAlignment.center:MainAxisAlignment.start,
            children: [
            if(icon!=null)Icon(icon, color: white,),const SizedBox(width: 10,),
            Text(label, style: TextStyle(color: label=='Logout'?white:label=='See all rides'?blue:white,fontSize: 18 ),)
          ],)),
      ),);
  }
}

class PreviousRides extends StatelessWidget {
  const PreviousRides({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor, // Updated to backgroundColor
        borderRadius: BorderRadius.circular(4), // Border radius added
      ),
      child: const Row(
        children: [
          Icon(Icons.car_crash_rounded, color: white),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sun, Nov 17, 6:09 PM",
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Date text in bold
                  color: Colors.white, // Text color set to white
                ),
              ),
              Text(
                "(Ride ID: 12345)", // Ride ID added
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "San Martin Cupertino Los Angeles California",overflow: TextOverflow.clip,
                    style: TextStyle(color: Colors.white), // Text color set to white
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Colors.green,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Trader Joe's 9th cross Cupertino Los Angeles",overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white), // Text color set to white
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
