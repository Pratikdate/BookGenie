import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/ColorHandler.dart';
import '../../../../../core/IconsHandler.dart';

class ArticleScreen extends StatelessWidget {
  final List<String> categories = [
    "All",
    "History",
    "Political",
    "Science",
    "Technology"
  ];

  _appBarSection() {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  final articles = [
    {
      "id": 1,
      "title": "Budget 2024 Explained Highlights: BJP acknowledges economic distress, need for Centre-state partnership",
      "description": "Union Budget 2024 Explained Highlights: Here is the analysis and explanation of the key terms and announcements, and why they matter.",
      "image_url": "https://images.indianexpress.com/2024/07/Union-Budget-2024-liveExplained_443c2b.jpg?w=750",
      "author": "Jane Doe",
      "author_image_url": "https://cdn.freelogovectors.net/wp-content/uploads/2021/12/the-indian-express-logo-freelogovectors.net_-306x400.png"
    },
    {
      "id": 2,
      "title": "Understanding Climate Change",
      "description": "Explore the impact of climate change on our planet and what we can do to mitigate its effects.",
      "image_url": "https://www.un.org/sites/un2.un.org/files/2021/08/feeling-the-heat.jpg",
      "author": "Alice Johnson",
      "author_image_url": "https://www.un.org/sites/un2.un.org/files/2021/03/un-logo.png"
    },
    {
      "id": 3,
      "title": "Elon Musk gives update on Tesla humanoid robot launch timeline",
      "description": "Tesla's CEO Elon Musk has announced a revised timeline for Optimus, the company's humanoid robot. Initially set for 2024, Optimus will now start low production in 2025.",
      "image_url": "https://static.toiimg.com/thumb/msid-112011302,imgsize-907306,width-400,resizemode-4/112011302.jpg",
      "author": "TOI Tech Desk",
      "author_image_url": "https://cdn.freelogovectors.net/wp-content/uploads/2021/12/the-indian-express-logo-freelogovectors.net_-306x400.png"
    },

    {
      "id": 4,
      "title": "A Path Towards Autonomous Machine Intelligence",
      "description": "How could machines learn as efficiently as humans and animals; learn to reason and plan; learn representations of percepts and action plans at multiple levels of abstraction, enabling them to reason, predict, and plan at multiple time horizons?",
      "image_url": "https://radar.gesda.global/static/e28a4662b1c448e0cde98d63aefcfa22/f6693/a-path-towards-autonomous-machine-intelligence_image__https_3A_2F_2Fpbs.substack.com_2Fmedia_2FFWR6whFX0AMgIxK_jqcncb.png",
      "author": "gesda",
      "author_image_url": "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSi4Ddxln9z9POFipxhX2B1cAFoIIBvJRTfbZlfSi7psvv5E0LZ"
    },

  ];


  _buildSearchMenu() {
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
                hintText: 'Search',
              ),
              onSubmitted: (text_) {},
            ),
          ),
        ),
        SizedBox(width: 24),
        ThreeDotMenuButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHandler.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Color.fromRGBO(51, 51, 51, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  _appBarSection(),
                  _buildSearchMenu(),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  // List of articles
                  ListView.builder(
                    padding: EdgeInsets.only(top: 40),
                    // Add padding to avoid overlap with the category chips
                    itemCount: 4,
                    // Number of articles
                    itemBuilder: (_, index) =>
                        ArticleCard(index: articles[index]),
                  ),
                  // Horizontal list of categories
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(top: 5, bottom: 3),
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0),
                            child: Chip(
                              label: Text(categories[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ArticleCard extends StatelessWidget {
  final  index;

  ArticleCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shadowColor: Colors.transparent,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(index['image_url']), // Placeholder image URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${index['title']}', // Example title
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1),
            Text(
              index['description'],
              style: TextStyle(
                fontSize: 12,
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
                        '${index['author_image_url']}', // Placeholder logo URL
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      index['author'], // Example user
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(8.0),
                //   child: Image.network(
                //     'https://via.placeholder.com/30', // Placeholder article logo URL
                //     height: 30,
                //     width: 30,
                //     fit: BoxFit.cover,
                //   ),
                // ),
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
      icon: Icon(IconHandler.three_dot_menue, color: Colors.white),
    );
  }
}
