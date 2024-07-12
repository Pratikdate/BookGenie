import 'dart:convert';
import 'dart:io';
import 'package:bookapp/Controller/BookStoreController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

import '../Auth/Tokens.dart';

class ReadBookController extends GetxController with SingleGetTickerProviderMixin {
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();

  File? file;
  bool isFilePicked = false;
  Uint8List? bytes;
  PdfViewerController pdfViewerController = PdfViewerController();
  String? selectedTextLines;
  var isSearch = false.obs;
  TextEditingController controller = TextEditingController();
  late SharedPreferences prefs;
  var isLoading = true.obs;
  static String fileUrl = '';
  int? page;

  static String PDFFileBasename = '';
  static String fileUID = '';
  late TabController _tabController;

  @override
  void onInit() {
    super.onInit();
    _tabController = TabController(length: 2, vsync: this);
    fetchPdfFromNetwork(fileUrl);
    FetchBookmarks();

  }

  void onClose() {
    // TODO: implement onClose

    prefs.setInt("Page_read", 0);
    super.onClose();

  }



  Future<void> fetchPdfFromNetwork(String url) async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(BookStoreController.BASE_URL+url),headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}' , // Pass token if needed
      });
      if (response.statusCode == 200) {
        bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        file = File(join(tempDir.path, 'downloaded.pdf'));

        await file!.writeAsBytes(bytes!);
        isFilePicked = true;
        isLoading.value = false;
        update();
      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Request failed", "Failed to load book file", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);

      print("In catch section");
      rethrow;
    }
  }

  Future<void> loadPage() async {
    prefs = await SharedPreferences.getInstance();
    if (file != null) {
      page = prefs.getInt("Page_read");
      if (page != null) {
        pdfViewerController.jumpToPage(page!);
      }
    }
  }



  Future<void> savePage() async {
    if (file != null) {
      print('Inside save pagae ');
      prefs.setInt("Page_read", pdfViewerController.pageNumber);
    }
  }

  void handlePickedFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      file = File(result.files.single.path!);
      if (file != null) {
        bytes = file!.readAsBytesSync();
        isFilePicked = true;
        update();
      }
    } else {
      // User canceled the picker
    }
  }

  Future<void> FetchBookmarks()async {

    try {
      final response = await http.get(Uri.parse('${BookStoreController.BASE_URL}/api/bookmarks/$fileUID'),headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}' , // Pass token if needed
      });
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        pdfViewerController.jumpToPage(body[0]['page']);

      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {

      print("In catch section");
      rethrow;
    }
  }

  Future<void> SetBookmarks()async {
    prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(Uri.parse(BookStoreController.BASE_URL+'/api/bookmarks/$fileUID'),headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${await getToken()}' , // Pass token if needed
      },
          body:json.encode({
          'page':prefs.getInt("Page_read")

          })
      );
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Add Bookmark successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);


      } else {
        throw Exception('Failed to set bookmark');
      }
    } catch (e) {

      print("In catch section");
      rethrow;
    }

  }




}
