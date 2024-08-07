// // import 'dart:convert';
// // import 'package:get/get.dart';
// // import 'package:http/http.dart' as http;
// // import '../../Auth/Tokens.dart';
// // import '../BookStoreController.dart';
// //
// // class MyBooksController extends GetxController {
//   var bookmarkInfo = <dynamic>[].obs;
//
//   Future<void> FetchListBookmarks() async {
//     try {
//       final response = await http.get(
//         Uri.parse('${BookStoreController.BASE_URL}/api/bookmarks/'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Token ${await getToken()}',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> body = json.decode(response.body);
//         bookmarkInfo.assignAll(body);
//
//       } else {
//         // Handle other status codes
//         print('Error: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       // Handle exception
//       print('Exception: $e');
//     }
//   }
// }
