import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/ColorHandler.dart';
import '../../../../../core/IconsHandler.dart';

class AnimatedVideos extends StatelessWidget {
  final List<String> categories = ["All", "Spiritual",  "Epics", "History","Science",];

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

  final articles=[
    {
      "id": 1,
      "title": "Siddhartha Part Two: The Ferryman Summary & Analysis",
      "description": "Having resolved to live a new life by the river, Siddhartha soon meets the ferryman, the same one who had helped Siddhartha cross the river years before. ",
      "image_url": "https://koala.sh/api/image/v2-620fm-t6xvb.jpg?width=1216&height=832&dream",
      "author": "Jane Doe",
      "author_image_url": "https://cdn.freelogovectors.net/wp-content/uploads/2021/12/the-indian-express-logo-freelogovectors.net_-306x400.png"
    },
    {
      "id": 2,
      "title": "The Story of My Experiments with Truth Part-1 Birth And Parentage",
      "description": "The Story of My Experiments with Truth is the autobiography of Mahatma Gandhi, covering his life from early childhood through to 1921.",
      "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxYC-t3VtLdbvma96jO6fzGn06vlwpGCAFnQ&s",
      "author": "Alice Johnson",
      "author_image_url": "https://www.un.org/sites/un2.un.org/files/2021/03/un-logo.png"
    },
    {
      "id": 3,
      "title": "The American Revolution Part-1",
      "description": "The American Revolution came about due to growing tensions between the American colonies and Great Britain, primarily over issues of taxation and representation",
      "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8hfjmzPGL3XTiv7p56xcBp57bgqLxsLS30w&s",
      "author": "TOI Tech Desk",
      "author_image_url": "https://cdn.freelogovectors.net/wp-content/uploads/2021/12/the-indian-express-logo-freelogovectors.net_-306x400.png"


    },

    {
      "id": 4,
      "title": "Prayag Ramayana Part-5",
      "description": "The epic narrates the life of Rama, a prince of Ayodhya in the kingdom of Kosala. The epic follows his fourteen-year exile to the forest urged",
      "image_url": "https://static2.tripoto.com/media/filter/nl/img/1728/SpotDocument/1476093447_3798300550_a14669ce29_o.jpg.webp",
      "author": "Bob Brown",
      "author_image_url": "https://via.placeholder.com/30?text=BB"
    }
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
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 3),
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
                itemBuilder: (_, index) =>ArticleCard( index: articles[index],),

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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Row(
            //       children: <Widget>[
            //         ClipRRect(
            //           borderRadius: BorderRadius.circular(8.0),
            //           child: Image.network(
            //             '${index['author_image_url']}', // Placeholder logo URL
            //             height: 30,
            //             width: 30,
            //             fit: BoxFit.cover,
            //           ),
            //         ),
            //         SizedBox(width: 10),
            //         Text(
            //           index['author'], // Example user
            //           style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ],
            //     ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(8.0),
                //   child: Image.network(
                //     'https://via.placeholder.com/30', // Placeholder article logo URL
                //     height: 30,
                //     width: 30,
                //     fit: BoxFit.cover,
                //   ),
                // ),
          //     ],
          //   ),
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