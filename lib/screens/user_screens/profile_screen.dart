import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/data/proflie_page_data.dart';
import 'package:transit/core/theme/colors.dart';
import 'package:transit/widgets/profile_page_widgets/pro_page_item.dart';
import 'package:transit/widgets/profile_page_widgets/profile_top_cont.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  backgroundColor: const Color.fromARGB(250, 255, 255, 255),
      appBar: AppBar(backgroundColor: enabledFillColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Container(
          alignment: Alignment.centerLeft,
          child:  Text("My Personal Profile", style: TextStyle(fontSize: 18.sp),),
        ),
      ),
      body: Container(decoration: BoxDecoration(color: profileBackgroundGrey),
      padding: EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileTopContainer(),
SizedBox(height:  10.h),
            //main section I've defined headings separately 
 
            _buildTitle("My Toolkit"),

            ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
              itemCount: myToolkitItems.length,
              itemBuilder: (context, index) {
              return ProfilePageItem(
                  top:index==0,bottom: index==myToolkitItems.length-1,
                label: myToolkitItems[index],iconPath: myToolkitItemsIconPaths[index],
            onTap: () {
              
            },
              );
            },),
            SizedBox(height: 20.h,),
_buildTitle("Legal & Buisness"),
            ListView.builder(physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: legalaB.length,
              itemBuilder: (context, index) {
              return ProfilePageItem(
                top:index==0,bottom: index==legalaB.length-1,
                label: legalaB[index],iconPath: legalaBIconPaths[index],
            onTap: () {
              switch(index){
                case 0:
                
                break;
                case 1:
                break;
                case 2:
                break;
                case 3:
                break;
              }
            },
              );
            },),
                        SizedBox(height: 20.h,),

            _buildTitle("My Settings"),

            ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
              itemCount: settings.length,
              itemBuilder: (context, index) {
              return ProfilePageItem(
                  top:index==0,bottom: index==settings.length-1,
                label: settings[index],iconPath: sesttingsIconPaths[index],
            onTap: () {
              
            },
              );
            },),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(label){
    return Container(child: Column(children: [
      Text(label, style: TextStyle(fontSize: 18.h, fontWeight: FontWeight.w600,color: const Color.fromARGB(255, 170, 170, 170) ),),
                        SizedBox(height: 10.h,),
    ],),);
  }
}


