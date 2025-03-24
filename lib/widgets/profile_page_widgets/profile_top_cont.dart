import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/bloc/user_specific/user_bloc.dart/user_bloc.dart';
import 'package:transit/bloc/user_specific/user_bloc.dart/user_states.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/repository/user_repo.dart';

class ProfileTopContainer extends StatelessWidget {
  const ProfileTopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider<UserBloc>(create: (context) => UserBloc(UserRepository()),
    child: BlocConsumer<UserBloc,UserState>(
      listener: (context, state) {
        
      },
      builder: (context, state) {
      return  Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12),
          
        ),child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                CircleAvatar(),
                (state is UserLoaded)?Text(state.user.name??''):(state is UserLoaded)?CircularProgressIndicator():Text("se"),
                IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: black,), ),
                Text("Edit profile",style: TextStyle(fontSize: 10.sp),),
        
               
              ],),
              
            ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Container(
              padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                
                borderRadius: BorderRadius.circular(12),
                color: profileBackgroundGrey),
                  child:Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Please complete your profile", style: TextStyle(fontWeight: FontWeight.w600),),
                    SizedBox(height: 1.h,),
                      Text("Share your mobile number to receive booking updates and other critical communication",
                    style: TextStyle(fontSize: 10.sp),),
                                    SizedBox(height:10.h,),
        
                    Divider(height: 1.h,thickness: 2.h,color: borderColor,),
                    SizedBox(height: 30.h,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.all(2)),
                        onPressed: (){}, child: Text("Add Moblie No.",style: TextStyle(color: elevatedButtonBlue),)),
                    )
                    ],
                  ) ,
                  ),
             )
          ],
        ),
        );
    },
   
    )
     
     
    );
  }
}