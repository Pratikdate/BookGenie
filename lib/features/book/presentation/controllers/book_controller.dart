
import 'package:get/get.dart';

import '../../domain/ entities/book.dart';
import '../../domain/usecases/fetch_books_usecase.dart';





class BookController extends GetxController with SingleGetTickerProviderMixin {
  final FetchBookInPopularUseCase fetchBookInPopularUseCase;
  final FetchBookbookShelfUseCase fetchBookbookShelfUseCase;
  var isLoadingPopular = true.obs;

  var isLoadingShelf = true.obs;
  var booksInPopular = <Book>[].obs;
  var booksInShelf = <Book>[].obs;


  BookController( {required this.fetchBookInPopularUseCase, required this.fetchBookbookShelfUseCase});

  @override
  void onInit() {
    super.onInit();
    fetchBookInPopular();
    fetchBookShelf();
  }






  Future<void> refreshBookInPopular({int count =3}) async {

    try {
      booksInPopular.clear();
      final books = await fetchBookInPopularUseCase.execute(count: count);
      booksInPopular.addAll(books);

    } finally {

    }
  }
  Future<void> refreshBookShelf({int count =3}) async {

    try {
      booksInShelf.clear();
      final books = await fetchBookInPopularUseCase.execute(count: count);
      booksInShelf.addAll(books);

    } finally {

    }
  }


  Future<List<Book>> fetchBookInPopular({int count =3}) async {
    isLoadingPopular(true);
    try {
      final books = await fetchBookInPopularUseCase.execute(count: count);
      booksInPopular.addAll(books);
      return books;
    } finally {
      isLoadingPopular(false);
    }
  }

  Future<List<Book>> fetchBookShelf({int count =3}) async {
    isLoadingShelf(true);
    try {
      final books = await fetchBookbookShelfUseCase.execute(count: count);
      booksInShelf.addAll(books);
      return books;
    } finally {
      isLoadingShelf(false);
    }
  }


}
