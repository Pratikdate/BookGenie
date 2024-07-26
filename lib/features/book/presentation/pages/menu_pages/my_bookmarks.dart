
import 'package:bookapp/core/ColorHandler.dart';
import 'package:bookapp/core/IconsHandler.dart';
import 'package:bookapp/features/book/presentation/controllers/bookmark_controller.dart';
import 'package:bookapp/features/book/presentation/pages/present_book_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants.dart';
import '../../../dependency_injection.dart';
import '../../../domain/ entities/book.dart';
import '../../../domain/ entities/bookmark.dart';


class MyBookScreen extends StatefulWidget {
  @override
  _MyBookScreenState createState() => _MyBookScreenState();
}

class _MyBookScreenState extends State<MyBookScreen> {
  late BookmarkController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<BookmarkController>();
    controller.fetchListBookmarks();
  }

  AppBar _appBarSection() {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  Widget _buildSearchMenu() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 20),
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: 'Search'),
              onSubmitted: (text_) {},
            ),
          ),
        ),
        SizedBox(width: 24),
        ThreeDotMenuButton(),
      ],
    );
  }

  Widget bookmarkCard(Book data) {
    return GestureDetector(
      onTap: ()=>Get.to(()=>const PresentBookViewScreen(), arguments: [data],duration: Duration(milliseconds: 1000),binding: DependencyBinding()),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(data.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8,top: 8),
              child: Text(
                data.name??"",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                data.author??"",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: ColorHandler.normalFont,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              child: Column(
                children: [
                  _appBarSection(),
                  _buildSearchMenu(),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: controller.bookmarkInfo.length,
                itemBuilder: (context, index) =>
                    bookmarkCard(controller.bookmarkInfo[index]),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class ThreeDotMenuButton extends StatelessWidget {
  void _handleMenuOption(String option) {
    // Handle the selected menu option
    print('Selected option: $option');
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: _handleMenuOption,
      itemBuilder: (BuildContext context) {
        return {'Option 1', 'Option 2', 'Option 3'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
      icon: Icon(IconHandler.three_dot_menue, color: Colors.white),
    );
  }
}
