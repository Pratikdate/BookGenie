// import 'package:get/get.dart';
//
// import '../Model/BookStoreModel.dart';
//
// class BookStoreController extends GetxController with SingleGetTickerProviderMixin {
//   var isLoading = true.obs;
//   static String BASE_URL= "http://192.168.74.145:8000";
//   late List<Book> booksInShelf ;
//   late List<Book> booksInPopular ;
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     booksInShelf = List<Book>.filled(3,Book(
//     name: "",
//     author: "",
//     progress: 0,
//     image: "https://i.pinimg.com/564x/f7/fd/65/f7fd65f7361a917f0d0d81fc59a2b452.jpg",
//     fileUrl:""
//     ),growable: false).obs;
//
//     booksInPopular = List<Book>.filled(3,Book(
//       name: "",
//       author: "",
//       progress: 0,
//       image: "https://i.pinimg.com/564x/f7/fd/65/f7fd65f7361a917f0d0d81fc59a2b452.jpg",
//       rating: 0,
//       price: "0",
//     ),growable: false).obs;
//
//   }
//
//
//
// }
//
// class Book {
//   final String uid;
//   final String name;
//   final String author;
//   final int progress;
//   final String description;
//   final String image;
//   final String fileUrl;
//   final String price;
//   final double rating;
//   final String published;
//
//   Book(   {
//     required this.name,
//     required this.author,
//     required this.progress,
//     required this.image,
//     this.description="",
//     this.price = "",
//     this.published="",
//     this.uid='',
//     this.rating = 0.0,
//     this.fileUrl=''
//
//
//   });
// }
