// import 'dart:convert';
// import 'dart:io';
// import 'package:bookapp/Controller/BookStoreController.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:typed_data';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
// import 'package:file_picker/file_picker.dart';
//
// import '../Auth/Tokens.dart';
//
// class ReadBookController extends GetxController with SingleGetTickerProviderMixin {
//   final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
//
//   File? file;
//   var isFilePicked = false.obs;
//   Uint8List? bytes;
//   PdfViewerController pdfViewerController = PdfViewerController();
//   String? selectedTextLines;
//   var isSearch = false.obs;
//   TextEditingController controller = TextEditingController();
//   late SharedPreferences prefs;
//   var isLoading = true.obs;
//   var fileUrl = ''.obs;
//   var page = 0.obs;
//
//   var PDFFileBasename = ''.obs;
//   var fileUID = ''.obs;
//   late TabController _tabController;
//   var setLastBookmark = true.obs;
//   var ShowBookmarks = <dynamic>[].obs;
//
//   @override
//   Future<void> onInit() async {
//     super.onInit();
//     _tabController = TabController(length: 2, vsync: this);
//     FetchBookmarks();
//   }
//
//   @override
//   void onClose() {
//     ShowBookmarks.clear();
//     prefs.setInt("Page_read", 0);
//     _tabController.dispose();
//     super.onClose();
//   }
//
//   Future<void> fetchPdfFromNetwork() async {
//     isLoading.value = true;
//     try {
//       final response = await http.get(Uri.parse(BookStoreController.BASE_URL + fileUrl.value), headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Token ${await getToken()}', // Pass token if needed
//       });
//
//       if (response.statusCode == 200) {
//         bytes = response.bodyBytes;
//         final tempDir = await getTemporaryDirectory();
//         file = File(join(tempDir.path, 'downloaded.pdf'));
//         await file!.writeAsBytes(bytes!);
//         isFilePicked.value = true;
//         isLoading.value = false;
//       } else {
//         throw Exception('Failed to load PDF');
//       }
//     } catch (e) {
//       isLoading.value = false;
//       Get.snackbar("Request failed", "Failed to load book file", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
//       rethrow;
//     }
//   }
//
//   Future<void> loadPage() async {
//     prefs = await SharedPreferences.getInstance();
//     if (file != null) {
//       page.value = prefs.getInt("Page_read") ?? 0;
//       if (page.value != 0) {
//         pdfViewerController.jumpToPage(page.value);
//       }
//     }
//   }
//
//   Future<void> savePage() async {
//     if (file != null) {
//       prefs.setInt("Page_read", pdfViewerController.pageNumber);
//     }
//   }
//
//   void handlePickedFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//
//     if (result != null) {
//       file = File(result.files.single.path!);
//       if (file != null) {
//         bytes = file!.readAsBytesSync();
//         isFilePicked.value = true;
//       }
//     } else {
//       // User canceled the picker
//     }
//   }
//
//   Future<void> FetchBookmarks() async {
//     try {
//       final response = await http.get(Uri.parse('${BookStoreController.BASE_URL}/api/bookmarks/${fileUID.value}'), headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Token ${await getToken()}', // Pass token if needed
//       });
//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);
//         ShowBookmarks.assignAll(body);
//         pdfViewerController.jumpToPage(ShowBookmarks.last[3]);
//       } else {
//         throw Exception('Failed to load bookmarks');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<void> SetBookmarks(String name, [String? description]) async {
//     prefs = await SharedPreferences.getInstance();
//     try {
//       final response = await http.post(Uri.parse('${BookStoreController.BASE_URL}/api/bookmarks/${fileUID.value}'), headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Token ${await getToken()}', // Pass token if needed
//       }, body: json.encode({
//         "title": name,
//         "description": description,
//         'page': prefs.getInt("Page_read"),
//       }));
//       if (response.statusCode == 201) {
//         Get.snackbar("Success", "Bookmark added successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
//       } else {
//         throw Exception('Failed to set bookmark');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<void> DeleteBookmark(String uid) async {
//     prefs = await SharedPreferences.getInstance();
//
//     try {
//       final response = await http.delete(Uri.parse('${BookStoreController.BASE_URL}/api/bookmarks/$uid'), headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Token ${await getToken()}', // Pass token if needed
//       });
//
//       if (response.statusCode == 200) {
//         ShowBookmarks.clear();
//         FetchBookmarks();
//         Get.snackbar("Success", "Bookmark delete successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
//       } else {
//         throw Exception('Failed to delete bookmark');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
