import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class ShowCaseProvider extends GetxController {
  GlobalKey _popularPageKey = GlobalKey();
  GlobalKey _bookShelfKey = GlobalKey();
  GlobalKey _searchKey = GlobalKey();


  GlobalKey get popularPageKey => _popularPageKey;
  GlobalKey get bookShelfKey => _bookShelfKey;
  GlobalKey get searchKey => _searchKey;

}