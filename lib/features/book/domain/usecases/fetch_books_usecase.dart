import 'dart:io';

import '../ entities/book.dart';
import '../repositories/book_repository.dart';



class FetchBookInPopularUseCase {
  final BookRepository bookRepository;

  FetchBookInPopularUseCase(this.bookRepository);

  Future<List<Book>> execute({required int count}) async {
    return await bookRepository.booksInPopular(count: count);
  }
}

class FetchBookbookShelfUseCase {
  final BookRepository bookRepository;

  FetchBookbookShelfUseCase(this.bookRepository);

  Future<List<Book>> execute({required int count}) async {
    return await bookRepository.bookShelf(count: count);
  }

}


class FetchBookPDFUseCase {
  final BookRepository fetchBookPDFUseCase ;

  FetchBookPDFUseCase(this.fetchBookPDFUseCase );

  Future<File> execute( String fileUrl) async {
    return await fetchBookPDFUseCase.fetchPDFRepositories(fileUrl);
  }

}
