import 'dart:convert';
import 'dart:io';
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
  late TabController _tabController;

  @override
  void onInit() {
    super.onInit();
    _tabController = TabController(length: 2, vsync: this);
    fetchPdfFromNetwork(fileUrl);

  }

  void onClose() {
    // TODO: implement onClose

    prefs.setInt("Page_read", 0);
    super.onClose();

  }



  Future<void> fetchPdfFromNetwork(String url) async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse("http://192.168.233.145:8000/"+url));
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
}
