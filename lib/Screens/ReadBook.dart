import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/ChatScreenController.dart';
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

  late TabController _tabController;

  bool isFilePicked = false;
  late Uint8List bytes;
  String? selectedTextLines;
  bool isSearch = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    ReadBookController.fileUrl=Get.arguments[0];
    ChatScreenController.bookUid=Get.arguments[1];

  }










  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {

    }
  }

  // void _resetScroll() {
  //   //scrollController.jumpTo(0.0);
  //   //or use .animateTo() for a smooth scroll
  // }

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
                Tab(text: "Mr.Chat"),

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
          body: TabBarView(
            controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
            children: [
            BookViewScreen(file: Get.arguments[0]),
            ChatScreenHandler( uid:Get.arguments[1], )

          ],

          ),
        ));
  }
}

