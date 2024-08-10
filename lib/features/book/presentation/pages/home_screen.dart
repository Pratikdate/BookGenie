
import 'package:bookapp/features/book/presentation/controllers/book_controller.dart';
import 'package:bookapp/features/book/presentation/controllers/menu_controllers/userprofile_controller.dart';
import 'package:bookapp/features/book/presentation/pages/present_book_view_screen.dart';
import 'package:bookapp/features/book/presentation/pages/tabs_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math'as math;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import '../../dependency_injection.dart';
import '../../domain/ entities/book.dart';
import '../controllers/tab_controller.dart';
import '../widgets/refresh_indicator.dart';
import 'menu_pages/animation_videos.dart';
import 'menu_pages/articles.dart';
import 'menu_pages/go_preminum.dart';
import 'menu_pages/my_bookmarks.dart';
import 'menu_pages/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  static const ANIMATION_DURATION = 500;
  static const BUTTON_HEIGHT = 58.0;
  static const RADIUS = 24.0;
  static const HORIZONTAL_PADDING = 24.0;
  static const BOOKSHELF_PAGE_HEIGHT = 354.0;

  late AnimationController _controller;
  late Animation<double> valueTween;
  late Animation<Color> colorTween;
  late Animation<double> tabHeightAnim;
  static late Animation<double> popularPageHeight;
  static late Animation<double> bookshelfPageHeight;
  late Animation<Color> grayToWhite;
  late Animation<Color> whiteToGray;
  late Animation<Color> popularLabelColor;
  late Animation<Color> bookShelfLabelColor;
  late Animation<double> valueAnimation;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late BookController controller;
  late TabSController tab_controller;
  late UserprofileController controllerprofile;

  //controllers
  late ScrollController bookshelfController;
  late ScrollController popularController;

  final gray = Color(0xffdbe1ed);
  final white = Colors.white;
  final closedLabelColor = Color(0xff9fa5b2);

  @override
  void dispose() {
    // Dispose any resources or controllers that you have initialized
    bookshelfController.dispose();
    popularController.dispose();
    _controller.dispose();
    controller.dispose();
    tab_controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    bookshelfController = ScrollController()
      ..addListener(handleBookshelfScrolling);
    popularController = ScrollController()
      ..addListener(handlePopularBookScrolling);
    controllerprofile = Get.find();
    controller = Get.find();
    tab_controller=Get.find();
  }

  _init() {
    final screenHeight = MediaQuery.of(context).size.height;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: ANIMATION_DURATION),
    );
    CurvedAnimation parent = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
      reverseCurve: Curves.ease,
    );

    bookshelfPageHeight = Tween<double>(
      end: BUTTON_HEIGHT,
      begin: BOOKSHELF_PAGE_HEIGHT,
    ).animate(parent);

    final minPopularPageHeight = BOOKSHELF_PAGE_HEIGHT + BUTTON_HEIGHT;

    final maxTabHeight = minPopularPageHeight;
    final minTabHeight = screenHeight / 3.5;

    tabHeightAnim = Tween<double>(
      begin: maxTabHeight,
      end: minTabHeight,
    ).animate(parent);

    valueAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(parent);
  }

  void handleBookshelfScrolling() {
    if (bookshelfController.offset >=
        bookshelfController.position.maxScrollExtent) {
      controller.fetchBookShelf(count: controller.booksInShelf.length + 3);
    }
    // if (bookshelfController.offset <=
    //         bookshelfController.position.minScrollExtent &&
    //     !bookshelfController.position.outOfRange) {
    //   print(bookshelfController.position.minScrollExtent);
    // }
  }

  void handlePopularBookScrolling() {
    if (popularController.offset >=
        popularController.position.maxScrollExtent) {
      controller.fetchBookInPopular(
          count: controller.booksInPopular.length + 3);
    }
  }

  _forward() => _controller.forward();

  _reverse() => _controller.reverse();

  _buildSearchMenu() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
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
        IconButton(
            onPressed: () {
              controllerprofile.fetchUserProfile();
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 30,
            ))
      ],
    );
  }

  _buildTabIndicator() {
    return Row(
      children: Iterable.generate(
        4,
        (index) => Container(
          margin: EdgeInsets.all(4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 2 ? Colors.white : Colors.grey.withOpacity(0.3),
          ),
        ),
      ).toList(),
    );
  }

  _buildTabTitle() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Opacity(opacity: 0.6, child: _caroserTabSlider()),
          Transform.scale(
            alignment: Alignment.centerLeft,
            scale: valueAnimation.value,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8 * valueAnimation.value),
              child: Text(
                "New 93 books",
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const Text(
            "A Journey of \n a Thousand Words.",
            style: TextStyle(
                overflow: TextOverflow.fade,
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      // Positioned(
      //   bottom: 32,
      //   left: 0,
      //   right: 0,
      //   child: Row(
      //     children: <Widget>[
      //       Spacer(
      //         flex: 1000,
      //       ),
      //       //_buildTabIndicator(),
      //       Spacer(
      //         flex: (1001 - (1 - valueAnimation.value) * 1000).toInt(),
      //       )
      //     ],
      //   ),
      // )
    );
  }

  _buildTab() {
    final height = tabHeightAnim.value + 32;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('asset/image/tab.png'),
            fit: BoxFit.cover,
          ),
        ),
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: SafeArea(
            child: Column(
              // Use Column as the Flex container
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: <Widget>[
                _buildSearchMenu(),

                Expanded(
                    flex: 1,
                    child: _buildTabTitle()), // Expanded is now inside Column
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabSliderCard(String imgURL, String text) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.white38),
      // ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Align children at the top
        children: [
          Container(
            width: 120,
            height: 120, // Adjust height as needed
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(imgURL),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10), // Add spacing between image and text
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                text,
                softWrap: true,
                style: const TextStyle(
                  color: Colors.white38,
                ),
                overflow: TextOverflow.ellipsis, // Handle text overflow
                maxLines: 5, // Limit maximum lines of text
              ),
            ),
          )
        ],
      ),
    );
  }

  _caroserTabSlider() {
    return Transform.scale(
      alignment: Alignment.center,
      scale: valueAnimation.value,
      child: CarouselSlider(
        items: [
          _tabSliderCard(
              "https://media.istockphoto.com/id/1887444772/photo/three-diverse-professional-women-in-business-attire-smiling-and-posing-in-an-office.webp?b=1&s=170667a&w=0&k=20&c=Qw3xzprj3QLKjiWJEejZI1Py6eohrsSKaX3a6fy3HrI=",
              "Carousel Slider is one of the most popular image slider used nowadays in most apps. These Carousel Sliders are mostly seen in various eCommerce"),
          _tabSliderCard("https://www.ibef.org/assets/images/banking-2.jpg",
              "As per the Reserve Bank of India (RBI), India’s banking sector is sufficiently capitalised and well-regulated.")

          //3rd Image of Slider
          // Container(
          //   margin: EdgeInsets.all(6.0),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(8.0),
          //     image: DecorationImage(
          //       image: NetworkImage("https://media.istockphoto.com/id/1887444772/photo/three-diverse-professional-women-in-business-attire-smiling-and-posing-in-an-office.webp?b=1&s=170667a&w=0&k=20&c=Qw3xzprj3QLKjiWJEejZI1Py6eohrsSKaX3a6fy3HrI="),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          //
        ],

        //Slider Container properties
        options: CarouselOptions(
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 1200),
          viewportFraction: 1,
        ),
      ),
    );
  }

  _buildTitle(String title, Color titleColor, double animValue,
      {required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
        height: BUTTON_HEIGHT,
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: titleColor,

              ),

            ),
            Expanded(
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Opacity(
                    opacity: 1 - animValue,
                    child: Text(
                      "See all",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: animValue,
                    child: Text(
                      "Open section",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: closedLabelColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItem(Book book) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Get.to(() => const PresentBookViewScreen(),
                  arguments: [book],
                  duration: Duration(milliseconds: 1000),
                  binding: DependencyBinding());
            },
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 84,
                  child: AspectRatio(
                    aspectRatio: 384 / 614,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        book.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            book.name ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '',
                            //"\$ ${book.price}",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        book.author ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.pink,
                          ),
                          SizedBox(width: 2),
                          Text(
                            '7',
                            //"${book.rating}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  _buildPopularPage() {
    return Positioned(
      top: tabHeightAnim.value,
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(
            color: Colors.black,
            blurRadius: 2.0,
          ),],
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(RADIUS),
              topRight: Radius.circular(RADIUS * (1 - valueAnimation.value))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTitle(
              "Popular page",
              Colors.orange,
              valueAnimation.value,
              onTap: _forward,
            ),
            Obx(() {
              return Expanded(
                child: CheckMarkIndicator(
                  onRefresh:() async =>await controller.refreshBookInPopular(),
                  child: ListView.builder(
                    controller: popularController,
                    padding: const EdgeInsets.only(top: 6, bottom: BUTTON_HEIGHT + 6),
                    shrinkWrap: true,
                    itemBuilder: (_, index) =>
                        _buildPopularItem(controller.booksInPopular[index]),
                    itemCount: controller.booksInPopular.length,
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildBookshelfItem(Book book) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () {
          Get.to(() => const PresentBookViewScreen(),
              arguments: [book],
              duration: Duration(milliseconds: 1000),
              binding: DependencyBinding());
        },
        child: SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 384 / 614,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    book.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                height: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.topLeft,
                      widthFactor: 0 / 100.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // SizedBox(height: 10),
              Text(
                book.name ?? "",
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 2),
              Text(
                book.author ?? "",
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBookshelfPage() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: const BoxDecoration(

          boxShadow: [BoxShadow(
            color: Colors.black,
            blurRadius: 2.0,
          ),],
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(RADIUS),
            topRight: Radius.circular(RADIUS),
          ),
        ),
        height: bookshelfPageHeight.value,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 8),
          children: <Widget>[
            _buildTitle(
              "Bookshelf",
              Colors.black45,
              1 - valueAnimation.value,
              onTap: _reverse,
            ),

            Obx(() {
              return
                CheckMarkIndicator(
                  onRefresh:() async =>await controller.refreshBookShelf(), // Your refresh logic

                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: bookshelfController,
                  padding: const EdgeInsets.only(left: HORIZONTAL_PADDING),
                  child: Row(
                    children: controller.booksInShelf
                        .map((it) => _buildBookshelfItem(it))
                        .toList(),
                  ),
                ),

            );
             })
          ],
        ),
      ),
    );
  }


  _drawer() {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
              margin: const EdgeInsets.all(0),
              decoration: const BoxDecoration(
                color: Colors.green,
              ), //BoxDecoration
              child: Obx(() {
                return UserAccountsDrawerHeader(
                    margin: const EdgeInsets.only(bottom: 0),
                    decoration: const BoxDecoration(color: Colors.green),
                    accountName: Text(
                      controllerprofile.userProfile.value.name ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    accountEmail:
                        Text(controllerprofile.userProfile.value.email ?? ""),
                    currentAccountPictureSize: const Size.square(50),
                    currentAccountPicture: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 165, 255, 137),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              controllerprofile.userProfile.value.image ?? ''),
                        )));
              }) //circleAvatar

              ), //DrawerHeader
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(' My Profile '),
            onTap: () {
              Navigator.pop(context);
              Get.to(ProfileScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text(' My Books'),
            onTap: () {
              Navigator.pop(context);
              Get.to(MyBookScreen(), binding: DependencyBinding());
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Upload Book'),
            onTap: () async {
              tab_controller.isFilePicked.value=false;
              await tab_controller.handlePickedFile();
              Get.to(()=>const BookTabScreen(),binding:DependencyBinding());



            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text(' Article'),
            onTap: () {
              Navigator.pop(context);
              Get.to(ArticleScreen(),binding:DependencyBinding() );
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_label),
            title: const Text(' Animated Videos '),
            onTap: () {
              Navigator.pop(context);
              Get.to(AnimatedVideos());
            },
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text(' Go Premium '),
            onTap: () {
              Navigator.pop(context);
              Get.to(GoPremium());
            },
          ),

          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(' Write Something'),
            onTap: () {
              //Get.to(WriteSomething());
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ); //Draw
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: _drawer(),
      body: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _buildTab(),
                _buildPopularPage(),
                _buildBookshelfPage(),
              ],
            );
          }),
    );
  }
}

//
// class Book {
//   final String name;
//   final String author;
//   final int progress;
//   final String image;
//   final String price;
//   final double rating;
//
//   Book({
//     required this.name,
//     required this.author,
//     required this.progress,
//     required this.image,
//     this.price = "",
//     this.rating = 0.0,
//   });
// }
//
// final booksInShelf = [
//   Book(
//     name: "Cleansed by dead",
//     author: "Catherine finger",
//     progress: 50,
//     image: "asset/image/1.jpg",
//   ),
//   Book(
//     name: "A thin veil",
//     author: "Jane Gorman",
//     progress: 34,
//     image: "asset/image/2.jpg",
//   ),
//   Book(
//     name: "Be mine",
//     author: "Rick mofina",
//     progress: 38,
//     image: "asset/image/3.jpg",
//   ),
//   Book(
//     name: "Rick mofina",
//     author: "Before sunrise",
//     progress: 94,
//     image: "asset/image/4.jpg",
//   ),
//   Book(
//     name: "Bullet in the blue sky",
//     author: "Bill larkin",
//     progress: 80,
//     image: "asset/image/5.jpg",
//   ),
// ];
//
// final booksInPopular = [
//   Book(
//     name: "Cleansed by dead",
//     author: "Catherine finger",
//     progress: 50,
//     image: "asset/image/7.jpg",
//     rating: 8.2,
//     price: "9.95",
//   ),
//   Book(
//     name: "A thin veil",
//     author: "Jane Gorman",
//     progress: 34,
//     image: "asset/image/8.jpg",
//     rating: 8.2,
//     price: "11.95",
//   ),
//   Book(
//     name: "Be mine",
//     author: "Rick mofina",
//     progress: 38,
//     image: "asset/image/9.jpg",
//     rating: 9.2,
//     price: "8.95",
//   ),
//   Book(
//     name: "Rick mofina",
//     author: "Before sunrise",
//     rating: 6.4,
//     price: "6.95",
//     progress: 94,
//     image: "asset/image/10.jpg",
//   ),
//   Book(
//     name: "Bullet in the blue sky",
//     rating: 7.4,
//     price: "12.95",
//     author: "Bill larkin",
//     progress: 80,
//     image: "asset/image/11.jpg",
//   ),
//   Book(
//     name: "Bullet in the blue sky",
//     author: "Bill larkin",
//     progress: 80,
//     image: "asset/image/12.jpg",
//     rating: 8.2,
//     price: "8.99",
//   ),
//   Book(
//     name: "Bullet in the blue sky",
//     author: "Bill larkin",
//     progress: 80,
//     image: "asset/image/13.jpg",
//     rating: 8.2,
//     price: "8.99",
//   ),
// ];
//
//
