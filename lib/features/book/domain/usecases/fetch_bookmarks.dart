

import 'package:bookapp/features/book/data/repositories/bookmark_repository_impl.dart';
import 'package:bookapp/features/book/domain/%20entities/bookmark.dart';

import '../ entities/book.dart';
import '../repositories/bookmark_repository.dart';


class FetchListBookmarksUseCase {
  final BookmarkRepository bookmarkRepository;

  FetchListBookmarksUseCase(this.bookmarkRepository);

  Future<List<Book>> execute() async {
    return await bookmarkRepository.fetchListBooksMarksRepository();
  }
}

class FetchBookmarksUseCase {
  final BookmarkRepository bookmarkRepository;

  FetchBookmarksUseCase(this.bookmarkRepository);

  Future<List<Bookmark>> execute(String fileUid) async {
    return await bookmarkRepository.fetchBooksMarksRepository(fileUid);
  }
}

class SetBookmarksUseCase {
  final BookmarkRepository bookmarkRepository;

  SetBookmarksUseCase(this.bookmarkRepository);

  Future<bool> execute({required String fileUID, required String name, required int page, String? description}) async {
    return await bookmarkRepository.setBooksMarksRepository(fileUID, name, page, description);
  }
}

class DeleteBookmarksUseCase {
  final BookmarkRepository bookmarkRepository;

  DeleteBookmarksUseCase(this.bookmarkRepository);

  Future<bool> execute(String uid) async {
    return await bookmarkRepository.deleteBooksMarksRepository(uid);
  }
}

