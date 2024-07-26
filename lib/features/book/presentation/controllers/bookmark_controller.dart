
import 'package:bookapp/features/book/presentation/controllers/tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/ entities/book.dart';
import '../../domain/ entities/bookmark.dart';
import '../../domain/usecases/fetch_bookmarks.dart';




class BookmarkController extends GetxController with SingleGetTickerProviderMixin {
  final FetchBookmarksUseCase fetchBookmarksUseCase;
  final FetchListBookmarksUseCase fetchListBookmarksUseCase;
  final SetBookmarksUseCase setBookmarksUseCase;
  final DeleteBookmarksUseCase deleteBookmarksUseCase;
  final TabSController tabSController = Get.find<TabSController>();

  var setLastBookmark = true.obs;
  var ShowBookmarks = <Bookmark>[].obs;
  var bookmarkInfo = <Book>[].obs;
  var page = 0.obs;

  BookmarkController( {
    required this.fetchBookmarksUseCase,
    required this.setBookmarksUseCase,
    required this.deleteBookmarksUseCase,
    required this.fetchListBookmarksUseCase,
  });




  Future<void> fetchListBookmarks() async {
    try {
      final bookMarks = await fetchListBookmarksUseCase.execute();
      bookmarkInfo.addAll(bookMarks);

    } catch (e) {
      rethrow;
    }
  }



  Future<void> FetchBookmarks() async {
    try {
      final bookMarks = await fetchBookmarksUseCase.execute(tabSController.fileUID.value);
      ShowBookmarks.assignAll(bookMarks);
     if(tabSController.isLoadingPDF.value){
       tabSController.pdfViewerController.jumpToPage(ShowBookmarks.last.page ?? 0);
     }

    } catch (e) {
      rethrow;
    }
  }

  Future<void> SetBookmarks({required String name, String? description}) async {
    tabSController.prefs = await SharedPreferences.getInstance();
    try {
      final result = await setBookmarksUseCase.execute(
        fileUID: tabSController.fileUID.value,
        name: name,
        page: tabSController.prefs.getInt("Page_read") ?? 0,
        description: description,
      );
      if (result) {
        Get.snackbar(
          "Success",
          "Bookmark added successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> DeleteBookmark(String uid) async {
    tabSController.prefs = await SharedPreferences.getInstance();
    try {
      final result = await deleteBookmarksUseCase.execute(uid);
      if (result) {
        Get.snackbar(
          "Success",
          "Bookmark deleted successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
