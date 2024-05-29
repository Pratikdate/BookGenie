import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/ReadBookController.dart';
import 'BookViewScreen.dart';
import 'ChatBookScreen.dart';
import 'package:get/get.dart';


class ReadBook extends StatefulWidget {
  const ReadBook({super.key});


  @override
  State<ReadBook> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ReadBook>
    with SingleTickerProviderStateMixin {

  final ReadBookController controller = Get.put(ReadBookController());


  //final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late TabController _tabController;
  //final ScrollController _scrollController = ScrollController();
  //late final File _file = widget.file;
  bool isFilePicked = false;
  late Uint8List bytes;
  //PdfViewerController pdfViewerController = PdfViewerController();
  String? selectedTextLines;
  bool isSearch = false;
  //TextEditingController Controller = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    ReadBookController.fileUrl=Get.arguments[0];

  }










  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      _resetScroll();
    }
  }

  void _resetScroll() {
    //controller.scrollController.jumpTo(0.0);
    //or use .animateTo() for a smooth scroll
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: "Read Book"),
                Tab(text: "Chat With Book"),

              ],
            ),
            toolbarHeight: 30,
            leadingWidth: MediaQuery.of(context).size.width,
            backgroundColor: Colors.white70,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(0),
              ),
            ),
          ),
          body: TabBarView(controller: _tabController, children: [
            BookViewScreen(file: Get.arguments[0]),
            ChatScreenHandler( uid:Get.arguments[1], )
          ]),
        ));
  }
}

