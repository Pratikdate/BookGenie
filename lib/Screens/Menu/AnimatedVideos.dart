import 'package:flutter/material.dart';

import '../../core/ColorHandler.dart';
import '../../core/FontHandler.dart';
import '../../core/IconsHandler.dart';
import 'package:get/get.dart';


class AnimatedVideos extends StatelessWidget {
  final List<String> categories = ["All", "History", "Political", "Science", "Technology"];

  _appBarSection(){
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      //title: FontHandler("Anima", color: Colors.white, textAlign: TextAlign.left,),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: (){
          Get.back();
        },
      ),
    );
  }

  _buildSearchMenu() {
    return Row(

      children: <Widget>[

        Expanded(
          child: Container(
              margin: EdgeInsets.only(left: 20),

              padding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 0,
              ),
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
              )),
        ),
        SizedBox(width: 24),
        ThreeDotMenuButton()
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[

            Container(
              padding: EdgeInsets.only(bottom: 20,),
              decoration: BoxDecoration(
                  color: ColorHandler.normalFont,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))

              ),
              child: Column(
                children: [
                  _appBarSection(),
                  _buildSearchMenu(),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5,bottom: 3),
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(
                      label: Text(categories[index]),
                    ),
                  );
                },
              ),
            ),
            // Article Cards
            Expanded(
              child: ListView.builder(
                itemCount: 4, // Number of articles
                itemBuilder: (context, index) {
                  return ArticleCard(index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final int index;

  ArticleCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/300'), // Placeholder image URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Article Title $index',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              'About this article...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'https://via.placeholder.com/30', // Placeholder logo URL
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Posted by User $index',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://via.placeholder.com/30', // Placeholder article logo URL
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
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
      icon: Icon(IconHandler.three_dot_menue,color: Colors.white,),
    );
  }
}