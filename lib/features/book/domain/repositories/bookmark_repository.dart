

import '../ entities/book.dart';
import '../ entities/bookmark.dart';

abstract class BookmarkRepository {

  Future<List<Book>> fetchListBooksMarksRepository();
  Future<List<Bookmark>> fetchBooksMarksRepository(String fileUID);
  Future<bool> setBooksMarksRepository(String fileUID, String name, int page, [String? description]);
  Future<bool> deleteBooksMarksRepository(String uid);
}
