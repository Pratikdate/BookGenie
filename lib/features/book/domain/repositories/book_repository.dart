


import 'dart:io';

import '../ entities/book.dart';


abstract class BookRepository {
  Future<List<Book>> booksInPopular({required int count});
  Future<List<Book>> bookShelf({required int count});
  Future<File> fetchPDFRepositories( String fileUrl);


}

