import 'package:get/get.dart';

import '../Model/BookStoreModel.dart';

class BookStoreController extends GetxController with SingleGetTickerProviderMixin {
  var isLoading = true.obs;
  static String BASE_URL="notification-mostly-ni-federal.trycloudflare.com";  //"http://192.168.74.145:8000";



  @override
  void onInit() {
    super.onInit();
    BookStoreModel.BookShelfModel();
    BookStoreModel.booksInPopularModel();

  }
  final booksInShelf = List<Book>.filled(3,Book(
    name: "",
    author: "",
    progress: 0,
    image: "https://i.pinimg.com/564x/f7/fd/65/f7fd65f7361a917f0d0d81fc59a2b452.jpg",
    fileUrl:""
  ),growable: false).obs;

      //<Book>[
    // Book(
    //   name: "Cleansed by dead",
    //   author: "Catherine finger",
    //   progress: 50,
    //   image: "asset/image/1.jpg",
    // ),
    // Book(
    //   name: "A thin veil",
    //   author: "Jane Gorman",
    //   progress: 34,
    //   image: "asset/image/2.jpg",
    // ),
    // Book(
    //   name: "Be mine",
    //   author: "Rick mofina",
    //   progress: 38,
    //   image: "asset/image/3.jpg",
    // ),
    // Book(
    //   name: "Rick mofina",
    //   author: "Before sunrise",
    //   progress: 94,
    //   image: "asset/image/4.jpg",
    // ),
    // Book(
    //   name: "Bullet in the blue sky",
    //   author: "Bill larkin",
    //   progress: 80,
    //   image: "asset/image/5.jpg",
    // ),
  //].obs;

  final booksInPopular = List<Book>.filled(3,Book(
    name: "",
    author: "",
    progress: 0,
    image: "https://i.pinimg.com/564x/f7/fd/65/f7fd65f7361a917f0d0d81fc59a2b452.jpg",
    rating: 0,
    price: "0",
  ),growable: false).obs;
  // [
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
  // ].obs;



}

class Book {
  final String uid;
  final String name;
  final String author;
  final int progress;
  final String image;
  final String fileUrl;
  final String price;
  final double rating;

  Book( {
    required this.name,
    required this.author,
    required this.progress,
    required this.image,
    this.price = "",
    this.uid='',
    this.rating = 0.0,
    this.fileUrl=''


  });
}
