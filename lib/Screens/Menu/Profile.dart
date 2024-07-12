import 'package:bookapp/Controller/BookStoreController.dart';
import 'package:bookapp/Screens/Subscreens/UpdateProfile.dart';
import 'package:bookapp/core/ColorHandler.dart';
import 'package:bookapp/core/FontHandler.dart';
import 'package:bookapp/core/IconsHandler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/MenuController/ProfileController.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  ProfileController controller=Get.put(ProfileController());




  _appBarSection(){

    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: (){
          Get.back();
        },
      ),
    );
  }

  _PersonalSection(){

    return Container(
      padding: EdgeInsets.only(top:8 ,left: 8.0,right: 16,bottom: 16),

      decoration: BoxDecoration(
        color: Colors.green,



          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.3,0.5,1],
            colors: [
              Colors.green.shade700,
              Colors.green.shade600,
              Colors.green.shade400,
              Colors.green.shade300,

            ],
          ),


      borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(60),


    ),
      ),
      child: Stack(
        children: [
          Obx(() {
            return Column(
                children: <Widget>[
                _appBarSection(),
            CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('${BookStoreController.BASE_URL}/${controller.profileInfo['image']}'),
            ),
            SizedBox(height: 10),
            Text(
            controller.profileInfo['name'],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
            controller.profileInfo['email'],
            style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 5),
            Text(
              controller.profileInfo['personal_info'],
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        );
  }),

          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              alignment:Alignment.center,
              width: 25.r,
              height: 25.r,
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(100.sp),
              //     color: Colors.green.shade700),
              child: IconButton(
                icon: Icon(
                  IconHandler.alternate_pencil,
                  color: ColorHandler.bgColor,
                  size: 20.r,
                ), onPressed: () { Get.to(()=>UpdateProfileScreen()); },
              ),
            ),
          ),
    ],
      ),
    );
  }


  _activityCard(String src,String title,String subtitle){
    return Card(
      color: Colors.white,
      child: ListTile(

        leading: ClipRRect(borderRadius: BorderRadius.circular(8.0),child: Image.network(src,fit: BoxFit.fill,)),
        title: FontHandler(title, color: ColorHandler.normalFont, textAlign: TextAlign.start,),
        subtitle: FontHandler(subtitle, color: ColorHandler.normalFont, textAlign: TextAlign.start,),
        trailing: Icon(IconHandler.delete, color: ColorHandler.normalFont),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black),

        ),

      ),
    );
  }


  _activitySection(){
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Visited Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _activityCard("https://media.istockphoto.com/id/1887444772/photo/three-diverse-professional-women-in-business-attire-smiling-and-posing-in-an-office.webp?b=1&s=170667a&w=0&k=20&c=Qw3xzprj3QLKjiWJEejZI1Py6eohrsSKaX3a6fy3HrI=","Banking Fraud","SBI 2000 crore froud jjjjjjjjjjjjjjjjjjhhhhhhhhhhhjjjjj"),
            _activityCard("https://media.istockphoto.com/id/1887444772/photo/three-diverse-professional-women-in-business-attire-smiling-and-posing-in-an-office.webp?b=1&s=170667a&w=0&k=20&c=Qw3xzprj3QLKjiWJEejZI1Py6eohrsSKaX3a6fy3HrI=","Banking Fraud","SBI 2000 crore froud jjjjjjjjjjjjjjjjjjhhhhhhhhhhhjjjjj"),
            _activityCard("https://media.istockphoto.com/id/1887444772/photo/three-diverse-professional-women-in-business-attire-smiling-and-posing-in-an-office.webp?b=1&s=170667a&w=0&k=20&c=Qw3xzprj3QLKjiWJEejZI1Py6eohrsSKaX3a6fy3HrI=","Banking Fraud","SBI 2000 crore froud jjjjjjjjjjjjjjjjjjhhhhhhhhhhhjjjjj"),

          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[

          _PersonalSection(),
          _activitySection()

        ],
      ),
    );
  }
}
