import 'dart:io';
import 'package:bookapp/features/book/domain/repositories/book_repository.dart';
import '../../domain/ entities/book.dart';
import '../datasouces/remote/book_api_service.dart';

class BookRepositoryImpl implements BookRepository {
  final RemoteBookDataSource remoteBookDataSource;

  BookRepositoryImpl(this.remoteBookDataSource);

  @override
  Future<List<Book>> bookShelf({required int count}) async {
    final bookDataList = await remoteBookDataSource.bookShelfDataSource(count: count);
    return bookDataList.map((bookData) => Book.fromJson(bookData)).toList();
  }

  @override
  Future<List<Book>> booksInPopular({required int count}) async {
    final bookDataList = await remoteBookDataSource.booksInPopularDataSource(count: count);
    return bookDataList.map((bookData) => Book.fromJson(bookData)).toList();
  }

  @override
  Future<File> fetchPDFRepositories(String fileUrl) async {
    final bookFile = await remoteBookDataSource.fetchPdfFromNetwork(fileUrl: fileUrl);
    return bookFile;
  }
}
