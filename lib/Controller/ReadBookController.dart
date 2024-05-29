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
  //final ScrollController scrollController = ScrollController();
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

  static String PDFFileBasename = '';
  late TabController _tabController;

  @override
  void onInit() {
    super.onInit();
    _tabController = TabController(length: 2, vsync: this);
    loadPage();
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
      int? page = prefs.getInt(basename(file!.path));
      if (page != null) {
        pdfViewerController.jumpToPage(page);
      }
    }
  }

  Future<void> savePage() async {
    if (file != null) {
      prefs.setInt(basename(file!.path), pdfViewerController.pageNumber);
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
