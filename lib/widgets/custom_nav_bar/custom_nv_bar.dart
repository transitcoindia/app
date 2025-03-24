import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:transit/bloc/auth_bloc/auth_bloc.dart';
import 'package:transit/bloc/auth_bloc/auth_event.dart';
import 'package:transit/bloc/auth_bloc/auth_state.dart';
import 'package:transit/core/theme/colors.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
             double bottomPadding = MediaQuery.of(context).padding.bottom;
    double iconSize =  24; // ✅ Selected = 28, Unselected = 24
//isSelected ? 26 :
    double height = 30.h;
    double? width = null;
    return Container(padding: EdgeInsets.all(0),
    
      child: Container(
      decoration: BoxDecoration(color: elevatedButtonBlue),
        padding: EdgeInsets.only(bottom: bottomPadding/1.8, top: 4), 
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
      InkWell(
        child: SizedBox(height: height,width:width,child: Image.asset('assets/bottom_bar_icons/home.png', height: iconSize,),)),
         InkWell(child: SizedBox(height: height,width:width,child: Image.asset('assets/bottom_bar_icons/travel.png'),)),
      InkWell(
        onTap: () {
           context.read<AuthBloc>().add(AuthLogout());
        },
        child: SizedBox(height: height,width:width,child: Image.asset('assets/bottom_bar_icons/explore.png'),)),
      BlocBuilder<AuthBloc,AuthState>(builder: (context, state) {
        return InkWell(
          onTap: () {
            if(state is AuthLoggedIn){
GoRouter.of(context).push('/profile');
            }
           else{
            GoRouter.of(context).push('/login');

           }
          },
          child: SizedBox(height: height,width:width,child: Image.asset('assets/bottom_bar_icons/profile.png'),));
      },
       
      ),
            
            ],),),
    );
  }
}