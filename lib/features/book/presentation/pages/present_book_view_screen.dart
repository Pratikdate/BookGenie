import 'package:bookapp/core/IconsHandler.dart';
import 'package:bookapp/features/book/presentation/pages/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/ColorHandler.dart';
import '../../../../core/FontHandler.dart';
import '../../dependency_injection.dart';
import 'audio_book_screen.dart';

class PresentBookViewScreen extends StatefulWidget {
  const PresentBookViewScreen({super.key});

  @override
  State<PresentBookViewScreen> createState() => _PresentBookViewScreenState();
}

class _PresentBookViewScreenState extends State<PresentBookViewScreen> {

  final bookImage=Get.arguments[0].image;
  final name=Get.arguments[0].name;
  final description=Get.arguments[0].description;
  final author=Get.arguments[0].author;
  final published=Get.arguments[0].published;
  @override
  void initState() {
    super.initState();

  }

  _appBarSection(){

    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(IconHandler.angle_left, color: ColorHandler.normalFont),
        onPressed: (){
          Get.back();
        },
      ),
    );
  }

  _couverSection(){

    return Container(

      height: MediaQuery.of(context).size.height/1.4,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(bookImage),fit: BoxFit.fill) ,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(60),

        ),
      ),
      child:_appBarSection() ,
    );
  }

  _bookInfoSection(){
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            FontHandler(
              name,
              color: ColorHandler.normalFont,
              textAlign: TextAlign.left,
              fontsize: 24,
              fontweight: FontWeight.bold,
            ),
            Text(
              description,
              softWrap: true,
              style: const TextStyle(
                color: ColorHandler.normalFont,
              ),
              overflow: TextOverflow.ellipsis, // Handle text overflow
              maxLines: 4, // Limit maximum lines of text
            ),
            Row(
              children: [
                FontHandler(
                  "by ${author}",
                  color: ColorHandler.normalFont,
                  textAlign: TextAlign.left,
                  fontsize: 18,
                  fontweight: FontWeight.bold,
                ),
                Spacer(),
                FontHandler(
                  published,
                  color: ColorHandler.normalFont,
                  textAlign: TextAlign.left,
                  fontsize: 18,
                ),
              ],
            )


          ],
        ),
      ),
    );
  }

  _NavSection(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(

        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                Colors.deepOrange,
                minimumSize: Size(40.sp, 40.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.sp),
                ),
              ),
              onPressed: () {
                Get.to(AudiobookScreen(),arguments: [Get.arguments[0]]);

              },
              child: Row(
                children: [
                  Icon(IconHandler.Audiobook,color: Colors.white,),
                  SizedBox(width:10),
                  Text(
                    "Audio book",
                    style: TextStyle(
                        color: ColorHandler.bgColor, fontSize: 20.sp),
                  )
                ],
              )),
          Spacer(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                Colors.deepOrange,
                minimumSize: Size(40.sp, 40.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.sp),
                ),
              ),
              onPressed: () {
                Get.to(()=>const BookTabScreen(),arguments: [Get.arguments[0].fileUrl,Get.arguments[0].uid],binding: DependencyBinding() );

              },
              child: Row(
                children: [
                  Icon(IconHandler.chat,color: Colors.white,),
                  SizedBox(width:10),
                  Text(
                    "book",
                    style: TextStyle(
                        color: ColorHandler.bgColor, fontSize: 20.sp),
                  )
                ],
              )),
        ],
      ),
    );
  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,


        children: <Widget>[
          _couverSection(),


          _bookInfoSection(),
          _NavSection(),

        ],
      ),
    );
  }
}
