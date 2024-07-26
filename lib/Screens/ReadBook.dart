// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:bookapp/Screens/res/PopupForm.dart';
// import 'package:bookapp/core/ColorHandler.dart';
// import 'package:bookapp/core/FontHandler.dart';
// import 'package:http/http.dart' as http;
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Controller/ChatScreenController.dart';
// import '../Controller/ReadBookController.dart';
// import '../core/IconsHandler.dart';
// import 'BookViewScreen.dart';
// import 'ChatBookScreen.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class ReadBook extends StatefulWidget {
//   const ReadBook({super.key});
//
//   @override
//   State<ReadBook> createState() => _ReadBookState();
// }
//
// class _ReadBookState extends State<ReadBook>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   bool isFilePicked = false;
//   late Uint8List bytes;
//   String? selectedTextLines;
//   bool isSearch = false;
//   late SharedPreferences prefs;
//   final ReadBookController controller = Get.put(ReadBookController());
//   final ChatScreenController controller_C = Get.put(ChatScreenController() );
//
//   @override
//   void initState() {
//     super.initState();
//
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(_handleTabChange);
//
//     if (Get.arguments != null && Get.arguments.length >= 2) {
//
//         controller.fileUrl.value = Get.arguments[0];
//         controller.fileUID.value = Get.arguments[1];
//         controller_C.bookUid.value = Get.arguments[1];
//
//
//     } else {
//       print('Arguments are not provided');
//       Get.back();
//     }
//   }
//
//   @override
//   void dispose() {
//
//     super.dispose();
//   }
//
//   void _handleTabChange() {
//     if (!_tabController.indexIsChanging) {
//       // Handle tab change
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.circular(30),
//             ),
//           ),
//           leading: Align(
//             alignment: Alignment.topRight,
//             child: ThreeDotMenuButton(),
//           ),
//           bottom: TabBar(
//             dividerColor: Colors.transparent,
//             indicatorColor: Colors.white,
//             labelColor: Colors.white,
//             controller: _tabController,
//             tabs: const [
//               Tab(text: "Read Book"),
//               Tab(text: "Mr.Chat"),
//             ],
//           ),
//           toolbarHeight: 30,
//           leadingWidth: MediaQuery.of(context).size.width,
//           backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
//         ),
//         body:TabBarView(
//           controller: _tabController,
//           physics: const NeverScrollableScrollPhysics(),
//           children: [
//
//             BookViewScreen(),
//             ChatScreenHandler(),
//
//           ],
//         ),
//
//       ),
//     );
//
//   }
// }
//
// class ThreeDotMenuButton extends StatelessWidget {
//   final ReadBookController controller = Get.put(ReadBookController());
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//
//   Future<void> _handleMenuOption(String option, BuildContext context) async {
//     switch (option) {
//       case "Add Bookmark":
//         _openDialog(context);
//         break;
//       case "Show Bookmarks":
//         // controller.ShowBookmarks.clear();
//         // await controller.FetchBookmarks();
//         break;
//       case "Exit":
//         Get.back();
//         break;
//     }
//   }
//
//   Future<void> _openDialog(BuildContext context) => showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: FontHandler(
//             "Add Bookmark",
//             color: ColorHandler.normalFont,
//             textAlign: TextAlign.left,
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(label: Text('Name')),
//               ),
//               TextField(
//                 controller: descriptionController,
//                 decoration: InputDecoration(
//                     label: Text('Description'), hintText: "Optional"),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 String bookmarkName = nameController.text;
//                 String bookmarkDescription = descriptionController.text;
//                 controller.SetBookmarks(bookmarkName, bookmarkDescription);
//                 nameController.clear();
//                 descriptionController.clear();
//
//                 Navigator.of(context).pop();
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<String>(
//       onOpened: () {
//         controller.ShowBookmarks.clear();
//         controller.FetchBookmarks();
//       },
//       onSelected: (option) => _handleMenuOption(option, context),
//       itemBuilder: (BuildContext context) {
//         return [
//           const PopupMenuItem<String>(
//             value: "Add Bookmark",
//             child: FontHandler(
//               'Add Bookmark',
//               color: ColorHandler.normalFont,
//               textAlign: TextAlign.left,
//             ),
//           ),
//           PopupMenuItem<String>(
//             value: "Show Bookmarks",
//             child: ShowBookmarksButton(),
//           ),
//           PopupMenuItem<String>(
//             value: "Exit",
//             child: FontHandler(
//               'Exit',
//               color: ColorHandler.normalFont,
//               textAlign: TextAlign.left,
//             ),
//           ),
//         ];
//       },
//       icon: Icon(
//         IconHandler.three_dot_menue,
//         color: Colors.white,
//       ),
//     );
//   }
// }
//
// class ShowBookmarksButton extends StatelessWidget {
//   final ReadBookController controller = Get.put(ReadBookController());
//
//   Future<void> _handleMenuOption(String option, BuildContext context) async {
//     Navigator.pop(context);
//   }
//
//
//   Widget bookmarkCard(String text, String disc, int page, String bookmarkId,BuildContext context) {
//     return ListTile(
//       onTap: (){
//         controller.pdfViewerController.jumpToPage(page);
//         Navigator.pop(context);
//
//         },
//       dense: true,
//       visualDensity: const VisualDensity(vertical: -3,),
//       //leading: ClipRRect(borderRadius: BorderRadius.circular(1.0)),
//       title: FontHandler(
//         text,
//         color: ColorHandler.normalFont,
//         textAlign: TextAlign.left,
//         fontsize: 14,
//         fontweight: FontWeight.bold,
//       ),
//       subtitle: FontHandler(
//         disc,
//         color: ColorHandler.normalFont,
//         textAlign: TextAlign.left,
//         fontsize: 8,
//       ),
//       trailing: IconButton(
//         icon: const Icon(
//           IconHandler.delete,
//           size: 20,
//         ),
//         onPressed: () {
//           controller.DeleteBookmark(bookmarkId);
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<String>(
//       onSelected:(option)=> _handleMenuOption(option,context),
//       itemBuilder: (BuildContext context) {
//         if (controller.ShowBookmarks.isEmpty) {
//           return [""].map((dynamic choice) {
//             return PopupMenuItem<String>(
//               value: choice,
//               child: Text("Bookmark not found"),
//             );
//           }).toList();
//         } else {
//           return controller.ShowBookmarks.map((dynamic choice) {
//             return PopupMenuItem<String>(
//
//               value: choice[1],
//               child: bookmarkCard(choice[1], choice[2], choice[3], choice[0],context),
//             );
//           }).toList();
//         }
//       },
//       child: const FontHandler(
//         "Show Bookmarks",
//         color: ColorHandler.normalFont,
//         textAlign: TextAlign.left,
//       ),
//     );
//   }
// }
