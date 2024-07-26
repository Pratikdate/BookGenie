



import 'package:bookapp/features/book/data/datasouces/remote/bookmarks_api_service.dart';
import 'package:bookapp/features/book/domain/%20entities/bookmark.dart';

import '../../../../core/utils/constants.dart';
import '../../domain/ entities/book.dart';
import '../../domain/repositories/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final RemoteBookmarkDataSource remoteBookmarkDataSource;

  BookmarkRepositoryImpl(this.remoteBookmarkDataSource);

  @override
  Future<bool> deleteBooksMarksRepository(String uid) async {
    return await remoteBookmarkDataSource.DeleteBookmarkDataSource(uid);
  }

  @override
  Future<List<Bookmark>> fetchBooksMarksRepository(String fileUID) async {
    final bookMarksList = await remoteBookmarkDataSource.FetchBookmarksDataSource(fileUID: fileUID);

    return bookMarksList.map((bookMark) => Bookmark(uid: bookMark[0],title: bookMark[1], description: bookMark[2],page: bookMark[3],created_at: bookMark[4])).toList();
  }

  @override
  Future<bool> setBooksMarksRepository(String fileUID, String name, int page, [String? description]) async {
    return await remoteBookmarkDataSource.SetBookmarksDataSource(fileUID, name, page, description);
  }

  @override
  Future<List<Book>> fetchListBooksMarksRepository() async {
    final bookmarksList = await remoteBookmarkDataSource.fetchListBookmarksDataSource();

    return bookmarksList.map((books)=>Book(uid:books.uid!, name:books.title!, author:books.author??"",published:  books.created_at, image: "${Constants.BASE_URL}/media/${books.frontal_page}"!, fileUrl:"${Constants.BASE_URL}/media/${books.book_file}"!,description:books.description )).toList();
  }

}
