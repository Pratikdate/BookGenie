
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/usecases/fetch_bookmarks.dart';
import '../../domain/usecases/fetch_books_usecase.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bookmark_controller.dart';
import 'chat_tab_controller.dart';





class TabSController extends GetxController with SingleGetTickerProviderMixin {

  final FetchBookPDFUseCase fetchBookPDFUseCase;
  File? file;
  final isLoadingPDF=true.obs;
  final fileUrl=''.obs;
  final fileUID=''.obs;
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  var isFilePicked = false.obs;
  PdfViewerController pdfViewerController = PdfViewerController();
  String? selectedTextLines;
  var isSearch = false.obs;
  TextEditingController controller = TextEditingController();
  late SharedPreferences prefs;
  var page = 0.obs;
  var PDFFileBasename = ''.obs;
  late TabController _tabController;

  @override
  Future<void> onInit() async {
    super.onInit();
    _tabController = TabController(length: 2, vsync: this);
    prefs = await SharedPreferences.getInstance();



    // Any other initialization if needed
  }

  @override
  void onClose() {
    //ShowBookmarks.clear();
    prefs.setInt("Page_read", 0);
    _tabController.dispose();
    super.onClose();
  }


  TabSController( {required this.fetchBookPDFUseCase,});

  Future<void> fetchBookPDF() async {
    isLoadingPDF(true);
    try {

      final book = await fetchBookPDFUseCase.execute(fileUrl.value);

      file=book;
    } finally {
      isLoadingPDF(false);
    }
  }

  Future<void> loadPage() async {
    prefs = await SharedPreferences.getInstance();
    if (file != null) {
      page.value = prefs.getInt("Page_read") ?? 0;
      if (page.value != 0) {
        pdfViewerController.jumpToPage(page.value);
      }
    }
  }

  Future<void> savePage() async {
    if (file != null) {
      prefs.setInt("Page_read", pdfViewerController.pageNumber);
    }
  }
  //
  // void handlePickedFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );
  //
  //   if (result != null) {
  //     file = File(result.files.single.path!);
  //     if (file != null) {
  //       bytes = file!.readAsBytesSync();
  //       isFilePicked.value = true;
  //     }
  //   } else {
  //     // User canceled the picker
  //   }
  // }


}