// import 'package:bookapp/Controller/BookStoreController.dart';
// import 'package:bookapp/Screens/BookHomeScreen.dart';
// import 'package:bookapp/Screens/ReadBook.dart';
// import 'package:bookapp/core/ColorHandler.dart';
// import 'package:bookapp/core/FontHandler.dart';
// import 'package:bookapp/core/IconsHandler.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../Controller/MenuController/MyBooksController.dart';
//
// class MyBookScreen extends StatefulWidget {
//   @override
//   _MyBookScreenState createState() => _MyBookScreenState();
// }
//
// class _MyBookScreenState extends State<MyBookScreen> {
//   late MyBooksController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(MyBooksController());
//     controller.FetchListBookmarks();
//   }
//
//   AppBar _appBarSection() {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       centerTitle: true,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: () {
//           Get.back();
//         },
//       ),
//     );
//   }
//
//   Widget _buildSearchMenu() {
//     return Row(
//       children: <Widget>[
//         Expanded(
//           child: Container(
//             margin: EdgeInsets.only(left: 20),
//             padding: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: TextField(
//               decoration: const InputDecoration(
//                   icon: Icon(Icons.search),
//                   border: InputBorder.none,
//                   hintText: 'Search'),
//               onSubmitted: (text_) {},
//             ),
//           ),
//         ),
//         SizedBox(width: 24),
//         ThreeDotMenuButton(),
//       ],
//     );
//   }
//
//   Widget bookmarkCard(dynamic data) {
//     return GestureDetector(
//       onTap: ()=>Get.to(()=>ReadBook(),arguments: ['/media/${data[7]}',data[0]]),
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               height: 220,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(10.0),
//                   topRight: Radius.circular(10.0),
//                 ),
//                 image: DecorationImage(
//                   image: NetworkImage('${BookStoreController.BASE_URL}/media/${data[6]}'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0,right: 8,top: 8),
//               child: Text(
//                 data[1],
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Text(
//                 data[2],
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
//         child: Column(
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.only(bottom: 20),
//               decoration: BoxDecoration(
//                 color: ColorHandler.normalFont,
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(10),
//                     bottomRight: Radius.circular(10)),
//               ),
//               child: Column(
//                 children: [
//                   _appBarSection(),
//                   _buildSearchMenu(),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Obx(() => GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 8.0,
//                   mainAxisSpacing: 8.0,
//                   childAspectRatio: 2 / 3,
//                 ),
//                 itemCount: controller.bookmarkInfo.length,
//                 itemBuilder: (context, index) =>
//                     bookmarkCard(controller.bookmarkInfo[index][0]),
//               )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ThreeDotMenuButton extends StatelessWidget {
//   void _handleMenuOption(String option) {
//     // Handle the selected menu option
//     print('Selected option: $option');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<String>(
//       onSelected: _handleMenuOption,
//       itemBuilder: (BuildContext context) {
//         return {'Option 1', 'Option 2', 'Option 3'}.map((String choice) {
//           return PopupMenuItem<String>(
//             value: choice,
//             child: Text(choice),
//           );
//         }).toList();
//       },
//       icon: Icon(IconHandler.three_dot_menue, color: Colors.white),
//     );
//   }
// }
